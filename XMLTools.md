# GE Toolbox - XML Tools

This collection of scripts helps creating XML for the ingame assets.

## Create i3d XML mappings

### Usage
1. Select one or more nodes in the scenegraph in GE
2. Execute script "*Create i3d XML mappings (v2)*" in the scripts folder/submenu `GE Toolbox/XML Tools` (for keyboard shortcut, check [GE-HAM](https://github.com/w33zl/GE-Hotkeys-and-Macros))
3. The script now outputs a XML tag for each node selected with the node name as the "id" attribute and the index path as the "node" attribute, e.g. `<i3dMapping id="sampleNode" node="0>1" />`
4. Copy the text below the line `==[COPY TEXT BELOW]=================` and then paste into your vehicle/placeable XML file

***Please note:** There is two versions (v1 and v2) included, it is recommended to use the v2 version.*

