local bit = require("bit")

local M = {}

M.opts = {}

local defaults = {
	index_dir = vim.fn.stdpath("data") .. "/sesh_index",
	max_files = 1000,
}

function M.setup(opts)
	M.opts.index_dir = opts.index_dir or defaults.index_dir
	M.opts.max_files = opts.max_files or defaults.max_files
	vim.fn.mkdir(M.opts.index_dir, "p")
end

local function djb2(input)
	local hash = 5381
	for i = 1, #input do
		hash = bit.band(hash * 32, 0xFFFFFFFF) + hash + input:byte(i)
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

local function maybe_sesh_file(path)
	local hashed = djb2(path)
	local file = M.opts.index_dir .. "/" .. hashed
	if file_exists(file) then
		return file
	else
		return nil
	end
end

function M.save_sesh(path)
	-- TODO: do more than notify?
	local files_num = vim.fn.len(vim.fn.globpath(M.opts.index_dir, "*", 0, 1))
	if files_num >= M.opts.max_files then
		vim.notify(
			"There are " .. files_num .. " (>" .. M.opts.max_files .. ") session files already.",
			vim.log.levels.WARN
		)
	end
	local hashed = djb2(path)
	local sesh_file = M.opts.index_dir .. "/" .. hashed
	vim.cmd("mksession! " .. sesh_file)
end

function M.load_sesh(current_path)
	local sesh_file = maybe_sesh_file(current_path)
	if sesh_file == nil then
		vim.notify("No session file found for " .. current_path, vim.log.levels.WARN)
	else
		vim.cmd("source " .. sesh_file)
	end
end

return M
