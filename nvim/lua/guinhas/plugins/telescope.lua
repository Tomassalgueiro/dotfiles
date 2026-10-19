return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    keys = {
      { "<leader>sf", "<cmd>Telescope find_files<cr>" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>sc", "<cmd>Telescope find_files cwd=~/guinhas-obsidian/cheatsheets<cr>"}
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
