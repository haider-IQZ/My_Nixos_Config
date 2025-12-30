{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Environment variables for Hyprland session
  environment.sessionVariables = {
    HYPRLAND_CONFIG = "/etc/hypr/hyprland.conf";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };
  
  # Packages useful for a Hyprland Session
  environment.systemPackages = with pkgs; [
    waypaper
    swww
    wl-clipboard
    grim
    slurp
    nwg-look
  ];

  environment.etc."hypr/hyprland.conf".text = ''
    ################
    ### MONITORS ###
    ################

    monitor=,preferred,auto,auto

    ###################
    ### MY PROGRAMS ###
    ###################

    $terminal = foot 
    $fileManager = nemo

    #################
    ### AUTOSTART ###
    #################
    exec-once = sh /etc/waybar/start.sh & swww
    exec = gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    exec = gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    exec-once = waypaper --restore

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################
    env = XCURSOR_SIZE,24
    env = HYPRCURSOR_SIZE,24
    env = QT_QPA_PLATFORMTHEME,qt6ct

    #####################
    ### LOOK AND FEEL ###
    #####################

    general {
        gaps_in = 2
        gaps_out = 20
        border_size = 0
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)
        resize_on_border = false
        allow_tearing = false
        layout = dwindle
    }

    decoration {
        rounding = 10
        rounding_power = 2
        active_opacity = 1.0
        inactive_opacity = 1.0
        shadow {
            enabled = true
            range = 4
            render_power = 3
            color = rgba(1a1a1aee)
        }
        blur {
            enabled = true
            size = 10
            passes = 1
            vibrancy = 0.1696
            noise = 0.08
            xray = false
        }
    }

    animations {
        enabled = yes, please :)
        bezier = easeOutQuint,   0.23, 1,    0.32, 1
        bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
        bezier = linear,         0,    0,    1,    1
        bezier = almostLinear,   0.5,  0.5,  0.75, 1
        bezier = quick,          0.15, 0,    0.1,  1

        animation = global,        1,     10,    default
        animation = border,        1,     5.39,  easeOutQuint
        animation = windows,       1,     4.79,  easeOutQuint
        animation = windowsIn,     1,     4.1,   easeOutQuint, popin 87%
        animation = windowsOut,    1,     1.49,  linear,       popin 87%
        animation = fadeIn,        1,     1.73,  almostLinear
        animation = fadeOut,       1,     1.46,  almostLinear
        animation = fade,          1,     3.03,  quick
        animation = layers,        1,     3.81,  easeOutQuint
        animation = layersIn,      1,     4,     easeOutQuint, fade
        animation = layersOut,     1,     1.5,   linear,       fade
        animation = fadeLayersIn,  1,     1.79,  almostLinear
        animation = fadeLayersOut, 1,     1.39,  almostLinear
        animation = workspaces,    1,     1.94,  almostLinear, fade
        animation = workspacesIn,  1,     1.21,  almostLinear, fade
        animation = workspacesOut, 1,     1.94,  almostLinear, fade
        animation = zoomFactor,    1,     7,     quick
    }

    dwindle {
        pseudotile = true 
        preserve_split = true 
    }

    master {
        new_status = master
    }

    misc {
        force_default_wallpaper = -1 
        disable_hyprland_logo = false 
    }

    #############
    ### INPUT ###
    #############

    input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =
        repeat_rate = 35
        repeat_delay = 200
        accel_profile=flat
        follow_mouse = 1
        sensitivity = 0 

        touchpad {
            natural_scroll = false
        }
    }

    gesture = 3, horizontal, workspace

    device {
        name = epic-mouse-v1
        sensitivity = -0.5
    }

    ###################
    ### KEYBINDINGS ###
    ###################
    bind = Super, W, exec, waypaper
    bind = Super, K, exec, codium
    bind = Super, X, exec, firefox
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
    bind = Super, Q, exec, $terminal
    bind = Super, C, killactive,
    bind = Super, E, exec, $fileManager
    bind = Super, V, togglefloating,
    bind = Super, D, exec, fuzzel
    bind = Super, P, pseudo, # dwindle
    bind = Super, J, togglesplit, # dwindle
    bind = SUPER SHIFT, R, exec, sh /etc/waybar/start.sh
    # Move focus with mainMod + arrow keys
    bind = Super, left, movefocus, l
    bind = Super, right, movefocus, r
    bind = Super, up, movefocus, u
    bind = Super, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = Super, 1, workspace, 1
    bind = Super, 2, workspace, 2
    bind = Super, 3, workspace, 3
    bind = Super, 4, workspace, 4
    bind = Super, 5, workspace, 5
    bind = Super, 6, workspace, 6
    bind = Super, 7, workspace, 7
    bind = Super, 8, workspace, 8
    bind = Super, 9, workspace, 9
    bind = Super, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = Super SHIFT, 1, movetoworkspace, 1
    bind = Super SHIFT, 2, movetoworkspace, 2
    bind = Super SHIFT, 3, movetoworkspace, 3
    bind = Super SHIFT, 4, movetoworkspace, 4
    bind = Super SHIFT, 5, movetoworkspace, 5
    bind = Super SHIFT, 6, movetoworkspace, 6
    bind = Super SHIFT, 7, movetoworkspace, 7
    bind = Super SHIFT, 8, movetoworkspace, 8
    bind = Super SHIFT, 9, movetoworkspace, 9
    bind = Super SHIFT, 0, movetoworkspace, 10

    # Example special workspace (scratchpad)
    bind = Super, S, togglespecialworkspace, magic
    bind = Super SHIFT, S, movetoworkspace, special:magic

    # Scroll through existing workspaces with mainMod + scroll
    bind = Super, mouse_down, workspace, e+1
    bind = Super, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = Super, mouse:272, movewindow
    bindm = Super, mouse:273, resizewindow

    # Laptop multimedia keys for volume and LCD brightness
    bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
    bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

    # Requires playerctl
    bindl = , XF86AudioNext, exec, playerctl next
    bindl = , XF86AudioPause, exec, playerctl play-pause
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioPrev, exec, playerctl previous

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    windowrule = suppressevent maximize, class:.*
    windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    windowrulev2 = opacity 0.85 0.85,class:^(foot)$
    windowrulev2 = opacity 0.85 0.85,class:^(nemo)$
    windowrulev2 = opacity 0.85 0.85,class:^(brave-browser)$
    windowrulev2 = opacity 0.85 0.85,class:^(VSCodium)$
  '';
  
  # For Hyprland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
}
