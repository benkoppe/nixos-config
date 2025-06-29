{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) merge mkIf enabled;
  sddmAstronautTheme =
    {
      stdenvNoCC,
      qt6,
      lib,
      fetchFromGitHub,
      formats,
      theme ? "astronaut",
      themeConfig ? null,
    }:
    let
      overwriteConfig = (formats.ini { }).generate "${theme}.conf.user" themeConfig;
    in
    stdenvNoCC.mkDerivation rec {
      name = "sddm-astronaut-theme";

      src = fetchFromGitHub {
        owner = "Keyitdev";
        repo = "sddm-astronaut-theme";
        rev = "bf4d01732084be29cedefe9815731700da865956";
        hash = "sha256-JMCG7oviLqwaymfgxzBkpCiNi18BUzPGvd3AF9BYSeo=";
      };

      propagatedUserEnvPkgs = with qt6; [
        qtsvg
        qtvirtualkeyboard
        qtmultimedia
      ];

      dontBuild = true;

      dontWrapQtApps = true;

      installPhase = ''
        themeDir="$out/share/sddm/themes/${name}"

        mkdir -p $themeDir
        cp -r $src/* $themeDir

        install -dm755 "$out/share/fonts"
        cp -r $themeDir/Fonts/* $out/share/fonts/

        # Update metadata.desktop to load the chosen theme.
        substituteInPlace "$themeDir/metadata.desktop" \
          --replace-fail "ConfigFile=Themes/astronaut.conf" "ConfigFile=Themes/${theme}.conf"

        # Create theme.conf.user of the selected theme. To overwrite its configuration.
        ${lib.optionalString (lib.isAttrs themeConfig) ''
          install -dm755 "$themeDir/Themes"
          cp ${overwriteConfig} $themeDir/Themes/${theme}.conf.user
        ''}
      '';

      meta = with lib; {
        description = "Series of modern looking themes for SDDM";
        homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
        license = licenses.gpl3;
        platforms = platforms.linux;
      };
    };
in
merge (
  mkIf (false && config.isDesktop) {
    # add theme to environment
    environment.systemPackages = with pkgs; [
      (callPackage sddmAstronautTheme {
        theme = "pixel_sakura";
      })
    ];

    # use sddm as displayManager
    services.displayManager = {
      sddm = enabled {
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
        extraPackages = with pkgs; [
          kdePackages.qtmultimedia
          kdePackages.qtsvg
          kdePackages.qtvirtualkeyboard
        ];
      };
      defaultSession = "none+i3";
    };
  }
)
