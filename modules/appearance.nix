{ config, pkgs, ... }:

{
  # GTK Theme Config
  programs.dconf.enable = true;
  system.activationScripts.gtkConfig = ''
    mkdir -p /home/soka/.config/gtk-3.0
    mkdir -p /home/soka/.config/gtk-4.0

    cat > /home/soka/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-cursor-theme-name=Bibata-Modern-Ice
gtk-cursor-theme-size=24
EOF

    cat > /home/soka/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-cursor-theme-name=Bibata-Modern-Ice
gtk-cursor-theme-size=24
EOF

    chown -R soka:users /home/soka/.config/gtk-3.0
    chown -R soka:users /home/soka/.config/gtk-4.0
  '';

  environment.systemPackages = with pkgs; [
    bibata-cursors
    adwaita-icon-theme
    gnome-themes-extra
    gruvbox-dark-gtk
    nwg-look
    kdePackages.qtstyleplugin-kvantum
    tokyonight-gtk-theme
  ];

  # Fonts
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
