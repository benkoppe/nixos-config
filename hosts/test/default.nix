lib: lib.nixosSystem' ({ config, lib, ... }: let
  inherit (lib) collectNix remove;
in {
  imports = collectNix ./. |> remove ./default.nix;

  users.users = {
    root = {};
    test = {
      description  = "Test";
      isNormalUser = true;
      extraGroups  = [ "wheel" ];
    };
  };

  time.timeZone = "America/Los_Angeles";

  nixpkgs.config.allowUnfree = true;

  home-manager.users = {
    root = {};
    test = {};
  };

  boot.loader.grub = enabled {
    device = "/dev/vda";
    useOSProber = true;
  };

  networking = {
    hostName = "test";
    
    # wireless.enable = true;
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  system.stateVersion = "25.05";
  home-manager.sharedModules = [{
    home.stateVersion = "25.05";
  }];

  # Enable auto login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "test";

  # Add qemu-guest-agent
  services.qemuGuest.enable = true;
  # Add spice-vdagent
  services.spice-vdagentd.enable = true;
})
