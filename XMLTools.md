# GE Toolbox - XML Tools

This collection of scripts helps creating XML for the ingame assets.

## Create i3d XML mappings

### Usage
1. Select one or more nodes in the scenegraph in GE
2. Execute script "*Create i3d XML mappings*" in the scripts folder/submenu `GE Toolbox/` (for keyboard shortcut, check [GE-HAM](https://github.com/w33zl/GE-Hotkeys-and-Macros))
3. The script now outputs a XML tag for each node selected with the node name as the "id" attribute and the index path as the "node" attribute, e.g. `<i3dMapping id="sampleNode" node="0>1" />`
4. Copy the text below the line `==[COPY TEXT BELOW]=================` and then paste into your vehicle/placeable XML file

***Please note:** The script will output the node index/path in the format `0>1|0|2`. If you need the indexes in the format `0|1|0|2` you can change line 24 to:
 ```lua
 local USE_NEW_METHOD = false
 ```


## Create XML nodes for lights (W.I.P.)
TBD