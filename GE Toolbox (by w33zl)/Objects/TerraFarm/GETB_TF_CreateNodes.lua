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
-- Name: TF: Create terraform nodes
-- Description: Prints a XML tag in the log for each selected node in the scenegraph
-- Icon:
-- Hide: no

local function printf(formatText, ...) print(string.format(formatText, ...)) end

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

print("\n##[ GE Toolbox - TerraFarm - Create nodes ]##############################################")
-- print("========================================================================\n")

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
local numNodes = getConfig("TF Num Nodes", 4)
local width = getConfig("TF Width", 1)
local depth = getConfig("TF Depth", 0)

local widthPerNode = width / (numNodes - 1)
local depthPerNode = depth / (numNodes / 2) -- TODO: keep it simple, or make it non linear?
local startX = -(width / 2)
local startY = -(depth / 2)

local TF_NODE_NAME = "terraFormNode"

for i=getNumOfChildren(selectedRootNodeId) - 1, 0, -1  do
    local childNode = getChildAt(selectedRootNodeId, i)
    if getName(childNode) == "previewNode" or getName(childNode) == TF_NODE_NAME then
        delete(childNode)
        
    end
end


-- local mid = {x= 14+((226-14)*math.cos(165))+((446-496)*math.sin(165)), y= 446+((496-446)*math.cos(165))+((226-14)*math.sin(165))};

local function addChildNode(parentNodeId, nodeName, x, y, z)
    local newTransformGroupNodeId = createTransformGroup( nodeName )
    -- addUserAttribute(selectedNodeId, "IsObjectDistributorSourceNode", "Boolean", 0)
    link( parentNodeId, newTransformGroupNodeId )
    setTranslation(newTransformGroupNodeId, x, y, z)
    return newTransformGroupNodeId
    
end

local offsetX, offsetY, offsetZ = getTranslation(selectedRootNodeId)



local lastChildNode = -1
local indexOffset = -1 -- -(numNodes % 2)
local indexMiddlepoint = ((numNodes + indexOffset) / 2)

-- printf("offset: %f, middlepoint: %f, depthPerNode: %f", indexOffset, indexMiddlepoint, depthPerNode)
print("\nCreating nodes")
printf("Number of nodes: %d\nTotal width: %.2f\nTotal depth: %.2f\nDepth per node: %.2f\n", numNodes, width, depth, depthPerNode)

for i=0, numNodes - 1, 1 do
    -- local nodeOffset = i / numNodes
    
    local ii = i - indexMiddlepoint
    local n = ( numNodes / 2) - indexMiddlepoint
    local z = -(math.abs(ii) * depthPerNode)
    -- printf("ii = %d, n: %f z: %f", ii, n, z)
    lastChildNode = addChildNode(selectedRootNodeId, TF_NODE_NAME, startX, 0, z)
    printf("%d [#%d] : \t% .2f\t% .2f\t% .2f", i + 1, lastChildNode, startX, 0, z)
    startX = startX + widthPerNode
end

if lastChildNode ~= -1 then
    clearSelection()
    addSelection(lastChildNode)
end


print("\nDone")