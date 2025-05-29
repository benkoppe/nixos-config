{pkgs, ...}: {
  imports = [
    ../../home/core.nix

    ../../home/programs
    ../../home/shell
  ];

  programs.git = {
    userName = "Ben Koppe";
    userEmail = "koppe.development@gmail.com";
  };

  # Enable automatic login for the user.
  }
