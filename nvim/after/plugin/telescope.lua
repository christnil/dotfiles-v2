
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fa', builtin.find_files, { desc = '[F]ind [A]ll files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
vim.keymap.set('n', '<leader>fh', builtin.buffers, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)