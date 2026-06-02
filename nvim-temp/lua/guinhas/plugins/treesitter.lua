return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Enable highlighting automatically using Neovim's FileType autocommand
      -- for any buffers that have an available Treesitter parser.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ok, parser = pcall(vim.treesitter.get_parser)
          if ok and parser then
            vim.treesitter.start()
          end
        end,
      })
    end,
  },
}
