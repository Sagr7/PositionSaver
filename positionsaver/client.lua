----------------------------------------------------------
--Save and Load positions for race gamemode, by Overlord
--Also it measures the map's length by calculating time
	--between each warp from the time it was loaded.
--Feel free to edit the code, just include some rights :)
----------------------------------------------------------
--Commands:
	-- /sw				For save warp
	-- /lw				For load warp
	-- /dw				For delete warp
	-- /resetWarps		For delete all warps
	-- /duration		duration between the first and the last warp
	
addEventHandler("onClientResourceStart", resourceRoot, function()
	outputChatBox("-----------------------------------------------")
	outputChatBox("---------#ff0000Overlord's #ffffffposition saver", _, _, _, true)
	outputChatBox("------------#ff0000/sw #ffffff(Save Warp)", _, _, _, true)
	outputChatBox("------------#ff0000/lw #ffffff(Load Warp)", _, _, _, true)
	outputChatBox("------------#ff0000/dw #ffffff(Delete Warp)", _, _, _, true)
	outputChatBox("------------#ff0000/resetWarps#ffffff", _, _, _, true)
	outputChatBox("------------#ff0000/duration#ffffff", _, _, _, true)
	outputChatBox("-----------------------------------------------")
end)
	
local waitTime = 2000	--Freezing duration on load warp (ms)
-------------------------------------------------------------

local warps = {}

local eTimer = 0
local loadTick = 0

local allowedToAction = true

function getDuration()
	if #warps < 1 then 
		return 0
	else 
		return getTickCount() - loadTick 
	end
end

addCommandHandler("sw", function()
	if not allowedToAction then
		outputChatBox("#ff0000Overlord: #ffffffCannot save while loading..", _, _, _, true)
		return false
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not isPedInVehicle(localPlayer) or not vehicle then
		outputChatBox("Error: you are not in a vehicle!")	
	else
		--local warpToAdd = {}
		local vModel = getElementModel(vehicle)
		if not tonumber(vModel) then 
			return outputChatBox("Unknowen Error(vModel)") 
		end
			
		local px, py, pz = getElementPosition(vehicle)
		local rx, ry, rz = getElementRotation(vehicle)
		local vx, vy, vz = getElementVelocity(vehicle)
		local tvx, tvy, tvz = getVehicleTurnVelocity(vehicle)
		
		local vHealth = getElementHealth(vehicle)
		local nitroCount = getVehicleNitroCount(vehicle)
		
		local nitroLevel = nitroCount and getVehicleNitroLevel(vehicle) or 0
		local nitroActive = nitroCount and isVehicleNitroActivated(vehicle) or false
		local nitroRecharging = nitroCount and isVehicleNitroRecharging(vehicle) or false
		
		local warpToSave = {
			["vModel"] = vModel,
			
			["px"] = px,
			["py"] = py,
			["pz"] = pz,
			
			["rx"] = rx,
			["ry"] = ry,
			["rz"] = rz,
			
			["vx"] = vx,
			["vy"] = vy,
			["vz"] = vz,
					
			["tvx"] = tvx,
			["tvy"] = tvy,
			["tvz"] = tvz,
								
			["vHealth"] = vHealth,
			["nitroCount"] = nitroCount,
			["nitroLevel"] = nitroLevel,
			
			["nitroActive"] = nitroActive,
			["nitroRecharging"] = nitroRecharging,
				
			["time"] = getTickCount(),
			["timeBetween"] = getDuration() 
		}
		
		table.insert(warps, warpToSave)
		loadTick = getTickCount()
		outputChatBox("#ff0000Overlord: #ffffffSaved postition [#00ff00#"..#warps.."#ffffff].", _, _, _, true)
		--outputChatBox(tostring(nitroLevel.."  ..  "..tostring(nitroActive).."  ..  "..tostring(nitroRecharging)))
		
	end
end)

addCommandHandler("lw", function(cmd, id)
	if not allowedToAction then
		outputChatBox("#ff0000Overlord: #ffffffThe previous loading hasn't done yet..", _, _, _, true)
		return false
	end
	
	if not type(warps) == "table" or #warps < 1 then
		warps = {}
		return outputChatBox("#ff0000Overlord: #ff006dYou don't have any warps yet, use [#ffffff/sw#ff006d].", _, _, _, true)
	end
	
	
	if not id or not tonumber(id) then
		id = #warps
	end
	id = tonumber(id)
	
	if id > #warps then
		return outputChatBox("#ff0000Overlord: #ff006dInvalid warp [#ffffffMax: "..#warps.."#ff006d].", _, _, _, true)
	elseif id < 1 then
		return outputChatBox("#ff0000Overlord: #ff006dInvalid warp[#ffffffMust be higher than 0#ff006d].", _, _, _, true)
	end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not isPedInVehicle(localPlayer) or not vehicle then
		outputChatBox("Error: you are not in a vehicle!", 255, 0, 0)	
	else
		allowedToAction = false
		outputChatBox("#ff0000Overlord: #ffffffLoading warp [#0000ff#"..id.."#ffffff].", _, _, _, true)
		
		--setElementHealth(vehicle, 1000)
		if warps[id]["vHealth"] < 251 then
			setElementHealth(vehicle, 1000)
		else
			setElementHealth(vehicle, warps[id]["vHealth"])
		end
		removeVehicleUpgrade(vehicle, 1010)
		
		setElementModel(vehicle, warps[id]["vModel"])
		
		setElementPosition(vehicle, warps[id]["px"], warps[id]["py"], warps[id]["pz"])
		setElementRotation(vehicle, warps[id]["rx"], warps[id]["ry"], warps[id]["rz"])
		
		setElementFrozen(vehicle, true)
		
		setTimer(function()
			setElementFrozen(vehicle, false)
			
			setElementHealth(vehicle, warps[id]["vHealth"])
			setElementVelocity(vehicle, warps[id]["vx"], warps[id]["vy"], warps[id]["vz"])
			setVehicleTurnVelocity(vehicle, warps[id]["tvx"], warps[id]["tvy"], warps[id]["tvz"])
			if warps[id]["nitroCount"] then
				addVehicleUpgrade(vehicle, 1010)
				setVehicleNitroCount(vehicle, warps[id]["nitroCount"])
				setVehicleNitroLevel(vehicle, warps[id]["nitroLevel"])
				setVehicleNitroActivated(vehicle, warps[id]["nitroActive"])
			end
			loadTick = getTickCount()
			allowedToAction = true
		end, waitTime, 1)
	end
end)

addCommandHandler("dw", function(cmd, id)
	if not id or not tonumber(id) then
		id = #warps
	end
	id = tonumber(id)

	if id > #warps then
		return outputChatBox("#ff0000Overlord: #ff006dInvalid warp [#ffffffMax: "..#warps.."#ff006d].", _, _, _, true)
	elseif id < 1 then
		return outputChatBox("#ff0000Overlord: #ff006dInvalid warp[#ffffffMust be higher than 0#ff006d].", _, _, _, true)
	end
	
	table.remove(warps, id)
	outputChatBox("#ff0000Overlord: #ffffffWarp [#ff0000#"..id.."#ffffff] Succesfuly #ff0000Deleted. #ffffff(/resetWarps to delete all)", _, _, _, true)

end)

addCommandHandler("resetWarps", function()
	if #warps >= 1 then
		for i = 1, #warps do
			table.remove(warps, i)
		end
	end
	warps = {}
	outputChatBox("#ff0000Overlord: #ffffffAll of your warps has been succesfuly #ff0000Deleted.", _, _, _, true)
end)

addCommandHandler("duration", function()
	if #warps <= 1 then
		outputChatBox("TIMER ERROR: NO ENOUGH WARPS", 255, 0, 0)
		outputChatBox("Notice that this function measures the time between the first and last warp.", 255, 255, 255)
		return
	end
	local length = 0
	for i, v in ipairs(warps) do
		length = length + v["timeBetween"]
	end
	outputChatBox(timeFormate(length))
end)

function timeFormate(ms)
	ms = tonumber(ms) or 0
	
	if ms <= 0 then
		return "00:00:000"
	else
		local minutes = string.format("%02.f", math.floor((ms/1000)/60))
		local seconds = string.format("%02.f", math.floor((ms/1000) - minutes*60))
		local milsecs = string.format("%03.f", math.floor((ms/10) - seconds*100 ))
		
		return minutes..":"..seconds..":"..milsecs
	end

end

--Have fun!
