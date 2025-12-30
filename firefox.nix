{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    
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

    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    
    preferencesStatus = "default";
  };

  environment.etc."firefox/policies/user.js".text = builtins.readFile (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js";
    sha256 = "sha256-ZpWvGPD/nzOrYln+cnm3j/T02zsNHEsI053rEuPhQxQ=";
  });
}

