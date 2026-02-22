{ pkgs, inputs, lib, ... }:

let
  nvidia-oc = pkgs.rustPlatform.buildRustPackage {
    pname = "nvidia_oc";
    version = "0.1.24";
    src = inputs.nvidia-oc-src;
    cargoHash = "sha256-e6cX9P5dHDOLS06Bx1VuMpH/ilcpyFnHpttG7DDwz8U=";
  };
in
{
  systemd.services.nvidia-oc = {
    description = "Nvidia Overclocking Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    };

    # You'll want to update the flags below based on your configuration
    # As with all OCing, your mileage may vary. "It works on my machine!"
    # See: https://github.com/Dreaming-Codes/nvidia_oc
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${nvidia-oc}/bin/nvidia_oc set --index 0 --freq-offset 250 --mem-offset 6000";
      User = "root";
      Restart = "on-failure";
    };
  };
}
