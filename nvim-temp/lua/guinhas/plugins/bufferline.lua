return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local bufferline = require("bufferline")

		local function hl(name)
			local value = vim.api.nvim_get_hl(0, { name = name, link = false })
			if value then
				return {
					bg = value.bg and string.format("#%06x", value.bg) or nil,
					fg = value.fg and string.format("#%06x", value.fg) or nil,
				}
			end
			return nil
		end

		local function fg_or_nil(group)
			local value = hl(group)
			return value and value.fg or nil
		end

		local function sync_fill_highlight()
			local tabline_fill = hl("TabLineFill")
			local tabline = hl("TabLine")
			local normal = hl("Normal")
			local fill_bg = (tabline_fill and tabline_fill.bg) or (tabline and tabline.bg) or (normal and normal.bg)

			if fill_bg then
				vim.api.nvim_set_hl(0, "BufferLineFill", { bg = fill_bg })
			end
		end

		local function get_highlights()
			local normal = hl("Normal")
			local tabline = hl("TabLine")
			local tabline_sel = hl("TabLineSel")

			if not normal then
				return {}
			end

			local base_bg = (tabline and tabline.bg) or normal.bg
			local base_fg = (tabline and tabline.fg) or normal.fg
			local selected_bg = (tabline_sel and tabline_sel.bg) or normal.bg or base_bg
			local selected_fg = (tabline_sel and tabline_sel.fg) or normal.fg

			return {
				background = { bg = base_bg, fg = base_fg, default = false },
				buffer = { bg = base_bg, fg = base_fg, default = false },
				buffer_visible = { bg = base_bg, default = false },
				buffer_selected = { bg = selected_bg, fg = selected_fg, bold = true, default = false },
				duplicate = { bg = base_bg, fg = base_fg, default = false },
				duplicate_visible = { bg = base_bg, fg = base_fg, default = false },
				duplicate_selected = { bg = selected_bg, fg = selected_fg, bold = true, default = false },
				modified = { bg = base_bg, fg = fg_or_nil("DiagnosticWarn") or base_fg, default = false },
				modified_visible = { bg = base_bg, fg = fg_or_nil("DiagnosticWarn") or base_fg, default = false },
				modified_selected = { bg = selected_bg, fg = fg_or_nil("DiagnosticWarn") or selected_fg, default = false },
				separator = { bg = base_bg, fg = base_bg, default = false },
				separator_visible = { bg = base_bg, fg = base_bg, default = false },
				separator_selected = { bg = selected_bg, fg = selected_bg, default = false },
				indicator_selected = { bg = selected_bg, fg = fg_or_nil("Special") or selected_fg, default = false },
			}
		end

		local options = {
			options = {
				mode = "buffers",
				separator_style = "thin",
				always_show_bufferline = true,
				sort_by = "insert_after_current",
				show_buffer_close_icons = false,
				show_close_icon = false,
				offsets = {
					{
						filetype = "NvimTree",
						text = "Choose a File",
						text_align = "center",
						separator = true,
					},
				},
			},
		}

		local function render()
			local highlights = get_highlights()
			local final_options = vim.tbl_deep_extend("force", options, { highlights = highlights })
			bufferline.setup(final_options)
			sync_fill_highlight()
		end

		render()

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("GuinhasBufferline", { clear = true }),
			callback = render,
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>h", ":BufferLineMovePrev<CR>", { silent = true, desc = "Move buffer left" })
		vim.keymap.set("n", "<leader>l", ":BufferLineMoveNext<CR>", { silent = true, desc = "Move buffer right" })
	end,
}
