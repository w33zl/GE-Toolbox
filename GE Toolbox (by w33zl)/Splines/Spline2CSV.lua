
-- Author: w33zl
-- Name: Spline To CSV
-- Description: Exports a spline in GE to CSV file.
-- Icon:iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAsBJREFUOI11kVtoXHUQxn/z33P2mj1ZmiarNSahu4SW1mhaBYONBMULokGotC8qvtlCsYioKFihL7416D4UpVZ8kICCF9CKvvRFGyhsKghqrSahyTbm1qRudvfsuY0PTSQN6QfzMMN833wzI2yBxXf6AXYIfAAMAJeAVxCZaDs5fkuv2Uy+fqIfwBEoAV8AQ8BZoIRq19JN8dvCCLT/enzvkbGju9+9vzNjA9gx6X31QH7kqxeKHxrhoa0Gr2Nod0dyujTcVXuk4Fw3wjHA2rGdi8cPivveS7a/v5cFYOc6wdrIFniw9Ez3XbvakxzozqYGTv8+4AbRR3t72DlyTOMiPrUIp/wnmdvdwORSMVK2IZuIrWmC2dC1mWBtylFdD/2/trKK/8tfIAJzyyigWwooXDv10z9h3x3p2ORyU0PVRROTYPyKnn3idQYB6k0WgZlnT+xDZM3iBmcZy0jf+Zd3vf9apX4h15NtOh2pOUBUVdZ2UkQUqEVB9I2I8HgyzkGBmB9ydfRw8UxbwSmPdjnbW1u3mSDy8AKXdNwhiDwMBjdoEDdJrk3OX7JyLXz2yZu0ORn4+Bw+sFoR5no6i/kn9zxPw6/J2OQ5HSwME0YB1eaKjE19z6O9h/RMZWSflbBpG+pHWjPo31O2vccknzttZHR/rtB3YfI7Gt4q+WwXf8yVmb0xxbZMno6WTixj0wzcW74iVS/k699W3qoIC0ZieIFL5cYEl+fHudPp4YHux5hfnaGztcB8dZqIEFN3uVr6kvDU54Q/lqPG2z/MTACEkU/CSlFsv5eWRE5+nvhW7FhcVJVix31ML18RFLGqDZ4++SkPC0ioLCjMqtKYWrrMU/e8SN37V8vT5xksDKOqVN1llmqzLNZmAerCJtz8r9xtJ2IX04lsPoh88cOmpuMOftjEC11JWmm8wA38pv/GfwPeGf0WdaAkAAAAAElFTkSuQmCCpQAAAOAA4AAAAABELlUgQJY9KXkVAIAAAAAAAAAAACAAAAAlAAAAAgAAAI/CdbUAAAAAAAAAAI/CdbUK2Ek+AgAAAM4e1j4AAAAAAAAAAM4e1j4K2Ek+AgAAAI/CdbUAAAAAAAAAAI/CdbUK2Ek+AgAAAM4e1j4AAAAAAAAAAM4e1j4K2Ek+AgAAAAMAAwAAAAAAAAAAAAIAAgAHAAYAAgAAAAAAAAAAAAAAAAAAAAEAAQAEAAUAAgAAAAcABwAAAAAAAAAAAAIAAgABAAMAAgAAAAQAAMAAAAAAAAAAAF6FIUC0h7U/AgAAAAAAAAAAAAAAAAAAAA==
-- Hide: no
-- Version: 1.0


-- GE Toolbox - Spline To CSV © 2022 by w33zl is licensed under CC BY-NC-ND 4.0 (Creative Commons Attribution-NonCommercial-ShareAlike) - http://creativecommons.org/licenses/by-nc-sa/4.0/

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

print("\n#####[ Export Spline to CSV - by w33zl ]###########################################")
print("Check GitHub for additonal information and latest updates: https://github.com/w33zl\n")

if selectedNodeID == nil or selectedNodeID == 0 then
    print("ERROR: You must select a spline first, no node was selected!")
    return
elseif not GHLib:IsSpline(selectedNodeID) then
    printf("ERROR: The selected node [#%d] must be a spline, please select a spline node before you run the script again.", selectedNodeID)
    return
end

local canContinue = true
local outputFilename = openFileDialog("Choose a name for you new CSV file", "*.csv")

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
    -- local lineConfig = "l"
    local output = ""
    local numberOfCVs = getSplineNumOfCV(selectedNodeID)
    local vertexIndex = 0
    for i = 1, numberOfCVs, 1 do
        local numRepeats = 1
        if i == 1 or i == numberOfCVs then numRepeats = 2 end
    
        for r = 1, numRepeats, 1 do
            local x, y, z = getSplineCV(selectedNodeID, i - 1)
    
            -- printf("%d: x%f y%f z%f", i, x, y, z)
            output = string.format("%s%f, %f, %f\n", output, z, x, y) -- Actual X, Y, Z should be printed as Z, X, Y
    
            vertexIndex = vertexIndex + 1
        
            -- lineConfig = string.format("%s %d", lineConfig, vertexIndex)
        end
    end

    -- return string.format("%s%s", output, lineConfig)
    return output
end

if dryRun then
    print("\n==[COPY TEXT BELOW]=================")
    print(createObjFileContent())
    print("====================================")
else
    local fileId = createFile(outputFilename, FileAccess.WRITE)
    -- fileWrite(fileId, "# Exported by 'Spline to Object' GE script by w33zl")
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
