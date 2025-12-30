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
    
    # The magical hooks for GPU passthrough
    hooks.qemu = {
      "gpu-passthrough" = pkgs.writeScript "qemu-hook-gpu" ''
        #!/bin/sh

        # 1. LIST OF VMS THAT GET THE GPU
        ALLOWED_VMS="win10 arch linux steam-os"

        # 2. CHECK: IS THE CURRENT VM IN THE LIST?
        GUEST_NAME="$1"
        if ! echo "$ALLOWED_VMS" | grep -w -q "$GUEST_NAME"; then
           exit 0
        fi

        # -----------------------------------------------------------
        # IF WE ARE HERE, IT'S A GAMING VM! ACTIVATE PROTOCOL.
        # -----------------------------------------------------------
        
        # Define GPU IDs
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
          # 1. Unload VFIO-PCI Drivers
          modprobe -r vfio_pci
          modprobe -r vfio_iommu_type1
          modprobe -r vfio

          # 2. Reattach GPU to Host
          virsh nodedev-reattach $VIRSH_GPU_VIDEO
          virsh nodedev-reattach $VIRSH_GPU_AUDIO

          # 3. Rebind VT Consoles
          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind

          # 4. Wake up GPU
          nvidia-smi > /dev/null 2>&1

          # 5. Bind EFI-Framebuffer
          echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

          # 6. Load Nvidia Drivers
          modprobe nvidia_drm
          modprobe nvidia_modeset
          modprobe drm_kms_helper
          modprobe nvidia
          modprobe drm
          modprobe nvidia_uvm

          # 7. Restart Display Manager
          systemctl start display-manager.service
        fi
      '';
    };
  };

  # Auto-start default network
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
    
  # Add user to libvirtd group (must match username in configuration.nix really, but good to have here)
  users.users.soka.extraGroups = [ "libvirtd" ];
}
