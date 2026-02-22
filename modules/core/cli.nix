{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    btop
    eza
    fastfetch
    fd
    fzf
    hwloc
    jq
    neovim
    nitch
    sd
    starship
    wiki-tui
    yazi
    zellij
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#ANV1L";
      nv = "nvim";
      y = "yazi";
    };
  };
  programs.nushell.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  xdg.configFile = {
    "btop".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/btop");
    "starship.toml".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/starship.toml");
    "yazi/yazi.toml".text = ''
        [opener]
        edit = [ { run = 'nvim "$@"', block = true } ]

        [preview]
        image_filter = "lanczos3"
        max_width = 1500
        max_height = 1500
      '';
  };
}
