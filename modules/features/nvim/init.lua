--[[
  Adapted from kickstart.nvim.
  Plugin management is split:
    - specs.general / specs.lazy in your nix flake put plugins on &runtimepath
      (general = eager, lazy = only reachable via vim.cmd.packadd("name"))
    - this file only *configures* plugins (require(...).setup{...}) and
      wires up packadd for the lazy ones. No plugin manager runs in Lua.
  Plugins NOT covered by nix (telescope core, mason, plenary/nui/render-markdown
  for avante) are still installed here via vim.pack.add, since nix doesn't know
  about them yet. Move them into your nix specs whenever you get around to it
  and delete the corresponding vim.pack.add call.
--]]

-- ============================================================
-- SECTION 1: FOUNDATION
-- ============================================================
do
  vim.loader.enable()

  vim.g.mapleader = " "
  vim.g.maplocalleader = " "
  vim.g.have_nerd_font = true

  vim.o.number = true
  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  vim.o.mouse = "a"
  vim.o.showmode = false

  vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
  end)

  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = "yes"
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true

  vim.o.list = true
  vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

  vim.o.inccommand = "split"
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.confirm = true

  -- Required for vim-cool to have anything to clear. Without this, hlsearch
  -- is off by default and vim-cool has nothing to do (looks "broken").
  vim.o.hlsearch = true

  -- No manual <Esc> nohlsearch mapping needed anymore -- vim-cool clears
  -- highlighting automatically once you're done searching / move the cursor.

  vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
      end,
    },
  })

  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
  vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

  vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
  vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
  vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
  vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })
end

---Helper for the remaining vim.pack.add calls (things not yet in nix).
---@param repo string
---@return string
local function gh(repo)
  return "https://github.com/" .. repo
end

-- ============================================================
-- SECTION 2: EAGER PLUGINS PROVIDED BY NIX (specs.general)
-- These are already on &runtimepath and already sourced by Neovim's
-- native plugin loading -- just configure them.
-- ============================================================
do
  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  })

  require("which-key").setup({
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { "<leader>s", group = "[S]earch", mode = { "n", "v" } },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "gr", group = "LSP Actions", mode = { "n" } },
    },
  })

  require("tokyonight").setup({
    styles = { comments = { italic = false } },
  })
  vim.cmd.colorscheme("sorbet")

  local function set_floating_window_highlights()
    local float_bg = "#11111b"
    local float_border_fg = "#74c7ec"
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = float_bg })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = float_border_fg, bg = float_bg })
    vim.api.nvim_set_hl(0, "FloatTitle", { bg = float_bg })
    vim.api.nvim_set_hl(0, "FloatFooter", { bg = float_bg })
    vim.api.nvim_set_hl(0, "WhichKeyNormal", { bg = float_bg })
    vim.api.nvim_set_hl(0, "WhichKeyBorder", { fg = float_border_fg, bg = float_bg })
    vim.api.nvim_set_hl(0, "WhichKeyTitle", { bg = float_bg })
  end
  set_floating_window_highlights()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("floating-window-highlights", { clear = true }),
    callback = set_floating_window_highlights,
  })

  require("todo-comments").setup({ signs = false })
  require("guess-indent").setup({})
  require("auto-session").setup({})

  require("fidget").setup({})

  require("avante").setup({
    input = { provider = "snacks" },
    selector = { provider = "snacks" },
  })

  require("toggleterm").setup({
    direction = "float",
    open_mapping = [[<C-/>]],
    float_opts = { border = "rounded" },
  })

  -- markview-nvim and copilot-lua are on rtp via nix but have no required
  -- setup() call here -- add require("...").setup({...}) if/when you want
  -- non-default options for either.
end

-- ============================================================
-- SECTION 3: LAZY PLUGINS PROVIDED BY NIX (specs.lazy)
-- Not on &runtimepath until vim.cmd.packadd("name") is called. Gate each
-- behind the trigger that used to be event/cmd/keys in lazy.nvim.
-- ============================================================
do
  -- mini.nvim: used constantly (pairs/ai/surround/statusline/tabline), so
  -- there's no real lazy-loading benefit -- consider moving it to
  -- specs.general in nix. For now, packadd it eagerly here.
  require("mini.pairs").setup()
  require("mini.ai").setup({
    mappings = { around_next = "aa", inside_next = "ii" },
    n_lines = 500,
  })
  require("mini.surround").setup()
  local statusline = require("mini.statusline")
  statusline.setup({ use_icons = vim.g.have_nerd_font })
  statusline.section_location = function()
    return "%2l:%-2v"
  end
  require("mini.tabline").setup({
    format = function(buf_id, label)
      return require("mini.tabline").default_format(buf_id, label, {
        show_reorder = false,
        show_close = false,
        tabpage_section = "left",
      })
    end,
  })

  -- Duck
  vim.keymap.set("n", "<leader>dd", function()
    vim.cmd.packadd("duck.nvim")
    require("duck").hatch()
  end, { desc = "Hatch Duck" })
  vim.keymap.set("n", "<leader>dk", function()
    vim.cmd.packadd("duck.nvim")
    require("duck").cook()
  end, { desc = "Cook Duck" })
  vim.keymap.set("n", "<leader>da", function()
    vim.cmd.packadd("duck.nvim")
    require("duck").cook_all()
  end, { desc = "Cook All Ducks" })

  -- Cellular Automaton
  vim.api.nvim_create_user_command("CellularAutomaton", function(opts)
    vim.cmd.packadd("cellular-automaton.nvim")
    vim.cmd("CellularAutomaton " .. opts.args)
  end, { nargs = 1 })
  vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make It Rain" })

  -- Lazygit
  vim.keymap.set("n", "<leader>lg", function()
    vim.cmd.packadd("lazygit.nvim")
    vim.cmd("LazyGit")
  end, { desc = "LazyGit" })

  -- conform.nvim: also used on every BufWritePre, so gating it behind an
  -- event yourself buys little -- packadd it up front. Consider moving it
  -- to specs.general in nix instead.
  require("conform").setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
      local enabled_filetypes = {
        -- lua = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      end
      return nil
    end,
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = { nix = { "nixfmt" } },
  })
  vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({ async = true })
  end, { desc = "[F]ormat buffer" })

  -- telescope-fzf-native / -ui-select / -file-browser: packadd now so
  -- Section 4 can load them as telescope extensions unconditionally.
end

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- telescope.nvim + plenary.nvim aren't in nix yet -- installed via
-- vim.pack.add. Move them into specs.general whenever convenient.
-- ============================================================
do
  -- vim.pack.add({
  --   gh("nvim-lua/plenary.nvim"),
  --   gh("nvim-telescope/telescope.nvim"),
  -- })

  local select_one_or_multi = function(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
      require("telescope.actions").close(prompt_bufnr)
      for _, j in pairs(multi) do
        if j.path ~= nil then
          vim.cmd(string.format("%s %s", "edit", j.path))
        end
      end
    else
      require("telescope.actions").select_default(prompt_bufnr)
    end
  end

  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<c-enter>"] = "to_fuzzy_refine",
          ["<CR>"] = select_one_or_multi,
        },
      },
    },
    extensions = {
      ["ui-select"] = { require("telescope.themes").get_dropdown() },
    },
  })

  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")
  pcall(require("telescope").load_extension, "file_browser")

  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
  vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
  vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
  vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
  vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
  vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
  vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
  vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
  vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
      vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
      vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
      vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
      vim.keymap.set(
        "n",
        "gW",
        builtin.lsp_dynamic_workspace_symbols,
        { buffer = buf, desc = "Open Workspace Symbols" }
      )
      vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "[G]oto [T]ype Definition" })
    end,
  })

  vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
    }))
  end, { desc = "[/] Fuzzily search in current buffer" })

  vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
  end, { desc = "[S]earch [/] in Open Files" })

  vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "[S]earch [N]eovim files" })
end

-- ============================================================
-- SECTION 5: LSP
-- nvim-lspconfig and fidget.nvim come from nix (already configured in
-- Section 2 / used below). mason + friends aren't in nix -- vim.pack.add
-- for now.
-- ============================================================
do
  -- vim.pack.add({
  --   gh("mason-org/mason.nvim"),
  --   gh("mason-org/mason-lspconfig.nvim"),
  --   gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  -- })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
      map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method("textDocument/documentHighlight", event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
          end,
        })
      end

      if client and client:supports_method("textDocument/inlayHint", event.buf) then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "[T]oggle Inlay [H]ints")
      end
    end,
  })

  ---@type table<string, vim.lsp.Config>
  local servers = {
    clangd = {},
    rust_analyzer = {},
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end
        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
              "${3rd}/luv/library",
              "${3rd}/busted/library",
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = { Lua = { format = { enable = false } } },
    },
  }

  require("mason").setup({})

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, { "stylua" })
  require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- ============================================================
-- SECTION 6: AUTOCOMPLETE & SNIPPETS
-- LuaSnip and blink.cmp come from nix -- just configure them.
-- ============================================================
do
  require("luasnip").setup({})

  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
    sources = { default = { "lsp", "path", "snippets" } },
    snippets = { preset = "luasnip" },
    fuzzy = { implementation = "lua" },
    signature = { enabled = true },
  })
end

-- ============================================================
-- SECTION 7: TREESITTER
-- nvim-treesitter.withAllGrammars comes from nix with every grammar
-- already installed, so none of the install-on-demand machinery from
-- the "main"-branch treesitter API is needed -- just attach.
-- NOTE: withAllGrammars in nixpkgs may track the older/stable
-- nvim-treesitter API rather than the "main" branch. If
-- vim.treesitter.language.add / vim.treesitter.start below error on
-- startup, that's the mismatch -- check the nixpkgs vimPlugins revision,
-- or configure via require("nvim-treesitter.configs").setup{...} instead.
-- ============================================================
do
  local parsers =
    { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "markdown_inline", "query", "vim", "vimdoc", "nix" }

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local buf, filetype = args.buf, args.match
      local language = vim.treesitter.language.get_lang(filetype)
      if not language or not vim.tbl_contains(parsers, language) then
        return
      end
      if not vim.treesitter.language.add(language) then
        return
      end
      vim.treesitter.start(buf, language)
      if vim.treesitter.query.get(language, "indents") then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

-- ============================================================
-- SECTION 8: OPTIONAL EXAMPLES / NEXT STEPS
-- ============================================================
do
  -- require 'kickstart.plugins.debug'
  -- require 'kickstart.plugins.indent_line'
  -- require 'kickstart.plugins.lint'
  -- require 'kickstart.plugins.autopairs'
  -- require 'kickstart.plugins.neo-tree'
  -- require 'custom.plugins'
end

-- vim: ts=2 sts=2 sw=2 et

-- Remember folds
vim.opt.viewoptions:remove("options")
local remember_folds = vim.api.nvim_create_augroup("remember_folds", { clear = true })

local function should_save_view()
  return vim.bo.buftype == "" and vim.fn.empty(vim.fn.expand("%:t")) == 0 and vim.bo.filetype ~= "gitcommit"
end

vim.api.nvim_create_autocmd("BufWinLeave", {
  group = remember_folds,
  pattern = "?*",
  callback = function()
    if should_save_view() then
      vim.cmd("silent! mkview")
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = remember_folds,
  pattern = "?*",
  callback = function()
    if should_save_view() then
      vim.cmd("silent! loadview")
    end
  end,
})
