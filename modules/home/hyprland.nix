{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    waypaper
    swww
    wl-clipboard
    grim
    slurp
    nwg-look
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      monitor = ",preferred,auto,auto";

      "$terminal" = "foot";
      "$fileManager" = "nemo";

      exec-once = [
        "swww"
        "waypaper --restore"
      ];
      
      exec = [
        "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"
        "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      general = {
        gaps_in = 2;
        gaps_out = 20;
        border_size = 0;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 10;
          passes = 1;
          vibrancy = 0.1696;
          noise = 0.08;
          xray = false;
        };
      };

      animations = {
        enabled = "yes, please :)";
        bezier = [
          "easeOutQuint,   0.23, 1,    0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear,         0,    0,    1,    1"
          "almostLinear,   0.5,  0.5,  0.75, 1"
          "quick,          0.15, 0,    0.1,  1"
        ];

        animation = [
          "global,        1,     10,    default"
          "border,        1,     5.39,  easeOutQuint"
          "windows,       1,     4.79,  easeOutQuint"
          "windowsIn,     1,     4.1,   easeOutQuint, popin 87%"
          "windowsOut,    1,     1.49,  linear,       popin 87%"
          "fadeIn,        1,     1.73,  almostLinear"
          "fadeOut,       1,     1.46,  almostLinear"
          "fade,          1,     3.03,  quick"
          "layers,        1,     3.81,  easeOutQuint"
          "layersIn,      1,     4,     easeOutQuint, fade"
          "layersOut,     1,     1.5,   linear,       fade"
          "fadeLayersIn,  1,     1.79,  almostLinear"
          "fadeLayersOut, 1,     1.39,  almostLinear"
          "workspaces,    1,     1.94,  almostLinear, fade"
          "workspacesIn,  1,     1.21,  almostLinear, fade"
          "workspacesOut, 1,     1.94,  almostLinear, fade"
          "zoomFactor,    1,     7,     quick"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "us";
        repeat_rate = 35;
        repeat_delay = 200;
        accel_profile = "flat";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gesture = "3, horizontal, workspace";

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "Super, W, exec, waypaper"
        "Super, K, exec, codium"
        "Super, X, exec, firefox"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "Super, Q, exec, $terminal"
        "Super, C, killactive,"
        "Super, E, exec, $fileManager"
        "Super, V, togglefloating,"
        "Super, D, exec, fuzzel"
        "Super, P, pseudo,"
        "Super, J, togglesplit,"
        "SUPER SHIFT, R, exec, pkill -SIGUSR2 waybar"
        "Super, left, movefocus, l"
        "Super, right, movefocus, r"
        "Super, up, movefocus, u"
        "Super, down, movefocus, d"
        "Super, 1, workspace, 1"
        "Super, 2, workspace, 2"
        "Super, 3, workspace, 3"
        "Super, 4, workspace, 4"
        "Super, 5, workspace, 5"
        "Super, 6, workspace, 6"
        "Super, 7, workspace, 7"
        "Super, 8, workspace, 8"
        "Super, 9, workspace, 9"
        "Super, 0, workspace, 10"
        "Super SHIFT, 1, movetoworkspace, 1"
        "Super SHIFT, 2, movetoworkspace, 2"
        "Super SHIFT, 3, movetoworkspace, 3"
        "Super SHIFT, 4, movetoworkspace, 4"
        "Super SHIFT, 5, movetoworkspace, 5"
        "Super SHIFT, 6, movetoworkspace, 6"
        "Super SHIFT, 7, movetoworkspace, 7"
        "Super SHIFT, 8, movetoworkspace, 8"
        "Super SHIFT, 9, movetoworkspace, 9"
        "Super SHIFT, 0, movetoworkspace, 10"
        "Super, S, togglespecialworkspace, magic"
        "Super SHIFT, S, movetoworkspace, special:magic"
        "Super, mouse_down, workspace, e+1"
        "Super, mouse_up, workspace, e-1"
      ];

      bindm = [
        "Super, mouse:272, movewindow"
        "Super, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];

      windowrulev2 = [
        "opacity 0.85 0.85,class:^(foot)$"
        "opacity 0.85 0.85,class:^(nemo)$"
        "opacity 0.85 0.85,class:^(brave-browser)$"
        "opacity 0.85 0.85,class:^(VSCodium)$"
      ];
    };
  };
}
