function init()
	RegisterTool("rooftopsniper", "Rooftop Sniper", "MOD/vox/launcher.vox")
	SetBool("game.tool.rooftopsniper.enabled", true)

	isToolActive = false
	selectedItem = 1
	
	queue = false
	shotTimer = 0
	time = 0
	randomValue = false

	suppressQueue = {}
	regularQueue = {}

	publicCoord = Vec()

	suppressed = {
		"file0 - sniper snare.ogg",
		"file2 - double sniper snare.ogg",
		"file54 - clean double snare.ogg",
		"file58 - sniper snare.ogg"
	}

	unsuppressed = {
		"file3 - clean double.ogg",
		"file4 - rumbly double.ogg",
		"file5 - rumble double sand.ogg",
		"file9 - rumbly double.ogg"
	}
end

function tick()
	local c = GetCameraTransform()
	local cv = VecAdd(c)
	local fwd = TransformToParentVec(c, Vec(0, 0, -1))
	local hit, dist, normal, shape = QueryRaycast(c.pos, fwd, 100)
	local hitPos = VecAdd(c.pos, VecScale(fwd, dist))
	t = GetPlayerCameraTransform()

	if GetString("game.player.tool") == "rooftopsniper" then
		isToolActive = true

		if InputPressed("R") then
			if selectedItem == 3 then selectedItem = 1 else selectedItem = selectedItem + 1 end
		end

		if InputDown("shift") then
		else
			if InputPressed("usetool") then
				if selectedItem == 1 then
					shotTimer = GetTime()+2
					--table.insert(suppressQueue, VecCopy(hitPos))
				elseif selectedItem == 2 then
					--table.insert(regularQueue, VecCopy(hitPos))
					shotTimer = GetTime()+2
				elseif selectedItem == 3 then
					DebugPrint(dump(GetString(selectedItem)))
				end
			end
		end
	else
		isToolActive = false
	end

	--if InputPressed("return") then
		--shotTimer = GetTime()+2
	--end

	if shotTimer ~= nil and GetTime() >= shotTimer then
		shootTargets()
		shotTimer = nil
	end
	
	if InputPressed("L") then
		DebugPrint("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
	end
end

function update()
	time = time+20

	if time==100 then time=0 end
end

function shootTargets()
	for k, v in pairs(suppressQueue) do
		local random_ind = math.random(4)
		local random_file = suppressed[random_ind]
		snd = LoadSound(random_file)

		PlaySound(snd, VecAdd(t.pos[1],t.pos[2]-1,t.pos[3]), 25)
		
		local coord = Vec(v[1], v[2], v[3])
		publicCoord = VecCopy(coord)
		MakeHole(publicCoord, 0.75,0.65,0.5, true)
	end

	for k, v  in pairs(regularQueue) do
		local coord = Vec(v[1], v[2], v[3])
		local random_ind = math.random(4)
		local random_file = unsuppressed[random_ind]
		snd = LoadSound(random_file)

		PlaySound(snd, VecAdd(t.pos[1],t.pos[2]-1,t.pos[3]), 35)
		MakeHole(coord, 0.75,0.65,0.5, true)
	end

	clearQueue()
end

function clearQueue()
	for k,v in pairs(suppressQueue) do
		suppressQueue[k]=nil
	end
	for k,v in pairs(regularQueue) do
		regularQueue[k]=nil
	end
	
	publicCoord = Vec()
end

--[[
function setSuppressedCoords(value)
	suppressed_vec = value
	return p
end

function setUnsuppressedCoords(value)
	unsuppressed_vec = value
	return p
end
]]

function GetAimPos()
	local ct = GetCameraTransform()
	local forwardPos = TransformToParentPoint(ct, Vec(0, 0, -300))
    local direction = VecSub(forwardPos, ct.pos)
    local distance = VecLength(direction)
	local direction = VecNormalize(direction)
	local hit, hitDistance = QueryRaycast(ct.pos, direction, distance)
	if hit then
		forwardPos = TransformToParentPoint(ct, Vec(0, 0, -hitDistance))
		distance = hitDistance
	end
	return forwardPos, hit, distance
end

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
			end
		return s .. '} '
		else
			return tostring(o)
	end
end

function draw()
	if isToolActive and GetPlayerVehicle() == 0 then
		UiPush()
			UiTranslate(UiCenter()+UiCenter(), UiMiddle())
			UiColor(0.4, 0.4, 0.4)
			UiAlign("right")
			UiFont("regular.ttf", 25)
			UiTextOutline(0,0,0,1,0.2)

			UiPush()
				UiColor(1, 1, 1)
				UiText("R: Scroll")
				UiTranslate(0, 20)
				UiText("Shift: Override mouse hotkeys")
			UiPop()

			UiTranslate(0, 70)
			UiPush()
				if selectedItem == 1 then UiColor(1, 1, 1) end
				UiText("Suppressed support")
			UiPop()

			UiTranslate(0, 30)
			UiPush()
				if selectedItem == 2 then UiColor(1, 1, 1) end
				UiText("Unsuppressed support")
			UiPop()

			UiTranslate(0, 30)
			UiPush()
				if selectedItem == 3 then UiColor(1, 1, 1) end
				UiText("Zoom - 1x")
			UiPop()
		UiPop()
	end
end