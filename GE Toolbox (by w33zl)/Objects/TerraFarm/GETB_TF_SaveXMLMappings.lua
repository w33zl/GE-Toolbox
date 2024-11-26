--[[
GE Toolbox - Create TerraFarm XML

Author:     w33zl / WZL Modding
Version:    1.0
Modified:   2024-06-11

Facebook:           https://www.facebook.com/w33zl
Ko-fi:              https://ko-fi.com/w33zl
Patreon:            https://www.patreon.com/wzlmodding
Github:             https://github.com/w33zl

Changelog:

]]

-- Author: w33zl
-- Name: TF: Save TerraFarm XML to file
-- Description: Prints a XML tag in the log for each selected node in the scenegraph
-- Icon:
-- Hide: no


print("\n##[ GE Toolbox - TerraFarm - Save XML ]###############################################\n")

local function printf(formatText, ...) print(string.format(formatText, ...)) end

local numItemsSelected = getNumSelected()
if numItemsSelected == 0 then
    printf("ERROR: Please select one node (transform group) in the scenegraph to apply the configuration to", numItemsSelected)
    return
elseif numItemsSelected > 1 then
    printf("ERROR: %d items selected, please only select one node in the scenegraph", numItemsSelected)
    return
end

local selectedRootNodeId = getSelection(0)

local function getConfig(name, defaultValue)
    local userAttribute = getUserAttribute(selectedRootNodeId, name)

    if userAttribute ~= nil then
        return userAttribute
    else 
        return defaultValue
    end
end

local function showEnabledFeatures(value, text)
    if (type(value) == "boolean" and value == true) or ( type(value) == "number" and value ~= 0) or (type(value) == "string" and value ~= "") then
        printf(text, value)
    end
end

local worldRootNodeId = getRootNode()
local mapRootNodeId = getChildAt(worldRootNodeId,0)
local terrainRootNodeId = getChild(mapRootNodeId, "terrain")
terrainRootNodeId = (terrainRootNodeId ~= 0 and terrainRootNodeId) or getChild(mapRootNodeId, "Terrain") -- Fallback check since it is case sensitive

local nodeName = getConfig("TF Node Name", "0>")
local terraformModes = getConfig("TF Terraform", "MATERIAL LOWER FLATTEN SMOOTH PAINT")
local dischargeModes = getConfig("TF Discharge", "MATERIAL RAISE FLATTEN SMOOTH PAINT")
-- local numNodes = getConfig("TF Num Nodes", 4)
-- local width = getConfig("TF Width", 1)

local TF_NODE_NAME = "terraFormNode"

-- local widthPerNode = width / (numNodes - 1)
-- local startX = -(width / 2)

-- local function addChildNode(parentNodeId, nodeName, x, y, z)
--     local newTransformGroupNodeId = createTransformGroup( nodeName )
--     -- addUserAttribute(selectedNodeId, "IsObjectDistributorSourceNode", "Boolean", 0)
--     link( parentNodeId, newTransformGroupNodeId )
--     setTranslation(newTransformGroupNodeId, x, y, z)
--     return newTransformGroupNodeId
    
-- end


-- local outputFilename = string.gsub( getSceneFilename(), ".i3d", ".tf" )
local outputFilename = getSceneFilename() .. ".tf"
-- print(outputFilename)


local canContinue = true
-- local outputFilename = openFileDialog("Choose a name for you new obj file", "*.obj")

if fileExists(outputFilename) then
    canContinue = (g_lastSaveXMLMappingsFilename ~= nil and g_lastSaveXMLMappingsFilename == outputFilename)

    if not canContinue then
        print("ERROR: File already exists! Please re-run the script to force the file to be overwritten.")
        g_lastSaveXMLMappingsFilename = outputFilename
    end
end

if not canContinue then return end

g_lastSaveXMLMappingsFilename = nil

local fileId = createFile(outputFilename, FileAccess.WRITE)
fileWrite(fileId, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
fileWrite(fileId, "<terraFarm>\n")

local offsetX, offsetY, offsetZ = getTranslation(selectedRootNodeId)

print("Writing terraform node:")
printf("- Reference node: %s\n- Offset: %.2f %.2f %.2f\n- Terraform modes: %s\n", nodeName, offsetX, offsetY, offsetZ, terraformModes)

fileWrite(fileId, string.format("\t<terraform node=\"%s\" offset=\"%.2f %.2f %.2f\" modes=\"%s\">\n", nodeName, offsetX, offsetY, offsetZ, terraformModes))

print("Writing terraform sub nodes:")
for i=0, getNumOfChildren(selectedRootNodeId) - 1 do
    local childNode = getChildAt(selectedRootNodeId, i)
    if getName(childNode) == TF_NODE_NAME then
        local x, y, z = getTranslation(childNode)
        fileWrite(fileId, string.format("<node position=\"%.2f %.2f %.2f\" />", x, y, z))

        printf("%d : \t% .2f\t% .2f\t% .2f", i + 1, x, y, z)
    end
end
fileWrite(fileId, "\t</terraform>\n")

print("\nWriting discharge node:")
printf("- Discharge modes: %s\n", dischargeModes)


fileWrite(fileId, string.format("\t<discharge modes=\"%s\" />\n", dischargeModes))

fileWrite(fileId, "</terraFarm>\n")
delete(fileId)

local cleanedUpFilename = string.sub( outputFilename, 1, string.len( outputFilename )  )
cleanedUpFilename = string.gsub(cleanedUpFilename, "\\", "/")

if fileExists(outputFilename) then
    printf("Successfully created file '%s'", cleanedUpFilename)
else
    printf("ERROR: Failed to create file '%s'!", cleanedUpFilename)
end