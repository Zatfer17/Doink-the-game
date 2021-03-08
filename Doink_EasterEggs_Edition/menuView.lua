-----------------------------------------------------------------------------------------
-- menuView.lua
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
-- include global variables custom lua
	local global = require( "variables" )

--> FUNCTIONS
local function creditsView()
	soundBtn:removeSelf()
	soundBtn = nil
	composer.gotoScene( "creditsView", "slideLeft", 300 )	-- event listener function
	return true
end
local function ballView()
	soundBtn:removeSelf()
	soundBtn = nil
	composer.gotoScene( "ballView", "slideLeft", 300 )	-- event listener function
	return true
end
local function gameView()
	soundBtn:removeSelf()
	soundBtn = nil
	composer.gotoScene( "gameView", "fade", 300 )	-- event listener function
	return true
end
local function fieldView()
	soundBtn:removeSelf()
	soundBtn = nil
	composer.gotoScene( "fieldView", "slideRight", 300)
end
local function trainingView()
	soundBtn:removeSelf()
	soundBtn = nil
	composer.gotoScene( "trainingView", "slideLeft", 300)
end

--> SOUND
global.sound = audio.loadSound("sounds/mainSound.wav")
--sound
	function playSound()
		if (global.soundFlag==1) then
			audio.play(global.sound, {loops=-1})
			global.soundFlag=0
			soundBtn:removeSelf()
			soundBtn = nil
			soundBtn = widget.newButton{
		 		defaultFile= "buttons/volumeOn.png",
		 		width = display.contentWidth*12/100, height = display.contentWidth*12/100,
		 		onRelease = playSound
		 		}
		 	soundBtn.x = display.contentWidth*11/100
		 	soundBtn.y = display.contentHeight*102/100
		elseif (global.soundFlag==0) then
			audio.pause(global.sound)
			global.soundFlag=1
			soundBtn:removeSelf()
			soundBtn = nil
			soundBtn = widget.newButton{
	 		defaultFile= "buttons/volumeOff.png",
	 		width = display.contentWidth*12/100, height = display.contentWidth*12/100,
	 		onRelease = playSound
	 		}
			soundBtn.x = display.contentWidth*11/100
		 	soundBtn.y = display.contentHeight*102/100
		end
	end
	function playSound2()
		if (global.soundFlag==0) then
			soundBtn = widget.newButton{
		 		defaultFile= "buttons/volumeOn.png",
		 		width = display.contentWidth*12/100, height = display.contentWidth*12/100,
		 		onRelease = playSound
		 		}
			soundBtn.x = display.contentWidth*11/100
			soundBtn.y = display.contentHeight*102/100
		elseif (global.soundFlag==1) then
		soundBtn = widget.newButton{
			defaultFile= "buttons/volumeOff.png",
			width = display.contentWidth*12/100, height = display.contentWidth*12/100,
			onRelease = playSound
			}
			soundBtn.x = display.contentWidth*11/100
			soundBtn.y = display.contentHeight*102/100
		end
	end


--> SCENE FUNCTIONS
function scene:create( event )
	local sceneGroup = self.view
	audio.play(global.sound, {loops=-1})
--background
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight*150/100 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

--[[ome applicazione
	local logoApp = display.newImageRect( "logo.png", 264, 42 )
	logoApp.x = display.contentCenterX
	logoApp.y = display.contentHeight*10/100
]]

--training button
local trnBtn = widget.newButton{
	--label="Training",
	--labelColor = { default={255}, over={128} },
	defaultFile="buttons/trnBtn.png",
	overFile="buttons/trnBtnPressed.png",
	width= display.contentWidth*45/100,
	height= display.contentHeight*11/100,
	onRelease = trainingView
}
trnBtn.x = display.contentCenterX
trnBtn.y = display.contentHeight*28/100

--play button (avvia il game)
	local playBtn = widget.newButton{
		--label="Play",
		--labelColor = { default={255}, over={128} },
		defaultFile="buttons/playBtn.png",
		overFile="buttons/playBtnPressed.png",
		width= display.contentWidth*45/100,
		height= display.contentHeight*11/100,
		onRelease = gameView
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight*10/100

--balls button
local ballBtn = widget.newButton{
	defaultFile= "ballView.png",
	width = display.contentWidth*40/100, height = display.contentWidth*40/100,
	onRelease = ballView
}
ballBtn.x = display.contentCenterX
ballBtn.y = display.contentHeight*50/100

--fields button
local fieldBtn = widget.newButton{
	defaultFile= "fieldView.png",
	width = display.contentWidth*45/100, height = display.contentWidth*40/100,
	onRelease = fieldView
}
fieldBtn.x = display.contentCenterX
fieldBtn.y = display.contentHeight*80/100

--sound button
	soundBtn = widget.newButton{
 		defaultFile= "buttons/volumeOn.png",
 		width = display.contentWidth*12/100, height = display.contentWidth*12/100,
 		onRelease = playSound
 		}
	soundBtn.x = display.contentWidth*11/100
	soundBtn.y = display.contentHeight*102/100

--credits button
	local crdBtn = widget.newButton{
		label="i",
		labelColor = { default={255}, over={128} },
		defaultFile="buttons/button.png",
		overFile="buttons/button-over.png",
		width=35, height=35,
		onRelease = creditsView
	}
	crdBtn.x = display.contentWidth*88/100
	crdBtn.y = display.contentHeight*102/100

-- all display objects must be inserted into group
	sceneGroup:insert( background )
	--sceneGroup:insert( logoApp )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( crdBtn )
	sceneGroup:insert( soundBtn )
	sceneGroup:insert( ballBtn )
	sceneGroup:insert( fieldBtn )
	sceneGroup:insert ( trnBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
end

function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		-- INSERT code here to pause the scene
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )
	local sceneGroup = self.view
	playBtn:removeSelf()	-- widgets must be manually removed
	playBtn = nil
	crdBtn:removeSelf()	-- widgets must be manually removed
	crdBtn = nil
	ballBtn:removeSelf()	-- widgets must be manually removed
	ballBtn = nil
	fieldBtn:removeSelf()
	fieldBtn = nil
	trnBtn:removeSelf()
	trnBtn = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
