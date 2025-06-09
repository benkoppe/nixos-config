{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  programs.direnv = enabled {
    nix-direnv = enabled;

    silent = true;
    loadInNixShell = true;
    enableZshIntegration = true;
  };
}
