-- Danh sách yêu cầu thắng cho từng world
local worldWins = {
    [1] = "Free", [2] = "10", [3] = "20", [4] = "30", [5] = "50",
    [6] = "100", [7] = "250", [8] = "500", [9] = "1k", [10] = "2k",
    [11] = "4k", [12] = "7k", [13] = "11k", [14] = "16k"
}

-- Tạo GUI Menu
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local instructions = Instance.new("TextLabel")

screenGui.Name = "TeleportMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

frame.Name = "MenuFrame"
frame.Size = UDim2.new(0.4, 0, 0.7, 0)
frame.Position = UDim2.new(0.3, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
frame.Parent = screenGui

title.Name = "Title"
title.Text = "RYZOR-SCRIPT"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(0.8, 0.8, 0.8)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

instructions.Name = "Instructions"
instructions.Text = "Nhấn Open để bật, Close để dừng. Menu tự động ẩn/hiện với Ctrl."
instructions.Size = UDim2.new(1, 0, 0.08, 0)
instructions.Position = UDim2.new(0, 0, 0.1, 0)
instructions.BackgroundTransparency = 1
instructions.TextColor3 = Color3.new(0.8, 0.8, 0.8)
instructions.Font = Enum.Font.SourceSansBold
instructions.TextScaled = true
instructions.Parent = frame

local teleportStatus = {}

-- Hàm tạo nút
local function createButton(worldIndex, positionY)
    local label = Instance.new("TextLabel")
    local winReq = worldWins[worldIndex] or "?"
    label.Text = "World " .. worldIndex .. " (" .. winReq .. " win)"
    label.Size = UDim2.new(0.4, 0, 0.05, 0)
    label.Position = UDim2.new(0.1, 0, positionY, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Parent = frame

    local buttonOpen = Instance.new("TextButton")
    buttonOpen.Text = "Open"
    buttonOpen.Size = UDim2.new(0.2, 0, 0.05, 0)
    buttonOpen.Position = UDim2.new(0.55, 0, positionY, 0)
    buttonOpen.BackgroundColor3 = Color3.new(0, 0.8, 0)
    buttonOpen.TextColor3 = Color3.new(1, 1, 1)
    buttonOpen.Font = Enum.Font.SourceSansBold
    buttonOpen.TextScaled = true
    buttonOpen.Parent = frame

    local buttonClose = Instance.new("TextButton")
    buttonClose.Text = "Close"
    buttonClose.Size = UDim2.new(0.2, 0, 0.05, 0)
    buttonClose.Position = UDim2.new(0.77, 0, positionY, 0)
    buttonClose.BackgroundColor3 = Color3.new(0.8, 0, 0)
    buttonClose.TextColor3 = Color3.new(1, 1, 1)
    buttonClose.Font = Enum.Font.SourceSansBold
    buttonClose.TextScaled = true
    buttonClose.Parent = frame

    teleportStatus[worldIndex] = false

    buttonOpen.MouseButton1Click:Connect(function()
        if not teleportStatus[worldIndex] then
            teleportStatus[worldIndex] = true
            buttonOpen.BackgroundColor3 = Color3.new(1, 1, 1) -- Trắng
            buttonOpen.TextColor3 = Color3.new(0, 0, 0) -- Chữ đen

            print("Dịch chuyển tự động tới World " .. worldIndex)
            task.spawn(function()
                while teleportStatus[worldIndex] do
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local world = game.Workspace.Worlds.Worlds:FindFirstChild("World" .. worldIndex)

                    if world then
                        local targetPart = world:FindFirstChild("Part")
                        if targetPart and targetPart:IsA("BasePart") then
                            character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0)
                        else
                            print("Không tìm thấy Part trong World " .. worldIndex)
                        end
                    else
                        print("Không tìm thấy World " .. worldIndex)
                    end
                    task.wait(1)
                end
            end)
        end
    end)

    buttonClose.MouseButton1Click:Connect(function()
        teleportStatus[worldIndex] = false
        buttonOpen.BackgroundColor3 = Color3.new(0, 0.8, 0) -- Xanh lá lại
        buttonOpen.TextColor3 = Color3.new(1, 1, 1) -- Trắng
        print("Dừng dịch chuyển tự động tới World " .. worldIndex)
    end)
end

-- Tạo 14 nút
for i = 1, 14 do
    createButton(i, 0.18 + (i - 1) * 0.055)
end

-- Ẩn/hiện menu bằng Ctrl
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        frame.Visible = not frame.Visible
        print("Menu đã được ẩn hoặc hiện!")
    end
end)
