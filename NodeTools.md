# GE Toolbox - Node Tools

This collection of scripts helps working with the nodes in the scenegraph.

## Wrap node in transform
This will wrap the currently selected node in a transform group, i.e. the selected node will be a child of a newly created transform group node in the same position as the currently selected node.

### Usage
1. Select a node in the scenegraph in GE
2. Execute script "*Wrap in transform*"
3. You should now have your existing node wrapped as a child to a new transform group node

## Show Node Debug Info
Simply prints some useful information to the log about the currently selected node. This is useful when creating your own scripts for GE. E.g. the hierarcy (name of the node and all its ancestors), the current translation/scaling etc is printed to the log. More data points we be added in the future. 
