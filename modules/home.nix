{ config, pkgs, ... }:
{
  flake.homeModules.default = { pkgs, ...}: {
    home.username = "fabio";
    home.homeDirectory = "/home/fabio";

    # Example Home Manager options
    # programs.zsh.enable = true;
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "fabio";
          email = "fabiocastromorffi@gmail.com";
        };
      };
    };


    programs.bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''''; 
      historyIgnore = [
          "ls*"
          "cd*"
          "exit"
          "history*"
          "man *"
      ];
      initExtra = ''
          if [[ "$KITTY_WINDOW_ID" == "1" ]]; then
            fastfetch --logo ~/Pictures/wooper_ascii.txt --logo-color-1 94 --color-keys 117 --color-title 117
          fi

          unset PROMPT_COMMAND
          set_my_prompt() {
                  # Using pure ANSI escapes ensures no dependency on 'tput' timing
                  local COLOR_USER="\[\e[38;5;39m\]"
                  local COLOR_AT="\[\e[38;5;45m\]"
                  local COLOR_HOST="\[\e[38;5;51m\]"
                  local COLOR_DIR="\[\e[38;5;195m\]"
                  local COLOR_RESET="\[\e[0m\]"
                  
                  export PS1="''${COLOR_USER}\u''${COLOR_AT}@''${COLOR_HOST}\h ''${COLOR_DIR}\w''${COLOR_RESET}\$ "
          } 

          PROMPT_COMMAND=set_my_prompt
        '';

      sessionVariables = {
        PATH="$HOME/.cargo/bin:$PATH";
      };

      shellAliases = {
        "vim" = "nvim";
        "ls" = "ls --color=auto";
        "grep" = "grep --color=auto";
        "fgrep" = "fgrep --color=auto";
        "egrep" = "egrep --color=auto";
      };
    };

    programs.dircolors = {
        enable = true;
        enableBashIntegration = true;
    };

    # programs.starship = {
    #   enable = true;
    #   enableBashIntegration = true;
    #   settings = {
    #     # single-line layout
    #     add_newline = false;
    #
    #     format = "$directory$git_branch$git_status$character";
    #     directory = {
    #       truncation_length = 3;
    #       truncate_to_repo = true;
    #       style = "bold cyan";
    #     };
    #
    #     git_branch = {
    #         format = "on [$symbol$branch]($style) ";
    #         symbol = "⌥";
    #         style = "bold purple";
    #     };
    #
    #     git_status = {
    #       format = "[\\[$all_status$num_status\\]]($style) ";
    #       style = "bold red";
    #     };
    #
    #     character = {
    #       success_symbol = "[❯](bold green)";
    #       error_symbol = "[❯](bold red)";
    #     };
    #   };
    # };

    home.stateVersion = "26.05";
  };
}
