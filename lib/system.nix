inputs: self: super: let
  inherit (self) attrValues filter getAttrFrompath hasAttrByPath collectNix;

  modulesCommon = collectNix ../modules/common;
  modulesLinux  = collectNix ../modules/linux;
  # modulesDarwin = collectNix ../modules/darwin;

  inputModulesLinux  = collectInputs [ "nixosModules"  "default" ];
  inputModulesDarwin = collectInputs [ "darwinModules" "default" ];

  inputOverlays = collectInputs [ "overlays" "default" ];
  overlayModule = { nixpkgs.overlays = inputOverlays; };

  specialArgs = inputs // {
    inherit inputs;

    # keys = import ../keys.nix;
    lib = self;
  };
in {
  nixosSystem' = module: super.nixosSystem {
    inherit specialArgs;

    modules = [
      module
      overlayModule
    ] ++ modulesCommon
      ++ modulesLinux
      ++ inputModulesLinux;
  };
}
