-- Author: w33zl
-- Name:
-- Description:
-- Hide: yes
-- Version: 1.0

---comment
---@param formatString any
function printf(formatString, ...)
    print(string.format(formatString, ...))
end

_G.printTimestampPrefix = false

function enableConsoleTimestampPrefix() 
    _G.printTimestampPrefix = true
end

local function appendDatePrefix(string)
    return "[" .. getDate("%Y-%m-%d %H:%M:%S") .. "] " .. string
end

_G.oldPrint = _G.oldPrint or _G.print
_G.print = function(string)
    if _G.printTimestampPrefix then
        string = appendDatePrefix(string)
    end
    _G.oldPrint(string)
end


_G.oldPrintWarning = _G.oldPrintWarning or _G.printWarning
_G.printWarning = function(formatString, ...)
    local warningPrefix = "WARNING: "
    if _G.printTimestampPrefix then
        warningPrefix = appendDatePrefix(warningPrefix)
    end
    _G.oldPrintWarning(string.format( warningPrefix .. formatString, ... ))
end

_G.oldPrintError = _G.oldPrintError or _G.printError
_G.printError = function(formatString, ...)
    local errorPrefix = "ERROR: "
    if _G.printTimestampPrefix then
        errorPrefix = appendDatePrefix(errorPrefix)
    end
    _G.oldPrintError(string.format( errorPrefix .. formatString, ... ))
end


function getSceneNode()
    return getChildAt(getRootNode(), 0)
end

function getTopLevelNode(name)
    return getChild(getSceneNode(), name)
end

---comment
---@param name string The name of the root placeholders node (default: placeholders)
---@param autoCreate boolean True if a node should be automatically created
function getPlaceholdersNode(name, autoCreate)
    name = name or "placeholders"
    autoCreate = autoCreate or false

    local placeholdersNodeID = getTopLevelNode(name)

    if placeholdersNodeID ~= 0 then
        return placeholdersNodeID
    elseif placeholdersNodeID == 0 and autoCreate then
        --TODO: create
        placeholdersNodeID = createTransformGroup(name)
        printf("New id: %d", placeholdersNodeID)
        
        -- setUserAttribute(placeholdersNodeID, "any", "string", "abc")
        -- setUserAttribute(placeholdersNodeID, "onCreate", "scriptcallback", "Placeholders.onCreate")
        -- setUserAttribute(placeholdersNodeID, "onCreate2", "script callback", "Placeholders.onCreate")
        -- setUserAttribute(placeholdersNodeID, "onCreate3", "script_callback", "Placeholders.onCreate")
        -- setUserAttribute(placeholdersNodeID, "onCreate4", "scriptCallback", "Placeholders.onCreate")
        

        link( getSceneNode(), placeholdersNodeID )
        -- setUserAttribute(placeholdersNodeID, "any2", "string", "abc")

        addSelection(placeholdersNodeID)

        setUserAttribute(placeholdersNodeID, "onCreate2", "ScriptCallback", "");
        setUserAttribute(placeholdersNodeID, "onCreate3", "Scriptcallback", "");
        setUserAttribute(placeholdersNodeID, "onCreate4", "Script Callback", "");
        setUserAttribute(placeholdersNodeID, "onCreate5", "Script_Callback", "");
        setUserAttribute(placeholdersNodeID, "onCreate6", "Script callback", "");
        setUserAttribute(placeholdersNodeID, "onCreate7", "scriptCallback", "");
        setUserAttribute(placeholdersNodeID, "onCreate8", "Script", "");
        setUserAttribute(placeholdersNodeID, "onCreate9", "Callback", "");
        setUserAttribute(placeholdersNodeID, "onCreate10", "function", "");
        setUserAttribute(placeholdersNodeID, "onCreate11", "Function", "");
        
        setUserAttribute(placeholdersNodeID, "onCreate", "", "Placeholders.onCreate")
        setUserAttribute(placeholdersNodeID, "onCreate0", "String", "")
        
        return
    else
        printWarning("Could not find node '%s'", name)
    end
end

print("Lib reloaded")