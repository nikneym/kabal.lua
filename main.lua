-- get Kabal
local Kabal = require "kabal"

-- initialize Kabal, use "/" as cursor
local kabal = Kabal("/")

-- lets add some commands
kabal:cmd("hi", function()
	print("Hi there!")
end)

kabal:cmd("flip", function()
	print("(╯°□°）╯︵ ┻━┻")
end)

-- args table returns user defined arguments
kabal:cmd("multiply", function(args)
	local result = args[1] * args[2]
	print(result)
end)

-- lets count from 1 to x number!
-- params and args are same thing, you can also use your custom naming
kabal:cmd("count", function(params)
	local i = 1

	while i <= tonumber(params[1]) do
		print(i)
		i = i + 1
	end
end)

-- too basic example of player opping
local player_op = 0

kabal:cmd("op", function(args)
	player_op = tonumber(args[1])

	print("Player OP status: " .. player_op)
end)

-- with table.concat we can return all parameters
-- given by user as a string
kabal:cmd("say", function(args)
	print("Player said: " .. table.concat(args, " "))
end)

-- let user call lua stuff? O.o
kabal:cmd("call", function(args)
	local line = table.concat(args, " ")

	local foo = loadstring(line)
	if type(foo) == "function" then
		foo()
	else
		print("error")
	end
end)

-- lets get user input and test
print("Kabal waiting for user input:")
repeat
	local get = kabal:cinput()
	kabal:call(get)
until get == "quit"