{ config, pkgs, inputs, ... }:

{
  imports = [
    ./modules/core/cli.nix
    ./modules/desktop/apps.nix
    ./modules/desktop/hyprland-user.nix
    ./modules/development/kubernetes.nix
    ./modules/desktop/media.nix
    ./modules/development/tools.nix
    ./modules/security/secrets.nix
    ./modules/services/rclone.nix
  ];

  home.username      = "skill";
  home.homeDirectory = "/home/skill";
  home.stateVersion  = "25.05";

  xdg.enable = true;
}
