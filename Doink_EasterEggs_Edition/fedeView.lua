-----------------------------------------------------------------------------------------
-- fedeView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--> FUNCTIONS
function fede5()
	local background = display.newImageRect( "fede/fede01.png", display.contentWidth, display.contentHeight*119/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	timer.performWithDelay(1500, fede1)
end

function fede4()
	local background = display.newImageRect( "fede/fede02.png", display.contentWidth, display.contentHeight*119/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	timer.performWithDelay(1500, fede5)
end

function fede3()
	local background = display.newImageRect( "fede/fede03.png", display.contentWidth, display.contentHeight*119/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	timer.performWithDelay(1500, fede4)
end

function fede2()
	local background = display.newImageRect( "fede/fede04.png", display.contentWidth, display.contentHeight*119/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	timer.performWithDelay(1500, fede3)
end

function fede1()
	display.remove(playBtn)
	local background = display.newImageRect( "fede/fede05.png", display.contentWidth, display.contentHeight*119/100)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	timer.performWithDelay(1500, fede2)
end

--> SCENE FUNCTIONS
function scene:create( event )
	local sceneGroup = self.view

	fede1()

-- all display objects must be inserted into group
	if(background) then
		sceneGroup:insert(background)
	end
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
	display.remove(background)

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
