{ pkgs, inputs, ... }:

{
  # --- Desktop ---
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Dank Material Shell Ecosystem
  programs.dms-shell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    # Core features
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };

  # DankSearch
  programs.dsearch.enable = true;

  # DMS Greeter
  services.displayManager.defaultSession = "hyprland-uwsm";
  programs.dank-material-shell.greeter = {
    enable = true;
    compositor = {
      name = "niri";
      customConfig = ''
        // --- Left Vertical (DP-1) ---
        output "DP-1" {
            mode "1920x1080@60"
            position x=0 y=1210
            transform "270"
            scale 1.0
        }

        // --- Center Ultrawide (DP-3) ---
        output "DP-3" {
            mode "3440x1440@175"
            position x=1080 y=1440
            scale 1.0
        }

        // --- Top Center (DP-2) ---
        output "DP-2" {
            mode "2560x1440@165"
            position x=1520 y=0
            scale 1.0
        }

        // --- Right Vertical (HDMI-A-1) ---
        output "HDMI-A-1" {
            mode "1920x1080@60"
            position x=4520 y=1210
            transform "90"
            scale 1.0
        }

        hotkey-overlay {
          skip-at-startup
        }
      '';
    };
    configHome = "/home/skill";
  };

  programs.niri.enable = true; # for DMS Greeter

  environment.systemPackages = with pkgs; [
    inputs.dsearch.packages.${pkgs.system}.default
    vulkan-hdr-layer-kwin6
  ];
}
