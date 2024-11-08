local width_percentage = 0.8
local vsplit_width = math.floor(vim.o.columns * width_percentage)

local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if split_cmd then
			vim.cmd(vsplit_width .. split_cmd)
		end

		if vim.tbl_islist(result) then
			util.jump_to_location(result[1])

			if #result > 1 then
				-- util.set_qflist(util.locations_to_items(result))
				vim.fn.setqflist(util.locations_to_items(result))
				api.nvim_command("copen")
				api.nvim_command("wincmd p")
			end
		else
			util.jump_to_location(result)
		end
	end

	return handler
end

-- vim.lsp.handlers["textDocument/definition"] = goto_definition("vsplit")
