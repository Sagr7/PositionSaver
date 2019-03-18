
local notesDuration = 2000
local screenX, screenY = guiGetScreenSize()

local someTimer = nil
local someText = ""

function addNote(text)
	
	if isEventHandlerAdded("onClientRender", root, drawNotes) then
		removeEventHandler("onClientRender", root, drawNotes)
		someText = ""
		if isTimer(someTimer) then
			killTimer(someTimer)
		end
	end
	
	someText = text
	addEventHandler("onClientRender", root, drawNotes)
	
	someTimer = setTimer(function()
		if isEventHandlerAdded("onClientRender", root, drawNotes) then
			removeEventHandler("onClientRender", root, drawNotes)
			someText = ""
		end
	end, notesDuration, 1)

end

function drawNotes()
	if someText and tostring(someText) and string.len(someText) > 3 then
		dxDrawRectangle(40, (screenY/2) - 100, dxGetTextWidth(someText, 0.8, "bankgothic", true) + 15, 25, tocolor(0,0,0, 220))
		dxDrawText(someText, 50, (screenY/2) - 100, _, _, _, 0.8, "bankgothic", _, _, _, _, _,true)
	end
	
end



function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
        	         return true
        	    end
	       end
	  end
     end
     return false
end
