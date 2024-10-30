vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "JK", "<Esc>")
vim.keymap.set("n", "H", "0")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "<C-q>", ":qa!<cr>")

-- QUIT

-- EASIER INDENTING
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- WINDOW MANAGEMENT
vim.keymap.set("n", "<M-up>", ":resize +2<cr>")
vim.keymap.set("n", "<M-down>", ":resize -2<cr>")
vim.keymap.set("n", "<left>", ":vertical resize +2<cr>")
vim.keymap.set("n", "<right>", ":vertical resize -2<cr>")

-- GENERAL - FILE SOTIONS, ETC
vim.keymap.set("n", "<space>cd", ":cd %:p:h<cr>:pwd<cr>")

-- FZF LUA
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>sa", "<cmd>FzfLua live_grep_native<cr>")
vim.keymap.set("n", "<leader>?", "<cmd>FzfLua oldfiles<cr>")
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua lgrep_curbuf<cr>")

-- MINI FILES
vim.keymap.set("n", "-", "<cmd>lua MiniFiles.open()<cr>")

--lsp
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename)
vim.keymap.set({ "i" }, "<C-k>", function()
	require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })

vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.open_float()
end, { noremap = true, silent = true })

vim.keymap.set("n", "gd", vim.lsp.buf.document_highlight)

--SPECTRE (I.E REPLACE)
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<leader>sf", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})
