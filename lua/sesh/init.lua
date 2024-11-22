local bit = require("bit")

local M = {}

M.opts = {}

local defaults = {
	index_dir = vim.fn.stdpath("data") .. "/sesh_index", -- where to save the session files
	max_files = 1000, -- show warning when there are more than max_files session files
	verbose = false, -- print INFO messages
}

function M.setup(opts)
	M.opts.index_dir = opts.index_dir or defaults.index_dir
	M.opts.max_files = opts.max_files or defaults.max_files
	M.opts.verbose = opts.verbose or defaults.verbose
	vim.fn.mkdir(M.opts.index_dir, "p")
end

local function djb2(input)
	local hash = 5381
	for i = 1, #input do
		hash = bit.band(hash * 32, 0xFFFFFFFF) + hash + input:byte(i) -- NOTE: Lua has 32bit-signed ints, so need to prevent overflows
	end
	return bit.tohex(hash)
end

local function file_exists(path)
	local file = io.open(path, "r")
	if file then
		file:close()
		return true
	end
	return false
end

function M.file_name(path)
	local hashed = djb2(path)
	return M.opts.index_dir .. "/" .. hashed
end

local function maybe_sesh_file(path)
	local sesh_file = M.file_name(path)
	if file_exists(sesh_file) then
		return sesh_file
	else
		return nil
	end
end

function M.save_sesh(path)
	-- TODO: do more than notify?
	local files_num = vim.fn.len(vim.fn.globpath(M.opts.index_dir, "*", 0, 1))
	if files_num > M.opts.max_files then
		vim.notify(
			"There are " .. files_num .. " (>" .. M.opts.max_files .. ") session files already.",
			vim.log.levels.WARN
		)
	end

	local sesh_file = M.file_name(path)
	if M.opts.verbose then
		vim.notify("Saving session file to " .. sesh_file, vim.log.levels.INFO)
	end
	vim.cmd("mksession! " .. sesh_file)
end

function M.load_sesh(path)
	local sesh_file = maybe_sesh_file(path)
	if sesh_file == nil then
		vim.notify("No session file found for " .. path, vim.log.levels.WARN)
	else
		vim.cmd("source " .. sesh_file)
		if M.opts.verbose then
			vim.notify("Loaded session file from " .. sesh_file, vim.log.levels.INFO)
		end
	end
end

return M
