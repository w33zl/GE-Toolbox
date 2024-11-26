--[[
GE Toolbox - Create i3d Mappings

Author:     w33zl / WZL Modding
Version:    2.0
Modified:   2022-02-27

Facebook:           https://www.facebook.com/w33zl
Ko-fi:              https://ko-fi.com/w33zl
Patreon:            https://www.patreon.com/wzlmodding
Github:             https://github.com/w33zl

Changelog:
v2.0.0      Initial version (fork of v1)
]]

-- Author: w33zl
-- Name: Create i3d XML mappings
-- Description: Prints a XML tag in the log for each selected node in the scenegraph
-- Icon:
-- Hide: no

local nNumSelectedNodes     = getNumSelected()

local function getIndexPath(node)
    local name = getName(node)
    local index = getChildIndex(node)
    local parent = getParent(node)
    local grandParent = getParent(parent)

    if grandParent == getChildAt(getRootNode(), 0) then
        local p_name, p_index = getIndexPath(parent)
        name = p_name .. name
        index = p_index .. index
    elseif parent ~= 0 and parent ~= getChildAt(getRootNode(), 0) then
        local p_name, p_index = getIndexPath(parent)
        name = p_name .. "|" .. name
        index = p_index .. "|" .. index
    else
        name = name .. ">"
        index = index .. ">"
    end
    return name, index
end

if nNumSelectedNodes <= 0 then

    print ( "Nothing selected. Please select at least 1 object. ")
    return
    
elseif nNumSelectedNodes >= 1 then

    local nSelectedRootNodeID = getSelection( 0 )

    print("Creating i3d mappings...")

    for i=0, nNumSelectedNodes - 1, 1 do

        local  selectedNodeID    = getSelection( i )
        local _, indexPath = getIndexPath(selectedNodeID)
        local name = getName(selectedNodeID)
        
        print( string.format("<i3dMapping id=\"%s\" node=\"%s\" />", name, indexPath ));

    end
end