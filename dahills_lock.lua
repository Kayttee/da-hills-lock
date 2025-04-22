-- Da Hills Aimlock by Uriel
getgenv().AimlockEnabled = true
getgenv().AimPart = "Head"
getgenv().Prediction = true
getgenv().PredictionVelocity = 0.14
getgenv().AimRadius = 100
getgenv().TeamCheck = false
getgenv().Keybind = Enum.KeyCode.X

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Holding = false
local Target

local function getClosest()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(getgenv().AimPart) then
            if getgenv().TeamCheck == false or player.Team ~= LocalPlayer.Team then
                local pos = player.Character[getgenv().AimPart].Position
                local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(pos)
                if onScreen then
                    local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude
                    if mag < dist and mag <= getgenv().AimRadius then
                        dist = mag
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

Mouse.Button2Down:Connect(function()
    if getgenv().AimlockEnabled then
        Holding = true
        while Holding do
            Target = getClosest()
            if Target and Target.Character and Target.Character:FindFirstChild(getgenv().AimPart) then
                local aimPos = Target.Character[getgenv().AimPart].Position
                if getgenv().Prediction then
                    aimPos = aimPos + Target.Character[getgenv().AimPart].Velocity * getgenv().PredictionVelocity
                end
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, aimPos)
            end
            RunService.RenderStepped:Wait()
        end
    end
end)

Mouse.Button2Up:Connect(function()
    Holding = false
end)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == getgenv().Keybind then
        getgenv().AimlockEnabled = not getgenv().AimlockEnabled
        game.StarterGui:SetCore("SendNotification", {
            Title = "Da Hills Lock",
            Text = getgenv().AimlockEnabled and "Lock Enabled" or "Lock Disabled",
            Duration = 2
        })
    end
end)
