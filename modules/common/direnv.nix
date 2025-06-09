{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  programs.direnv = enabled {
    nix-direnv = enabled;

    loadInNixShell = true;
    enableZshIntegration = true;
  };
}
