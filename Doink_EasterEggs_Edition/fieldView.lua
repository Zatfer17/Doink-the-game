-----------------------------------------------------------------------------------------
-- fieldView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
-- include global variables custom lua
local global = require( "variables" )

--> FUNCTIONS
local function menuView()
	global.fieldType = 0
	composer.gotoScene( "menuView", "slideLeft", 300 )	-- event listener function
	playSound2()
  return true
end
local function menuView1()
  global.fieldType = 1
	composer.gotoScene( "menuView", "slideLeft", 300 )	-- event listener function
	playSound2()
  return true
end
local function menuView2()
  global.fieldType = 2
	composer.gotoScene( "menuView", "slideLeft", 300 )	-- event listener function
	playSound2()
  return true
end
local function menuView3()
  global.fieldType = 3
	composer.gotoScene( "menuView", "slideLeft", 300 )	-- event listener function
	playSound2()
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
  local text = display.newText('Pick your field',display.contentCenterX,display.contentCenterY)
	text:setFillColor( 0, 0, 0 )
  text.size = 32
	text.x = display.contentWidth*55/100
  text.y = display.contentHeight*1/100

  local field0 = widget.newButton{
  	defaultFile= "fields/field0.png",
  	width = display.contentWidth*40/100, height = display.contentWidth*71/100,
  	onRelease = menuView
  }
  field0.x = display.contentWidth*25/100
  field0.y = display.contentHeight*32/100

  local field1 = widget.newButton{
  	defaultFile= "fields/field1v.png",
  	width = display.contentWidth*40/100, height = display.contentWidth*71/100,
  	onRelease = menuView1
  }
  field1.x = display.contentWidth*75/100
  field1.y = display.contentHeight*32/100

  local field2 = widget.newButton{
  	defaultFile= "fields/field2v.png",
  	width = display.contentWidth*40/100, height = display.contentWidth*71/100,
  	onRelease = menuView2
  }
  field2.x = display.contentWidth*25/100
  field2.y = display.contentHeight*82/100

  local field3 = widget.newButton{
  	defaultFile= "fields/field3.png",
  	width = display.contentWidth*40/100, height = display.contentWidth*71/100,
    onRelease = menuView3
  }
  field3.x = display.contentWidth*75/100
  field3.y = display.contentHeight*82/100

  --back button
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
	sceneGroup:insert( text )
	sceneGroup:insert( field0 )
	sceneGroup:insert( field1 )
  sceneGroup:insert( field2 )
  sceneGroup:insert( field3 )
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
	local sceneGroup = self.view
	backBtn:removeSelf()	-- widgets must be manually removed
	backBtn = nil
	field0:removeSelf()	-- widgets must be manually removed
	field0 = nil
	field1:removeSelf()	-- widgets must be manually removed
	field1 = nil
	field2:removeSelf()	-- widgets must be manually removed
	field2 = nil
	field3:removeSelf()	-- widgets must be manually removed
	field3 = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
--scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
