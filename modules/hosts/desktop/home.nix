{ config, pkgs, ... }:
{
  flake.homeModules.homeDesktop = { pkgs, ...}: {
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
      historyIgnore = [
          "ls*"
          "cd*"
          "exit"
          "history*"
          "man *"
      ];
      initExtra = ''
          if [[ "$KITTY_WINDOW_ID" == "1" ]]; then
            fastfetch --logo ~/Pictures/wooper_ascii.txt --structure-disabled colors --logo-position top --logo-color-1 94 --color-keys 117 --color-title 117
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

    programs.kitty = {
      enable = true;
      enableGitIntegration = true;
      font = {
        name = "FiraCode Nerd Font Mono";
        size = 12;
      };
      extraConfig = ''
        cursor_shape block
        cursor_shape_unfocused hollow

        # Trail
        cursor_trail 1
        cursor_trail_decay 0.1 0.4
        enable_audio_bell no

        #windows
        rememeber_window_size no
        initial_window_width 80c
        initial_window_height 24c
        window_margin_width 7.5
        window_padding_width 0
        hide_window_decorations yes

        #background
        background_opacity 0.65
        background_blur 1
    '';
    };

    # programs.rmpc = {
    #   enable = true;
    #   config = {
    #
    #
    #   };
    # };

    home.packages = with pkgs; [
      slack
      yazi
    ];

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
