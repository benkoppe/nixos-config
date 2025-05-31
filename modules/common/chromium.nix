{ config, lib, pkgs, ... }: let
  inherit (lib) enabled merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    programs.chromium = enabled;
  }];
}

