{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    kubectl
    kube-score
    k9s
    kubernetes-helm
    kind
    kubectx
    fluxcd
    popeye
    stern
  ];

  programs.fish.shellAliases = {
    k = "kubectl";
    kgp = "kubectl get pods";
    kga = "kubectl get all";
    kgn = "kubectl get nodes";
    kd = "kubectl describe";
    kl = "kubectl logs";
    ke = "kubectl edit";
  };
}
