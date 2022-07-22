return function(state)
    if (state) then
        -- lua may have a built in way to do this
        local username = ceh.util.withTmpVar(257, function(namePtr)
            return ceh.util.withTmpVar(4, function(sizePtr)
                writeInteger(sizePtr, 257)
                executeCodeEx(0, nil, getAddressSafe("GetUserNameA"), { type = 0, value = namePtr },
                    { type = 0, value = sizePtr })
                return readString(namePtr)
            end)
        end)

        local path = "C:/Users/" .. username .. "/.wasmer/lib/wasmer.dll"
        local result = ceh.util.withTmpVar(string.len(path), function(pathPtr)
            writeString(pathPtr, path)
            return executeCode(getAddressSafe("LoadLibraryA"), pathPtr)
        end)

        print(tostring(result))

        if result == 0 then
            showMessage("Wasmer doesn't appear to be installed.\nYou can install wasmer from https://wasmer.io")
            error()
        end
    else
        local getModuleHandle = getAddressSafe("GetModuleHandleA")
        local dllName = "wasmer.dll"
        local hmodule = ceh.util.withTmpVar(string.len(dllName), function(dllNamePtr)
            writeString(dllNamePtr, dllName)
            return executeCode(getModuleHandle, dllNamePtr)
        end)

        if hmodule ~= 0 then
            executeCode(getAddressSafe("FreeLibrary"), hmodule)
        end
    end
end
