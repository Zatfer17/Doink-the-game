-----------------------------------------------------------------------------------------
-- sababounceView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )

-- include Corona's "widget" library
local widget = require "widget"

--> FUNCTIONS
local function menuView()
	composer.gotoScene( "menuView", "fade", 300 )	-- event listener function
	playSound2()
	return true
end

--> SCENE FUNCTIONS
function scene:create( event )
	local sceneGroup = self.view

--background
	local background = display.newImageRect( "sababounce/sababounce.jpg", display.contentWidth, display.contentHeight*150/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

  local platform = display.newImageRect( "sababounce/platform.png", 400, 200 )
  platform.x = display.contentCenterX
  platform.y = display.contentHeight*5/6

  local saba1 = display.newImageRect( "sababounce/saba2.png", 112, 112 )
  saba1.x = display.contentCenterX
  saba1.y = display.contentHeight/3

  local saba2 = display.newImageRect( "sababounce/saba1.png", 112, 112 )
  saba2.x = saba1.x+saba1.x/2
  saba2.y = display.contentHeight/3

  local saba3 = display.newImageRect( "sababounce/saba1.png", 112, 112 )
  saba3.x = saba1.x-saba1.x/2
  saba3.y = display.contentHeight/3

  physics.start()
  physics.addBody( platform,  "static" )

physics.addBody( saba2, "dynamic", { radius=0, bounce=0 } )
physics.addBody( saba1, "dynamic", { radius=0, bounce=0 } )
physics.addBody( saba3, "dynamic", { radius=0, bounce=0 } )


local function sabamove1()
saba1:applyLinearImpulse( 0, -15, saba1.x, saba1.y )
end

local function sabamove2()
saba2:applyLinearImpulse( 0, -15, saba2.x, saba2.y )
end

local function sabamove3()
saba3:applyLinearImpulse( 0, -15, saba3.x, saba3.y )
end


saba1:addEventListener( "tap", sabamove1 )
saba2:addEventListener( "tap", sabamove2 )
saba3:addEventListener( "tap", sabamove3 )

--buttons
	local backBtn = widget.newButton{
		defaultFile= "buttons/back_round.png",
		width = display.contentWidth*20/100, height = display.contentWidth*20/100,
		onRelease = menuView
	}
	backBtn.x = display.contentWidth*13/100
	backBtn.y = display.contentHeight*1/100

-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( backBtn )
  sceneGroup:insert( saba1 )
  sceneGroup:insert( saba2 )
  sceneGroup:insert( saba3 )
  sceneGroup:insert( platform )
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
	display.remove(backBtn)
	display.remove(background)
  display.remove(saba)
  display.remove(saba2)
  display.remove(saba3)
  display.remove(platform)

  physics.stop()

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
