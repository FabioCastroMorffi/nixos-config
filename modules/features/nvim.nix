{ self, inputs, ... }: {

  flake.nixosModules.nvim = { pkgs, lib, ... }: {
    programs.neovim = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim;
    };
  };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {

      packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;

        specs.general = with pkgs.vimPlugins; [
          auto-session
          guess-indent-nvim
          gitsigns-nvim
          which-key-nvim
          tokyonight-nvim
          todo-comments-nvim

          mini-nvim
          vim-cool
          # transparent-nvim
          auto-session

          luasnip
          blink-cmp

          nvim-treesitter
          nvim-lspconfig
          fidget-nvim

          copilot-lua
          # copilot-vim
          avante-nvim

          toggleterm-nvim
        ];

        specs.lazy = {
          lazy = true;
          data = with pkgs.vimPlugins; [
            duck-nvim
            cellular-automaton-nvim
            # discotheque-vim

            lazygit-nvim

            telescope-fzf-native-nvim
            telescope-file-browser-nvim
            telescope-ui-select-nvim

            conform-nvim
          ];
        };

        info = {
          have_nerd_font = true;
          leader = " ";
          colorscheme = "sorbet";
        };

        runtimePkgs = with pkgs; [
          clang-tools
          rust-analyzer
          gopls
          lua-language-server
          stylua
          nixfmt

          gnumake
          nodejs
          lazygit
        ];

        settings.config_directory = ./nvim;
      };
    };
}
