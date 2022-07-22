return function(state)
    if (state) then
        ceh = {}
        ceh.util = {}
        ceh.util.withTmpVar = function(size, callback)
            local memory = allocateMemory(size)
            local result = { callback(memory) }
            table.insert(result, readQword(memory))
            deAlloc(memory)
            return table.unpack(result)
        end
        ceh.util.activate = function(name, state)
            for i = 0, AddressList.Count - 1, 1 do
                if (AddressList[i].Description == name) then
                    AddressList[i].Active = state ~= false
                    break
                end
            end
        end
    else
        ceh = nil
    end
end
