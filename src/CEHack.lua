return function(state)
    if (state) then
        ceh = {}

        ceh.util = {
            withTmpVar = function(size, callback)
                local memory = allocateMemory(size)
                local result = { callback(memory) }
                table.insert(result, readQword(memory))
                deAlloc(memory)
                return table.unpack(result)
            end,

            activate = function(name, state_)
                for i = 0, AddressList.Count - 1, 1 do
                    if (AddressList[i].Description == name) then
                        AddressList[i].Active = state_ ~= false
                        break
                    end
                end
            end
        }
        
        ceh.modules = {
            load = function(id, path)
                ceh.modules[id] = dofile(path)
                ceh.modules[id](true)
            end,
            unload = function(id)
                ceh.modules[id](false)
                ceh.modules[id] = nil
            end
        }
    else
        ceh = nil
    end
end
