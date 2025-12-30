{ config, pkgs, ... }:

{
  # Only enable the system package if you want it globally available
  # (Home Manager installs it for the user anyway, but keeping it here is fine)
  environment.systemPackages = [ pkgs.foot ];

  # --- Home Manager Configuration for Foot ---
  home-manager.users.soka = { pkgs, ... }: {
    
    # We must define this inside the user block
    home.stateVersion = "24.11";

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

          # Normal/Regular
          regular0 = "282828"; # Black
          regular1 = "cc241d"; # Red
          regular2 = "98971a"; # Green
          regular3 = "d79921"; # Yellow
          regular4 = "458588"; # Blue
          regular5 = "b16286"; # Magenta
          regular6 = "689d6a"; # Cyan
          regular7 = "a89984"; # White

          # Bright
          bright0 = "928374";
          bright1 = "fb4934";
          bright2 = "b8bb26";
          bright3 = "fabd2f";
          bright4 = "83a598";
          bright5 = "d3869b";
          bright6 = "8ec07c";
          bright7 = "ebdbb2";
        };
      };
    };
  };
}
