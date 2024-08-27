
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Teams = game:GetService("Teams")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()


_G.triggerbot = false
_G.Teamcheck = false

local function isMouseOverPlayer()
    local target = Mouse.Target
    if target and target.Parent then
        local character = target.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local player = Players:GetPlayerFromCharacter(character)
        if humanoid and player then
            if _G.Teamcheck then
                return player.Team ~= LocalPlayer.Team
            else
                return true
            end
        end
    end
    return false
end

local function simulateMouseClick()
    mouse1press()
    wait()
    mouse1release()
end

local function triggerBot()
    if _G.triggerbot and isMouseOverPlayer() then
        print("Cursor is over a valid target!")
        simulateMouseClick()
    end
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.T then
            _G.triggerbot = not _G.triggerbot
            print("TriggerBot " .. (_G.triggerbot and "Enabled" or "Disabled"))
        elseif input.KeyCode == Enum.KeyCode.Y then
            _G.Teamcheck = not _G.Teamcheck
            print("Team Check " .. (_G.Teamcheck and "Enabled" or "Disabled"))
        end
    end
end)


RunService.RenderStepped:Connect(triggerBot)
