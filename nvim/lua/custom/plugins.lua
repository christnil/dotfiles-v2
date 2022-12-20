return function(use)
    use('mbbill/undotree')
    use('folke/zen-mode.nvim')

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })
  end