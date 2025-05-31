{ config, lib, pkgs, inputs, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    imports = [ inputs.mnw.homeManagerModules.default ];

    programs.mnw = enabled {
      
    };
  ]};
}
