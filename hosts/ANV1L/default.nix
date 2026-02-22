{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/boot.nix
    ../../modules/core/fonts.nix
    ../../modules/core/system-cli.nix
    ../../modules/desktop/gaming.nix
    ../../modules/desktop/hyprland-system.nix
    ../../modules/development/podman.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/RTX-5090-OC.nix
    ../../modules/services/ai.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # --- Networking & Time ---
  networking.hostName = "ANV1L";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Chicago";
  system.stateVersion = "25.05";

  # --- User & Permissions ---
  users.users.skill = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.fish;
  };
}
