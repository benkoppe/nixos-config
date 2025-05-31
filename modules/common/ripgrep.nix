{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  home-manager.sharedModules = [
    {
      programs.ripgrep = enabled {
        arguments = [
          "--line-number"
          "--smart-case"
        ];
      };
    }
  ];
}
