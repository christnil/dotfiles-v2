-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Hey! Put lazy into the runtimepath for neovim!
vim.opt.runtimepath:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)


-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
		{ import = "custom.plugins" },
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
}, {
	ui = {
	  -- If you are using a Nerd Font: set icons to an empty table which will use the
	  -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
	  icons = vim.g.have_nerd_font and {} or {
		cmd = '⌘',
		config = '🛠',
		event = '📅',
		ft = '📂',
		init = '⚙',
		keys = '🗝',
		plugin = '🔌',
		runtime = '💻',
		require = '🌙',
		source = '📄',
		start = '🚀',
		task = '📌',
		lazy = '💤 ',
	  },
	},
  })