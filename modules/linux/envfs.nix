{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  services.envfs = enabled;
}
