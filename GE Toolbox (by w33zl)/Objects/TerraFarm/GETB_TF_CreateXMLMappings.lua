--[[
GE Toolbox - Create TerraFarm XML

Author:     w33zl / WZL Modding
Version:    1.0
Modified:   2024-06-10

Facebook:           https://www.facebook.com/w33zl
Ko-fi:              https://ko-fi.com/w33zl
Patreon:            https://www.patreon.com/wzlmodding
Github:             https://github.com/w33zl

Changelog:

]]

-- Author: w33zl
-- Name: TF: Generate TerraFarm XML
-- Description: Prints a XML tag in the log for each selected node in the scenegraph
-- Icon:
-- Hide: no

-- local nNumSelectedNodes     = getNumSelected()

-- local function getIndexPath(node)
--     local name = getName(node)
--     local index = getChildIndex(node)
--     local parent = getParent(node)
--     local grandParent = getParent(parent)

--     if grandParent == getChildAt(getRootNode(), 0) then
--         local p_name, p_index = getIndexPath(parent)
--         name = p_name .. name
--         index = p_index .. index
--     elseif parent ~= 0 and parent ~= getChildAt(getRootNode(), 0) then
--         local p_name, p_index = getIndexPath(parent)
--         name = p_name .. "|" .. name
--         index = p_index .. "|" .. index
--     else
--         name = name .. ">"
--         index = index .. ">"
--     end
--     return name, index
-- end

-- if nNumSelectedNodes <= 0 then

--     print ( "Nothing selected. Please select at least 1 object. ")
--     return
    
-- elseif nNumSelectedNodes >= 1 then

--     local nSelectedRootNodeID = getSelection( 0 )

--     print("Creating i3d mappings...")

--     for i=0, nNumSelectedNodes - 1, 1 do

--         local  selectedNodeID    = getSelection( i )
--         local _, indexPath = getIndexPath(selectedNodeID)
--         local name = getName(selectedNodeID)
        
--         print( string.format("<i3dMapping id=\"%s\" node=\"%s\" />", name, indexPath ));

--     end
-- end

print("\n##[ GE Toolbox - TerraFarm - Generate XML ]###############################################")

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

local offsetX, offsetY, offsetZ = getTranslation(selectedRootNodeId)

print("\n===[ COPY PASTE THE FOLLOWING LINES ]==================================")

print(string.format("<terraform node=\"%s\" offset=\"%.2f %.2f %.2f\" modes=\"%s\">", nodeName, offsetX, offsetY, offsetZ, terraformModes))

for i=0, getNumOfChildren(selectedRootNodeId) - 1  do
    local childNode = getChildAt(selectedRootNodeId, i)
    if getName(childNode) == TF_NODE_NAME then
        local x, y, z = getTranslation(childNode)
        print(string.format("\t<node position=\"%.2f %.2f %.2f\" />", x, y, z))
    end
end


-- for i=0, numNodes - 1, 1 do
--     print(string.format("\t<node position=\"%.2f %.2f %.2f\" />", startX, 0, 0))
--     addChildNode(selectedRootNodeId, "previewNode", startX, 0, 0)
--     startX = startX + widthPerNode
-- end

print("</terraform>\n")

print(string.format("<discharge modes=\"%s\" />", dischargeModes))
print("===============================================================")

print("\nDone")

