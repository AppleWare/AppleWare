local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local githubUrl = "https://raw.githubusercontent.com/AppleWare/AppleWare/main/Keys.lua"

local function fetchGithubContent()
    local success, content = pcall(function()
        return game:HttpGet(githubUrl, true)
    end)
    if not success then
        warn("Failed to fetch content from GitHub:", content)
        LocalPlayer:Kick("Error fetching key data. Please contact support.")
        return nil
    end
    return content
end

local githubContent = fetchGithubContent()
if not githubContent then return end

local success, Keys = pcall(function()
    local chunk = loadstring(githubContent)
    if chunk then
        return chunk()
    else
        error("Failed to load GitHub content")
    end
end)

if not success then
    warn("Failed to load GitHub content:", Keys)
    LocalPlayer:Kick("Error processing key data. Please contact support.")
    return
end

if not Keys then
    warn("Failed to find 'Keys' table in the fetched content.")
    LocalPlayer:Kick("Error processing key data. Please contact support.")
    return
end

-- Check if the player's key exists in the Keys table
local function isKeyValid(key, keysTable)
    for _, v in ipairs(keysTable) do
        if v == key then
            return true
        end
    end
    return false
end

if isKeyValid(_G.Key, Keys) then
    print("Nice, it worked")
else
    LocalPlayer:Kick("Wrong Key. Please DM Staff to help you.")
end
