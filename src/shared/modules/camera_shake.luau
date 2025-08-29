--!strict

local module = {}

module.easing_styles = {
	linear = function(t: number)
		return t
	end,
	quadratic_in = function(t: number)
		return t * t
	end,
	quadratic_out = function(t: number)
		return t * (2 - t)
	end,
	quadratic_in_out = function(t: number)
		return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
	end,
	cubic_in = function(t: number)
		return t * t * t
	end,
	cubic_out = function(t: number)
		return 1 - math.pow(1 - t, 3)
	end,
	cubic_in_out = function(t: number)
		return t < 0.5 and 4 * t * t * t or 1 - math.pow(-2 * t + 2, 3) / 2
	end,
	quartic_in = function(t: number)
		return t * t * t * t
	end,
	quartic_out = function(t: number)
		return 1 - math.pow(1 - t, 4)
	end,
	quartic_in_out = function(t: number)
		return t < 0.5 and 8 * t * t * t * t or 1 - math.pow(-2 * t + 2, 4) / 2
	end,
	quintic_in = function(t: number)
		return t * t * t * t * t
	end,
	quintic_out = function(t: number)
		return 1 - math.pow(1 - t, 5)
	end,
	quintic_in_out = function(t: number)
		return t < 0.5 and 16 * t * t * t * t * t or 1 - math.pow(-2 * t + 2, 5) / 2
	end,
	sine_in = function(t: number)
		return 1 - math.cos((t * math.pi) / 2)
	end,
	sine_out = function(t: number)
		return math.sin((t * math.pi) / 2)
	end,
	sine_in_out = function(t: number)
		return -(math.cos(math.pi * t) - 1) / 2
	end,
	exponential_in = function(t: number)
		return t == 0 and 0 or math.pow(2, 10 * t - 10)
	end,
	exponential_out = function(t: number)
		return t == 1 and 1 or 1 - math.pow(2, -10 * t)
	end,
	exponential_in_out = function(t: number)
		if t == 0 then
			return 0
		elseif t == 1 then
			return 1
		elseif t < 0.5 then
			return math.pow(2, 20 * t - 10) / 2
		else
			return (2 - math.pow(2, -20 * t + 10)) / 2
		end
	end,
	circular_in = function(t: number)
		return 1 - math.sqrt(1 - math.pow(t, 2))
	end,
	circular_out = function(t: number)
		return math.sqrt(1 - math.pow(t - 1, 2))
	end,
	circular_in_out = function(t: number)
		return t < 0.5 and (1 - math.sqrt(1 - math.pow(2 * t, 2))) / 2 or (math.sqrt(1 - math.pow(-2 * t + 2, 2)) + 1) / 2
	end,
	back_in = function(t: number)
		local c1 = 1.70158
		local c3 = c1 + 1
		return c3 * t * t * t - c1 * t * t
	end,
	back_out = function(t: number)
		local c1 = 1.70158
		local c3 = c1 + 1
		return 1 + c3 * math.pow(t - 1, 3) + c1 * math.pow(t - 1, 2)
	end,
	back_in_out = function(t: number)
		local c1 = 1.70158
		local c2 = c1 * 1.525
		return t < 0.5 and (math.pow(2 * t, 2) * ((c2 + 1) * 2 * t - c2)) / 2 or (math.pow(2 * t - 2, 2) * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
	end,
	elastic_in = function(t: number)
		local c4 = (2 * math.pi) / 3
		return t == 0 and 0 or t == 1 and 1 or -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * c4)
	end,
	elastic_out = function(t: number)
		local c4 = (2 * math.pi) / 3
		return t == 0 and 0 or t == 1 and 1 or math.pow(2, -10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
	end,
	elastic_in_out = function(t: number)
		local c5 = (2 * math.pi) / 4.5
		if t == 0 then
			return 0
		elseif t == 1 then
			return 1
		elseif t < 0.5 then
			return -(math.pow(2, 20 * t - 10) * math.sin((20 * t - 11.125) * c5)) / 2
		else
			return (math.pow(2, -20 * t + 10) * math.sin((20 * t - 11.125) * c5)) / 2 + 1
		end
	end,
	bounce_in = function(t: number)
		return 1 - module.easing_styles.bounce_out(1 - t)
	end,
	bounce_out = function(t: number)
		local n1 = 7.5625
		local d1 = 2.75
		if t < 1 / d1 then
			return n1 * t * t
		elseif t < 2 / d1 then
			return n1 * (t - 1.5 / d1) * t + 0.75
		elseif t < 2.5 / d1 then
			return n1 * (t - 2.25 / d1) * t + 0.9375
		else
			return n1 * (t - 2.625 / d1) * t + 0.984375
		end
	end,
	bounce_in_out = function(t: number)
		return t < 0.5 and (1 - module.easing_styles.bounce_out(1 - 2 * t)) / 2 or (1 + module.easing_styles.bounce_out(2 * t - 1)) / 2
	end,
}

local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera
local current_shake

function lerp(a : number, b : number, t: number)
	return a + (b - a) * t
end

function module:shake(intensity : number, duration : number, easing_style)
	if current_shake ~= nil then
		current_shake:Disconnect()
	end

	local style_function = easing_style or module.easing_styles['linear']
	intensity = intensity or self.intensity
	duration = duration or self.duration

	local start_time = tick()
	local end_time = start_time + duration

	local seed = math.random(1,100000)
	local rng = Random.new(seed)

	current_shake = rs.RenderStepped:Connect(function()
		local current_time = tick()

		if current_time > end_time then
			current_shake:Disconnect()
			return
		end

		local current_cframe = camera.CFrame

		local progress = (current_time - start_time) / duration
		progress = style_function(progress)

		local current_intensity = lerp(intensity, 0, progress)

		local off_x = rng:NextNumber() * current_intensity - current_intensity / 2
		local off_y = rng:NextNumber() * current_intensity - current_intensity / 2
		local off_z = rng:NextNumber() * current_intensity - current_intensity / 2

		local shake_cframe = current_cframe * CFrame.new(off_x, off_y, off_z)
		camera.CFrame = shake_cframe
	end)
end

return module
