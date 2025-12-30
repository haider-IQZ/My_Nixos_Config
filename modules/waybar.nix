{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.waybar ];

  environment.etc."waybar/start.sh" = {
    text = ''
      #!/bin/sh
      ${pkgs.psmisc}/bin/pkill -9 -u $USER waybar

      sleep 0.1

      waybar -c /etc/waybar/config -s /etc/waybar/style.css &
    '';
  };

  environment.etc."waybar/config".text = ''
    {
        "layer": "top",
        "position": "top",
        "height": 38,
        "modules-left": ["hyprland/workspaces", "custom/sep", "hyprland/window"],
        "modules-center": [],
        "modules-right": ["custom/sep", "memory", "custom/sep", "clock", "custom/sep", "tray"],

        "hyprland/workspaces": {
            "disable-scroll": true,
            "all-outputs": true,
            "warp-on-scroll": false,
            "format": "{name}",
            "persistent-workspaces": {
                "*": 9
            }
        },

        "hyprland/window": {
            "max-length": 40,
            "separate-outputs": false
        },

        "custom/sep": {
            "format": "|",
            "interval": "once",
            "tooltip": false
        },

        "memory": {
            "format": "Mem: {used}GiB"
        },

        "clock": {},
        "tray": {}
    }
  '';

  environment.etc."waybar/style.css".text = ''
     @define-color bg #282828;
    @define-color fg #ebdbb2;
    @define-color blk #282828;
    @define-color red #fb4934;
    @define-color grn #b8bb26;
    @define-color ylw #fabd2f;
    @define-color blu #83a598;
    @define-color mag #d3869b;
    @define-color cyn #8ec07c;
    @define-color brblk #928374;
    @define-color wht #ebdbb2;

    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 18px;
      font-weight: bold;
    }

    window#waybar {
      background: @bg;
      color: @fg;
    }

    #workspaces button {
      padding: 0 6px;
      color: @fg;
      background: transparent;
      border-bottom: 3px solid @bg;
    }

    #workspaces button.active {
      color: @grn;
      border-bottom: 3px solid @grn;
    }

    #workspaces button.empty {
      color: @brblk;
    }

    #workspaces button.empty.active {
      color: @grn;
      border-bottom: 3px solid @grn;
    }

    #clock, #custom-sep, #battery, #cpu, #memory, #disk, #network, #tray {
      padding: 0 10px;
    }

    #custom-sep {
      color: @brblk;
    }

    #clock {
      color: @blu;
      border-bottom: 4px solid @blu;
    }

    #disk {
      color: @ylw;
      border-bottom: 4px solid @ylw;
    }

    #memory {
      color: @mag;
      border-bottom: 4px solid @mag;
    }

    #cpu {
      color: @grn;
      border-bottom: 4px solid @grn;
    }

    #network {
      color: @cyn;
      border-bottom: 4px solid @cyn;
    }
  '';
}
