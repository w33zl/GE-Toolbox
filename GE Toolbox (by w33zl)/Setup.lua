
-- Author: w33zl
-- Name: Setup
-- Description: Configures your GE setup to work with the GE Toolbox Library
-- Icon:
-- Hide: no
-- Version: 1.0


-- GE Toolbox © 2022 by w33zl is licensed under CC BY-NC-ND 4.0 (Creative Commons Attribution-NonCommercial-ShareAlike) - http://creativecommons.org/licenses/by-nc-sa/4.0/

-- TL;DR: You are ALLOWED TO SHARE (copy and redistribute) the material in any medium or format
-- as long as you ATTRIBUTE (give appropriate credit to) the original author, 
-- do NOT MAKE ANY DERIVATIVES (i.e. do not modify and re-publish this as your own work) 
-- and as long as it is NOT USED FOR COMMERCIAL PURPOSES.

-- DISCLAIMER: THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, 
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
-- DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
-- THE USE OR OTHER DEALINGS IN THE SOFTWARE.


-- print(getSceneFilename()) 

print("GE Toolbox setup")

DebugUtil = DebugUtil or {}

---Print a table recursively
-- @param table inputTable table to print
-- @param string inputIndent input indent
-- @param integer depth current depth
-- @param integer maxDepth max depth
function DebugUtil.printTableRecursively(inputTable, inputIndent, depth, maxDepth)
    inputIndent = inputIndent or "  "
    depth = depth or 0
    maxDepth = maxDepth or 3
    if depth > maxDepth then
        return
    end
    local debugString = ""
    for i,j in pairs(inputTable) do
        print(inputIndent..tostring(i).." :: "..tostring(j))
        --debugString = debugString .. string.format("%s %s :: %s\n", inputIndent, tostring(i), tostring(j))
        if type(j) == "table" then
            DebugUtil.printTableRecursively(j, inputIndent.."    ", depth+1, maxDepth)
            --local string2 = DebugUtil.printTableRecursively(j, inputIndent.."    ", depth+1, maxDepth)
            --if string2 ~= nil then
            --    debugString = debugString .. string2
            --end
        end
    end
    return debugString
end




local filePath = getSceneFilename()


function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local pathItems = mysplit(filePath, "/")
local fileName = pathItems[#pathItems]

-- print(filePath)
-- DebugUtil.printTableRecursively(pathItems, ">> ", 0, 2)


local toolboxPath = table.concat(pathItems, "/", 1, #pathItems - 1)
local userScripsPath = table.concat(pathItems, "/", 1, #pathItems - 2)

local TARGET_FOLDER = "C:/ProgramData/GE-Toolbox/"
local TARGET_FILENAME = "GEToolbox.lua"
local TARGET_FILEPATH = TARGET_FOLDER .. TARGET_FILENAME

local finalData = {
    sceneFileName = fileName,
    sceneFilePath = filePath,
    toolboxPath = toolboxPath,
    userScripsPath = userScripsPath,
    editorPath = getEditorDirectory(),
}

DebugUtil.printTableRecursively(finalData, "finalData.", 0, 2)


local sceneNodeID = getChildAt(getRootNode(), 0);

-- local newNote = createNoteNode("test")
-- setNoteNodeText(newNote, "Testar lorem lorem Testar lorem loremTestar lorem lorem \n\nTestetstt\n\nTestetstt")
-- setNoteNodeColor(newNote, 0.131, 0.925, 0.131, 2)
-- -- setNoteNodeColor(newNote, 0.894, 0.131, 0.131, 0.8)
-- -- setNoteNodeFixedSize(newNote, true)
-- link(sceneNodeID, newNote)
-- -- setNoteNodeFixedSize(newNote, true)

local DUMMY = [[
Utils = Utils or {}
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

_G.oldSource = _G.oldSource or _G.source
_G.source = function(path)
    if fileExists(g_geToolboxPath .. path) then
        return _G.oldSource(g_geToolboxPath .. path)
    else
        return _G.oldSource(path)
    end
end
_G.oldDofile = _G.oldDofile or _G.dofile
_G.dofile = function(path)
    if fileExists(g_geToolboxPath .. path) then
        return _G.oldDofile(g_geToolboxPath .. path)
    else
        return _G.oldDofile(path)
    end
end

_G.require = function(path)
    if fileExists(g_geToolboxPath .. path) then
        return loadfile(g_geToolboxPath .. path)
    else
        return loadfile(path)
    end
end

]]


local FORCE = true

if FORCE or not fileExists(TARGET_FILEPATH) then
    createFolder(TARGET_FOLDER)
    local fileId = createFile(TARGET_FILEPATH, FileAccess.WRITE)
    fileWrite(fileId, "-- GE Toolbox by w33zl\n")
    fileWrite(fileId, "--\n")
    fileWrite(fileId, "-- IMPORTANT: This is an automatically generated file, do NOT edit!\n\n")
    fileWrite(fileId, "_G.g_geToolboxPath = \"" .. toolboxPath ..  "/\"\n\n")
    fileWrite(fileId, DUMMY .. "\n\n")
    delete(fileId)

    if fileExists(TARGET_FILEPATH) then
        print("GE Toolbox successfully configured!")
    else
        print("ERROR! Failed to to confgure GE Toobox, please review log for any errors")
    end
else
    print("File already exists, no need to run configuration")
end

