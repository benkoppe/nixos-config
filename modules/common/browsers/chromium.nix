{ config, lib, ... }:
let
  inherit (lib) enabled merge mkIf;
  extensions = [
    { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # sponsorblock
    { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
    { id = "pejdijmoenmkgeppbflobdenhhabjlaj"; } # icloud passwords
    { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # google translate
  ];
in
merge
<| mkIf config.isDesktop {
  home-manager.sharedModules = [
    {
      programs.chromium = enabled {
        inherit extensions;
      };

      programs.brave = enabled {
        inherit extensions;
      };
    }
  ];
}
