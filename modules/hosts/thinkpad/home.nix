{ config, pkgs, ... }:
{
  flake.homeModules.homeThinkpad = { pkgs, ... }: {

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
          fastfetch --logo ~/.config/assets/wooper_ascii.txt --structure-disabled colors --logo-position top --logo-color-1 94 --color-keys 117 --color-title 117
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
        PATH = "$HOME/.cargo/bin:$PATH";
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

    home.packages = with pkgs; [
      slack
      yazi

      # Snip
      grim
      slurp
      wl-clipboard
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

    home.file = {
      # This creates a file at ~/.config/my-app/config.txt
      ".config/assets/wooper_ascii.txt".text = ''
                            ..........		
                       .~!7?YPPPPPPPPPJ!77.
             :      ^7Y5JYYJ77777777JYYY55J^   ^YG. .^
          J~ :P5^ :J5J77777777777777777777J5J: ~G@P:7#....
        .?@7 :P@7~GJ777777777777777777777777?#7 ^P@Y&GGG5!
        :G#G55P##PJ7777777777777777777777777JYP5YGBGPG#Y^
        :5#YY&#&#5!777777777777777777777777?&G##B#@? .7B!
        :Y^  ~@5GP!7777777777777777777777777?5&P^&B&5  .
            !#P.?PY77777777777777777777777777JP? ^557
            :!   ~PJ777777777777777777777777J#!
                  .J5J??7777777777777777??J5J:
                    :?5Y55J?77777777?YYYY5?:
                       .!~P#P??????7?5#J         ^^?555~.
                         ?5Y7J5PP5J777?55^     ~Y55J???55!
                       .7GJ7JJ????JJ?77GYY^.77Y5?777777!BP
                       ^@?!7J5YYYY5J777!B&5YY?77777777JG]
                       .75J?YY????YY?777?BBJ?777777JJ5?:
                       .~?BYB5YY5J7JP5YJ?JY55555YY?:
                      ~PJJJYP#P55555GGPP55J
                      :?555P5!      JP?JJJP
                      ~JJJJJ!       ~JJJJJ!
      '';

      # You can also create executable scripts this way
      ".config/assets/snip".text = ''
        #!/usr/bin/env bash
        grim -g "$(slurp)" - | wl-copy
      '';
      ".config/assets/snip".executable = true;
    };

    home.stateVersion = "26.05";
  };
}
