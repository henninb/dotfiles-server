--------------------------------------------------------------------------------
-- Plugins & Plugin Configurations
--------------------------------------------------------------------------------
require("plugins")         -- Load plugin manager settings

-- Plugin setups
require('lualine').setup()   -- Statusline
-- require('nvim_comment').setup()  -- Comment toggling
require("lsp")             -- Language Server Protocol configurations

--------------------------------------------------------------------------------
-- Treesitter Configuration
--------------------------------------------------------------------------------
-- Guarded setup to avoid errors if plugin missing
local ok_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  -- Disable TS highlighting on very large files to avoid parser issues
  local function disable_on_large_files(lang, buf)
    local max_filesize = 100 * 1024 -- 100 KB
    local uv = vim.uv or vim.loop
    local ok, stats = pcall(uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size and stats.size > max_filesize then
      return true
    end
    return false
  end

  ts_configs.setup {
    -- Parsers to install (or use "all")
    ensure_installed = {
      "c", "rust", "haskell", "javascript", "json", "kotlin", "go", "make",
      "perl", "python", "sql", "ruby", "toml", "typescript", "yaml", "dockerfile",
      "css", "clojure", "bash", "html", "lua", "cpp", "ocaml"
    },
    sync_install = false,       -- Install parsers asynchronously
    auto_install = true,        -- Automatically install missing parsers on buffer entry

    highlight = {
      enable = true,            -- Enable tree-sitter highlighting
      -- Disable Tree-sitter for markdown completely and use vim syntax
      disable = function(lang, buf)
        if lang == "markdown" or lang == "markdown_inline" then
          return true
        end
        return disable_on_large_files(lang, buf)
      end,
      -- Use regex highlighting for markdown files
      additional_vim_regex_highlighting = { "markdown", "org" },
    },

    -- Incremental selection based on syntax nodes
    incremental_selection = {
      enable = true,
      disable = { "markdown" }, -- Disable for markdown to prevent issues
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn", 
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },

    -- Tree-sitter playground for debugging syntax trees
    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
    },
  }
end

-- use 'tpope/vim-commentary'

--[[
--------------------------------------------------------------------------------
-- Optional: Null LS Configuration
--------------------------------------------------------------------------------
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
    },
})
--]]

--------------------------------------------------------------------------------
-- Global Variables and Options
--------------------------------------------------------------------------------
local g  = vim.g   -- Global variables
local o  = vim.o   -- Global options
local A  = vim.api -- API functions

-- Terminal and colors
o.termguicolors = true
-- o.background = 'dark'   -- Uncomment if needed

-- Performance & UI
o.timeoutlen = 500          -- Timeout for mapped sequences
o.updatetime = 200          -- Faster completion and responsiveness
o.scrolloff  = 8            -- Lines to keep above/below the cursor

-- Line Numbers and Cursor
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true

-- Editing behavior
o.expandtab = true          -- Use spaces instead of tabs
o.smarttab = true           -- Smart tabbing
o.cindent = true            -- C/C++ style indentation
o.autoindent = true
o.wrap = true               -- Wrap long lines
o.tabstop = 4               -- Number of spaces per tab
o.shiftwidth = 2            -- Indentation width
o.softtabstop = -1          -- Use shiftwidth for soft tabs
o.list = true               -- Show invisible characters
o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

-- Clipboard integration
o.clipboard = 'unnamedplus' -- Use system clipboard (Linux)

-- Searching
o.ignorecase = true         -- Case insensitive search
o.smartcase = true          -- Case sensitive if uppercase present

-- Backup, Undo, and History
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
o.history = 50

-- Window splitting behavior
o.splitright = true         -- Vertical splits open to the right
o.splitbelow = true         -- Horizontal splits open below

-- Mouse support (read-only in terminal mode)
vim.opt.mouse = 'r'

--------------------------------------------------------------------------------
-- Leader Key Configuration
--------------------------------------------------------------------------------
g.mapleader = ' '
g.maplocalleader = ' '

--------------------------------------------------------------------------------
-- Colorscheme
--------------------------------------------------------------------------------
vim.cmd[[colorscheme dracula]]
-- Uncomment one of the following to try a different colorscheme:
-- vim.cmd[[colorscheme base16-dracula]]
-- vim.cmd[[colorscheme base16-gruvbox-dark-medium]]
-- vim.cmd[[colorscheme base16-monokai]]
-- vim.cmd[[colorscheme base16-nord]]
-- vim.cmd[[colorscheme base16-oceanicnext]]
-- vim.cmd[[colorscheme base16-onedark]]
-- vim.cmd[[colorscheme palenight]]
-- vim.cmd[[colorscheme base16-solarized-dark]]
-- vim.cmd[[colorscheme base16-solarized-light]]
-- vim.cmd[[colorscheme base16-tomorrow-night]]

--------------------------------------------------------------------------------
-- Whitespace Highlighting
--------------------------------------------------------------------------------
vim.cmd([[
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
]])

vim.api.nvim_exec([[
  augroup highlight_unnecessary_whitespace
    autocmd!
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  augroup END
]], true)

--------------------------------------------------------------------------------
-- Yank Highlight
--------------------------------------------------------------------------------
A.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 120 })
    end,
})

--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------
local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Mimic shell movements in insert mode
map('i', '<C-E>', '<ESC>A')
map('i', '<C-A>', '<ESC>I')

--------------------------------------------------------------------------------
-- GUI Font
--------------------------------------------------------------------------------
vim.opt.guifont = { "monofur for Powerline", "h18" }

--------------------------------------------------------------------------------
-- Phase 1: Enhanced Completion Setup
--------------------------------------------------------------------------------
-- Setup nvim-cmp for auto-completion
local ok_cmp, cmp = pcall(require, 'cmp')
local ok_luasnip, luasnip = pcall(require, 'luasnip')

if ok_cmp and ok_luasnip then
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    }
  })
end

--------------------------------------------------------------------------------
-- Phase 2: Modern File Navigation Setup
--------------------------------------------------------------------------------
-- Setup telescope.nvim
local ok_telescope, telescope = pcall(require, 'telescope')
if ok_telescope then
  telescope.setup({
    defaults = {
      prompt_prefix = "🔍 ",
      selection_caret = "➤ ",
      path_display = {"truncate"},
      file_ignore_patterns = { "node_modules", ".git/", "*.pyc" },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false,
      },
      buffers = {
        theme = "dropdown",
        previewer = false,
      }
    },
  })
  
  -- Load fzf extension if available
  pcall(telescope.load_extension, 'fzf')
  
  -- Telescope keybindings
  local ok_builtin, builtin = pcall(require, 'telescope.builtin')
  if ok_builtin then
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Browse buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
  end
end

--------------------------------------------------------------------------------
-- Custom Keybindings
--------------------------------------------------------------------------------
require("keybindings")

