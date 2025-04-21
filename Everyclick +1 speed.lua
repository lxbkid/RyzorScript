-- Dịch vụ Roblox
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- Tạo GUI chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PhantomMenu"
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true -- đảm bảo GUI được bật

-- Đảm bảo GUI được thêm vào đúng Parent
local CoreGui = game:GetService("CoreGui")
local success, result = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Tạo MainFrame (menu chính)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 650)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Tạo nút logo để hiện lại menu
local logoButton = Instance.new("ImageButton")
logoButton.Name = "LogoButton"
logoButton.Size = UDim2.new(0, 50, 0, 50)
logoButton.Position = UDim2.new(0, 10, 0, 10) -- Góc trên trái cho dễ thấy
logoButton.BackgroundTransparency = 1
logoButton.Image = "rbxassetid://137967475559270" -- Icon bánh răng, không lỗi
logoButton.Visible = false
logoButton.Parent = ScreenGui

-- Kiểm tra xem MainFrame và logo có tồn tại
if MainFrame then print("MainFrame OK") else warn("MainFrame lỗi") end
if logoButton then print("LogoButton OK") else warn("LogoButton lỗi") end

-- Nhấn RightCtrl để ẩn menu và hiện logo
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = false
        logoButton.Visible = true
        print("Đã ẩn menu và hiện logo")
    end
end)

-- Nhấn vào logo để hiện lại menu
logoButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    logoButton.Visible = false
    print("Đã hiện lại menu và ẩn logo")
end)

-- Gán PrimaryPart tự động cho các World
local function assignPrimaryParts()
    local worldsFolder = workspace:FindFirstChild("Worlds")
    if worldsFolder and worldsFolder:FindFirstChild("Worlds") then
        local subFolder = worldsFolder.Worlds
        for _, world in pairs(subFolder:GetChildren()) do
            if world:IsA("Model") and not world.PrimaryPart then
                for _, part in pairs(world:GetChildren()) do
                    if part:IsA("BasePart") then
                        world.PrimaryPart = part
                        print("Đã gán PrimaryPart cho " .. world.Name .. " là: " .. part.Name)
                        break
                    end
                end
            end
        end
    else
        warn("Không tìm thấy workspace.Worlds.Worlds!")
    end
end
assignPrimaryParts()

-- Main Frame
MainFrame.Size = UDim2.new(0, 500, 0, 650)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "MenuTitle"
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "RyzorKid | Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = MainFrame

-- Navigation Bar
local Navigation = Instance.new("Frame")
Navigation.Size = UDim2.new(1, 0, 0, 50)
Navigation.Position = UDim2.new(0, 0, 0, 40)
Navigation.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Navigation.Parent = MainFrame

local UICorner_Nav = Instance.new("UICorner")
UICorner_Nav.CornerRadius = UDim.new(0, 6)
UICorner_Nav.Parent = Navigation

-- Tạo các trang
local Pages = {
    Main = Instance.new("ScrollingFrame"),
    Egg = Instance.new("Frame")
}

for name, page in pairs(Pages) do
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, -90)
    page.Position = UDim2.new(0, 0, 0, 90)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = MainFrame
end

-- Scrolling Frame cho Main
Pages.Main.ScrollBarThickness = 6
Pages.Main.CanvasSize = UDim2.new(0, 0, 0, 700)
Pages.Main.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)

-- Tạo nút điều hướng
local NavButtons = {}
local function CreateNavButton(name, text, position)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.4, -10, 0.8, -10)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 16
    Button.Parent = Navigation

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button

    NavButtons[name] = Button

    Button.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do
            p.Visible = (n == name)
        end
        for _, b in pairs(NavButtons) do
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        end
        Button.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
    end)
end

-- Vị trí nút điều hướng
CreateNavButton("Main", "Main", UDim2.new(0.1, 0, 0, 5))
CreateNavButton("Egg", "Egg", UDim2.new(0.55, 0, 0, 5))

-- Nội dung Main Page
local function InitializeMainPage()
    local function createButton(worldIndex, positionY)
        local worldName = "World" .. worldIndex
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.9, 0, 0.06, 0)
        frame.Position = UDim2.new(0.05, 0, positionY, 0)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        frame.BorderSizePixel = 0
        frame.Parent = Pages.Main

        local button = Instance.new("TextButton")
        button.Text = "World " .. worldIndex
        button.Size = UDim2.new(0.7, 0, 1, 0)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSansBold
        button.TextSize = 14
        button.Parent = frame

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = button

        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(0.05, 0, 0.4, 0)
        toggle.Position = UDim2.new(0.85, 0, 0.3, 0)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        toggle.Parent = frame

        local UICorner_Toggle = Instance.new("UICorner")
        UICorner_Toggle.CornerRadius = UDim.new(1, 0)
        UICorner_Toggle.Parent = toggle

        local active = false

        local teleporting = false

local function teleportLoop()
    while teleporting do
        local player = Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local worldModel = Workspace.Worlds.Worlds:FindFirstChild(worldName)
            if worldModel and worldModel:IsA("Model") and worldModel.PrimaryPart then
                player.Character.HumanoidRootPart.CFrame = worldModel.PrimaryPart.CFrame
            else
                warn("Không tìm thấy hoặc không có PrimaryPart cho: " .. worldName)
                teleporting = false
                toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                return
            end
        end
        wait(1)
    end
end

button.MouseButton1Click:Connect(function()
    teleporting = not teleporting
    if teleporting then
        toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Xanh
        teleportLoop()
    else
        toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Đỏ
    end
end)

    end

    for i = 1, 14 do
        createButton(i, 0.07 * (i - 1))
    end
end

-- Nội dung Egg Page
local function InitializeEggPage()
    local label = Instance.new("TextLabel")
    label.Text = "Coming Soon!"
    label.Size = UDim2.new(0.8, 0, 0.2, 0)
    label.Position = UDim2.new(0.1, 0, 0.4, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.Parent = Pages.Egg
end

-- Khởi tạo trang
InitializeMainPage()
