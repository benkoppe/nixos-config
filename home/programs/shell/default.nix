{ config, ...}: let
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  import = [
  ./common.nix
  ./zsh.nix
  ];

  # add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
  };
}
