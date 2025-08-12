local module = {}

local morse_mapping = {
	["A"] = ".-",
	["B"] = "-...",
	["C"] = "-.-.",
	["D"] = "-..",
	["E"] = ".",
	["F"] = "..-.",
	["G"] = "--.",
	["H"] = "....",
	["I"] = "..",
	["J"] = ".---",
	["K"] = "-.-",
	["L"] = ".-..",
	["M"] = "--",
	["N"] = "-.",
	["O"] = "---",
	["P"] = ".--.",
	["Q"] = "--.-",
	["R"] = ".-.",
	["S"] = "...",
	["T"] = "-",
	["U"] = "..-",
	["V"] = "...-",
	["W"] = ".--",
	["X"] = "-..-",
	["Y"] = "-.--",
	["Z"] = "--..",

	["0"] = "-----",
	["1"] = ".----",
	["2"] = "..---",
	["3"] = "...--",
	["4"] = "....-",
	["5"] = ".....",
	["6"] = "-....",
	["7"] = "--...",
	["8"] = "---..",
	["9"] = "----.",
	[" "] = "/"
}

module.text_to_morse = function(text)
	local result = ""

	for i = 1, #text do
		local char = text:sub(i, i):upper()
		if morse_mapping[char] then
			result = result..morse_mapping[char].." "
		end
	end

	return result
end

--0 = DOT, 1 = LINE

module.text_to_sequence_morse = function(text) -- : {'._..', '.___.'}
	local result = {}
	local current_layer = 1

	for i = 1, #text do
		local char = text:sub(i, i):upper()
		if morse_mapping[char] then
			if char == " " then --if space move to a new table
				current_layer = current_layer + 1
				continue
			end

			if not result[current_layer] then --make sequence table if no exists
				result[current_layer] = {}
			end

			table.insert(result[current_layer], morse_mapping[char])
		end
	end

	return result
end

return module
