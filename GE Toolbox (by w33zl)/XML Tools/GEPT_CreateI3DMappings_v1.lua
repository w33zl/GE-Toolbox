-- Name: Create i3d XML mappings (v1)
-- Author: w33zl
-- Description: Prints a XML tag in the log for each selected node in the scenegraph
-- Icon:
-- Hide: yes

--[[
Version: 1.0
Modified:   2022-02-27

Facebook:           https://www.facebook.com/w33zl
Ko-fi:              https://ko-fi.com/w33zl
Patreon:            https://www.patreon.com/wzlmodding
Github:             https://github.com/w33zl

Changelog:
v1.0.0      Initial version
]]

source("editorUtils.lua")

local nNumSelectedNodes     = getNumSelected()

if nNumSelectedNodes <= 0 then

    print ( "Nothing selected. Please select at least 1 object. ")
    return
    
elseif nNumSelectedNodes >= 1 then

    local nSelectedRootNodeID = getSelection( 0 )

    print("Creating i3d mappings...")

    for i=0, nNumSelectedNodes - 1, 1 do

        local  selectedNodeID    = getSelection( i )
        local _, indexPath = EditorUtils.getHierarchy(selectedNodeID)
        local name = getName(selectedNodeID)
        
        print( string.format("<i3dMapping id=\"%s\" node=\"%s\" />", name, indexPath ));

     end       
end