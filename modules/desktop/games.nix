{ pkgs, config, inputs, ... }:

{
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.system}.osu-lazer-bin
    (pkgs.prismlauncher.override {
      additionalLibs = with pkgs; [
        vulkan-loader
        libglvnd
        linuxPackages.nvidia_x11
        stdenv.cc.cc.lib
        xorg.libX11       # Required for Vulkan surface creation
        wayland           # Required for Hyprland
        libxkbcommon
      ];
    })
  ];

  xdg.desktopEntries = {
    "osu-lazer-pinned" = {
      name = "osu! (Pinned)";
      exec = "gamemoderun osu! %u";
      icon = "osu!";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
      comment = "osu! pinned to 3D V-Cache CCD";
    };
  };
}
