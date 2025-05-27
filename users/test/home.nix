{pkgs, ...}: {
  imports = [
    ../../home/core.nix
  ];

  programs.git = {
    userName = "Ben Koppe";
    userEmail = "koppe.development@gmail.com";
  };

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "test";

  # Install firefox.
  programs.firefox.enable = true;
}
