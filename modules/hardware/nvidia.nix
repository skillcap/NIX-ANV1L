{ config, pkgs, ... }:

{
  # --- Driver & Graphics Support ---
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;

  # --- Nvidia Blackwell Configuration ---
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

  # --- Session & Wayland Variables ---
  environment.sessionVariables = {
    NVIDIA_VARIANT = "open";
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_DRM_NO_ATOMIC = "1";
  };

  # --- Utils ---
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia # Monitoring
  ];
}
