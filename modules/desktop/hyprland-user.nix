{ config, pkgs, lib, ... }:

{
  # --- Cursor Theme ---
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # --- GTK Theme ---
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
  };

  home.packages = with pkgs; [
    kitty
    wl-clipboard
    libnotify
    cava
  ];

  # Symlinks
  xdg.configFile = {
    "hypr".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/etc/nixos/dotfiles/hypr");
  };
}
