{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./firefox.nix
    # My Custom Modules
    ./modules/appearance.nix
    ./modules/gaming.nix
    ./modules/gpu_passthrough.nix
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/foot.nix
    ./modules/fuzzel.nix
  ];


  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [ 
    "amd_iommu=on" 
    "iommu=pt" 
    "pcie_acs_override=downstream,multifunction" 
  ];  

  # Networking
  networking.hostName = "haider";
  networking.networkmanager.enable = true;

  # Time & Locale
  time.timeZone = "Asia/Baghdad";
  nixpkgs.config.allowUnfree = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Graphics Drivers
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;

  # Display Manager (SDDM)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;  
  services.displayManager.defaultSession = "hyprland";
  
  # User Config
  users.users.soka = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd"];
    packages = with pkgs; [ tree ];
  };

  # Shell Config
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      nitch
    '';
    shellAliases = {
      nc = "vim /home/soka/My_Nixos_Config/configuration.nix";
      nr = "sudo nixos-rebuild switch";
    };
  };

  # General System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    btop
    htop
    fastfetch
    nitch
    psmisc
    floorp-bin
    github-desktop
    vscodium
    obsidian
    obs-studio
    discord
    # Add other random tools here
  ];
  
  # Hard Drives
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/b18e8d99-0fe0-48f8-9dcd-a064448f63a4";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  system.stateVersion = "25.11"; 
}
