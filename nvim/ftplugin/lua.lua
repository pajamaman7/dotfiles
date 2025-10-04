-- Bind love run to F5
vim.api.nvim_set_keymap('n', '<F5>', ':!love ./<CR>', { noremap = true, silent = true })
