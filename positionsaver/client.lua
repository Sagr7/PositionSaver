----------------------------------------------------------
--Save and Load positions for race gamemode, by Overlord
--Also it measures the map's length by calculating time
	--between each warp from the time it was loaded.
--Feel free to edit the code, just include some rights :)

--Made some changes you're proud of? make sure to throw it here!
--Github page: https://github.com/Sagr7/PositionSaver
----------------------------------------------------------
--Commands:
	-- /sw				Save Warp
	-- /lw				Load Warp
	-- /dw				Delete Warp
	-- /resetWarps		Delete all warps
	-- /duration		Duration between the first and the last warp
	
addEventHandler("onClientResourceStart", resourceRoot, function()
	outputChatBox("-----------------------------------------------")
	outputChatBox("---------#ff0000Overlord's #ffffffposition Saver", _, _, _, true)
	outputChatBox("---------#FFFFFFPress #FF0000"..windowKey.." #FFFFFFto open the menu", _, _, _, true)
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

function loadCMDs()
	addCommandHandler(currentCommands["SaveWarp"], function()
		if not allowedToAction then
			outputChatBox("#ff0000[PositionSaver]: #ffffffCannot save while loading..", _, _, _, true)
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
			if isDrawNotes then
				addNote("#ffffffSaved postition [#00ff00#"..#warps.."#ffffff].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ffffffSaved postition [#00ff00#"..#warps.."#ffffff].", _, _, _, true)
			end
			--outputChatBox(tostring(nitroLevel.."  ..  "..tostring(nitroActive).."  ..  "..tostring(nitroRecharging)))
			
		end
	end, false)

	addCommandHandler(currentCommands["LoadWarp"], function(cmd, id)
		if not allowedToAction then
			if isDrawNotes then
				addNote("#ff0000The previous loading hasn't done yet..")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ffffffThe previous loading hasn't done yet..", _, _, _, true)
			end
			return false
		end
		
		if not type(warps) == "table" or #warps < 1 then
			warps = {}
			if isDrawNotes then
				addNote("#ff006dYou don't have any warps yet, use [#ffffff/sw#ff006d].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ff006dYou don't have any warps yet, use [#ffffff/sw#ff006d].", _, _, _, true)
			end
			return
		end
		
		
		if not id or not tonumber(id) then
			id = #warps
		end
		id = tonumber(id)
		
		if id > #warps then
			if isDrawNotes then
				addNote("#ff006dInvalid warp [#ffffffMax: "..#warps.."#ff006d].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ff006dInvalid warp [#ffffffMax: "..#warps.."#ff006d].", _, _, _, true)
			end
			return
		elseif id < 1 then
			if isDrawNotes then
				addNote("#ff006dInvalid warp[#ffffffMust be higher than 0#ff006d].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ff006dInvalid warp[#ffffffMust be higher than 0#ff006d].", _, _, _, true)
			end
			return
		end
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if not isPedInVehicle(localPlayer) or not vehicle then
			outputChatBox("Error: you are not in a vehicle!", 255, 0, 0)	
		else
			allowedToAction = false
			if isDrawNotes then
				addNote("#ffffffLoading warp [#0000ff#"..id.."#ffffff].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ffffffLoading warp [#0000ff#"..id.."#ffffff].", _, _, _, true)
			end
			
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
	end, false)

	addCommandHandler(currentCommands["DeleteWarp"], function(cmd, id)
		if not allowedToAction then
			if isDrawNotes then
				addNote("#ffffffThe previous loading hasn't done yet..")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ffffffThe previous loading hasn't done yet..", _, _, _, true)
			end
			return false
		end
		
		if not id or not tonumber(id) then
			id = #warps
		end
		id = tonumber(id)

		if not type(warps) == "table" or #warps < 1 then
			warps = {}
			if isDrawNotes then
				addNote("#ff006dYou don't have any warps yet, use [#ffffff/sw#ff006d].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ff006dYou don't have any warps yet, use [#ffffff/sw#ff006d].", _, _, _, true)
			end
			return
		end
		
		if id > #warps then
			if isDrawNotes then
				addNote("#ff006dInvalid warp [#ffffffMax: "..#warps.."#ff006d].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ff006dInvalid warp [#ffffffMax: "..#warps.."#ff006d].", _, _, _, true)
			end
			return
		elseif id < 1 then
			if isDrawNotes then
				addNote("#ff006dInvalid warp [#ffffffMust be higher than 0#ff006d].")
			end
			if isChatBoxNotes then
				outputChatBox("#ff0000[PositionSaver]: #ff006dInvalid warp [#ffffffMust be higher than 0#ff006d].", _, _, _, true)
			end
			return
		end
		
		table.remove(warps, id)
		if isDrawNotes then
			addNote("#ffffffWarp [#ff0000#"..id.."#ffffff] Succesfuly #ff0000Deleted.".. ((#warps%5 == 0) and " #ffffff(/resetWarps to delete all)" or ""))
		end
		if isChatBoxNotes then
			outputChatBox("#ff0000[PositionSaver]: #ffffffWarp [#ff0000#"..id.."#ffffff] Succesfuly #ff0000Deleted.".. ((#warps%5 == 0) and " #ffffff(/resetWarps to delete all)" or ""), _, _, _, true)
		end

	end, false)

	addCommandHandler(currentCommands["ResetWarps"], function()
		if #warps >= 1 then
			for i = 1, #warps do
				table.remove(warps, i)
			end
		end
		warps = {}
		if isDrawNotes then
			addNote("#ffffffAll of your warps has been succesfuly #ff0000Deleted.")
		end
		if isChatBoxNotes then
			outputChatBox("#ff0000[PositionSaver]: #ffffffAll of your warps has been succesfuly #ff0000Deleted.", _, _, _, true)
		end
	end, false)

	addCommandHandler(currentCommands["Duration"], function()
		if #warps <= 1 then
			outputChatBox("TIMER ERROR: NO ENOUGH WARPS", 255, 0, 0)
			outputChatBox("Notice that this function measures the time between the first and last warp.", 255, 255, 255)
			return
		end
		local length = 0
		for i, v in ipairs(warps) do
			length = length + v["timeBetween"]
		end
		outputChatBox("#ff0000[PositionSaver]: #ffffffCurrent time between #1 and #"..#warps.." warps: "..timeFormate(length), 255, 255, 255, true)
	end, false)
end


function timeFormate(ms)
	ms = tonumber(ms) or 0
	
	if ms <= 0 then
		return "00:00:000"
	else
		local minutes = string.format("%02.f", math.floor((ms/1000)/60))
		local seconds = string.format("%02.f", math.floor((ms/1000) - minutes*60))
		local milsecs = string.format("%02.f", math.floor((ms/10) - (seconds*100 + minutes*60)))
		
		return minutes..":"..seconds..":"..milsecs
	end

end

function deleteCommands()
	for i, v in ipairs(getCommandHandlers(getThisResource())) do
		removeCommandHandler(v)
	end
end
--Have fun!
