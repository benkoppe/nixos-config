{
  config,
  lib,
  ...
}:
let
  inherit (lib) merge mkIf enabled;
in
merge (
  mkIf config.isDesktop {
    boot = {
      plymouth = enabled;

      # enable "silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      # hide the OS choice for bootloaders.
      # requires a keypress to appear
      loader.timeout = 0;
    };
  }
)
