return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- Keep master branch for compatibility with Neovim 0.11.x
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "html", "javascript", "python" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
}
