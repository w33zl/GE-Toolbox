-- Author:Micke
-- Name: GE PowerTools - Dump GE
-- Description:
-- Icon:
-- Hide: yes

source("io.lua")
source("DebugUtil.lua")

Utils = {}

function Utils.overwrittenFunction(oldFunc, newFunc)
	if oldFunc ~= nil then
		return function (self, ...)
			return newFunc(self, oldFunc, ...)
		end
	else
		return function (self, ...)
			return newFunc(self, nil, ...)
		end
	end
end




local maxLineLength = 180
local ignore = {
	-- string = true,
	-- math = true,
	-- table = true
}
local ignoredTables = {}

ignore["DebugUtil"] = true
ignore["io"] = true

local engineGlobals = {}
local globalFunctions = {}
local globalObjects = {}


local function dumpTable(inputTable, inputIndent, depth, maxDepth, knownTables)
	inputIndent = inputIndent or "  "
	depth = depth or 0
	maxDepth = maxDepth or 2

	if depth > maxDepth then
		return nil
	end

	knownTables = knownTables or {}

	-- Always this current table to known tables
	knownTables[tostring(inputTable)] = true

	local string1 = ""


	for i, j in pairs(inputTable) do
		local indexOrKey = tostring(i)
		if type(i) == "number" then
			indexOrKey = string.format("[%d]", i)
		end

		if type(j) == "table" and knownTables[tostring(j)] == true then
			string1 = string1 .. string.format("\n%s %s = {}, -- REFERENCE %s\n", inputIndent, tostring(i), tostring(j))
		elseif type(j) == "table" and ignore[tostring(i)] == true then
			print(string.format("Skipped table '%s'", indexOrKey))
		elseif type(j) == "table" then
			local string2 = dumpTable(j, inputIndent .. "    ", depth + 1, maxDepth, knownTables)

			-- string1 = string1 .. string.format("\n%s %s = { -- %s\n", inputIndent, tostring(i), tostring(j))


			if string2 ~= nil then
				string2 = string.format("%s%s", inputIndent, string2)
				string1 = string1 .. string.format("\n%s %s = { -- %s%s\n%s },", inputIndent, indexOrKey, tostring(j), string2, inputIndent)
			else
				string1 = string1 .. string.format("\n%s %s = {}, -- %s\n", inputIndent, indexOrKey, tostring(j))
			end

			-- knownTables[tostring(j)] = true

		elseif type(j) == "function" and ignore[j] ~= true then
			string1 = string1 .. string.format("\n%s %s = function() end, -- %s", inputIndent, indexOrKey, tostring(j))


			--TODO: maybe do a pcall and try to figure out return type and even parameters?!
		else

			local value = tostring(j)
			if type(j) == "string" then
				value = value:gsub("\\\"", "\"")
				value = value:gsub("\"", "\\\"")
				value = string.format("\"%s\"", value)
			end

			string1 = string1 .. string.format("\n%s %s = %s, -- %s", inputIndent, indexOrKey, value, type(j))
		end
	end

	return string1
end


local globalObjectToDump = getfenv(0) -- _G
globalObjectToDump = getmetatable(_G).__index -- true global / __g

local function printf(formatText, ...) print(string.format(formatText, ...)) end

local outputFilename = "D:/OneDrive/Projects/Games/FS22/GiantsEditor Scripts/geDump_1_3_1_trueGlobal.lua"

printf("Opening file '%s'", outputFilename)

local fileId = createFile(outputFilename, FileAccess.WRITE)

if fileId ~= nil then

	printf("Writing to file handle #%d", fileId)
	

	local output = dumpTable(globalObjectToDump, "  ", 0, 8, ignoredTables)
-- file:write(string.format("%s\n", output))

-- print(output)

	fileWrite(fileId, string.format("_G = {%s\n}\n", output))
else
	printf("Filed to open file '%s'", outputFilename)
end


-- local file = io.open ("D:/OneDrive/Projects/Games/FS22/GiantsEditor Scripts/geDump.lua" , "w")
-- file:write(string.format("_G = {%s\n}\n", output))
-- file:close()
-- -- print("Done")

local dumpFile2Id = createFile("D:/OneDrive/Projects/Games/FS22/GiantsEditor Scripts/dump.txt", FileAccess.WRITE)

-- file = io.open ("D:/OneDrive/Projects/Games/FS22/GiantsEditor Scripts/dump.txt" , "w")
local dumpObject = _G
local dumpObject = getfenv(0)

local output = DebugUtil.debugTableToString(dumpObject, "> ", 0, 3)
-- file:write(string.format("%s\n", output))
fileWrite(dumpFile2Id, string.format("%s\n", output))
-- file:close()


-- local dumpFile3Id = createFile("D:/OneDrive/Projects/Games/FS22/GiantsEditor Scripts/dump.lua", FileAccess.WRITE)
-- -- file = io.open ("D:/OneDrive/Projects/Games/FS22/GiantsEditor Scripts/dump.lua" , "w")

-- -- local c = {1, 1, 1}
-- -- local z = UIWindow.new(c, "Hejsan", 1)

-- -- local x = debug.getinfo(UIWindow.new)
-- -- local xoutput = DebugUtil.debugTableToString(x, "info:: ", 0, 3)
-- -- print(xoutput)

-- -- print(Utils.overwrittenFunction)

-- -- file:write("_G = {")

-- local totalObjects = 0
-- for key, globalObject in pairs(_G) do
-- 	if ignore[globalObject] ~= true then
-- 		--engineGlobals[#engineGlobals + 1] = global
--         -- print(key .. ": " .. type(globalObject))
-- 		if type(globalObject) == "function" then
-- 			globalFunctions[key] = globalObject
-- 		else
-- 			globalObjects[key] = globalObject
-- 		end
-- 		totalObjects = totalObjects + 1
-- 	end
-- end

-- table.sort(globalFunctions)
-- for key, func in ipairs(globalFunctions) do
-- 	file:write(string.format("function %s()\nend\n\n", key))
-- end
-- file:write("\n")

-- for key, func in ipairs(globalFunctions) do
-- 	file:write(string.format("_G.%s = %s\n", key, key))
-- end
-- file:write("\n")

-- table.sort(globalObjects)
-- for key, obj in ipairs(globalObjects) do
-- 	local typeValue = nil
-- 	if type(obj) == "string" then
-- 		typeValue = "\"\""
-- 	elseif type(obj) == "boolean" then
-- 		typeValue = "true"
-- 	elseif type(obj) == "number" then
-- 		typeValue = "0"
-- 	elseif type(obj) == "table" then
-- 		typeValue = "{}"
-- 	elseif type(obj) == "nil" then
-- 		typeValue = "nil -- empty/nil"
-- 	else
-- 		typeValue = "nil -- unknown"
-- 	end
-- 	file:write(string.format("_G.%s = %s\n", key, typeValue))
-- end

-- file:write("\n")
-- file:close()
-- -- table.sort(engineGlobals)
-- print(totalObjects .. " globals found")

