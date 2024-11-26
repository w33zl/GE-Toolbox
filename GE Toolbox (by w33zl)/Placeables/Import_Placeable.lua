
-- Author: w33zl
-- Name: Import i3d as placeable
-- Description: 
-- Hide: yes
-- Version: 1.0


--[[ REQUIRED to load GE Toolbox library, do not remove this line! --]] if not (function() local a = "C:/ProgramData/GE-Toolbox/GEToolbox.lua" ; if fileExists(a) then source(a) ; return true else print("WARNING: GEToolbox not properly installed, please refer to the documentaiton for troubleshooting information") end ; end)() then return end

-- local function loadGEToolbox() local a = "C:/ProgramData/GE-Toolbox/GEToolbox.lua" ; if fileExists(a) then source(a) ; return true else print("WARNING: GEToolbox not properly installed, please refer to the documentaiton for troubleshooting information") end ; end ; if not loadGEToolbox() then return end

source("Placeables/Lib.lua")

enableConsoleTimestampPrefix()

local function requirePlaceholderNode(name)
    name = name or "placeholders"


end

-- if (function() return true end)() then print("japp") end

-- mapBoundId
--filename
--<placeable mapBoundId="bga"                filename="data/placeables/planET/bga1mw/bga1mw.xml"                                             position="985.905 83.408 -129.516" rotation="0 90 0" />
-- <placeable mapBoundId="farmHouse"  filename="data/placeables/mapUS/farmBuildings/farmHouse/farmHouse02.xml"   position="153.75 86.625 138" rotation="0 -90 0" farmId="1" defaultFarmProperty="true" />

local placeablesNodeID = getPlaceholdersNode("test2", true)



print("ok")


