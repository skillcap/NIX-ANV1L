{ pkgs, ... }:

{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
  ];

  # Tells Kind to use Podman
  environment.sessionVariables = {
    KIND_EXPERIMENTAL_PROVIDER = "podman";
  };
}
