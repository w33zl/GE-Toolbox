-- Author: w33zl
-- Name: Wrap node in transform
-- Description:
-- Icon:
-- Hide: no

local selectedNodeId = getSelection(0)
local selectedNodeIndex = getChildIndex(selectedNodeId)
local parentNodeId = getParent(selectedNodeId)
local wrapperNodeId = createTransformGroup("wrapper")

print(selectedNodeIndex)

if selectedNodeId ~= 0 and wrapperNodeId ~= 0 then
    unlink(selectedNodeId)
    link(parentNodeId, wrapperNodeId, selectedNodeIndex)
    link(wrapperNodeId, selectedNodeId)
end

-- scene = getChildAt(getRootNode(), 0)
-- nodeA = createTransformGroup("nodeA")
-- link(scene, nodeA)
-- link(getSelection(0), )



-- link(scene, nodeA)
-- delete(nodeA)
-- link(scene, nodeA)