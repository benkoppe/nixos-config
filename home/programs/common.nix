{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    htop

    # misc
    libnotify
  ];

  programs = {
    tmux = {
      enable = true;
    };

    bat = {
      enable = true;
    };
  };

  services = {
    # auto mount usb drives
    udiskie.enable = true;
  };
}
