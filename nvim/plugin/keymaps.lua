local set = vim.keymap.set
local k = vim.keycode
local f = require("custom.f")
-- local fn = f.fn

-- Basic movement keybinds, these make navigating splits easy for me
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("v", "<leader>x", ":lua<CR>", { desc = "Execute the current selection" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
set("n", "<leader>tf", vim.diagnostic.open_float, { desc = "Toggle folating diagnostics window" })

set("n", "<Esc>", function()
  vim.cmd.nohl()
end)
-- Toggle hlsearch if it's on, otherwise just do "enter"
set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return k("<CR>")
  end
end, { expr = true })

-- set("n", "]d", fn(vim.diagnostic.jump, { count = 1, float = true }))
-- set("n", "[d", fn(vim.diagnostic.jump, { count = -1, float = true }))

-- These mappings control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")

set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! ]c]])
  else
    vim.cmd([[m .+1<CR>==]])
  end
end)

set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd([[normal! [c]])
  else
    vim.cmd([[m .-2<CR>==]])
  end
end)

set("n", "<space>tt", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)

set("n", "j", function(...)
  local count = vim.v.count

  if count == 0 then
    return "gj"
  else
    return "j"
  end
end, { expr = true })

set("n", "k", function(...)
  local count = vim.v.count

  if count == 0 then
    return "gk"
  else
    return "k"
  end
end, { expr = true })

-- Meh + W => Write the current file
vim.keymap.set('n', '<leader><leader>w', ':write<CR>', { noremap = true, silent = true, desc = 'Write the current file' })

-- Meh + QW => Write and quit all files
vim.keymap.set('n', '<leader><leader>qw', ':wa | qa<CR>', { noremap = true, silent = true, desc = 'Write and quit all files' })

-- Meh + QQ => Quit the current file
vim.keymap.set('n', '<leader><leader>qq', ':quit<CR>', { noremap = true, silent = true, desc = 'Quit the current file' })

-- Meh + QA => Quit all files
vim.keymap.set('n', '<leader><leader>qa', ':qa<CR>', { noremap = true, silent = true, desc = 'Quit all files' })

-- Meh + QF => Force quit all files
vim.keymap.set('n', '<leader>qf', ':qa!<CR>', { noremap = true, silent = true, desc = 'Force quit all files' })