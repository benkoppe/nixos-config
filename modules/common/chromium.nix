{ config, lib, pkgs, ... }: let
  inherit (lib) enabled mapAttrsToList merge mkIf;
in merge <| mkIf config.isDesktop {
  home-manager.sharedModules = [{
    packages.chromium = enabled;
  }];
}

