return function(Tab)

    local Global = getgenv()
    local CloneReference = function(Object)
        if cloneref and typeof(cloneref) == "function" then
            return cloneref(Object)
        else
            return Object
        end
    end

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Cringles Workshop
    local CWPREMIUM = Tab:AddLeftGroupbox("Cringles WorkShop")

    CWPREMIUM:AddButton({
        Text = 'Teleport To End',
        Func = function()

            local door = workspace.CurrentRooms["2"].RippleExitDoor
            local doorCF = door:GetPivot()

            local offset = doorCF.LookVector * 2
            local finalCF = doorCF + offset

            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")

            hrp.CFrame = CFrame.new(finalCF.Position, doorCF.Position)
            Notify('Teleported...')
        end,
        DoubleClick = true,
        Tooltip = 'Makes You Teleport To The End. Must be in Room 1.'
    })

    -- Lobby
    local LOBBYPREMIUM = Tab:AddLeftGroupbox("Lobby")

    CodesList = {
        "67","54","41","CHEDDAR BALLS","XQC","PENGUINZ0","KREEKCRAFT","ISHOWSPEED",
        "DANTDM","KUBZ SCOUTS","FIND THE TROLLFACES","THINKNOODLES","W","RAGDOLL UNIVERSE",
        "RAGDOLL MAYHEM","BIJUU MIKE","8BITRYAN","SCREECHSUCKS","LORE","ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "FIND THE TROLLFACES","3rd","LAZYDEVS","RAGDOLL COMBAT","VOCAB HAVOC","PATHSWAP",
        "JUMP OVER THE BRICK"
    }

    LOBBYPREMIUM:AddButton{
        Text = 'Redeem Codes',
        DoubleClick = false,
        Tooltip = 'Redeems all currently active codes in the game',
        Func = function()
            for _, ShopCode in pairs(CodesList) do
                game:GetService("ReplicatedStorage").RemotesFolder.ShopCode:FireServer(ShopCode)
                task.wait(1.1)
            end
        end
    }

   

end
