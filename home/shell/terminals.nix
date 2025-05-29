{ dotfiles, ... }:

# terminals

{
  programs.ghostty = {
    enable = true;

    settings = builtins.readFile "${dotfiles}/.config/ghostty/config";
  };
}
