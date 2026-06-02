return {
{
    'nvim-telescope/telescope.nvim', version = '*',
    keys = {
      {"<leader>sf", "<cmd>Telescope find_files<cr>"},
      {"<leader>sg", "<cmd>Telescope live_grep<cr>"}
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
}
}
