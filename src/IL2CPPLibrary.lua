return function(state)
    if state then
        _G.il2cpp = {}

        _G.il2cpp.import = function(name)
            local address = getAddressSafe("il2cpp_" .. name)
            if (address == nil) then
                print("Failed to find export il2cpp_" .. name)
                return
            end
            _G.il2cpp[name] = function(...)
                local args = {}
                for _, val in ipairs(table.pack(...)) do
                    table.insert(args, { type = 0, value = val })
                end
                return executeCodeEx(0, nil, address, table.unpack(args))
            end
        end

        _G.il2cpp.import("domain_get")
        _G.il2cpp.import("domain_get_assemblies")
        _G.il2cpp.import("assembly_get_image")
        _G.il2cpp.import("image_get_name")
        _G.il2cpp.import("class_from_name")
        _G.il2cpp.import("class_get_name")
        _G.il2cpp.import("class_get_namespace")
        _G.il2cpp.import("class_get_method_from_name")
        _G.il2cpp.import("method_get_name")

    else
        _G.il2cpp = nil
    end
end
