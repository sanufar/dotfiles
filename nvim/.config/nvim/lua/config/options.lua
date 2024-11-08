vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Adjust 'iskeyword' with a more direct approach
		vim.opt_local.iskeyword = "@,48-57,_,:,." -- Adjust this to your needs
		vim.b.vimtex_enabled = 1
	end,
})

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.api.nvim_create_autocmd("BufLeave", {
	pattern = { "*.md" },
	callback = function()
		vim.o.laststatus = 3
		vim.o.cmdheight = 1
	end,
})

vim.g.vim_markdown_folding_disabled = 1
vim.o.shell = "/usr/local/bin/fish"
vim.o.cmdheight = 1
vim.o.conceallevel = 0
vim.opt.swapfile = false

vim.opt.breakindent = true -- break indentation for long lines
vim.opt.breakindentopt = { shift = 2 }
vim.o.linebreak = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.relativenumber = true
-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

vim.opt.splitbelow = true -- split windows below
vim.opt.splitright = true -- split windows right

vim.o.termguicolors = true

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option("updatetime", 300)

vim.o.inccommand = "split"

-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
--
-- ]])

local diagnostic_timer = nil

-- Set the sign column to be always visible
vim.cmd("set signcolumn=yes")

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

local modes = setmetatable({
	["n"] = { "NORMAL", "N" },
	["no"] = { "N·OPERATOR", "N·P" },
	["v"] = { "VISUAL", "V" },
	["V"] = { "V·LINE", "V·L" },
	[""] = { "V·BLOCK", "V·B" },
	[""] = { "V·BLOCK", "V·B" },
	["s"] = { "SELECT", "S" },
	["S"] = { "S·LINE", "S·L" },
	[""] = { "S·BLOCK", "S·B" },
	["i"] = { "INSERT", "I" },
	["ic"] = { "INSERT", "I" },
	["R"] = { "REPLACE", "R" },
	["Rv"] = { "V·REPLACE", "V·R" },
	["c"] = { "COMMAND", "C" },
	["cv"] = { "VIM·EX", "V·E" },
	["ce"] = { "EX", "E" },
	["r"] = { "PROMPT", "P" },
	["rm"] = { "MORE", "M" },
	["r?"] = { "CONFIRM", "C" },
	["!"] = { "SHELL", "S" },
	["t"] = { "TERMINAL", "T" },
}, {
	__index = function()
		return { "UNKNOWN", "U" } -- handle edge cases
	end,
})

local get_current_mode = function()
	local mode = modes[vim.api.nvim_get_mode().mode]
	if vim.api.nvim_win_get_width(0) <= 80 then
		return string.format("%s ", mode[2]) -- short name
	else
		return string.format("%s ", mode[1]) -- long name
	end
end

local git_branch = function()
	if vim.g.loaded_fugitive then
		local branch = vim.fn.FugitiveHead()
		if branch ~= "" then
			if vim.api.nvim_win_get_width(0) <= 80 then
				return " " .. string.upper(branch:sub(1, 5))
			end
			return " " .. string.upper(branch)
		end
	end
	return ""
end

local smart_file_path = function()
	local buf_name = vim.api.nvim_buf_get_name(0)
	if buf_name == "" then
		return "[No Name]"
	end
	local home = vim.env.HOME
	local is_term = false
	local file_dir = ""

	if buf_name:sub(1, 5):find("term") ~= nil then
		---@type string
		file_dir = vim.env.PWD
		if file_dir == home then
			return "$HOME "
		end
		is_term = true
	else
		file_dir = vim.fs.dirname(buf_name)
	end

	file_dir = file_dir:gsub(home, "~", 1)

	if vim.api.nvim_win_get_width(0) <= 80 then
		file_dir = vim.fn.pathshorten(file_dir)
	end

	if is_term then
		return file_dir .. " "
	else
		return string.format("%s/%s ", file_dir, vim.fs.basename(buf_name))
	end
end

local word_count = function()
	local words = vim.fn.wordcount()
	if words.visual_words ~= nil then
		return string.format("[%s]", words.visual_words)
	else
		return string.format("[%s]", words.words)
	end
end

local human_file_size = function()
	local format_file_size = function(file)
		local size = vim.fn.getfsize(file)
		if size <= 0 then
			return ""
		end
		local sufixes = { "B", "KB", "MB", "GB" }
		local i = 1
		while size > 1024 do
			size = size / 1024
			i = i + 1
		end
		return string.format("[%.0f%s]", size, sufixes[i])
	end

	local file = vim.api.nvim_buf_get_name(0)
	if string.len(file) == 0 then
		return ""
	end
	return format_file_size(file)
end

function status_line()
	return table.concat({
		get_current_mode(),
		"%{toupper(&spelllang)}", -- display language and if spell is on
		git_branch(), -- branch name
		" %<", -- spacing
		smart_file_path(), -- smart full path filename
		"%h%m%r%w", -- help flag, modified, readonly, and preview
		"%=", -- right align
		"%{get(b:,'gitsigns_status','')}", -- gitsigns
		word_count(), -- word count
		"[%-3.(%l|%c]", -- line number, column number
		human_file_size(), -- file size
		"[%{strlen(&ft)?&ft[0].&ft[1:]:'None'}]", -- file type
	})
end

vim.opt.statusline = "%!luaeval('status_line()')"

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "H", "0")
vim.keymap.set("n", "L", "$")

-- Set highlights permanently in Lua
local set_hl = vim.api.nvim_set_hl

-- Define highlight groups
set_hl(0, "MiniFilesBorder", { fg = "#f7b7b0", bg = "none", bold = true })
set_hl(0, "MiniFilesBorderModified", { fg = "#ffb0b0", bg = "none" })
set_hl(0, "MiniFilesCursorLine", { bg = "none" })
set_hl(0, "MiniFilesDirectory", { fg = "#f29585", bold = true })
set_hl(0, "MiniFilesFile", { fg = "#dcd7ba", bg = "none" })
set_hl(0, "MiniFilesNormal", { fg = "#dcd7ba", bg = "none" })
set_hl(0, "MiniFilesTitle", { fg = "#a89984", bold = true })
set_hl(0, "MiniFilesTitleFocused", { fg = "#ea6962", bold = true })

set_hl(0, "NormalFloat", { bg = "none" })
set_hl(0, "FloatBorder", { bg = "none" })
