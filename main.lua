function init()
	RegisterTool("rooftopsniper", "Rooftop Sniper", "MOD/vox/launcher.vox")
	SetBool("game.tool.rooftopsniper.enabled", true)
	
	cooldown = 60
	queue = false
	
	snd = LoadSound("snd0.ogg")
end

function tick()

		local c = GetCameraTransform()
		local cv = VecAdd(c)
		local fwd = TransformToParentVec(c, Vec(0, 0, -1))
		local hit, dist, normal, shape = QueryRaycast(c.pos, fwd, 100)
		local hitPos = VecAdd(c.pos, VecScale(fwd, dist))

		-- DebugWatch("Cooldown is " ..cooldown .." gameticks.")

		t = GetPlayerCameraTransform()

		if InputDown("e") and InputPressed("usetool") or InputDown("e") and InputPressed("grab") then
			queue = true
		end
	
		if queue == true then cooldown = cooldown-1 end

		while cooldown < 0 do
			PlaySound(snd, VecAdd(t.pos[1],t.pos[2]-1,t.pos[3]), 8)
			MakeHole(hitPos, 0.75,0.65,0.5, true)
			cooldown = 60
			queue = false
		end	
	
		if cooldown < 0 then cooldown = 60 end
	
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
		
		if InputPressed("x") then
			local hit, dist, normal, shape = QueryRaycast(pos, dir, 10)
			if hit then
				local hitPoint = VecAdd(pos, VecScale(dir, dist))
				local mat = GetShapeMaterialAtPosition(shape, hitPoint)
				DebugPrint("Raycast hit voxel made out of " .. mat)
			end
		end
end
