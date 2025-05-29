{ config, ...}: let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
  ./common.nix
  ./zsh.nix
  ./terminals.nix
  ];

  # add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
