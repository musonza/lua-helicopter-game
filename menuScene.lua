gc = require("gameCore");

local storyboard = require("storyboard")
local scene = storyboard.newScene()

-- ============================================================================
-- Called when the scene's view does not exist.
-- ============================================================================
function scene:createScene(inEvent)

	local gameBg = display.newImageRect('gameBg.png', 610, 320)
	 self.view:insert(gameBg);

	-- Create New Game text, center it and attach event handler
	--local txtStartGame = display.newText("Start Game", 150, 80, "Arial", 32);

	--txtStartGame:addEventListener("touch",
		--function(inEvent)
			--storyboard.gotoScene("gameScene", "zoomOutIn", 500);
		--end
		--);
		
	gameBg:addEventListener("touch",
    function(inEvent)
    	storyboard.gotoScene("gameScene", "zoomOutIn", 500);
    end
	);

	print("test")
	local systemFonts = native.getFontNames()

	-- Set the string to query for (part of the font name to locate)
	local searchString = "pt"

	-- Display each font in the Terminal/console
	for i, fontName in ipairs( systemFonts ) do

	    local j, k = string.find( string.lower(fontName), string.lower(searchString) )

	    if ( j ~= nil ) then
	        print( "Font Name = " .. tostring( fontName ) )
	    end
	end

	--self.view:insert(txtStartGame);

	-- Create New Game text, center it and attach event handler
	local txtBestScore = display.newText("Best: " .. tostring(gc.getBestScore()), 150, 150, "Marker Felt", 25);
	self.view:insert(txtBestScore);

	local instructions = display.newText("Tap to go up", 150, 200, "Marker Felt", 15);
	self.view:insert(instructions);

end -- End createScene().

-- Called BEFORE scene has moved on screen.
function scene:willEnterScene(inEvent)
end
-- Called AFTER scene has moved on screen.
function scene:enterScene(inEvent)
end
-- Called BEFORE scene moves off screen.
function scene:exitScene(inEvent)
end
-- Called AFTER scene has moved off screen.
function scene:didExitScene(inEvent)
end
-- Called prior to the removal of scene's "view" (display group).
function scene:destroyScene(inEvent)
end
-- Add scene lifecycle event handlers.
scene:addEventListener("createScene", scene);
scene:addEventListener("willEnterScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);
scene:addEventListener("didExitScene", scene);
scene:addEventListener("destroyScene", scene);
return scene;