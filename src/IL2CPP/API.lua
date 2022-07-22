return function(state)
    if state then
        il2cpp = {}

        il2cpp.import = function(name)
            local address = getAddressSafe("il2cpp_" .. name)
            if (address == nil) then
                print("Failed to find export il2cpp_" .. name)
                return
            end
            il2cpp[name] = function(...)
                local args = {}
                for _, val in ipairs(table.pack(...)) do
                    table.insert(args, { type = 0, value = val })
                end
                return executeCodeEx(0, nil, address, table.unpack(args))
            end
        end

        il2cpp.import("domain_get")
        il2cpp.import("domain_get_assemblies")
        il2cpp.import("assembly_get_image")
        il2cpp.import("image_get_name")
        il2cpp.import("class_from_name")
        il2cpp.import("class_get_name")
        il2cpp.import("class_get_namespace")
        il2cpp.import("class_get_method_from_name")
        il2cpp.import("method_get_name")

    else
        il2cpp = nil
    end
end
