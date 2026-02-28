{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ];
  xdg.desktopEntries."osu-lazer-pinned" = {
    name = "osu! (Pinned)";
    exec = "${pkgs.util-linux}/bin/taskset -c 0-7,16-23 osu! %u";
    icon = "osu!";
    terminal = false;
    type = "Application";
    categories = [ "Game" ];
    comment = "osu! pinned to 3D V-Cache CCD";
  };
}
