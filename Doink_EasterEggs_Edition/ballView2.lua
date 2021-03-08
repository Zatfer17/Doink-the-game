-----------------------------------------------------------------------------------------
-- ballView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
-- include global variables custom lua
local global = require( "variables" )

--> FUNCTIONS
local function menuView()
	composer.gotoScene( "menuView", "slideRight", 300 )	-- event listener function
	playSound2()
  return true
end
local function menuView4()
  global.ballType = 4
	composer.gotoScene( "menuView", "slideRight", 300 )	-- event listener function
	playSound2()
  return true
end
local function menuView5()
  global.ballType = 5
	composer.gotoScene( "menuView", "slideRight", 300 )	-- event listener function
	playSound2()
  return true
end
local function ballView1()
  composer.gotoScene( "ballView", "crossFade", 300 )	-- event listener function
  return true
end


--> SCENE FUNCTIONS
function scene:create( event )
	local sceneGroup = self.view

--background
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight*150/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	--back button
	local backBtn = widget.newButton{
		defaultFile= "buttons/back_round.png",
		width = display.contentWidth*20/100, height = display.contentWidth*20/100,
		onRelease = menuView
	}
	backBtn.x = display.contentWidth*13/100
	backBtn.y = display.contentHeight*1/100

--balls
local ball4 = widget.newButton{
  defaultFile= "balls/ball4S.png",
  overFile="balls/ball4P.png",
  width = display.contentWidth*40/100, height = display.contentWidth*40/100,
  onRelease = menuView4
 }
 ball4.x = display.contentWidth*25/100
 ball4.y = display.contentHeight*35/100

 local ball5 = widget.newButton{
    defaultFile= "balls/ball5S.png",
    overFile="balls/ball5P.png",
    width = display.contentWidth*40/100, height = display.contentWidth*40/100,
    onRelease = menuView5
  }
  ball5.x = display.contentWidth*75/100
  ball5.y = display.contentHeight*35/100

--arrow buttons
local rightBtn = widget.newButton{
	defaultFile= "buttons/buttonRight.png",
	width = display.contentWidth*15/100, height = display.contentWidth*15/100,
}
rightBtn.x = display.contentCenterX+35
rightBtn.y = display.contentHeight

local leftBtn = widget.newButton{
	defaultFile= "buttons/buttonLeft.png",
	width = display.contentWidth*15/100, height = display.contentWidth*15/100,
	onRelease = ballView1
}
leftBtn.x = display.contentCenterX-35
leftBtn.y = display.contentHeight

-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( backBtn )
	sceneGroup:insert( rightBtn )
	sceneGroup:insert( leftBtn )
	sceneGroup:insert( ball4)
	sceneGroup:insert( ball5)
end

function scene:destroy( event )
	local sceneGroup = self.view
	backBtn:removeSelf()	-- widgets must be manually removed
	backBtn = nil
	rightBtn:removeSelf()	-- widgets must be manually removed
	rightBtn = nil
	leftBtn:removeSelf()	-- widgets must be manually removed
	leftBtn = nil
  ball4:removeSelf()	-- widgets must be manually removed
	ball4 = nil
  ball5:removeSelf()	-- widgets must be manually removed
	ball5 = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
