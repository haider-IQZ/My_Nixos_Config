{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./system_related/firefox.nix
    ./system_related/appearance.nix
    ./system_related/gaming.nix
    ./system_related/gpu_passthrough.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelParams = [ 
    "amd_iommu=on" 
    "iommu=pt" 
    "pcie_acs_override=downstream,multifunction" 
  ];  

  networking.hostName = "haider";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Baghdad";
  nixpkgs.config.allowUnfree = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;  
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };
  
  users.users.soka = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd"];
    packages = with pkgs; [ tree ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      nitch
    '';
    shellAliases = {
      nc = "vim /home/soka/My_Nixos_Config/configuration.nix";
      nr = "sudo nixos-rebuild switch --flake /home/soka/My_Nixos_Config#haider";
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    nemo
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
    antigravity
    discord
  ];
  
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/b18e8d99-0fe0-48f8-9dcd-a064448f63a4";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  system.stateVersion = "26.05"; 
}
