-- Name: Create i3d XML mappings
-- Author: w33zl
-- Description: Prints a XML tag in the log for each selected node in the scenegraph
-- Icon:iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAWdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjH3g/eTAAAAtGVYSWZJSSoACAAAAAUAGgEFAAEAAABKAAAAGwEFAAEAAABSAAAAKAEDAAEAAAACAAAAMQECAA4AAABaAAAAaYcEAAEAAABoAAAAAAAAAGAAAAABAAAAYAAAAAEAAABQYWludC5ORVQgNS4xAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACSAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAGOkJsRSTv3MAAACPklEQVQ4T52Sy2sTURjFzzzyaEL6yqMmNEakbRpNVBCpUsWqxceqiLpwoeDChWhBUBFx58YuXGj/A3dKXSkuKrjoQqoobbEqhbYLNZi0RW1jUpvJZMZz76SCurB64Med882955t752INUkkT0aT7D50iE8Qv3W8S6X/TGTJJStL9oxJELDwo3Rp0nJx0HqX6yUci9n+O/BG0uoVWcpcMkUZRqEmEPSRVEifDZJCEyE+1kyyxyVlRqKmDfCd7pHN0nYh5r0mLKAgppJeMkSXSR4Suklniks4JF4EjpEsUhMTiVbnJDfIp0ukfnJ8qicCn4Y66K7pbQ+5NcYB+kQzEMgEcvdaFhojvlwAcOJ9CuieOOyeeZGifk+4jlzMTyV0x3D42rB66mLbiyRbUR12wqmIntS+4cK8XoosCJWmhcrNcMlNGyW4LhLzPFEUxLdvkoNp8T2NAVz2o2oamQJuVAf0P9okBll251OhZf8vmoRfNeXapcrIXflcIZbMITXWjM7gTY3OPEa5rwzdjAbpYmArulQHLlQK2RHejzu3HeHZEdpr+MorDydOYyo9j+usrNPtb4NXqsS3WA5eqO/egPbxVsrE5gwZfE7wuL1bMZaTWbUdrII2ZhbfsrsO2Lf5EGwUji7nCexTKi07AZG5U8m7+hVZcKSC/lGV3N8cPyJdmkGjqQLR+Azt65CWI+DZhR2I/DNOoHeKQswULZp9PC963+cSDsyvWinMGejMr4jICm8PdeJl7xFpQUxT18w/6D7GqHOmFngAAAABJRU5ErkJggg==
-- Hide: no

--[[
Author:     w33zl / WZL Modding
Version:    3.0
Modified:   2024-11-26

Facebook:           https://www.facebook.com/w33zl
Ko-fi:              https://ko-fi.com/w33zl
Patreon:            https://www.patreon.com/wzlmodding
Github:             https://github.com/w33zl

Changelog:
v3.0.0      GE10 / FS25 conversion
v2.0.0      Initial version (fork of v1)
]]


--***[ SETTINGS ]**************************************************************************************

local USE_NEW_METHOD = true
local DEBUG_MODE = false


--***[ DO NOT CHANGE BELOW THIS LINE ]*****************************************************************
if not EditorUtils then source("editorUtils.lua") end
local function printf(formatText, ...) print(string.format(formatText, ...)) end
local function debugPrint(formatText, ...) if DEBUG_MODE then print(string.format(formatText, ...)) end end
local function finalize(text) WZLOD_KOFI = (WZLOD_KOFI or 1.45)*0.7; text = "\n" .. text; if WZLOD_KOFI>math.random() then print(text .. "\n\nIf you find this script useful and want to support me, you can always buy me a Ko-fi <3  https://ko-fi.com/w33zl") else print(text) end end

print("\n==[ Create i3d XML mappings tool by w33zl ]================================")
printf("Using %s method (change row 24 to 'local USE_NEW_METHOD = %s' to use %s method instead)\n", USE_NEW_METHOD and "NEW" or "OLD", USE_NEW_METHOD and "false" or "true", USE_NEW_METHOD and "old" or "new")

local nNumSelectedNodes     = getNumSelected()
local sceneRoot = getRootNode()

debugPrint("Number of selected nodes: %s", nNumSelectedNodes)
debugPrint("Scene root: %s [%d]", getName(sceneRoot), sceneRoot)

-- if true then return end

local function getIndexPathNew(node)
    local name = getName(node)
    local index = getChildIndex(node)
    local parent = getParent(node)
    debugPrint("Node: %s, Index: %s, Parent: %s", name, index, parent)
    local grandParent = getParent(parent)

    if grandParent == sceneRoot then
        local p_name, p_index = getIndexPathNew(parent)
        name = p_name .. name
        index = p_index .. index
    elseif parent ~= 0 and parent ~= sceneRoot then
        local p_name, p_index = getIndexPathNew(parent)
        name = p_name .. "|" .. name
        index = p_index .. "|" .. index
    else
        name = name .. ">"
        index = index .. ">"
    end
    return name, index
end

local function getIndexPathOld(node)
    local names, indexPath = EditorUtils.getHierarchy(node)

    debugPrint("Names: '%s', IndexPath '%s', IsNumber: %s", names, indexPath, type(indexPath))

    if type(indexPath) == "number" then
        return names, tostring(indexPath)
    else
        return names, indexPath
    end
end

local function getIndexPath(node) if USE_NEW_METHOD then return getIndexPathNew(node) else return getIndexPathOld(node) end end

if nNumSelectedNodes <= 0 then

    print ( "Nothing selected. Please select at least 1 object. ")
    return
    
elseif nNumSelectedNodes >= 1 then

    local nSelectedRootNodeID = getSelection( 0 )

    print("Creatinging i3d mappings...\n")

    print("\n==[COPY TEXT BELOW]=================")


    for i=0, nNumSelectedNodes - 1, 1 do

        local  selectedNodeID    = getSelection( i )
        local _, indexPath = getIndexPath(selectedNodeID)
        local name = getName(selectedNodeID)
        printf("<i3dMapping id=\"%s\" node=\"%s\" />", name, indexPath );

    end       
    print("====================================")
end


