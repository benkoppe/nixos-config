{
  programs.ghostty = {
    enable = true;

    settings = {
      window-colorspace = "display-p3";
      theme = "0x96f";
      
      font-family = "MesloLG Nerd Font Mono";
      font-size = 10;

      window-padding-x = 5;
      window-padding-y = 10;

      confirm-close-surface = false;
      mouse-shift-cpature = false;

      config-file = "?config.local";
  };
}
