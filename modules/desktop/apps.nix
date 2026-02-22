{ config, pkgs, lib, inputs, ... }:

{
  home.packages = with pkgs; [
    appimage-run
    discord-ptb
    obsidian
    pcmanfm
    zed-editor
    inputs.zen-browser.packages."${pkgs.system}".default
  ];
}
