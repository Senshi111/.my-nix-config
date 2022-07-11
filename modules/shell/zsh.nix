#
# Shell
#

{ pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
 #     dotDir = ".config/zsh_nix";
      autosuggestions.enable = true;             # Auto suggest options and highlights syntact, searches in history for options
      syntaxHighlighting.enable = true;
#      history = {
#        size = 10000;
#        path = "${config.xdg.dataHome}/zsh/history";
#      };
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake github:Senshi111/.my-nix-config#desktop";
        in-node = "nix-shell -p nodejs";
        clear-g = "sudo nix-collect-garbage -d";
        flake-u = "nix flake update";
        git-p = "git push -u -f origin main";
        flat-u = "flatpak update";
        ec = "cd ~/Documents/GitHub/ElderCounsel/web-platform"
      };
      ohMyZsh = {                             # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
        custom = "$HOME/.config/zsh_nix/custom";
      };

#      initExtra = ''                            # Zsh theme
#        # Spaceship
#        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
#        autoload -U promptinit; promptinit
#       source $HOME/.config/shell/shell_init
#        # Hook direnv
#       emulate zsh -c "$(direnv hook zsh)"
#        # Swag
#        pfetch                                  # Show fetch logo on terminal start
#      '';
    };
  };
}
