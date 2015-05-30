-- ============================================================================
-- Our gameCore object will store our main game code.  We define the fields of
-- the object here but functions get added later (you could add the fields
-- later as well, but organizationally I prefer this form).
-- ============================================================================
local gameCore = {

  -- Our level data.
  --levelData = require("levelData"),

  -- The DisplayGroup for the gameScene.
  gameDG = nil,

  -- The DisplayGroup for the current level.  Anything that should be destroyed
  -- when moving to a new level should go here.
  levelDG = nil,

  -- Reference to the popup seen when the player dies or completes a level.
  popup = nil,

  -- Reference to the score text up top.
  scoreText = nil,

  helicopter = display.newImage('helicopter.png', 23, 52),

  rockets = {},

  yPos = {30, 90, 140, 180, 210, 320}, --Possible positions for the rockets

  speed = 5, --rocket speed
  
  speedTimer, --Increases rockets speed

  impulse = -60,--physics to make the helicopter go up

  up = false, -- is helicopter going up

  top = nil,

  topBar = nil,

  bottom = nil,

  scoreTF = nil,

  scoreBestTF = nil,

  physics = require("physics"),

  filename =  "scorefile.txt",

  savedBestScore = 0,

  playAgain,

  scoreTFBest,

  scoreTFinal,
  
  landscape_group = nil,

  -- Sounds
 
  bgMusic = nil,
  explo = nil
};

-- ============================================================================
-- Initialize the game.  We do one-time setup tasks here.  This is called
-- from createScene() in gameScene.
--
-- @param inDisplayGroup The DisplayGroup for the gameScene.
-- ============================================================================
function make_landscape( image, width, height, time )
  local landscape = display.newImageRect( image, width, height )

--landscape:setReferencePoint( display.TopLeftReferencePoint )
  landscape.anchorX = 0
  landscape.anchorY = 0 
  landscape.x = 0
  landscape.y = 320 - height
  landscape.time = time
  landscape.speed = 4
  
  local function reset_landscape( landscape )
    landscape.x = 0
    transition.to( landscape, {x=0-landscape.width+480, time=landscape.time, onComplete=reset_landscape} )
  end
  
  if(landscape ~= nil) then
    --reset_landscape( landscape )
  end
  
  return landscape
end

function gameCore:init(inDisplayGroup)

  gc.gameBg = display.newImageRect('gameBg.png', 610, 320)
  gc.gameBg.speed = 4

  -- Save reference to the DisplayGroup for gameScene.
  gc.gameDG = inDisplayGroup;

  -- Start physics engine and turn gravity on.
  physics.start(true);

  --gc.helicopter = display.newImage('helicopter.png', 23, 152);

	p_options = 
	{
		-- Required params
		width = 90,
		height = 37,
		numFrames = 2,
		-- content scaling
		sheetContentWidth = 180,
		sheetContentHeight = 37,
	}

	playerSheet = graphics.newImageSheet( "helicopter_sheet.png", p_options )
	gc.helicopter = display.newSprite( playerSheet, { name="player", start=1, count=2, time=500 } )
	gc.helicopter.x = 23
	gc.helicopter.y = 152
	gc.helicopter:play()



  gc.top = display.newRect(0, 0, 610, 1) -- 60
  gc.top:setFillColor(34, 34, 34)

  gc.bottom = display.newRect(0, 320, 610, 1) --260
  gc.bottom:setFillColor(34, 34, 34)

  gc.scoreTF = display.newText('0', 440, 5, 'Helvetica', 14)
  --gc.scoreTF:setTextColor(255, 255, 255)
  gc.scoreTF:setTextColor(0)

  gc.scoreBestTF = display.newText('Best: ' .. gameCore:getBestScore(), 10, 5, 'Helvetica', 14)
  --gc.scoreBestTF:setTextColor(255, 255, 255)
  gc.scoreBestTF:setTextColor(0)

  gc.rockets = display.newGroup()

  gc.filename =  "scorefile.txt"

  -- Now reset level state so we're good to go.
  --gc.resetLevel();

end -- End init().

-- ============================================================================
-- Starts the game running.  This is called from enterScene() in gameScene.
-- ============================================================================
function gameCore:start()

  print(gc.helicopter)
  if(gc.helicopter ~= nil) then
	   physics.addBody(gc.helicopter)
	   physics.addBody(gc.top, 'static')
	   physics.addBody(gc.bottom, 'static')
  end
	gc.savedBestScore = gameCore:getBestScore()
end -- End start().

function gameCore:getBestScore()
	local path = system.pathForFile(gc.filename, system.DocumentsDirectory)
	local contents = ""
	local file = io.open( path, "r")

	if(file) then
		-- read all contents of file into a string
		local contents = file:read( "*a")
		local bestScore = tonumber(contents)
		io.close( file )
		return bestScore
	else
		return 0
	end
end


function gameCore:saveBestScore(bestScore)
	local path = system.pathForFile( gc.fileame, system.DocumentsDirectory )
	local file = io.open(path, "w")

 	if ( file ) then
		local contents = tostring(bestScore)
		file:write( contents )
		io.close( file )
	else
		print( "Error: could not read ", gc.filename, "." )
	end
end

function createRocket()
	local r
	local rnd = math.floor(math.random() * 4) + 1
	r = display.newImage('missile.png', display.contentWidth, gc.yPos[math.floor(math.random() * 3)+1])
	r.name = 'missile'
	-- Block physics
	physics.addBody(r, 'kinematic')
	r.isSensor = true
	gc.rockets:insert(r)
end

function gameCore:resetLevel( )
	display.remove(gc.helicopter)
	display.remove(gc.gameBg)
	display.remove(gc.gameBg1)
	display.remove(gc.rockets)
	display.remove(gc.playAgain)
	display.remove(gc.menuButton)
	display.remove(gc.scoreTFBest)
	display.remove(gc.scoreTFinal)
	display.remove(gc.top)
	display.remove(gc.topBar)
	display.remove(gc.bottom)
	display.remove(gc.scoreTF)
	display.remove(gc.scoreBestTF)
	--display.remove(gc.landscape_group)
	physics.stop()
	gc.speed = 5 --rocket speed
	gc.impulse = -60
	gc.up = false
end
-- ****************************************************************************
-- All done defining gameCore, return it.
-- ****************************************************************************
return gameCore;