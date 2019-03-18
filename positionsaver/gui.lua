windowKey = "F6"

GUIEditor = {
    button = {},
    window = {},
    edit = {},
    checkbox = {},
    label = {}
}


currentCommands = {
	["SaveWarp"] = "sw",
	["LoadWarp"] = "lw",
	["DeleteWarp"] = "dw",
	["ResetWarps"] = "resetWarps",
	["Duration"] = "duration"
}

backupCommands = {
	["SaveWarp"] = "sw",
	["LoadWarp"] = "lw",
	["DeleteWarp"] = "dw",
	["ResetWarps"] = "resetWarps",
	["Duration"] = "duration"
}

isDrawNotes = true
isChatBoxNotes = false


addEventHandler("onClientResourceStart", resourceRoot,
    function()
		local screenW, screenH = guiGetScreenSize()
        GUIEditor.window[1] = guiCreateWindow((screenW - 501) / 2, (screenH - 283) / 2, 501, 283, "Overlord's Position Saver", false)
        guiWindowSetSizable(GUIEditor.window[1], false)

        GUIEditor.label[1] = guiCreateLabel(10, 46, 100, 17, "Commands:", false, GUIEditor.window[1])
        GUIEditor.label[2] = guiCreateLabel(20, 73, 68, 15, "Save Warp:", false, GUIEditor.window[1])
        GUIEditor.label[3] = guiCreateLabel(20, 110, 68, 15, "Load Warp:", false, GUIEditor.window[1])
        GUIEditor.label[4] = guiCreateLabel(20, 152, 72, 15, "Delete Warp:", false, GUIEditor.window[1])
        GUIEditor.label[5] = guiCreateLabel(252, 73, 73, 15, "Reset Warps:", false, GUIEditor.window[1])
        GUIEditor.label[6] = guiCreateLabel(252, 110, 105, 15, "Calculate Duration:", false, GUIEditor.window[1])
        GUIEditor.label[7] = guiCreateLabel(0, 188, 501, 15, "___________________________________________________________________", false, GUIEditor.window[1])
        GUIEditor.label[8] = guiCreateLabel(0, 21, 501, 15, "___________________________________________________________________", false, GUIEditor.window[1])
        GUIEditor.edit[1] = guiCreateEdit(110, 68, 88, 20, "lw", false, GUIEditor.window[1])
        GUIEditor.edit[2] = guiCreateEdit(110, 110, 88, 20, "sw", false, GUIEditor.window[1])
        GUIEditor.edit[3] = guiCreateEdit(110, 152, 88, 20, "dw", false, GUIEditor.window[1])
        GUIEditor.edit[4] = guiCreateEdit(367, 68, 88, 20, "resetWarps", false, GUIEditor.window[1])
        GUIEditor.edit[5] = guiCreateEdit(367, 110, 88, 20, "duration", false, GUIEditor.window[1])
		
        GUIEditor.button[1] = guiCreateButton(169, 223, 154, 31, "Update Settings!", false, GUIEditor.window[1])
		addEventHandler( "onClientGUIClick", GUIEditor.button[1], saveSettings, false)

        GUIEditor.button[2] = guiCreateButton(10, 223, 120, 33, "Get Duration", false, GUIEditor.window[1])
		addEventHandler( "onClientGUIClick", GUIEditor.button[2], function()
			executeCommandHandler(currentCommands["Duration"])
		end, false)
		
        GUIEditor.button[3] = guiCreateButton(357, 223, 120, 30, "Reset Warps", false, GUIEditor.window[1])
		addEventHandler( "onClientGUIClick", GUIEditor.button[3], function()
			executeCommandHandler(currentCommands["ResetWarps"])
		end, false)
		

        GUIEditor.label[9] = guiCreateLabel(252, 148, 128, 17, "Notifications type:", false, GUIEditor.window[1])
        GUIEditor.checkbox[1] = guiCreateCheckBox(370, 152, 117, 13, "Draw", false, false, GUIEditor.window[1])
		addEventHandler("onClientGUIClick", GUIEditor.checkbox[1], function()
			isDrawNotes = guiCheckBoxGetSelected(GUIEditor.checkbox[1])
		end, false)
        GUIEditor.checkbox[2] = guiCreateCheckBox(370, 175, 117, 13, "Chat Box", false, false, GUIEditor.window[1])    
		addEventHandler("onClientGUIClick", GUIEditor.checkbox[2], function()
			isChatBoxNotes = guiCheckBoxGetSelected(GUIEditor.checkbox[2])
		end, false)
		guiSetInputMode("no_binds_when_editing")
		guiSetVisible(GUIEditor.window[1], false)
    end
)

bindKey(windowKey, "up", function()
	
	guiSetVisible(GUIEditor.window[1], not guiGetVisible(GUIEditor.window[1]))
	showCursor(guiGetVisible(GUIEditor.window[1]))
	
end)

function refreshGui()
	guiSetText(GUIEditor.edit[1], currentCommands["SaveWarp"])
	guiSetText(GUIEditor.edit[2], currentCommands["LoadWarp"])
	guiSetText(GUIEditor.edit[3], currentCommands["DeleteWarp"])
	guiSetText(GUIEditor.edit[4], currentCommands["ResetWarps"])
	guiSetText(GUIEditor.edit[5], currentCommands["Duration"])
	guiCheckBoxSetSelected(GUIEditor.checkbox[1], isDrawNotes)
	guiCheckBoxSetSelected(GUIEditor.checkbox[2], isChatBoxNotes)
end


function loadSettings()
	local xmlFile = xmlLoadFile("settings.xml")
	if not xmlFile then 
		xmlFile = xmlCreateFile("settings.xml", "Overlord")
		local xmlChild = xmlCreateChild(xmlFile, "Commands")
		--nodes
		xmlNodeSetAttribute( xmlChild, "SaveWarp", currentCommands["SaveWarp"])
		xmlNodeSetAttribute( xmlChild, "LoadWarp", currentCommands["LoadWarp"])
		xmlNodeSetAttribute( xmlChild, "DeleteWarp", currentCommands["DeleteWarp"])
		xmlNodeSetAttribute( xmlChild, "ResetWarps", currentCommands["ResetWarps"])
		xmlNodeSetAttribute( xmlChild, "Duration", currentCommands["Duration"])
		xmlNodeSetAttribute( xmlChild, "DrawNotes", tostring(isDrawNotes))
		xmlNodeSetAttribute( xmlChild, "ChatBoxNotes", tostring(isChatBoxNotes))
		-------
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
		return loadSettings()
	else
		deleteCommands()
		local xmlChild = xmlFindChild(xmlFile, "Commands", 0)
		
		currentCommands = {
			["SaveWarp"] = xmlNodeGetAttribute(xmlChild, "SaveWarp"),
			["LoadWarp"] = xmlNodeGetAttribute(xmlChild, "LoadWarp"),
			["DeleteWarp"] = xmlNodeGetAttribute(xmlChild, "DeleteWarp"),
			["ResetWarps"] = xmlNodeGetAttribute(xmlChild, "ResetWarps"),
			["Duration"] = xmlNodeGetAttribute(xmlChild, "Duration")
		}
		isDrawNotes = (xmlNodeGetAttribute(xmlChild, "DrawNotes") == "true")
		isChatBoxNotes = (xmlNodeGetAttribute(xmlChild, "ChatBoxNotes") == "true")
		
		refreshGui()
		loadCMDs()
		xmlUnloadFile(xmlFile)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadSettings)

function saveSettings()
	
	local sw = guiGetText(GUIEditor.edit[1])
	local lw = guiGetText(GUIEditor.edit[2])
	local dw = guiGetText(GUIEditor.edit[3])
	local rw = guiGetText(GUIEditor.edit[4])
	local dur = guiGetText(GUIEditor.edit[5])
	--outputChatBox(sw..":"..lw..":"..dw..":"..rw..":"..dur)
	if string.find(sw, " ") ~= nil or string.find(sw, "/") ~= nil then
		outputChatBox("PS ERRPR: Save Warp command has an illegal character")
		return
	elseif string.find(lw, " ") ~= nil or string.find(sw, "/") ~= nil then
		outputChatBox("PS ERRPR: Load Warp command has an illegal character")
		return
	elseif string.find(dw, " ") ~= nil or string.find(sw, "/") ~= nil then
		outputChatBox("PS ERRPR: Delete Warp command has an illegal character")
		return
	elseif string.find(rw, " ") ~= nil or string.find(sw, "/") ~= nil then
		outputChatBox("PS ERRPR: Reset Warps command has an illegal character")
		return
	elseif string.find(dur, " ") ~= nil or string.find(sw, "/") ~= nil then
		outputChatBox("PS ERRPR: Duration command has an illegal character")
		return
	elseif string.lower(lw) == string.lower(sw) 
		or string.lower(dw) == string.lower(lw) 
		or string.lower(rw) == string.lower(dw) 
		or string.lower(dur) == string.lower(rw) then
		outputChatBox("PS ERRPR: You can't duplicate two commands for!")
		return
	end
	
	local xmlFile = xmlLoadFile("settings.xml")
	if xmlFile then
		local xmlChild = xmlFindChild(xmlFile, "Commands", 0)
		if not xmlChild then
			xmlChild = xmlCreateChild(xmlFile, "Commands")
		end

		xmlNodeSetAttribute( xmlChild, "SaveWarp", sw)
		xmlNodeSetAttribute( xmlChild, "LoadWarp", lw)
		xmlNodeSetAttribute( xmlChild, "DeleteWarp", dw)
		xmlNodeSetAttribute( xmlChild, "ResetWarps", rw)
		xmlNodeSetAttribute( xmlChild, "Duration", dur)
		xmlNodeSetAttribute( xmlChild, "DrawNotes", tostring(guiCheckBoxGetSelected(GUIEditor.checkbox[1])))
		xmlNodeSetAttribute( xmlChild, "ChatBoxNotes", tostring(guiCheckBoxGetSelected(GUIEditor.checkbox[2])))
		
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
		loadSettings()
		
		if isDrawNotes then
			addNote("#FFFFFFSettings updated #00FF00successfuly.")
		end
		if isChatBoxNotes then
			outputChatBox("#ff0000[PositionSaver]: #ffffffSettings updated #00FF00successfuly.", _, _, _, true)
		end
		if not isDrawNotes and not isChatBoxNotes then
			outputChatBox("#ff0000[PositionSaver]: #ffffffSettings updated #00FF00successfuly, #FFFFFFBut you didn't choose a notification way.", _, _, _, true)
		end
		
	else
		loadSettings()
	end
end
