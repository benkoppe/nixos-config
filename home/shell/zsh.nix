{ dotfiles, ... }:
{
  programs.zsh = {
    enable = true;
    initContent = builtins.readFile "${dotfiles}/.config/zsh/.zshrc";
  };
}
