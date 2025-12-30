{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  environment.sessionVariables = {
    STEAM_COUNTRY = "IQ";
    STEAM_REGION = "ME";
  };
  
  programs.gamemode.enable = true;
  
  environment.systemPackages = with pkgs; [
    protonplus
    mangohud
    goverlay
  ];
}
