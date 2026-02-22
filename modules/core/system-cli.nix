{ pkgs, ... }:

{
  programs.fish.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    ripgrep
    ripgrep-all
    bat
    slurm
    util-linux
    zip
    unzip
    tree
    age
    sops
  ];
}
