{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/foot.nix
    ./modules/home/fuzzel.nix
    ./modules/home/style.nix
    ./modules/home/waybar.nix
    ./modules/home/hyprland.nix
  ];

  home.username = "soka";
  home.homeDirectory = "/home/soka";
  home.stateVersion = "26.05"; 

  home.packages = with pkgs; [
    fastfetch
    htop
    home-manager
  ];

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Soka";
    };
  };
}
