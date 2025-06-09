{ sops-nix, ... }:
{
  imports = [ sops-nix.nixosModules.sops ];
}
# TODO: right now this uses `nixos` and is thus linux-only. For darwin, we'll need a switch
