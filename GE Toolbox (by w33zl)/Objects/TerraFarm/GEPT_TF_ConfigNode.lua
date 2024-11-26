--[[
GE Toolbox (by w33zl) - Config TerraFarm Node

Author:     w33zl / WZL Modding
Version:    1.0
Modified:   2024-06-10

Facebook:           https://www.facebook.com/w33zl
Ko-fi:              https://ko-fi.com/w33zl
Patreon:            https://www.patreon.com/wzlmodding
Github:             https://github.com/w33zl

Changelog:
v1.0.0      Initial version
]]

-- Author: w33zl
-- Name: TF: Config Base Node
-- Description: Configures a node (transform group) to be used with the "TerraFarm" XML generator
-- Icon:
-- Hide: no
-- Version: 1.0


print("\n##[ GE Toolbox - TerraFarm - Config TF Node ]###############################################\n")

local function printf(formatText, ...) print(string.format(formatText, ...)) end
local function finalize(text) WZLOD_KOFI = (WZLOD_KOFI or 1.45)*0.7; text = "\n" .. text; if WZLOD_KOFI>math.random() then print(text .. "\n\nIf you find this script useful and want to support me, you can always buy me a Ko-fi <3  https://ko-fi.com/w33zl") else print(text) end end
local function addUserAttribute(nodeId, attributeName, type, defaultValue) if getUserAttribute(nodeId, attributeName) == nil then setUserAttribute(nodeId, attributeName, type, defaultValue) end end

local numItemsSelected = getNumSelected()
if numItemsSelected == 0 then
    printf("ERROR: Please select one node (transform group) in the scenegraph to apply the configuration to", numItemsSelected)
    return
elseif numItemsSelected > 1 then
    printf("ERROR: %d items selected, please only select one node in the scenegraph", numItemsSelected)
    return
end

local selectedNodeId = getSelection(0)

-- <Attribute name="MaxRotationX" type="float" value="0.1"/>
-- <Attribute name="MaxRotationZ" type="float" value="0"/>
-- <Attribute name="OffsetRotationX" type="float" value="0"/>
-- <Attribute name="OffsetRotationZ" type="float" value="0"/>
-- <Attribute name="RandomRotationY" type="boolean" value="true"/>
-- <Attribute name="SnapToTerrainY" type="boolean" value="true"/>
-- <Attribute name="UseTargetName" type="boolean" value="true"/>
-- <Attribute name="UseTargetRotation" type="boolean" value="true"/>
-- <Attribute name="UseTargetScale" type="boolean" value="true"/>
-- <Attribute name="EnumerateTargetName" type="boolean" value="true"/>



-- local treeNodeId = selectedNodeId
-- local parentId = getParent(treeNodeId)
-- local tx,ty,tz = getTranslation(treeNodeId)
-- print("--[DEBUG ITEM]---------")
-- printf("%s (%d @ %d)", getName(treeNodeId), treeNodeId, parentId)
-- printf("Translation: %d %d %d", tx, ty, tz)
-- printf("Translation: %d %d %d", tx, ty, tz)
-- printf("Scale: %d %d %d", getScale(treeNodeId))
-- printf("Rotation: %d %d %d", getRotation(treeNodeId))


printf("Setting up node '%s' (%d) for TerraFarm XML generator", getName(selectedNodeId), selectedNodeId)

-- print("Creating terrafarm node")
local tfNodeName = "terraFarm"
-- local targetNodeName = getUserAttribute(selectedNodeId, "TargetNodeName")

local function addChildNode(parentNodeId, nodeName)
    local newTransformGroupNodeId = createTransformGroup( nodeName )
    -- addUserAttribute(selectedNodeId, "IsObjectDistributorSourceNode", "Boolean", 0)
    link( parentNodeId, newTransformGroupNodeId )
    return newTransformGroupNodeId
end

-- local hasSourceNode = false --, hasTargetNode = false, false
local tfNodeId = -1
for i=0,getNumOfChildren(selectedNodeId)-1 do
    local childNode = getChildAt(selectedNodeId, i)
    if getName(childNode) == tfNodeName then tfNodeId = childNode end
    -- hasSourceNode = hasSourceNode or (getName(childNode) == tfNodeName)
    -- hasTargetNode = hasTargetNode or (getName(childNode) == targetNodeName)
end

if tfNodeId == -1 then
    tfNodeId = addChildNode(selectedNodeId, tfNodeName)
else
    printf("WARNING: Node '%s' [%d] already exists, updating node", tfNodeName, tfNodeId)
end
-- if not hasTargetNode then addChildNode(selectedNodeId, targetNodeName) end
-- print("Ok")


print("Adding user attributes with default values")

addUserAttribute(tfNodeId, "TF Node Name", "String", getName(selectedNodeId))
addUserAttribute(tfNodeId, "TF Terraform", "String", "MATERIAL LOWER FLATTEN SMOOTH PAINT")
addUserAttribute(tfNodeId, "TF Discharge", "String", "MATERIAL RAISE FLATTEN SMOOTH PAINT")
addUserAttribute(tfNodeId, "TF Num Nodes", "Integer", 4)
addUserAttribute(tfNodeId, "TF Width", "Float", 1)
addUserAttribute(tfNodeId, "TF Depth", "Float", 0)

finalize("Done")