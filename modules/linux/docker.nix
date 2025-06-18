{ config, lib, ... }:
let
  inherit (lib)
    enabled
    mkIf
    merge
    ;
in
merge (
  mkIf config.isDesktop {
    virtualisation.docker = enabled;
  }
)
