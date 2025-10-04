--vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua vim.fn.jobstart({"typst", "watch", "--open=zathura", vim.fn.expand("%")})<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<ESC>', '<ESC>:w<CR>', { noremap = true})
-- vim.fn.jobstart({"typst", "watch", "--open=zathura", vim.fn.expand("%")})
--vim.cmd("!typst watch --open %")

