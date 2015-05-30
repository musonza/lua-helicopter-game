----
----
gc = require("gameCore");
local ui = require("ui")

local storyboard = require("storyboard")
-- Create a scene object to tie functions to.
local scene = storyboard.newScene();

local finalScore = 0

local filename = "scorefile.txt"


-- Bring in the physics engine.
physics = require("physics");


-- ============================================================================
-- Called when the scene's view does not exist.
-- ============================================================================
function scene:createScene(inEvent)
	gc.init()
end -- End createScene().


-- ============================================================================
-- Called BEFORE scene has moved on screen.
-- ============================================================================
function scene:willEnterScene(inEvent)


end -- End willEnterScene().

-- ============================================================================
-- Called AFTER scene has moved on screen.
-- ============================================================================
function scene:enterScene(inEvent)
	gc.start();
	local gameon = true

	function gameListeners(action)
		if(action == 'add') then
			gc.gameBg:addEventListener('touch', movePlayer)
			Runtime:addEventListener('enterFrame', update)
			timerSrc = timer.performWithDelay(1300, createRocket, 0)
			gc.speedTimer = timer.performWithDelay(5000, increaseSpeed, 5)
			gc.helicopter:addEventListener('collision', onCollision)
		else
			gc.gameBg:removeEventListener('touch', movePlayer)
			Runtime:removeEventListener('enterFrame', update)
			timer.cancel(timerSrc)
			timerSrc = nil
			timer.cancel(gc.speedTimer)
			speedTimer = nil
			gc.helicopter:removeEventListener('collision', onCollision)
		end
	end -- End gameListeners().

	function movePlayer(e)
		physics.addBody(gc.helicopter)
		if(e.phase == 'began') then
			gc.up = true
		end
		if(e.phase == 'ended') then
			gc.up = false
			gc.impulse = -60
		end
	end -- End movePlayer().

	function increaseSpeed()
	gc.speed = gc.speed + 2
	--speed = speed;
	-- Icon
	local icon = display.newImage('speed.png', 204, 124)
	transition.from(icon, {time = 200, alpha = 0.1, onComplete = function() timer.performWithDelay(500, function() transition.to(icon, {time = 200, alpha = 0.1, onComplete = function() display.remove(icon) icon = nil end}) end) end})
	end

	function update(e)
		if(gc.up) then
			gc.impulse = gc.impulse - 3
			gc.helicopter:setLinearVelocity(0, gc.impulse)
		end

		-- Move Rockets
		if(gc.rockets ~= nil)then
			for i = 1, gc.rockets.numChildren do
				gc.rockets[i].x = gc.rockets[i].x - gc.speed
			end
		end

		-- Score
		gc.scoreTF.text = tostring(tonumber(gc.scoreTF.text) + 1)
		finalScore = tonumber(gc.scoreTF.text)

		--- change best score if exceeded
		if(gc.savedBestScore < finalScore) then
			gc.scoreBestTF.text = 'Best Score: ' .. tostring(finalScore)
		end

	end -- End update().

	function addBestScore(bestScore)
		local path = system.pathForFile( filename, system.DocumentsDirectory )
		local file = io.open(path, "w")

	 	if ( file ) then
			local contents = tostring(bestScore)
			file:write( contents )
			io.close( file )
		else
			print( "Error: could not read ", filename, "." )
		end
	end

	function onCollision(e)
		audio.play(gc.explo)
		display.remove(gc.helicopter)

		if(gc.savedBestScore < finalScore) then
			addBestScore(finalScore)-- save Best score
		end
		gameon = false
		alert()
	end

	function alert()
		-- Wait 100 ms to stop physics
		gameListeners('rmv')
		gc.up = false
		timer.performWithDelay(1000, function() physics.stop() end, 1)

		-- play again
		gc.playAgain = display.newText('0', 200, 100, 'Marker Felt', 25)
		gc.playAgain:setTextColor(255, 235, 255)
		gc.playAgain.text = "Main Menu"

		-- display score now
		gc.scoreTFinal = display.newText('0', 200, 150, 'Marker Felt', 25)
		gc.scoreTFinal:setTextColor(255, 255, 255)
		gc.scoreTFinal.text = "Score: " .. tostring(finalScore)

		-- display best score now
		gc.scoreTFBest = display.newText('0', 200, 200, 'Marker Felt', 25)
		gc.scoreTFBest:setTextColor(255, 255, 255)
		gc.scoreTFBest.text = "Best: " .. tostring(gc.getBestScore())

		gc.playAgain:addEventListener("touch",
		function(inEvent)
			storyboard.gotoScene("menuScene", "zoomOutIn", 500);
		end
		);
	end

	if(gameon == true) then
		gameListeners('add')
	else 
		gameListeners('rmv')
	end
end -- End enterScene().


-- ============================================================================
-- Called BEFORE scene moves off screen.
-- ============================================================================
function scene:exitScene(inEvent)


end -- End exitScene().


-- ============================================================================
-- Called AFTER scene has moved off screen.
-- ============================================================================
function scene:didExitScene(inEvent)


end -- End didExitScene().


-- ============================================================================
-- Called prior to the removal of scene's "view" (display group).
-- ============================================================================
function scene:destroyScene(inEvent)
	gc.resetLevel()
end -- End destroyScene().


-- ****************************************************************************
-- ****************************************************************************
-- **********                 EXECUTION BEGINS HERE.                 **********
-- ****************************************************************************
-- ****************************************************************************

-- Add scene lifecycle event handlers.
scene:addEventListener("createScene", scene);
scene:addEventListener("willEnterScene", scene);
scene:addEventListener("enterScene", scene);
scene:addEventListener("exitScene", scene);
scene:addEventListener("didExitScene", scene);
scene:addEventListener("destroyScene", scene);

return scene;





