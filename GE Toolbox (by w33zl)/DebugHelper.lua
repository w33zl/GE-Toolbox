DebugHelper = DebugHelper or {}

--- Executes any function and returns the time it took to execute. 
--- The first return value is the execution time (in ms) and the rest of the values are the return values from the callback function.
---@param callback function Callback function to execute
---@return number timeElapsed "Execution time (in ms)"
---@return  returnValues "A list of return values from the callback function" 
function DebugHelper:timedExecution(callback)
    local startTime = getTimeSec()

    local returnValue = { callback() }
    local timeElapsed = (getTimeSec() - startTime)

    return timeElapsed, unpack(returnValue)
end

--- Starts a execution timer with the given format string.
---@param formatString string "Format string to print the execution time (you need to add '%f' to the string)"
---@return table "Execution timer object with the stop function (call ':stop(true)' to supress automatic print of the results)"
---@remark The results will be printed to the console when the timer is stopped (see ':stop()') unless the 'noPrint' parameter is set to true (e.g. ':stop(true)').
function DebugHelper:measureStart(formatString)
    return {
        text = formatString,
        startTime = getTimeSec(),
        stop = function(self, noPrint)
            self.endTime = getTimeSec()
            self.diff = self.endTime - self.startTime
            self.results = string.format(formatString, self.diff)
            if not noPrint then
                print(self.results)
            end
            return self.results
        end,
    }
end
