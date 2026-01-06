local vim = vim

vim.o.clipboard = 'unnamedplus'
vim.o.winborder = 'rounded'

vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "no"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.conceallevel = 2
vim.o.termguicolors = true

vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>o', ':update<CR>:source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')

vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/phha/zenburn.nvim" },
    { src = "https://github.com/szammyboi/dune.nvim" },

    { src = "https://github.com/tpope/vim-surround" },

    { src = "https://github.com/neovim/nvim-lspconfig" },

    { src = "https://github.com/lervag/vimtex" },

    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },

    { src = "https://github.com/sirver/ultisnips" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },

    { src = "https://github.com/mason-org/mason.nvim" },

})
-- mason and lsp setup
require "mason".setup()

vim.lsp.enable({
    "lua_ls", "cssls", "html-lsp", "quick-lint-js", "pyright", "texlab", "pylint", 
})

-- Telescope bindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>r', builtin.oldfiles, { desc = 'Telescope recents' })

-- Load snippet files for luasnip
local ls = require("luasnip")
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

-- Enable autosnippets
ls.config.set_config({
    enable_autosnippets = true,
    history = true,
    updateevents = "TextChanged,TextChangedI",
})

-- snippet keybinds
vim.cmd [[
imap <silent><expr> <tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<tab>'
smap <silent><expr> <tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<tab>'
imap <silent><expr> <S-tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-tab>'
smap <silent><expr> <S-tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-tab>'
]]

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

--vimtex settings
vim.g.vimtex_compiler_latexmk = {
    continuous = 1,
    executable = 'latexmk',
    args = { '-pdf', '-interaction=nonstopmode', '-synctex=1' },
}

--viewer and compiler settings
vim.g.vimtex_view_general_viewer = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.tex_conceal = 'abdmg'

-- UltiSnips settings
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"

--visual settings
vim.cmd("colorscheme gruvbox")
--disables color of statusline
-- vim.cmd(":hi statusline guibg=NONE")
