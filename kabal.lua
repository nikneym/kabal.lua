--[[
User op commands and debugging for Lua and LÖVE

MIT LICENSE

Copyright (c) 2021 Halil Durak

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local Kabal = {
	_VERSION = 1.1,
	_DESCRIPTION = "User OP commands and debug interface for Lua and LÖVE"
}
Kabal.__index = Kabal

setmetatable(Kabal, {
	-- initialize --
	__call = function(_, cursor)
		local self = {
			cursor = cursor or "/",
			funcs = {},

			--[[
				so 'funcs' will store user-defined functions
				and name them. like:

				["/try"] = function()
				["/hi"] = function()
			]]
		}

		return setmetatable(self, Kabal)
	end
})

-- split any (thanks to MikuAuahDark for improvement) --
local function split(line)
	local chars = {}
	for i = 1, #line do
		chars[i] = line:sub(i, i)
	end
	return chars
end

-- get user input at cmd (only works on command prompt) --
function Kabal:cinput(line)
	io.write("> ")
	io.flush()
	return io.read()
end

-- add a command --
function Kabal:cmd(name, func)
	-- add our cursor to command
	name = self.cursor .. tostring(name)
	self.funcs[name] = func
end

-- simple lexing --
function Kabal:call(data)
	local line = split(data)
	local token = ""

	for c = 1, #line do
		token = token .. line[c]

		--lexer found a matching pattern
		if self.funcs[token] then
			local info = debug.getinfo(self.funcs[token])
			if info.nparams ~= 0 then
				-- looks like this function needs some arguments
				local params = data:gsub(token, "")
				local args = {}
				for param in params:gmatch "%S+" do
					table.insert(args, param)
				end

				-- (for error handling in the future)
				local success, err = pcall(self.funcs[token], args)
				--print(success, err)
			else
				-- no argument is needed, just call the func.
				-- (for error handling in the future)
				local success, err = pcall(self.funcs[token])
			end

			break
		end
	end
end

return Kabal