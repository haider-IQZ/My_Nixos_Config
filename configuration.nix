{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  # UnFree_pkgs
  nixpkgs.config.allowUnfree = true;

  # Drivers_Nvidia
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [ 
    "amd_iommu=on" 
    "iommu=pt" 
    "pcie_acs_override=downstream,multifunction" 
  ];  


  networking.hostName = "haider";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Baghdad";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;  
  services.displayManager.defaultSession = "hyprland";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  users.users.soka = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "input" "libvirtd"];
    packages = with pkgs; [ tree ];
  };

  programs.steam.enable = true;
  environment.sessionVariables = {
    STEAM_COUNTRY = "IQ";
    STEAM_REGION = "ME";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  system.activationScripts.footConfig = ''
    mkdir -p /home/soka/.config/foot
    cat > /home/soka/.config/foot/foot.ini << 'EOF'
font=JetBrainsMono NF:size=16
pad=8x8 center-when-maximized-and-fullscreen

[colors]
foreground=c0caf5
background=1a1b26

regular0=15161E
regular1=f7768e
regular2=9ece6a
regular3=e0af68
regular4=7aa2f7
regular5=bb9af7
regular6=7dcfff
regular7=a9b1d6

bright0=414868
bright1=f7768e
bright2=9ece6a
bright3=e0af68
bright4=7aa2f7
bright5=bb9af7
bright6=7dcfff
bright7=c0caf5

dim0=ff9e64
dim1=db4b4b

alpha=0.9
EOF
    chown soka:users /home/soka/.config/foot/foot.ini
  '';

  system.activationScripts.fuzzelConfig = ''
    mkdir -p /home/soka/.config/fuzzel
    cat > /home/soka/.config/fuzzel/fuzzel.ini << 'EOF'
[main]
font=JetBrainsMono Nerd Font:size=14
dpi-aware=yes
icon-theme=Papirus-Dark
layer=overlay
terminal=foot
width=40
horizontal-pad=20
vertical-pad=10
inner-pad=10

[colors]
background=1a1b26ee
text=c0caf5ff
match=7aa2f7ff
selection=33467cff
selection-text=c0caf5ff
selection-match=7aa2f7ff
border=7aa2f7ff

[border]
width=2
radius=10
EOF
    chown soka:users /home/soka/.config/fuzzel/fuzzel.ini
  '';

  environment.etc."waybar/start.sh" = {
    text = ''
      #!/bin/sh
      # Use pkill to forcefully terminate any 'waybar' process owned by the current user
      ${pkgs.psmisc}/bin/pkill -9 -u $USER waybar

      # A tiny delay to ensure the process is fully terminated
      sleep 0.1

      # Start a new Waybar instance in the background
      waybar -c /etc/waybar/config -s /etc/waybar/style.css &
    '';
  };

  environment.etc."waybar/config".text = ''
    {
        "layer": "top",
        "position": "top",
        "height": 30,
        "modules-left": ["hyprland/workspaces", "custom/sep", "hyprland/window"],
        "modules-center": [],
        "modules-right": ["custom/sep", "network", "custom/sep", "cpu", "custom/sep", "memory", "custom/sep", "disk", "custom/sep", "clock", "custom/sep", "tray"],

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

        "network": {
            "format": "Online",
            "format-disconnected": "Offline"
        },

        "cpu": {
            "format": "CPU: {usage}%",
            "tooltip": false
        },

        "memory": {
            "format": "Mem: {used}GiB"
        },

        "disk": {
            "interval": 60,
            "path": "/",
            "format": "Disk: {free}"
        },

        "clock": {},
        "tray": {}
    }
  '';

  environment.etc."waybar/style.css".text = ''
    @define-color bg #1a1b26;
    @define-color fg #a9b1d6;
    @define-color blk #32344a;
    @define-color red #f7768e;
    @define-color grn #9ece6a;
    @define-color ylw #e0af68;
    @define-color blu #7aa2f7;
    @define-color mag #ad8ee6;
    @define-color cyn #0db9d7;
    @define-color brblk #444b6a;
    @define-color wht #ffffff;

    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 16px;
      font-weight: bold;
    }

    window#waybar {
      background: @bg;
      color: @fg;
    }

    #workspaces button {
      padding: 0 6px;
      color: @cyn;
      background: transparent;
      border-bottom: 3px solid @bg;
    }

    #workspaces button.active {
      color: @cyn;
      border-bottom: 3px solid @mag;
    }

    #workspaces button.empty {
      color: @wht;
    }

    #workspaces button.empty.active {
      color: @cyn;
      border-bottom: 3px solid @mag;
    }

    #clock, #custom-sep, #battery, #cpu, #memory, #disk, #network, #tray {
      padding: 0 8px;
    }

    #custom-sep {
      color: @brblk;
    }

    #clock {
      color: @cyn;
      border-bottom: 4px solid @cyn;
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
      color: @blu;
      border-bottom: 4px solid @blu;
    }
  '';

  #Dark_Mode
  # GTK theme for dark mode
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

  # ===Hyprland_config====
  environment.etc."hypr/hyprland.conf".text = ''
    ################
    ### MONITORS ###
    ################

    # See https://wiki.hypr.land/Configuring/Monitors/
    monitor=,preferred,auto,auto

    ###################
    ### MY PROGRAMS ###
    ###################

    # See https://wiki.hypr.land/Configuring/Keywords/

    # Set programs that you use
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

    # See https://wiki.hypr.land/Configuring/Environment-variables/
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

    # https://wiki.hypr.land/Configuring/Variables/#input
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
    bind = Super, X, exec, brave
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

    # See https://wiki.hypr.land/Configuring/Window-Rules/ for more
    # See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

    # Example windowrule
    # windowrule = float,class:^(kitty)$,title:^(kitty)$

    # Ignore maximize requests from apps. You'll probably like this.
    windowrule = suppressevent maximize, class:.*
    # Fix some dragging issues with XWayland
    windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    windowrulev2 = opacity 0.85 0.85,class:^(foot)$
    windowrulev2 = opacity 0.85 0.85,class:^(nemo)$
    windowrulev2 = opacity 0.85 0.85,class:^(brave-browser)$
    windowrulev2 = opacity 0.85 0.85,class:^(VSCodium)$
  '';

  environment.sessionVariables = {
    HYPRLAND_CONFIG = "/etc/hypr/hyprland.conf";
    BROWSER = "brave";
  }; 

 xdg.mime.defaultApplications = {
    "text/html" = "brave-browser.desktop";
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
  };


  # === PKGS === 
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    brave
    (pkgs.writeShellScriptBin "brave" ''
      exec ${pkgs.brave}/bin/brave \
        --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,CanvasOOPRasterization \
        --enable-gpu-rasterization \
        --enable-zero-copy \
        --ignore-gpu-blocklist \
        --enable-gpu-compositing \
        --disable-gpu-driver-bug-workarounds \
        "$@"
    '')
    psmisc
    foot
    nemo
    fuzzel
    waybar
    waypaper
    swww
    wl-clipboard 
    vscodium 
    nitch
    pavucontrol
    bibata-cursors
    protonplus
    kdePackages.sddm
    qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    libnotify
    fzf
    fd
    llvmPackages.systemLibcxxClang
    grim
    slurp
    btop
    cava
    matugen
    adwaita-icon-theme
    gnome-themes-extra
    rustup
    mangohud
    goverlay
    antigravity
    xdg-utils
    obsidian
    obs-studio
    xdg-user-dirs
    axel
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  
#Virt-manager-setup
programs.virt-manager.enable = true;
virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
  };
};


  systemd.services.libvirt-default-net-autostart = {
    description = "Ensure default libvirt network is started";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      # 1. Check if 'default' network exists
      if ${pkgs.libvirt}/bin/virsh net-info default > /dev/null 2>&1; then
        
        # 2. Enable Autostart (Apply and ignore if already set)
        ${pkgs.libvirt}/bin/virsh net-autostart default || true
        
        # 3. Start if not running
        # We use simple 'net-list' which lists active networks by default
        if ! ${pkgs.libvirt}/bin/virsh net-list | grep -q default; then
          ${pkgs.libvirt}/bin/virsh net-start default || true
        fi
      fi
    '';
  };



  # -------------------------------------------------------------
  # UNIVERSAL GPU PASSTHROUGH HOOK
  # (Works for win10, arch, linux, or anything in the list!)
  # -------------------------------------------------------------
  virtualisation.libvirtd.hooks.qemu = {
    "gpu-passthrough" = pkgs.writeScript "qemu-hook-gpu" ''
      #!/bin/sh

      # 1. LIST OF VMS THAT GET THE GPU
      # (Add as many names as you want here, separated by space)
      ALLOWED_VMS="win10 arch linux steam-os"

      # 2. CHECK: IS THE CURRENT VM IN THE LIST?
      GUEST_NAME="$1"
      if ! echo "$ALLOWED_VMS" | grep -w -q "$GUEST_NAME"; then
         # If not in list, exit silently and do nothing.
         # This lets safe VMs run normally in the background!
         exit 0
      fi

      # -----------------------------------------------------------
      # IF WE ARE HERE, IT'S A GAMING VM! ACTIVATE PROTOCOL.
      # -----------------------------------------------------------
      
      # Define GPU IDs
      VIRSH_GPU_VIDEO="pci_0000_09_00_0"
      VIRSH_GPU_AUDIO="pci_0000_09_00_1"
      
      COMMAND="$2"
      STATE="$3"

      if [ "$COMMAND" = "prepare" ] && [ "$STATE" = "begin" ]; then
        systemctl stop display-manager
        echo 0 > /sys/class/vtconsole/vtcon0/bind
        echo 0 > /sys/class/vtconsole/vtcon1/bind
        echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
        sleep 4
        modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
        virsh nodedev-detach $VIRSH_GPU_VIDEO
        virsh nodedev-detach $VIRSH_GPU_AUDIO
        modprobe vfio vfio_pci vfio_iommu_type1
      fi

      if [ "$COMMAND" = "release" ] && [ "$STATE" = "end" ]; then
        modprobe -r vfio_pci vfio_iommu_type1 vfio
        virsh nodedev-reattach $VIRSH_GPU_VIDEO
        virsh nodedev-reattach $VIRSH_GPU_AUDIO
        echo 1 > /sys/class/vtconsole/vtcon0/bind
        echo 1 > /sys/class/vtconsole/vtcon1/bind
        echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
        modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia
        systemctl start display-manager
      fi
    '';
  };


#hard-drive-stuff
services.gvfs.enable = true;
services.udisks2.enable = true;
fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/b18e8d99-0fe0-48f8-9dcd-a064448f63a4";
    fsType = "ext4";
    options = [ "nofail" ]; # "nofail" is CRITICAL!
  };





















  system.stateVersion = "25.11"; 
}
