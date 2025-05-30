# enable audio
{ config, lib, ... }: let
  inherit (lib) enabled disabled merge mkIf;
in merge <| mkIf config.isDesktop {
  services.pulseaudio = disabled;
  security.rtkit = enabled;

  services.pipewire = enabled {
    alsa = enabled;
    pulse = enabled;

    # jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };
}
