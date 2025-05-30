{ config, lib, pkgs, ... }: let
  inherit (lib) attrValues disabled merge mkIf;
in merge

(mkIf config.isDesktop {
  fonts.packages = attrValues {
    sans = pkgs.noto-fonts;
    mono = pkgs.nerd-fonts.meslo-lg;

    inherit (pkgs)
      material-design-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-jgc-plus
      noto-fonts-emoji
    ;
  };
})

(mkIf config.isServer {
  fonts.fontconfig = disabled;
})
