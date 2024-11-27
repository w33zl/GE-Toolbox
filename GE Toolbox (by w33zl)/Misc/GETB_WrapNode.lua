-- Author: w33zl
-- Name: Wrap node in transform
-- Description:
-- Icon:iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAWdEVYdFNvZnR3YXJlAFBhaW50Lk5FVCA1LjH3g/eTAAAAtGVYSWZJSSoACAAAAAUAGgEFAAEAAABKAAAAGwEFAAEAAABSAAAAKAEDAAEAAAACAAAAMQECAA4AAABaAAAAaYcEAAEAAABoAAAAAAAAAGAAAAABAAAAYAAAAAEAAABQYWludC5ORVQgNS4xAAMAAJAHAAQAAAAwMjMwAaADAAEAAAABAAAABaAEAAEAAACSAAAAAAAAAAIAAQACAAQAAABSOTgAAgAHAAQAAAAwMTAwAAAAAGOkJsRSTv3MAAAChElEQVQ4T3VSz0tUURT+7n0/ZhydZtScRvyFEMykUyhioWKGUIvACsVFUFDtoo34P7QsChdJqyKojdAiqHbNSkrKMQw1hmSa5pdMIw32nGae773ueTqDQ9MH551zzzn3u99597I6iaFgWL2zQ81Pe/31bZaeMZnkBbiDr6a1Hw/eb193y+wrBHb2LHJVkCdPNGAprk3fGDw20OXlgHcEViELXsqiv63BLwgujnY5bILX3/7Ymw6DN7pktHtlpU7hMIoxyANTQOsADH0HqsTRojJGNbJa4JZlwSyWxNeC88JjKMf74RyZhhK6CUtPgVSLom21YNMyVREdDMXwXeixLyguvYK+sQCm+MGofmC1wE3BrJvgjDFI2IP5+S2Q/ASZUVKMZQmVovE/AiApMLCY0n3DHa4pk6nYSi7jZz6PXIFjbUvD89Vf8y7J2mgduozRsTGEQiHQYcFgELFYrKKMRjkrrDl//+qCZ/bFpIjp0MTszMzH34UCJM7tjQURr6yswOPxIBwOQxZNBLOrnofdjn2+Hn/jy7U8vKODJ29lc7nzpVLJzgsCJgj0SCTypK+vL0u5MgG+ayag7cdSSzvapO3gEbf7XiAQQFNTE0zTtBUYhoHOzs4rc3Nzl0RrrnK5QgFCRx12rCgKnE6nSTLX19exubmJRCKBeDyOVCpF9eHx8fE31FshIAVKR48dv7sWsJbvnP4gSZK93t3dBcX84D+4XC50d3cPUu2f53Xq4SI792yDCX+G1rTB4XBAVdWKkcIyeRUBvUr6YQdejL0/N63JaqGKgK4onU6XfSSTycxrmmafVh7hsBGqCCjp8/nK3piYmLgdjUYfCSIkk8kqy2bpFoG/KgIIzqYVJ9oAAAAASUVORK5CYII=
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