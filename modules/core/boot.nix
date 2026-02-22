{ pkgs, lib, inputs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # --- Secure Boot ---
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Kernel Params ---
  boot.kernelParams = [
    # --- Graphics ---
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"

      # --- CPU Optimization ---
      "amd_pstate=active"                    # Let the CPU manage its own frequency
      "initcall_blacklist=acpi_cpufreq_init" # Prevent conflicts with old driver
      "nowatchdog"                           # Disable the kernel watchdog
      "nmi_watchdog=0"                       # Disable Non-Maskable Interrupt watchdog

      # --- System Latency ---
      "split_lock_detect=off"                # Prevent stutters in unoptimized software
      "transparent_hugepage=madvise"         # Faster memory pages for large assets
  ];

  # --- CachyOS LTS compiled locally for native instruction set ---
  boot.kernelPackages = let
    # LTS to ensure compatibility with Nvidia 590.xx drivers
    # Unfortunately LTO breaks the NVIDIA open drivers at the moment
    baseKernel = inputs.nix-cachyos-kernel.packages.${pkgs.system}.linux-cachyos-lts;

    optimizedKernel = baseKernel.overrideAttrs (old: {
      modDirVersion = "${old.version}-cachyos-znver5-v4-fixed";

      # Inject Zen 5 Native AVX-512 flags
      preConfigure = (old.preConfigure or "") + ''
        export KCFLAGS="-march=native -O3 -pipe"
        export KCPPFLAGS="-march=native -O3 -pipe"
      '';

      separateDebugInfo = false;
    });
  in
    pkgs.linuxPackagesFor optimizedKernel;

  # --- Memory Compression ---
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # Balance of speed/compression
    memoryPercent = 100; # % compressable - (3:1)
  };

  # --- Task Scheduler ---
  services.scx = {
    enable = true;
    package = pkgs.scx.full;
    scheduler = "scx_lavd"; # Optimized for latency
  };

  # --- AppImage Support ---
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    sbctl # Secure boot management
  ];
}
