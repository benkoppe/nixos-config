{
  config,
  lib,
  ...
}:
let
  inherit (lib) merge mkIf enabled;
in
merge (
  mkIf config.isDesktop {
    boot.plymouth = enabled;
  }
)
