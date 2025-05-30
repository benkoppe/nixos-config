{ config, lib, ... }: let
  inherit (lib) enabled;
in {
  home-manager.sharedModules = [{
    programs.btop.enabled = true;
  }];
}
