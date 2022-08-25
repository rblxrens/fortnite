-- // Dependencies
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Load.lua"))()("Module")
local AimingChecks = Aiming.Checks
local AimingSelected = Aiming.Selected
local AimingSettingsIgnored = Aiming.Settings.Ignored
local AimingSettingsIgnoredPlayers = Aiming.Settings.Ignored.Players
local AimingSettingsIgnoredWhitelistMode = AimingSettingsIgnored.WhitelistMode

-- // Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- // Vars
Aiming.AimLock = {
    Enabled = true,
    FocusMode = false, -- // Stays locked on to that player only. If true then uses the aim lock keybind, if a input type is entered, then that is used
    CurrentlyFocused = nil,
    ToggleBind = false, -- // true = Toggle, false = Hold (to enable)
    Keybind = Enum.UserInputType.MouseButton2, -- // You can also have Enum.KeyCode.E, etc.
}
local IsToggled = false
local Settings = Aiming.AimLock

-- //
function Settings.ShouldUseCamera()
    -- //
    return (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter)
end

-- // Allows for custom
function Settings.AimLockPosition(CameraMode)
    local Position = CameraMode and AimingSelected.Part.Position or AimingSelected.Position
    return Position, {}
end

-- // Focuses a player
local Backup = {table.unpack(AimingSettingsIgnoredPlayers)}
function Settings.FocusPlayer(Player)
    table.insert(AimingSettingsIgnoredPlayers, Player)
    AimingSettingsIgnoredWhitelistMode.Players = true
end

-- // Unfocuses a player
function Settings.Unfocus(Player)
    -- // Find it within ignored, and remove if found
    local PlayerI = table.find(AimingSettingsIgnoredPlayers, Player)
    if (PlayerI) then
        table.remove(AimingSettingsIgnoredPlayers, PlayerI)
    end

    -- // Disable whitelist mode
    AimingSettingsIgnoredWhitelistMode.Players = false
end

-- // Unfocuses everything
function Settings.UnfocusAll(Replacement)
    Replacement = Replacement or Backup
    AimingSettingsIgnored.Players = Replacement
    AimingSettingsIgnoredWhitelistMode.Players = false
end

-- //
function Settings.FocusHandler()
    if (Settings.CurrentlyFocused) then
        Settings.Unfocus(Settings.CurrentlyFocused)
        Settings.CurrentlyFocused = nil
        return
    end

    if (AimingChecks.IsAvailable()) then
        Settings.FocusPlayer(AimingSelected.Instance)
        Settings.CurrentlyFocused = AimingSelected.Instance
    end
end

-- // For the toggle and stuff
local function CheckInput(Input, Expected)
    local InputType = Expected.EnumType == Enum.KeyCode and "KeyCode" or "UserInputType"
    return Input[InputType] == Expected
end

UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
    -- // Make sure is not processed
    if (GameProcessedEvent) then
        return
    end

    -- // Check if matches bind
    local FocusMode = Settings.FocusMode
    if (CheckInput(Input, Settings.Keybind)) then
        if (Settings.ToggleBind) then
            IsToggled = not IsToggled
        else
            IsToggled = true
        end

        if (FocusMode == true) then
            Settings.FocusHandler()
        end
    end

    -- // FocusMode check
    if (typeof(FocusMode) == "Enum" and CheckInput(Input, FocusMode)) then
        Settings.FocusHandler()
    end
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessedEvent)
    -- // Make sure is not processed
    if (GameProcessedEvent) then
        return
    end

    -- // Check if matches bind
    if (CheckInput(Input, Settings.Keybind) and not Settings.ToggleBind) then
        IsToggled = false
    end
end)

-- // Constantly run
local BeizerCurve = Aiming.BeizerCurve
RunService:BindToRenderStep("AimLockAiming", 0, function()
    -- // Vars
    local CameraMode = Settings.ShouldUseCamera()
    local Manager = CameraMode and BeizerCurve.ManagerB or BeizerCurve.ManagerA

    -- // Make sure key (or mouse button) is down
    if (Settings.Enabled and IsToggled and AimingChecks.IsAvailable()) then
        -- // Vars
        local Position, BeizerData = Settings.AimLockPosition(CameraMode)
        BeizerData.TargetPosition = Position

        -- // Aim
        Manager:ChangeData(BeizerData)
    else
        -- // Stop any aim
        Manager:StopCurrent()
    end
end)

-- // Check if GUI exists (for Venyx)
if (Aiming.GUI and false) then
    -- // Vars
    local UI = Aiming.GUI[1]

    -- //
    local AimLockPage = UI:addPage({
        title = "Aim Lock",
        icon = 5012544693
    })
    AimLockPage:setOrderPos(2)

    -- //
    local MainSection = AimLockPage:addSection({
        title = "Main"
    })

    MainSection:addToggle({
        title = "Enabled",
        default = Settings.Enabled,
        callback = function(value)
            Settings.Enabled = value
        end
    })

    MainSection:addKeybind({
        title = "Keybind",
        default = Settings.Keybind,
        changedCallback = function(value)
            Settings.Keybind = value
        end
    })

    MainSection:addToggle({
        title = "Focus Mode (Uses Keybind)",
        default = Settings.FocusMode,
        callback = function(value)
            Settings.FocusMode = value
        end
    })
    MainSection:addKeybind({
        title = "Focus Mode (Custom Bind)",
        changedCallback = function(value)
            Settings.FocusMode = value
        end
    })

    MainSection:addToggle({
        title = "Toggle Bind",
        default = Settings.ToggleBind,
        callback = function(value)
            Settings.ToggleBind = value
        end
    })

    -- //
    local BeizerA = AimLockPage:addSection({
        title = "Beizer A: Mouse"
    })

    BeizerA:addSlider({
        title = "Smoothness",
        min = 0,
        max = 1,
        precision = 4,
        default = BeizerCurve.ManagerA.Smoothness,
        callback = function(value)
            BeizerCurve.ManagerA.Smoothness = value
        end
    })

    BeizerA:addToggle({
        title = "Draw Path",
        default = BeizerCurve.ManagerA.DrawPath,
        callback = function(value)
            BeizerCurve.ManagerA.DrawPath = value
        end
    })

    local function AddCurvePointSliders(Section, ManagerName)
        -- // Vars
        local CurvePoints = BeizerCurve["Manager" .. ManagerName].CurvePoints

        -- //
        local function AddSliderXY(i)
            -- // Vars
            local PointName = "Point " .. (i == 1 and "A" or "B")

            -- // X Slider
            Section:addSlider({
                title = PointName .. ": X",
                min = 0,
                max = 1,
                precision = 2,
                default = CurvePoints[i].X,
                callback = function(value)
                    CurvePoints[i] = Vector2.new(value, CurvePoints[i].Y)
                end
            })

            -- // Y Slider
            Section:addSlider({
                title = PointName .. ": Y",
                min = 0,
                max = 1,
                precision = 2,
                default = CurvePoints[i].Y,
                callback = function(value)
                    CurvePoints[i] = Vector2.new(CurvePoints[i].X, value)
                end
            })
        end

        AddSliderXY(1)
        AddSliderXY(2)
    end

    AddCurvePointSliders(BeizerA, "A")

    -- //
    local BeizerB = AimLockPage:addSection({
        title = "Beizer B: Camera"
    })

    BeizerB:addSlider({
        title = "Smoothness",
        min = 0,
        max = 1,
        precision = 4,
        default = BeizerCurve.ManagerB.Smoothness,
        callback = function(value)
            BeizerCurve.ManagerB.Smoothness = value
        end
    })

    AddCurvePointSliders(BeizerB, "B")
end

-- // Check if GUI exists (for Linoria)
if (Aiming.GUI) then
    -- // Vars
    local AimingTab = Aiming.GUI[2]

    -- //
    local AimLockGroupBox = AimingTab:AddRightTabbox("Aim Lock")
    local MainTab = AimLockGroupBox:AddTab("Main")
    local MouseTab = AimLockGroupBox:AddTab("Mouse")
    local CameraTab = AimLockGroupBox:AddTab("Camera")

    -- //
    MainTab:AddToggle("AimLockEnabled", {
        Text = "Enabled",
        Default = Settings.Enabled,
        Tooltip = "Toggle the Aim Lock on and off",
        Callback = function(Value)
            Settings.Enabled = Value
        end
    }):AddKeyPicker("AimLockEnabledKey", {
        Default = Settings.Keybind,
        SyncToggleState = false,
        Mode = Settings.ToggleBind and "Toggle" or "Hold",
        Text = "Aim Lock",
        NoUI = false,
        ChangedCallback = function(Key)
            Settings.Keybind = Key
        end
    })
    MainTab:AddToggle("AimLockEnabledToggle", {
        Text = "Toggle Mode",
        Default = Settings.ToggleBind,
        Tooltip = "When disabled, it is hold to activate.",
        Callback = function(Value)
            Settings.ToggleBind = Value

            Options.AimLockEnabledKey.Mode = Value and "Toggle" or "Hold"
            Options.AimLockEnabledKey:Update()
        end
    })

    MainTab:AddToggle("AimLockFocusMode", {
        Text = "Enabled",
        Default = Settings.Enabled,
        Tooltip = "Only targets the current targetted player",
        Callback = function(Value)
            Settings.FocusMode = Value
        end
    }):AddKeyPicker("AimLockFocusModeKey", {
        Default = Settings.Keybind,
        SyncToggleState = false,
        Text = "Focus Mode",
        NoUI = false,
        ChangedCallback = function(Key)
            Settings.FocusMode = Key
        end
    })

    -- //
    MouseTab:AddSlider("AimLockMouseSmoothness", {
        Text = "Smoothness",
        Tooltip = "How smooth and fast the Mouse lock is",
        Default = BeizerCurve.ManagerA.Smoothness,
        Min = 0,
        Max = 1,
        Rounding = 4,
        Callback = function(Value)
            BeizerCurve.ManagerA.Smoothness = Value
        end
    })

    MouseTab:AddToggle("AimLockMouseDrawPath", {
        Text = "Draw Path",
        Default = BeizerCurve.ManagerA.DrawPath,
        Tooltip = "Draw the aim curve when activated",
        Callback = function(Value)
            BeizerCurve.ManagerA.DrawPath = Value
        end
    })

    local function AddCurvePointSliders(Tab, ManagerName)
        -- // Vars
        local CurvePoints = BeizerCurve["Manager" .. ManagerName].CurvePoints

        -- //
        local function AddSliderXY(i)
            -- // Vars
            local PointName = "Point " .. (i == 1 and "A" or "B")
            local PointNumber = i == 1 and "first" or "second"

            -- // X Slider
            Tab:AddSlider("AimingCurvePointX" .. tostring(i), {
                Text = PointName .. ": X",
                Tooltip = "The X position of the " .. PointNumber .. " point",
                Default = CurvePoints[i].X,
                Min = 0,
                Max = 1,
                Rounding = 2,
                Callback = function(Value)
                    CurvePoints[i] = Vector2.new(Value, CurvePoints[i].Y)
                end
            })

            -- // Y Slider
            Tab:AddSlider("AimingCurvePointY" .. tostring(i), {
                Text = PointName .. ": Y",
                Tooltip = "The Y position of the " .. PointNumber .. " point",
                Default = CurvePoints[i].Y,
                Min = 0,
                Max = 1,
                Rounding = 2,
                Callback = function(Value)
                    CurvePoints[i] = Vector2.new(CurvePoints[i].X, Value)
                end
            })
        end

        AddSliderXY(1)
        AddSliderXY(2)
    end

    AddCurvePointSliders(MouseTab, "A")

    -- //
    CameraTab:AddSlider("AimLockCameraSmoothness", {
        Text = "Smoothness",
        Tooltip = "How smooth and fast the Camera lock is",
        Default = BeizerCurve.ManagerB.Smoothness,
        Min = 0,
        Max = 1,
        Rounding = 4,
        Callback = function(Value)
            BeizerCurve.ManagerB.Smoothness = Value
        end
    })

    AddCurvePointSliders(CameraTab, "B")
end

-- //
return Aiming
