# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  pkgs,
  lib,
  username,
  ...
}: {
  # enable zsh shell for completions (actual enabling is done in home-manager)
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with `passwd`.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # give the users in this list the right to specify additional substituters via:
  #  1. `nixConfig.substituters` in `flake.nix`
  #  2. command line args `--options substituters http://xxx`
  nix.settings.trusted-users = [username];

  # customize /etc/nix/nix.conf declaratively nix `nix.settings`
  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    substituters = [
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431x0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    builders-use-substitutes = true;
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };   

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons

      # normal fonts
      noto-fonts
      noto-fonts-emoji

      # nerdfonts
      nerd-fonts.meslo-lg
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["MesloLG Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # automatically start openssh agent on login
  programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # core tools
    tealdeer # a very fast version o f tldr
    fastfetch
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    just # justfile
    git
    git-lfs # used by huggingface models
    yadm # dotfiles manager

    # archives
    zip
    xz
    p7zip

    # text processing
    gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
    gnused # GNU ssed, very powerful for text replacement
    gawk # GNU awk, pattern scanning & processing
    jq # lightweight and flexible command-line JSON processor

    # networking tools
    mtr # network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, providing the command `drill`
    wget
    curl
    aria2 # a lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # a utility for network discovery and security auditing
    ipcalc # calculator for IPv4/v6 addresses

    # misc
    file
    findutils
    which
    tree
    gnutar
    rsync

    sysstat
    lm_sensors # for `sensors` command
    fastfetch
    # minimal screen capture tool, used by i3 blur lock to take a screenshot
    # print screen key is also bound to this tool in i3 config
    # scrot
    # xfce.thunar # xfce4's file manager
];

  # Set the default editor to vim.
  environment.variables.EDITOR = "vim";

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

}
