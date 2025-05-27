{
  pkgs,
  config,
  username,
  ...
}: {
  programs = {
    chromium = {
      enable = true;
    };

    firefox = {
      enable = true;
    };
  };
}
