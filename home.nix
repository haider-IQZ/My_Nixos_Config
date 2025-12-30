{ config, pkgs, ... }:

{
  imports = [
    ./home-manager/foot.nix
    ./home-manager/fuzzel.nix
    ./home-manager/style.nix
    ./home-manager/waybar.nix
    ./home-manager/hyprland.nix
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
