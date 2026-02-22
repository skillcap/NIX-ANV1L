{ config, pkgs, lib, inputs, ... }:

{
  home.packages = with pkgs; [
    appimage-run
    discord-ptb
    kdePackages.dolphin
    obsidian
    pcmanfm
    zed-editor
    inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
