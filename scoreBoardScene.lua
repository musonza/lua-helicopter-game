local storyboard = require("storyboard")
local scene = storyboard.newScene()

-- ============================================================================
-- Called when the scene's view does not exist.
-- ============================================================================
function scene:createScene(inEvent)

	-- Create New Game text, center it and attach event handler
	local txtStartGame = display.newText("New Game", 150, 10, native.systemFont, 32);

	txtStartGame:addEventListener("touch",
		function(inEvent)
			storyboard.gotoScene("gameScene", "zoomOutIn", 500);
		end
		);
	    self.view:insert(txtStartGame);

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