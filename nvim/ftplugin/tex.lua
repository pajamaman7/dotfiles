-- Auto write when entering normal mode
vim.api.nvim_set_keymap('i', '<ESC>', '<ESC>:w<CR>', { noremap = true})
-- Bind :VimtexCompile to F5
vim.api.nvim_set_keymap('n', '<F5>', ':VimtexCompile<CR>', { noremap = true})
--vim.cmd("VimtexCompile")
