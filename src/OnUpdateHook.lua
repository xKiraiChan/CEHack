return function(state)
    if state then
        ceh.util.activate("IL2CPP Library")

        local domain = il2cpp.domain_get();
        print("IL2CPP Domain at " .. string.format("0x%X", domain))

        local assemblies, assembly_count = ceh.util.withTmpVar(8, function(temp)
            return il2cpp.domain_get_assemblies(domain, temp)
        end);

        print("List of " .. assembly_count .. " assemblies at " .. string.format("0x%X", assemblies))

        for i = 0, assembly_count - 1, 1 do
            local assembly = readPointer(assemblies + i * 8)
            local image = il2cpp.assembly_get_image(assembly)
            local name = readString(il2cpp.image_get_name(image))

            if name == "VRCCore-Standalone.dll" then
                print("Found VRCCore-Standalone.dll at " .. string.format("0x%X", assemblies + i * 8))

                local namespace = "VRC.Core"
                local className = "UpdateDelegator"
                local class = ceh.util.withTmpVar(string.len(namespace), function(namespace_ptr)
                    writeString(namespace_ptr, namespace)
                    return ceh.util.withTmpVar(string.len(className), function(className_ptr)
                        writeString(className_ptr, className)
                        return il2cpp.class_from_name(image, namespace_ptr, className_ptr)
                    end)
                end)

                print(
                    "Found "
                    .. readString(il2cpp.class_get_namespace(class))
                    .. "."
                    .. readString(il2cpp.class_get_name(class))
                    .. " at "
                    .. string.format("0x%X", class)
                )

                local methodName = "Update"
                local method = ceh.util.withTmpVar(string.len(methodName), function(methodName_ptr)
                    writeString(methodName_ptr, methodName)
                    return il2cpp.class_get_method_from_name(class, methodName_ptr, 0)
                end)

                print(
                    "Found method "
                    .. readString(il2cpp.method_get_name(method))
                    .. " at "
                    .. string.format("0x%X", method)
                )

                print("The method body is at " .. string.format("0x%X", readPointer(method)))

                break
            end
        end
    end
end
