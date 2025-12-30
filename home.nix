{ config, pkgs, ... }:

{
  # 1. Core Home Manager Settings
  home.username = "soka";
  home.homeDirectory = "/home/soka";
  home.stateVersion = "24.11"; 

  # 2. User Packages (Stuff only YOU need)
  home.packages = with pkgs; [
    # Add user-specific CLI tools here if you want
    fastfetch
    htop
  ];

  # 3. PROGRAM CONFIGURATIONS (This is where the magic happens)

  # --- FOOT TERMINAL ---
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono NF:size=16";
        pad = "8x8 center-when-maximized-and-fullscreen";
      };
      colors = {
        alpha = "0.9";
        foreground = "ebdbb2";
        background = "282828";
        # ... (We keep the rest of your colors) ...
        regular0 = "282828"; regular1 = "cc241d"; regular2 = "98971a"; regular3 = "d79921";
        regular4 = "458588"; regular5 = "b16286"; regular6 = "689d6a"; regular7 = "a89984";
        bright0 = "928374"; bright1 = "fb4934"; bright2 = "b8bb26"; bright3 = "fabd2f";
        bright4 = "83a598"; bright5 = "d3869b"; bright6 = "8ec07c"; bright7 = "ebdbb2";
      };
    };
  };

  # --- FUZZEL LAUNCHER ---
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        "dpi-aware" = "yes";
        "icon-theme" = "Papirus-Dark";
        layer = "overlay";
        terminal = "foot";
        width = 40;
        "horizontal-pad" = 20;
        "vertical-pad" = 10;
        "inner-pad" = 10;
      };
      colors = {
        background = "282828ee";
        text = "ebdbb2ff";
        match = "fabd2fff";
        selection = "3c3836ff";
        "selection-text" = "ebdbb2ff";
        "selection-match" = "fabd2fff";
        border = "b8bb26ff";
      };
      border = {
        width = 2;
        radius = 10;
      };
    };
  };

  # --- GIT ---
  programs.git = {
    enable = true;
    userName = "Soka";
  };
}
