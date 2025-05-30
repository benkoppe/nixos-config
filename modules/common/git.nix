{ self, config, lib, pkgs, ... }: let
  inherit (lib) attrValues head mkAfter enabled merge mkIf;
  inherit (lib.strings) match;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
      git-absorb
      tig
      lazygit
    ;
  };

  home-manager.sharedModules = [
    {programs.git = enabled {
      userName  = "Ben";
      userEmail = "koppe.development@gmail.com";

      lfs = enabled;

      difftastic = enabled {
        background = "dark";
      };

      extraConfig = merge {
        init.defaualtBranch = "main";

        commit.verbose = true;

        log.date  = "iso";
        column.ui = "auto";

        branch.sort = "-committerdate";
        tag.sort    = "version:refname";

        diff.algorithm  = "histogram";
        diff.colorMoved = "default";

        pull.rebase          = true;
        push.autoSetupRemote = true;

        merge.conflictStyle = "zdiff3";

        rebase.autoSquash = true;
        rebase.autoStash  = true;
        rebase.updateRefs = true;
        rerere.enabled    = true;

        fetch.fsckObjects    = true;
        receive.fsckObjects  = true;
        transfer.fsckobjects = true;

        alias.recent = "! git branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\" | head -10";

        # replace https with ssh
        url = {
          "ssh://git@github.com/benkoppe" = {
            insteadOf = "https://github.com/benkoppe";
          };
        };
      };

    };}

    (mkIf config.isDesktop {
      programs.gh = enabled {
        settings.git_protocol = "ssh";
      };
    })
  ]; 
}
