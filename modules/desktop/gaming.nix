{ pkgs, lib, config, ... }:

{
  options = {
    modules.desktop.gaming = {
      enable = lib.mkEnableOption "Gaming related configurations";
    };
  };

  config = lib.mkIf config.modules.desktop.gaming.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 9;
        };
        cpu = {
          pin_cores = "0-7,16-23";
        };
        gpu = {
          apply_gpu_optimizations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
        };
      };
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      platformOptimizations.enable = true;
      gamescopeSession.enable = false;
      package = pkgs.steam.override {
        extraEnv = {
          WINE_CPU_TOPOLOGY = "16:0,1,2,3,4,5,6,7,16,17,18,19,20,21,22,23";
          VKD3D_CONFIG = "dxr,dxr11,frame_latency=1";
          MANGOHUD_CONFIG = "position=top-left,toggle_hud=bracketright,fps,frametime,cpu_temp,gpu_temp,vram,ram,core_bars,no_display,fps_limit=173,fps_limit_method=late";
          PROTON_ENABLE_NVAPI = "1";
          DXVK_ENABLE_NVAPI = "1";
        };
      };
    };

    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-3:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    environment.systemPackages = with pkgs; [
      mangohud
      gamescope
      heroic
      # Helper for standard Wayland gaming
      (writeShellScriptBin "gs" ''
        export SDL_VIDEODRIVER=wayland
        export SDL_VIDEO_DRIVER=wayland
        export DXVK_HDR=1
        export PROTON_ENABLE_HDR=1
        export PROTON_ENABLE_WAYLAND=1
        export ENABLE_HDR_WSI=1
        export VKD3D_CONFIG="hdr,dxr,dxr11,frame_latency=1"
        export PROTON_ENABLE_NVAPI=1
        export DXVK_ENABLE_NVAPI=1
        export DXVK_CONFIG="dxvk.maxFrameLatency=1"
        export MANGOHUD_CONFIG="fps_limit=173,fps_limit_method=late"

        exec gamemoderun mangohud "$@"
      '')
      (writeShellScriptBin "gs2" ''
        export VKD3D_CONFIG="dxr,dxr11,frame_latency=1"
        export PROTON_ENABLE_NVAPI=1
        export DXVK_ENABLE_NVAPI=1
        export DXVK_CONFIG="dxvk.maxFrameLatency=1"
        export MANGOHUD_CONFIG="fps_limit=173,fps_limit_method=late"

        exec gamemoderun mangohud "$@"
      '')
      (writeShellScriptBin "gs3" ''
        export DXVK_HDR=1
        export ENABLE_HDR_WSI=1
        export PROTON_ENABLE_NVAPI=1
        export DXVK_ENABLE_NVAPI=1
        export DXVK_CONFIG="dxvk.maxFrameLatency=1"
        export MANGOHUD_CONFIG="fps_limit=173,fps_limit_method=late"

        exec gamemoderun gamescope --rt -O DP-3 -W 3440 -H 1440 -f -e --hdr-enabled --force-grab-cursor -- mangohud "$@"
      '')
    ];
  };
}
