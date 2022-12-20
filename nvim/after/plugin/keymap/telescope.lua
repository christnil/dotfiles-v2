local Remap = require("chris.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", ":Telescope")
nnoremap("<leader>fs", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})
end)
nnoremap("<C-p>", function()
    require('telescope.builtin').git_files()
end)
nnoremap("<Leader>fg", function()
    require('telescope.builtin').git_files()
end)
nnoremap("<Leader>ff", function()
    require('telescope.builtin').find_files()
end)

nnoremap("<leader>fw", function()
    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
end)
nnoremap("<leader>fb", function()
    require('telescope.builtin').buffers()
end)
nnoremap("<leader>fh", function()
    require('telescope.builtin').help_tags()
end)

-- TODO: Fix this immediately
nnoremap("<leader>vwh", function()
    require('telescope.builtin').help_tags()
end)

nnoremap("<leader>vrc", function()
    require('chris.telescope').search_dotfiles({ hidden = true })
end)
nnoremap("<leader>gc", function()
    require('chris.telescope').git_branches()
end)
nnoremap("<leader>gw", function()
    require('telescope').extensions.git_worktree.git_worktrees()
end)
nnoremap("<leader>gm", function()
    require('telescope').extensions.git_worktree.create_git_worktree()
end)
nnoremap("<leader>td", function()
    require('chris.telescope').dev()
end)



