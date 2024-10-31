local function source_lua_files_in_folder(folder)
	local path = vim.fn.stdpath("config") .. "/lua/" .. folder
	for _, file in ipairs(vim.fn.readdir(path, [[v:val =~ '\.lua$']])) do
		if file ~= "init.lua" then
			local file_name = file:gsub("%.lua$", "")
			require(folder .. "." .. file_name)
		end
	end
end

source_lua_files_in_folder("functions")
