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
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/lervag/vimtex" },

    { src = "https://github.com/sirver/ultisnips" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/kaarmu/typst.vim" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
    { src = "https://github.com/mason-org/mason.nvim"},

})
-- Mason setup
--require("mason").setup()
require 'typst-preview'.setup {}

-- Load snippet files for luasnip
local ls = require("luasnip")
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})

-- Enable autosnippets
ls.config.set_config({
  enable_autosnippets = true,
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

-- Keybindings using Lua
vim.cmd[[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]

-- mini.pick setup
require "mini.pick".setup()
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')

-- Oldfiles picker setup
local oldfiles_picker = function()
    local items = {}
    local cwd = vim.fn.getcwd()
    -- Ensure cwd has a trailing slash
    cwd = cwd:sub(-1) == '/' and cwd or (cwd .. '/')

    for _, path in ipairs(vim.v.oldfiles) do
        local normal_path = nil
        if vim.startswith(path, cwd) then
            -- Use ./ as cwd prefix
            normal_path = '.'.. path:sub(cwd:len())
        else
            -- Use ~ as home directory prefix
            normal_path = vim.fn.fnamemodify(path, ':~')
        end

        table.insert(items, normal_path)
    end

    local selection = require('mini.pick').start({
        source = {
            items = items,
            name = 'Recent Files'
        }
    })

    if selection then
        vim.cmd.edit(vim.trim(selection):match('%s+(.+)'))
    end
end

-- Key mapping for oldfiles picker
vim.keymap.set('n', '<leader>r', oldfiles_picker)

--lsp setup
vim.lsp.enable({ 
    "lua-ls",
    "typst",
})

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
--conceal settings
vim.g.tex_conceal = 'abdmg'

-- UltiSnips settings
vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<tab>"
-- vim.g.UltiSnipsJumpBackwardTrigger="<s-tab>"

--visual settings
vim.cmd("colorscheme gruvbox")
--disables color of statusline
--vim.cmd(":hi statusline guibg=NONE")
