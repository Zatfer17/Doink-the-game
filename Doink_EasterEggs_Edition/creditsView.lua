-----------------------------------------------------------------------------------------
-- creditsView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--> FUNCTIONS
local function menuView()
	composer.gotoScene( "menuView", "slideRight", 300 )	-- event listener function
	playSound2()
	return true
end
local function fedeView()
	composer.gotoScene( "fedeView", "fade", 300 )	-- event listener function
	return true
end
local function sababounceView()
	composer.gotoScene( "sababounceView", "fade", 300 )	-- event listener function
	return true
end
--> SCENE FUNCTIONS
function scene:create( event )
	local sceneGroup = self.view

--background
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight*150/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

--text
	local text = display.newText('App a cura di:\nLuca Montenero\nMatteo Ferrini\nAlessandro Chiabrera\nRiccardo Rocco',display.contentCenterX,display.contentCenterY)
	text:setFillColor( 0, 0, 0 )
	text.size = 32

--buttons
	local backBtn = widget.newButton{
		defaultFile= "buttons/back_round.png",
		width = display.contentWidth*20/100, height = display.contentWidth*20/100,
		onRelease = menuView
	}
	backBtn.x = display.contentWidth*13/100
	backBtn.y = display.contentHeight*1/100

	local sabaBtn = widget.newButton{
		defaultFile= "transparent.png",
		width=60, height=30,
		onRelease = sababounceView
	}
	sabaBtn.x = display.contentCenterX*25/100
	sabaBtn.y = display.contentHeight*35/100

	local fedeBtn = widget.newButton{
		defaultFile= "transparent.png",
		width=150, height=30,
		onRelease = fedeView
	}
	fedeBtn.x = display.contentCenterX*56/100
	fedeBtn.y = display.contentHeight*58/100

-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( text)
	sceneGroup:insert( backBtn )
	sceneGroup:insert( sabaBtn )
	sceneGroup:insert( fedeBtn )
end

--[[
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
end
]]

function scene:destroy( event )
	display.remove(text)
	display.remove(backBtn)
	display.remove(background)
	display.remove(sabaBtn)
	display.remove(fedeBtn)

	if backBtn then
		backBtn:removeSelf()	-- widgets must be manually removed
		backBtn = nil
	end

	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
--scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
