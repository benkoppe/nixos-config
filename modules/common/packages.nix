{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) attrValues optionalAttrs;
in
{
  environment.systemPackages =
    attrValues
    <|
      {
        inherit (pkgs)
          cowsay
          dig
          eza
          fastfetch
          fd
          openssl
          p7zip
          rsync
          yt-dlp

          vim
          just
          devenv
          yazi

          treefmt
          nixfmt-rfc-style
          ;

        fortune = pkgs.fortune.override { withOffensive = true; };
      }
      // optionalAttrs config.isLinux {
        inherit (pkgs)
          traceroute
          ;
      }
      // optionalAttrs config.isDesktop {
        inherit (pkgs)
          clang_16
          clang-tools_16
          deno
          gh
          go
          jdk
          lld
          llvm
          maven
          zig
          cargo
          python314
          uv

          qbittorrent
          ;
      }
      // optionalAttrs (config.isLinux && config.isDesktop) {
        inherit (pkgs)
          xclip
          flameshot

          thunderbird
          krita
          ;
        inherit (pkgs.xorg) xev;
      };
}
