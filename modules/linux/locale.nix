{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    const
    genAttrs
    merge
    mkIf
    ;
in
merge {
  i18n.defaultLocale = "en_US.UTF-8";
}
<| mkIf config.isDesktop {
  i18n.extraLocaleSettings =
    genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_MEASUREMENT"
      "LC_MONETARY"
      "LC_NAME"
      "LC_NUMERIC"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ]
    <| const "en_US.UTF-8";
}
