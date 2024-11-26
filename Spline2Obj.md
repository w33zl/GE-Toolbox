# GE Toolbox - Spline to .obj

The scripts takes the selected node (if it is a spline) and outputs it as a mesh in an .obj file that can be imported into e.g. Blender or Houdini.

## Usage
1. Select spline node in GE
2. Execute script "*Spline 2 Obj*" (for keyboard shortcut, check [GE-HAM](https://github.com/w33zl/GE-Hotkeys-and-Macros))
3. A file dialog is shown where you should choose a filename for the output .obj file
4. Open your 3D editor of choice and import the .obj file
5. Convert the imported mesh from the .obj file into a curve (for detailed instructions, refer to YouTube tutorial or user manual relevant for your selected tool)

*__Important__: The file dialog in step three will not give you a warning if you provide a filename of an existing file, however the script will abort the execution with a warning message. If you then choose to run the script again with the same filename the file **will be overwritten**.*


## Import a OBJ file as a curve in Blender

1. In GE, export the spline into .obj file using the `Spline 2 Obj` script
2. In Blender, choose *File>Import>Wavefront (.obj)*
3. Select the file you exported from GE
4. Select the imported mesh (should have the same name as the spline)
5. In object mode, goto the menu *Object>Convert>Curve*
6. Tab into Edit Mode, goto the menu *Curve>Set Spline Type>NURBS*

The sixth and final step is only needed if your spline in GE has the Spline Type "Cubic".