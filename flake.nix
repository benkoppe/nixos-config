{
  description = "My NixOS + home-manager default config - Ben Koppe";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    experimental-features = [
      "cgroups"
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    builders-use-substitutes = true;
    lazy-trees               = true;
    show-trace               = true;
    trusted-users            = [ "root" "@build" "@wheel" "@admin" ];
    use-cgroups              = true;
    warn-dirty               = false;
  };

  

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:benkoppe/dotfiles";
      flake = false;
    };

    nix.url = "github:DeterminateSystems/nix-src";
    nil.url = "github:oxalica/nil";
  };

  outputs = inputs @ { nixpkgs, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs nameValuePair;

    lib = nixpkgs.lib.extend <| import ./lib inputs;

    hostsByType = readDir ./hosts
      |> mapAttrs (name: const <| import ./hosts/${name} lib)
      |> attrsToList
      |> groupBy ({ name, value }:
        if value ? class && value.class == "nixos" then
          "nixosConfigurations"
        else
          "darwinConfigurations")
      |> mapAttrs (const listToAttrs);

    hostConfigs = hostsByType.nixosConfigurations
      |> attrsToList
      |> map ({ name, value }: nameValuePair name value.config)
      |> listToAttrs;
  in hostsByType // hostConfigs;

  #outputs = inputs @ {
  #  self,
  #  nixpkgs,
  #  home-manager,
  #  ...
  #}: {
  #  nixosConfigurations = {
  #    test = let
  #      username = "test";
  #      specialArgs = {inherit username; inherit (inputs) dotfiles;};
  #    in
  #      nixpkgs.lib.nixosSystem {
  #        inherit specialArgs;
  #        system = "x86_64-linux";
  #        
  #        modules = [
  #          ./hosts/test

  #        home-manager.nixosModules.home-manager {
  #          home-manager.useGlobalPkgs = true;
  #          home-manager.useUserPackages = true;

  #          home-manager.extraSpecialArgs = inputs // specialArgs;
  #          home-manager.users.${username} = import ./users/${username}/home.nix;
  #        }
  #      ];
  #    };
  #  };
  #};
}
