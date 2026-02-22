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
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-keephue = true;
      recolor-darkcolor = "#ebdbb2";
      recolor-lightcolor = "#282828";
      default-bg = "#282828";
      default-fg = "#ebdbb2";
    };
  };
}
