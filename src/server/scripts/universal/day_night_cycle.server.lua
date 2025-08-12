--!strict

local light = game.Lighting
local tween = game:GetService("TweenService")

local bool = Instance.new('BoolValue', game.ReplicatedStorage)
bool.Name = 'is_night'

light.ClockTime = 12

local night_cycle = 2 * 60 --in minutes
local day_cycle = 6 * 60
local intermission = 0

while wait() do
	local day = tween:Create(light,TweenInfo.new(day_cycle),{ClockTime = 12})
	day:Play()
	wait(day_cycle / 2)
	bool.Value = false
	day.Completed:Wait()
	
	wait(intermission)
	
	local night = tween:Create(light,TweenInfo.new(night_cycle),{ClockTime = 0})
	night:Play()
	wait(night_cycle / 2)
	bool.Value = true
	night.Completed:Wait()
end