-- Xeno Compatible: Server-Synced Log TP & Send Back
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local savedPositions = {}

-- Notification function
local function notify(message)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Log TP System";
        Text = message;
        Duration = 3;
    })
end

-- Notify when script is executed
notify("Prems Wayback Loaded")

-- Logs the current position (up to 2 recent positions)
local function logPosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        table.insert(savedPositions, 1, player.Character.HumanoidRootPart.Position)
        if #savedPositions > 2 then
            table.remove(savedPositions, 3) -- Keep only the last two positions
        end
        notify("Position Logged Into Database")
    end
end

-- Teleports to a saved position (with anchoring trick)
local function teleportBack(index)
    if savedPositions[index] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart

        -- Anchor and unanchor trick to sync with the server
        root.Anchored = true
        wait(0.1) -- Delay helps sync with the server
        root.CFrame = CFrame.new(savedPositions[index])
        wait(0.1) 
        root.Anchored = false

        if index == 1 then
            notify("Sent Back to Most Recent Position")
        elseif index == 2 then
            notify("Sent Back to Second Most Recent Position (Your welcome)")
        end
    else
        notify("No Position Logged Yet, Dumbass")
    end
end

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.K then
        logPosition() -- Logs position
    elseif input.KeyCode == Enum.KeyCode.L then
        teleportBack(1) -- Sends back to the most recent position
    elseif input.KeyCode == Enum.KeyCode.J then
        teleportBack(2) -- Sends back to the second most recent position
    end
end)

print("Prems Wayback Loaded")
