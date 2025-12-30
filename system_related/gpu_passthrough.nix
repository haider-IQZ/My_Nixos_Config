{ config, pkgs, ... }:

{
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
    
    hooks.qemu = {
      "gpu-passthrough" = pkgs.writeScript "qemu-hook-gpu" ''
        #!/bin/sh

        ALLOWED_VMS="win10 arch linux steam-os"

        GUEST_NAME="$1"
        if ! echo "$ALLOWED_VMS" | grep -w -q "$GUEST_NAME"; then
           exit 0
        fi


        VIRSH_GPU_VIDEO="pci_0000_09_00_0"
        VIRSH_GPU_AUDIO="pci_0000_09_00_1"
        
        COMMAND="$2"
        STATE="$3"

        if [ "$COMMAND" = "prepare" ] && [ "$STATE" = "begin" ]; then
          systemctl stop display-manager
          echo 0 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
          sleep 4
          modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
          virsh nodedev-detach $VIRSH_GPU_VIDEO
          virsh nodedev-detach $VIRSH_GPU_AUDIO
          modprobe vfio vfio_pci vfio_iommu_type1
        fi

        if [ "$COMMAND" = "release" ] && [ "$STATE" = "end" ]; then
          modprobe -r vfio_pci
          modprobe -r vfio_iommu_type1
          modprobe -r vfio

          virsh nodedev-reattach $VIRSH_GPU_VIDEO
          virsh nodedev-reattach $VIRSH_GPU_AUDIO

          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind

          nvidia-smi > /dev/null 2>&1

          echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

          modprobe nvidia_drm
          modprobe nvidia_modeset
          modprobe drm_kms_helper
          modprobe nvidia
          modprobe drm
          modprobe nvidia_uvm

          systemctl start display-manager.service
        fi
      '';
    };
  };

  systemd.services.libvirt-default-net-autostart = {
    description = "Ensure default libvirt network is started";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ${pkgs.libvirt}/bin/virsh net-info default > /dev/null 2>&1; then
        ${pkgs.libvirt}/bin/virsh net-autostart default || true
        if ! ${pkgs.libvirt}/bin/virsh net-list | grep -q default; then
          ${pkgs.libvirt}/bin/virsh net-start default || true
        fi
      fi
    '';
  };
    
  users.users.soka.extraGroups = [ "libvirtd" ];
}
