gc = require("gameCore");

local storyboard = require("storyboard")
local scene = storyboard.newScene()

-- ============================================================================
-- Called when the scene's view does not exist.
-- ============================================================================
function scene:createScene(inEvent)

	 gameBg = display.newImage('gameBg.png')
	 self.view:insert(gameBg);

	 -- Create New Game text, center it and attach event handler
	local msg = display.newText("To: Malcom and Alaya", 150, 40, "Marker Felt", 15);
	msg:setFillColor(0)
	local msg1 = display.newText("From: Bamudiki Tinashe", 150,60, "Marker Felt", 15);
	msg1:setFillColor(0)

	self.view:insert(msg);
	self.view:insert(msg1);

	-- Create New Game text, center it and attach event handler
	local txtStartGame = display.newText("Start Game", 150, 80, "Marker Felt", 32);

	txtStartGame:addEventListener("touch",
		function(inEvent)
			storyboard.gotoScene("gameScene", "zoomOutIn", 500);
		end
		);
	    self.view:insert(txtStartGame);

	-- Create New Game text, center it and attach event handler
	local txtBestScore = display.newText("Best: " .. tostring(gc.getBestScore()), 150, 150, "Marker Felt", 25);
	self.view:insert(txtBestScore);

	--local instructions = display.newText("Tap to go up", 150, 200, "Marker Felt", 15);
	--self.view:insert(instructions);

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