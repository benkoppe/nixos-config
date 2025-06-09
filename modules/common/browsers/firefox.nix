{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) merge mkIf enabled;
in
merge
<| mkIf (config.isDesktop) {
  home-manager.sharedModules = [
    {
      programs.firefox = enabled {
        policies = {
          # Check about:policies#documentation for options.
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          DisablePocket = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxScreenshots = true;
          OverrideFirestRunPage = "";
          OverridePostUpdatePage = "";
          DontCheckDefaultBrowser = true;
          DisplayBookmarksToolbar = "always"; # alternatives: "always" or "newtab"
          DisplayMenuBar = "default-off"; # alternatives: "always", "never", or "default-on"
          SearchBar = "unified";
        };

        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;
            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              darkreader
              vimium
            ];
            extensions.autoDisableScopes = 0;
          };
        };
      };
    }
  ];
}
