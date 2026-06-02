local M = {}

M.items = {
  { repo = "folke/tokyonight.nvim", schemes = { "tokyonight" } },
  { repo = "blazkowolf/gruber-darker.nvim", schemes = { "gruber-darker" } },
  { repo = "catppuccin/nvim", name = "catppuccin", schemes = { "catppuccin" } },
  { repo = "rebelot/kanagawa.nvim", schemes = { "kanagawa" } },
  { repo = "ellisonleao/gruvbox.nvim", schemes = { "gruvbox" } },
}

function M.names()
  local names = {}
  for _, item in ipairs(M.items) do
    if item.schemes then
      vim.list_extend(names, item.schemes)
    end
  end
  return names
end

return M
