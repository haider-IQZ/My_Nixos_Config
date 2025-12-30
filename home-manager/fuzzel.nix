{ config, pkgs, ... }:

{
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
}
