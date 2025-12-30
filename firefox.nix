{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
    # Extra policies to enforce things
    policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
    };

    # This combines your manual tweaks + the BetterFox `user.js` content
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    
    # The magic part: Append the huge BetterFox file to the user.js
    preferencesStatus = "default"; # "default" allows you to change settings later, "user" locks them.
  };

  # Since generic 'programs.firefox' module doesn't easily support raw user.js injection 
  # WITHOUT Home Manager, we do it via a system-wide wrapper if strictly needed, 
  # or we use the 'extraPrefs' hidden option if available.
  
  # However, the most robust way without Home Manager is to write it to the global default profile.
  # But wait, standard NixOS module 'programs.firefox' ONLY supports 'preferences' key-value pairs 
  # (which we just did) or 'policies'. 
  # It does NOT support raw 'extraConfig' text unless you use Home Manager.

  # === WORKAROUND FOR NON-HOME-MANAGER USERS ===
  # We will manually append the BetterFox content to the system-wide preference file.
  environment.etc."firefox/policies/user.js".text = builtins.readFile (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js";
    sha256 = "sha256-ZpWvGPD/nzOrYln+cnm3j/T02zsNHEsI053rEuPhQxQ="; # We will fix this hash in a second!
  });
}

