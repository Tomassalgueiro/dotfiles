local M = {}

M.items = {
  { repo = "folke/tokyonight.nvim", schemes = { "tokyonight" } },
  { repo = "blazkowolf/gruber-darker.nvim", schemes = { "gruber-darker" } },
  { repo = "catppuccin/nvim", name = "catppuccin", schemes = { "catppuccin" } },
  { repo = "rebelot/kanagawa.nvim", schemes = { "kanagawa" } },
  { repo = "ellisonleao/gruvbox.nvim", schemes = { "gruvbox" } },
}

function M.names()
  -- Hardcoded return to completely bypass the crashing loop
  return { 
    "gruber-darker", 
    "tokyonight", 
    "catppuccin", 
    "kanagawa", 
    "gruvbox" 
  }
end

return M
