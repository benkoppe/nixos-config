{
  self,
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrValues
    concatStringsSep
    const
    disabled
    filterAttrs
    flip
    id
    isType
    mapAttrs
    mapAttrsToList
    merge
    optionalAttrs
    optionals
    ;
  inherit (lib.strings) toJSON;

  registryMap = inputs |> filterAttrs (const <| isType "flake");
in
{
  # don't garbage this for faster builds (<LINK HERE>)
  environment.etc.".system-inputs.json".text = toJSON registryMap;

  nix.distributedBuilds = true;

  nix.channel = disabled;

  nix.gc =
    merge {
      automatic = true;
      options = "--delete-older-than 3d";
    }
    <| optionalAttrs config.isLinux {
      dates = "weekly";
      persistent = true;
    };

  nix.nixPath =
    registryMap
    |> mapAttrsToList (name: value: "${name}=${value}")
    |> (if config.isDarwin then concatStringsSep ":" else id);

  nix.registry =
    registryMap // { default = inputs.nixpkgs; } |> mapAttrs (_: flake: { inherit flake; });

  nix.settings =
    (import <| self + /flake.nix).nixConfig
    |> flip removeAttrs (optionals config.isDarwin [ "use-cgroups" ]);

  nix.optimise.automatic = true;

  nixpkgs.overlays = [ inputs.nur.overlay ];

  environment.systemPackages = attrValues {
    inherit (pkgs)
      nh
      nix-index
      nix-output-monitor
      ;
  };
}
