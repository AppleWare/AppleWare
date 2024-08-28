local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

_G.Esp = false
_G.Usernames = false
_G.Distance = false

local function createDrawing(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local esp = {}

local function createEsp(player)
    local drawings = {
        name = createDrawing("Text", {
            Size = 18,
            Center = true,
            Outline = true,
            Color = Color3.new(1, 1, 1),
            Visible = false
        }),
        distance = createDrawing("Text", {
            Size = 16,
            Center = true,
            Outline = true,
            Color = Color3.new(1, 1, 0),
            Visible = false
        })
    }
    esp[player] = drawings
end

local function removeEsp(player)
    if esp[player] then
        for _, drawing in pairs(esp[player]) do
            drawing:Remove()
        end
        esp[player] = nil
    end
end

local function updateEsp()
    for player, drawings in pairs(esp) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and _G.Esp then
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

                if _G.Usernames then
                    drawings.name.Text = player.Name
                    drawings.name.Position = Vector2.new(pos.X, headPos.Y - 40)
                    drawings.name.Visible = true
                else
                    drawings.name.Visible = false
                end

                if _G.Distance then
                    local distance = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    drawings.distance.Text = tostring(distance) .. " studs"
                    drawings.distance.Position = Vector2.new(pos.X, headPos.Y - 20)
                    drawings.distance.Visible = true
                else
                    drawings.distance.Visible = false
                end
            else
                drawings.name.Visible = false
                drawings.distance.Visible = false
            end
        else
            drawings.name.Visible = false
            drawings.distance.Visible = false
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(removeEsp)

RunService:BindToRenderStep("ESP", Enum.RenderPriority.Camera.Value, updateEsp)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.F1 then
            _G.Esp = not _G.Esp
        elseif input.KeyCode == Enum.KeyCode.F2 then
            _G.Usernames = not _G.Usernames
        elseif input.KeyCode == Enum.KeyCode.F3 then
            _G.Distance = not _G.Distance
        end
    end
end)
