{ config, pkgs, ... }:

{
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    bibata-cursors
    adwaita-icon-theme
    gnome-themes-extra
    gruvbox-dark-gtk
    nwg-look
    kdePackages.qtstyleplugin-kvantum
    tokyonight-gtk-theme
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter        
    noto-fonts   
    noto-fonts-color-emoji
    roboto       
  ];
  
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Inter" "Noto Sans Arabic" ];
      serif = [ "Noto Serif" "Noto Serif Arabic" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
    
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    hinting = {
      enable = true;
      style = "slight";
    };
    antialias = true;
  };
}
