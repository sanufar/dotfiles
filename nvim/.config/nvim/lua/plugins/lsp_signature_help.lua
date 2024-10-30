return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	opts = {
		max_height = 100,
		floating_window_above_cur_line = false,
		floating_window_off_y = -2,
		hint_enable = false,
		wrap = false,
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
