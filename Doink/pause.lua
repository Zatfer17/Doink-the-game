local composer = require( "composer" )

local scene = composer.newScene()

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  -- Reference to the parent scene object
    print("AAAAA")

    if ( phase == "will" ) then
        print("AAAAA")
        -- Call the "resumeGame()" function in the parent scene
        parent:resumeView()
    end
end

-- By some method such as a "resume" button, hide the overlay
composer.hideOverlay( "fade", 400 )

scene:addEventListener( "hide", scene )
return scene
