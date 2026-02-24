{ pkgs, ... }:

{
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 9;
      };
      custom = {
        start = "${pkgs.bash}/bin/bash -c 'sleep 1; taskset -cp 0-7,16-23 $GAMEMODE_PID'";
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    platformOptimizations.enable = true;
    gamescopeSession.enable = true;
  };

  # --- Gaming Cache ---
  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-3:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  environment.sessionVariables = {
    DXVK_HDR = "1";
    ENABLE_GAMESCOPE_WSI = "1";
  };

  # Configure for your primary display
  # Add to steam game launch options
  # gs %command%
  # gs2 grabs cursor for games that need it. ~CS2
  environment.systemPackages = with pkgs; [
    mangohud
    (pkgs.writeShellScriptBin "gs" ''
        export VCACHE_CORES="0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"
        export WINE_CPU_TOPOLOGY="16:$VCACHE_CORES"
        export SDL_VIDEODRIVER=wayland
        export SDL_VIDEO_DRIVER=wayland
        export MANGOHUD_CONFIG="fps_limit=173,no_display"

        # Proton and DXVK HDR flags
        export ENABLE_GAMESCOPE_WSI=1
        export DXVK_HDR=1
        export PROTON_ENABLE_HDR=1

        exec gamescope \
        -O DP-3 -W 3440 -H 1440 -r 175 -f \
        --adaptive-sync --hdr-enabled \
        --hdr-sdr-content-nits 1000 \
        -- \
        gamemoderun mangohud taskset -ac $VCACHE_CORES "$@"
    '')
    (pkgs.writeShellScriptBin "gs2" ''
        export VCACHE_CORES="0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"
        export WINE_CPU_TOPOLOGY="16:$VCACHE_CORES"
        export SDL_VIDEODRIVER=wayland
        export SDL_VIDEO_DRIVER=wayland
        export MANGOHUD_CONFIG="fps_limit=173,no_display"

        # Proton and DXVK HDR flags
        export ENABLE_GAMESCOPE_WSI=1
        export DXVK_HDR=1
        export PROTON_ENABLE_HDR=1

        exec gamescope \
          -O DP-3 -W 3440 -H 1440 -r 175 -f \
          --adaptive-sync --hdr-enabled \
          --force-grab-cursor \
          --hdr-sdr-content-nits 1000 \
          -- \
          gamemoderun mangohud taskset -ac $VCACHE_CORES "$@"
    '')
  ];
}
