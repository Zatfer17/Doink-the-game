-----------------------------------------------------------------------------------------
-- menuView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
-- include global variables custom lua
	local global = require( "variables" )

-----------------------------------------------------------------------------------------

--> FUNCTIONS
local function creditsView()
	composer.gotoScene( "creditsView", "fade", 300 )	-- event listener function
	return true
end
local function gameView()
	global.gameMode = 1
	composer.gotoScene( "gameView", "fade", 300 )
	return true
end
local function trainingView()
	global.gameMode = 2
	composer.gotoScene( "gameView", "fade", 300)
	return true
end

-----------------------------------------------------------------------------------------

--> SCENE FUNCTIONS
function scene:create( event )
	local sceneGroup = self.view

--background
	local background = display.newImageRect( "backgroundMenuNuovo.jpg", 320, 569 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

--play button (avvia il game)
	local playBtn = widget.newButton{
		defaultFile="buttons/transparent.png",
		width= display.contentWidth*32/100,
		height= display.contentHeight*12/100,
		onRelease = gameView
	}
	playBtn.x = display.contentWidth*33/100
	playBtn.y = display.contentHeight*46.5/100

	--training button
	--[[local trnBtn = widget.newButton{
		defaultFile="buttons/transparent.png",
		width= display.contentWidth*48/100,
		height= display.contentHeight*10/100,
		onRelease = trainingView
	}
	trnBtn.x = display.contentWidth*67/100
	trnBtn.y = display.contentHeight*76/100]]

--credits button
	local crdBtn = widget.newButton{
		defaultFile="buttons/transparent.png",
		width= display.contentWidth*48/100,
		height= display.contentHeight*10/100,
		onRelease = creditsView
	}
	crdBtn.x = display.contentWidth*24.5/100
	crdBtn.y = display.contentHeight*95.5/100--display.contentHeight*102/100

-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( crdBtn )
	--sceneGroup:insert ( trnBtn )
end

-----------------------------------------------------------------------------------------

function scene:destroy( event )
	local sceneGroup = self.view
	playBtn:removeSelf()	-- widgets must be manually removed
	playBtn = nil
	crdBtn:removeSelf()
	crdBtn = nil
	--trnBtn:removeSelf()
	--trnBtn = nil
end

-----------------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
