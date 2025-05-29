{ pkgs, ... }:
{
  # nix tooling
  home.packages = with pkgs; [
    deadnix
  ];

  programs.direnv = ={
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
