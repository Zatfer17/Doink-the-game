-----------------------------------------------------------------------------------------
-- main.lua
-----------------------------------------------------------------------------------------
	system.activate( "multitouch" )

-- include global variables custom lua
	local global = require( "variables" )

--> HIDE ANDROID SYSTEM UI
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

--> INCLUDI COMPOSER MODULE
  local composer = require "composer"
--set settings variables to default
	global.ballType = 0
	global.fieldType = 0
	global.soundFlag = 0
	--global.playerType = 0
-- load menu screen
  composer.gotoScene( "menuView" )
