local module = {}

function module.get(folder_name)
    local folder = workspace:FindFirstChild(folder_name)

    if not folder:IsA("Folder") or not folder then
       folder = Instance.new('Folder')
       folder.Name = folder_name
       folder.Parent = workspace
    end

    return folder
end

return module