{ lib, ... }:
let
  inherit (lib) enabled disabled;
in
{
  services.openssh = enabled {
    openFirewall = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = disabled;

  # automatically start openssh agent on login
  programs.ssh.startAgent = true;
}
