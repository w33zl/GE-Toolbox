-- Author: w33zl
-- Name: Show Node Debug Info
-- Description: Displays information about node path, scale, rotation etc
-- Icon:iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAf1JREFUOI2N00tI1FEUx/HPnUYblMpFFhUtDIpqEW7EWhgFSRQ9cCFBBQUlkQS9cNMuekGbHpIteiws2igVtYjIWvQQIoweUDCLih4gZCGJTikzt0X/xBGDDtzN5f6+58f53RNMUPWNzUSTIouwB2swiE5cwKeuzjYwabx49abdCoVQjtM4iYCH6MUqHMCveYtret69eVYI4zvHqATtWIKtCzJd2cp0tpSQ+jC8LP9luHptAj8qaE2PBcQI1mE56qomP3lXmc6mcZgYqkq7W76OLLw2HDN5tIpupYr8hxCwD+3zM13vZ5e8bEAFVmJFZG5N+eWlgpv4hP3FgBinYCFuz0hnIyqxCS/Qg/X4GQqFX3iAzcUAIY0UBpKLt9iKBmzDYvTVTrkE/ZhaBIgxDuAbajELdRjGffQl8C2D+cpM8ubROAdGcAVNz4c292MIW5JUWnAGL1/nNs5JAEeKUkilohjDRRzMFSpODuRnnsqkfnwuCbnPMBLLUr0ji0oI7XhK7A6M5h9QjV3YgRxe4RweE8qI69GM92gkfv/rIGAnzmIyrmMvmnAU05Nf8hEncDUEuXsd54X6xuaAnTGOivPYgDsCogymJW36RPkYuN/xZxfSMdo+pnMeR3D377LgZ3ImrDQOjRWH4BgK/xJMBGjCjWRYx+91tOX/Vwy/Ad2BrypZYwpQAAAAAElFTkSuQmCCAAAb9g4EABgAgFwAUgBFAEcASQBTAFQAUgBZAFwAVQBTAEUAUgBcAFMALQAxAC0ANQAtADIAMQAtADMAOAAyADYAMwA3ADEAMQA1ADQALQAxADUAMgAwADYAMAAzADcAOQA1AC0ANwA3ADEAOAA3ADgANwAxAC0AMQAwADAAMQBfAEMAbABhAHMAcwBlAHMAXABTAHkAcwB0AGUAbQBGAGkAbABlAEEAcwBzAG8AYwBpAGEAdABpAG8AbgBzAFwAaQBtAGEAZwBlAFwAUwBoAGUAbABsAEUAeABcAHsAMgA0ADAAQQA3ADEANwA0AC0ARAA2ADUAMwAtADQAQQAxAEQALQBBADYARAAzAC0ARAA0ADkANAAzAEMARgBCAEYARQAzAEQAfQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
-- Hide: no

print("--[GE PowerTools by w33zl: Debug Item]---------")

source("editorUtils.lua")

local function printf(formatText, ...)
    print(string.format(formatText, ...))
end


local treeNodeId = getSelection(0)
local parentId = getParent(treeNodeId)
local tx,ty,tz = getTranslation(treeNodeId)
printf("%s (%d @ %d)", getName(treeNodeId), treeNodeId, parentId)
printf("Hierarchy: %s", EditorUtils.getHierarchy(treeNodeId))
printf("Translation: %d %d %d", tx, ty, tz)
printf("Scale: %d %d %d", getScale(treeNodeId))
printf("Rotation: %d %d %d", getRotation(treeNodeId))

