
-- Author: w33zl
-- Name: Spline To OBJ
-- Description: Exports a spline in GE to OBJ file that can be imported e.g. to Blender
-- Icon:iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAlRJREFUOI19kk1I1FEUxX/v/958NA41I4p9ulDnAw1LKBJqUUwgCBFtok1IFGSgGxdhRmSIGNhG2rURonJRu1pMuShm0SqVMXIyK4oKRhs1Ga2Zv77/azEpEw4eeG9xuedw7rlXsAUyN5rcAhEDcwaYAEYE4ld53/hGjyhFXOw9iNbCI+Ae8BEYAQ4DV4AOA5MVfRMAyFICOzyKQ3vKLgKzOa3vVPUnFwYT6Z+T6T/pI9VlA3WDb98ZmAfWSvFbqgPuL9dP7F5p3OlLC0E7IL1uRoc6cR71SHOzDQ10l5xbCIZTXfudH9cOmK9XGx23FHHAFfAz7rzEMa8w3x5jgNsAqoSG5XNJvMoya5b5LydT+Exx82YBQ+7N9xW2e6VY1cYY0ICzkiN1uodGaUHOxhGCaWM2sQEIe5TV/+BszecytzUAHP1Xl4C76Il1By5pcUlK9gKsaVITnfVDVX5XQ01t3YtVY7VKKVuLPWqt72utP8zMzKCAmvMt3L18CgugdxjtGLqBp7YjmuvqantisZjxer0AOI5DIpG4kEwmT4ZCoZQCZHQfsrkeA4jjEa8MbpPHMOKcEKKrsrKSeDxOMBhECAEgjDG7/H7/s2w226QAVjUmZxdSfj+XN7Hn022v2+vzAC6XC6UUkUhkXcAAKKUCY2NjHgXMDj0h9XCUCoC5RfNpIZvLlfeNE41G1+cWReT/zl8B85klGjJLJTeSWV5e1lDIpxRKHdIGHMcZnpqaCgUCgS7btotFjNa6YG0rAYBwOKyklB0+ny9UXLdt+3c+n7/1F1F13AywgnPxAAAAAElFTkSuQmCCdWUiKQAAAAAAAAB5MawYAAwAk4lQTkcNChoKAAAADUlIRFIAAAAQAAAAEAgGAAAAH/P/YQAAAARzQklUCAgICHwIZIgAAAJUSURBVDiNfZJNSNRRFMV/7//efDQONSOKfbpQ5wMNSygSalFMIAgRbaJNSBRkoBsXYUZkiBjYRtq1EaJyUbtaTLkoZtEqlTFyMiuKCkYbNRmtmb++/2sxKRMOHnhvcbnncO65V7AFMjea3AIRA3MGmABGBOJXed/4Ro8oRVzsPYjWwiPgHvARGAEOA1eADgOTFX0TAMhSAjs8ikN7yi4Cszmt71T1JxcGE+mfk+k/6SPVZQN1g2/fGZgH1krxW6oD7i/XT+xeadzpSwtBOyC9bkaHOnEe9Uhzsw0NdJecWwiGU137nR/XDpivVxsdtxRxwBXwM+68xDGvMN8eY4DbAKqEhuVzSbzKMmuW+S8nU/hMcfNmAUPuzfcVtg==
-- Hide: no
-- Version: 1.0


-- GE Toolbox - Spline To OBJ © 2022 by w33zl is licensed under CC BY-NC-ND 4.0 (Creative Commons Attribution-NonCommercial-ShareAlike) - http://creativecommons.org/licenses/by-nc-sa/4.0/

-- TL;DR: You are ALLOWED TO SHARE (copy and redistribute) the material in any medium or format
-- as long as you ATTRIBUTE (give appropriate credit to) the original author, 
-- do NOT MAKE ANY DERIVATIVES (i.e. do not modify and re-publish this as your own work) 
-- and as long as it is NOT USED FOR COMMERCIAL PURPOSES.

-- DISCLAIMER: THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, 
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
-- DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
-- THE USE OR OTHER DEALINGS IN THE SOFTWARE.



-->>>>>>>>>>>>>>>>>>>>>>> EXTRACT FROM GHLIB <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

---Wrapper for print(string.format())
---@param formatText any
---@param ... unknown
_G.printf = function(formatText, ...)
    print(string.format(formatText, ...))
end

GHLib = {}

---Check if node is of type spline
---@param nodeID integer
---@return boolean isSpline Returns true if the node has the class id spline
function GHLib:IsSpline(nodeID)
    return getHasClassId(nodeID, ClassIds.SPLINE) or (getHasClassId(nodeID, ClassIds.SHAPE) and getSplineNumOfCV(nodeID) > 0)
end
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


local selectedNodeID = getSelection(0)
local sceneNodeID = getChildAt(getRootNode(), 0);
local terrainNodeID = getChild(sceneNodeID, "terrain")

local splineLength = getSplineLength( selectedNodeID ) ;

print("\n#####[ Export Spline to Obj - by w33zl ]###########################################")
print("Check GitHub for additonal information and latest updates: https://github.com/w33zl\n")

if selectedNodeID == nil or selectedNodeID == 0 then
    print("ERROR: You must select a spline first, no node was selected!")
    return
elseif not GHLib:IsSpline(selectedNodeID) then
    printf("ERROR: The selected node [#%d] must be a spline, please select a spline node before you run the script again.", selectedNodeID)
    return
end

local canContinue = true
local outputFilename = openFileDialog("Choose a name for you new obj file", "*.obj")

if fileExists(outputFilename) then
    canContinue = (g_lastSaveXMLMappingsFilename ~= nil and g_lastSaveXMLMappingsFilename == outputFilename)

    if not canContinue then
        print("ERROR: File already exists! Please re-run the script and choose the exact same filename again to force the script to override the file, or choose another filename.")
        g_lastSaveXMLMappingsFilename = outputFilename
    end
end

if not canContinue then return end

g_lastSaveXMLMappingsFilename = nil

local dryRun = (outputFilename == "")

--TODO: add the option to increase the resolution (number of CVs/vertices)
--TODO: add option to get relative or world spline coordinates

local function createObjFileContent()
    local lineConfig = "" -- "l"
    local output = string.format("o %s\n", getName(selectedNodeID))
    local numberOfCVs = getSplineNumOfCV(selectedNodeID)
    local vertexIndex = 0
    for i = 1, numberOfCVs, 1 do
        local numRepeats = 1
        if i == 1 or i == numberOfCVs then numRepeats = 2 end
    
        for r = 1, numRepeats, 1 do
            local x, y, z = getSplineCV(selectedNodeID, i - 1)
    
            -- printf("%d: x%f y%f z%f", i, x, y, z)
            output = string.format("%sv %f %f %f 1.00000\n", output, x, y, z)
    
            vertexIndex = vertexIndex + 1

            if vertexIndex > 1 then
                lineConfig = string.format("%sl %d %d\n", lineConfig, vertexIndex - 1, vertexIndex)
            end
        
            -- lineConfig = string.format("%s %d", lineConfig, vertexIndex)
        end
    end

    return string.format("%s%s", output, lineConfig)
end

if dryRun then
    print("\n==[COPY TEXT BELOW]=================")
    print(createObjFileContent())
    print("====================================")
else
    local fileId = createFile(outputFilename, FileAccess.WRITE)
    fileWrite(fileId, "# Exported by 'Spline to Object' GE script by w33zl\n")
    fileWrite(fileId, createObjFileContent())
    delete(fileId)

    local cleanedUpFilename = string.sub( outputFilename, 1, string.len( outputFilename ) - 1 )
    cleanedUpFilename = string.gsub(cleanedUpFilename, "\\", "/")  

    if fileExists(outputFilename) then
        printf("Successfully created file '%s'", cleanedUpFilename)
    else
        printf("ERROR: Failed to create file '%s'!", cleanedUpFilename)
    end
end

print("\nDone!")
