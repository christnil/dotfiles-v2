-- nvim-treesitter `main` branch (the rewrite). It no longer takes ensure_installed/highlight
-- opts: parsers are installed with .install() (needs the tree-sitter CLI, installed by mason)
-- and highlighting is started per buffer with vim.treesitter.start().
local parsers = {
  "bash", "c", "c_sharp", "css", "diff", "dockerfile", "git_config", "gitcommit", "html",
  "java", "javascript", "json", "lua", "luadoc", "markdown", "markdown_inline", "python",
  "query", "regex", "rust", "scala", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install(parsers)

      local max_filesize = 100 * 1024 -- skip highlighting in files > 100 KB
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang then return end
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return end

          -- auto-install parsers we don't have yet (like the old auto_install = true)
          if not pcall(vim.treesitter.language.add, lang) then
            if vim.list_contains(ts.get_available(), lang) then
              ts.install(lang) -- async; highlighting starts next time the file is opened
            end
            return
          end
          if pcall(vim.treesitter.start, buf, lang) then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
