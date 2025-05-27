{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "Ben Koppe";
    userEmail = "koppe.development@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase =  true;

      # replace https with ssh
      url = {
        "ssh://git@github.com/benkoppe" = {
          insteadOf = "https://github.com/benkoppe";
        };
      };
    };
  };
}
