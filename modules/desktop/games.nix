{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
  ];
}
