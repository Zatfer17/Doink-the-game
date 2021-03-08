----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- gameView.lua
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--> MISCELLANEOUS
require ("math")
system.activate( "multitouch" )

-- include Corona's "widget" library
local widget = require "widget"

-- include global variables custom lua
local global = require( "variables" )

-- include Corona's "physics" library
local physics = require "physics"

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--> VARIABLES AND CONSTANTS
	local halfpost = 36
	local longside = 140
	local a = 120
	local b = 100
	local strokeWidth = 10
	local X, Y, X1, Y1, X2, Y2
	local ball
	local ballDim = 30
	local player1
	local player2
	local player1Score
	local player1Score
	local score = 0
	local pdim = 10
	local background
	local bluLine
	local redLine
	local bluTableL = {}
	local bluTableR = {}
	local redTableL = {}
	local redTableR = {}
	local upBoundL
	local upBoundR
	local lowBoundL
	local lowBoundR
	local title
	local text
	local text2
	local porta1
	local porta2
	local v = 0.16
	local netTimeK = 1.2
	local bluX = {}
	local bluY = {}
	local redX = {}
	local redY = {}
	local timeTable = {}

	local LowerNetCollisionFilter = {categoryBits = 1, maskBits = 16}
	local upperNetCollisionFilter = {categoryBits = 2, maskBits = 32}
	local lowerBoundCollisionFilter = {categoryBits = 4, maskBits = 80}
	local upperBoundCollisionFilter = {categoryBits = 8, maskBits = 96}
	local bluPlayerCollisionFilter = {categoryBits = 16, maskBits = 101}
	local redPlayerCollisionFilter = {categoryBits = 32, maskBits = 90}
	local ballCollisionFilter = {categoryBits = 64, maskBits = 60}


	local LowerNetCollisionFilter_1 = {categoryBits = 1, maskBits = 0}
	local upperNetCollisionFilter_1 = {categoryBits = 2, maskBits = 0}
	local lowerBoundCollisionFilter_1 = {categoryBits = 4, maskBits = 64}
	local upperBoundCollisionFilter_1 = {categoryBits = 8, maskBits = 64}
	local bluPlayerCollisionFilter_1 = {categoryBits = 16, maskBits = 64}
	local redPlayerCollisionFilter_1 = {categoryBits = 32, maskBits = 64}
	local ballCollisionFilter_1 = {categoryBits = 64, maskBits = 60}

	local LowerNetCollisionFilter_2 = {categoryBits = 1, maskBits = 16}
	local upperNetCollisionFilter_2 = {categoryBits = 2, maskBits = 16}
	local lowerBoundCollisionFilter_2 = {categoryBits = 4, maskBits = 80}
	local upperBoundCollisionFilter_2 = {categoryBits = 8, maskBits = 80}
	local bluPlayerCollisionFilter_2 = {categoryBits = 16, maskBits = 79}
	local redPlayerCollisionFilter_2 = {categoryBits = 32, maskBits = 64}
	local ballCollisionFilter_2 = {categoryBits = 64, maskBits = 60}

	local i = 0
	local j = 0
	local segmentTransition
	local delta = 1
	local goal
  local shootPowerDefault=0.01
	local bluInPitch = false
	local redInPitch = false
	local lenBluX

	local power_button_red
	local staging_powerup
	local loading



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> GAME
	function scene:create( event )
	physics.start()
	physics.setGravity(0,0)
	local sceneGroup = self.view


--> SOUND
	local goalSound = audio.loadSound('sounds/goal.wav')


--> FUNCTIONS

	-- calcola il numero totale di elementi contenuti in un array
	local function tableSize(table)
		local i = 0
		while table[i+1] do
			i = i + 1
		end
		return i
	end

	--calcola la lunghezza di un segmento dati gli estremi
	local function segmentLenght( x1, y1, x2, y2 )
		local xFactor = x2 - x1
		local yFactor = y2 - y1
		local dist = math.sqrt( (xFactor*xFactor) + (yFactor*yFactor) )
		return dist
	end

	--calcola l'intervallo di tempo per percorrere un segmento con una certa velocità
	local function segmentTime(S, V)
		local timeInterval = S / V
		return timeInterval
	end

	--calcola l'angolo tra due oggetti
  local function angleBetween ( srcObj, dstObj )
      local xDist = dstObj.x-srcObj.x ; local yDist = dstObj.y-srcObj.y
      local angleBetween = math.deg( math.atan( yDist/xDist ) )
      if srcObj.x < dstObj.x then
				angleBetween = angleBetween+90
			else
				angleBetween = angleBetween-90
			end
      return angleBetween
    end


	local function menuView()
		composer.gotoScene( "menuView", "fade", 300 )	-- event listener function
		playSound2()
		return true
	end

	--muove player2 lungo la bluLine
	local function onCompleteMove()
		i = i + delta
		if timeTable[i] then
			segmentTransition = transition.to(player2, {
			time=timeTable[i],
			x=bluX[i+delta+j],
			y=bluY[i+delta+j],
			onComplete=onCompleteMove
			})
		else
			if j==0 then
				j = 1
			else
				j = 0
			end
		delta = delta*(-1)
		i = i + delta
		segmentTransition = transition.to(player2, {
			time=timeTable[i],
			x=bluX[i+delta+j],
			y=bluY[i+delta+j],
			onComplete=onCompleteMove
		})
		end
	end

	--ferma player2
	local function bluStop()
	transition.pause(segmentTransition)
	end

	--inverte il verso del moto di player2
	local function invert()
		bluStop()
		if player2.x <= display.contentCenterX - halfpost or player2.x >= display.contentCenterX + halfpost then
			print("I:", i)
			print("J:", j)
			print("D:", delta)
			delta = delta * (-1)
			if j==0 then
				j = 1
			else
				j = 0
			end
			segmentTransition = transition.to(player2, {
				time = segmentTime( segmentLenght( player2.x, player2.y, bluX[i+delta+j], bluY[i+delta+j]), v),
				x = bluX[i+delta+j],
				y = bluY[i+delta+j],
				onComplete = onCompleteMove
			})
		else
			transition.resume(segmentTransition)
		end
	end

	--spara player2 nel campo con direzione normale alla bluLine
	local function shoot()
		if not bluInPitch then
			if player2.x == display.contentCenterX - a - halfpost then
        bluStop()
        player2:applyLinearImpulse( shootPowerDefault, 0, player2.x, player2.y)
      elseif player2.x > display.contentCenterX - a - halfpost and player2.x < display.contentCenterX-halfpost then
      	local centerAS = display.newCircle(a, display.contentHeight/2-140, 0.1)
        centerAS:setFillColor( 0, 0, 0, 0)
        local angleAS = angleBetween(centerAS, player2)*math.pi/180
        local shootAngle = math.atan(b*math.sin(angleAS)/(a*math.cos(angleAS))) + math.pi/2
        print("ANGLE: ".. tostring(shootAngle*180/math.pi))
    		local shootPowerComp_x = shootPowerDefault * math.cos(shootAngle)
        local shootPowerComp_y = shootPowerDefault * math.sin(shootAngle)
        bluStop()
        player2:applyLinearImpulse(shootPowerComp_x, shootPowerComp_y, player2.x, player2.y)
      elseif player2.x >= display.contentCenterX - halfpost and player2.x <= display.contentCenterX + halfpost then
        bluStop()
        player2:applyLinearImpulse( 0, shootPowerDefault, player2.x, player2.y)
    	elseif player2.x > display.contentCenterX + halfpost and player2.x < display.contentCenterX + a + halfpost then
        local centerAD = display.newCircle(display.contentCenterX + halfpost, display.contentHeight/2-140, 0.1)
        centerAD:setFillColor( 0, 0, 0, 0)
        local angleAD = angleBetween(centerAD, player2)*math.pi/180
        local shootAngle = math.atan(b*math.sin(angleAD)/(a*math.cos(angleAD))) - math.pi/2
        local shootPowerComp_x = -shootPowerDefault * math.cos(shootAngle)
        local shootPowerComp_y = -shootPowerDefault * math.sin(shootAngle)
        bluStop()
        player2:applyLinearImpulse(shootPowerComp_x, shootPowerComp_y, player2.x, player2.y)
      elseif player2.x == display.contentCenterX + a + halfpost then
        bluStop()
      	player2:applyLinearImpulse( -shootPowerDefault, 0, player2.x, player2.y)
      end
			bluInPitch = true
    end
	end

	local function startMoving()
		i = 1
		if player2.x < display.contentCenterX then
			while bluX[i] < player2.x do
				i = i + 1
			end
			delta = 1
			j = 0
		else
			i = lenBluX
			while bluX[i] > player2.x do
				i = i - 1
			end
			delta = -1
			j = 1
		end
		segmentTransition = transition.to(player2, {
			time = segmentTime( segmentLenght( player2.x, player2.y, bluX[i], bluY[i]), v),
			x = bluX[i],
			y = bluY[i],
			onComplete = onCompleteMove
		})
	end


	local function EllipseY(X)
	return display.contentCenterY - math.sqrt((1-(X^2)/(a^2))*b^2) - longside
	end

	local leftX = display.contentCenterX - a - halfpost
	local leftPostX = display.contentCenterX - halfpost
	local rightPostX = display.contentCenterX + halfpost
	local rightX = display.contentCenterX + a + halfpost
	local highY = display.contentCenterY - longside - b

	local bluHooking = function(event)
		if bluInPitch and player2.y <= display.contentCenterY then
			if player2.x - leftX <= 3 or rightX - player2.x <= 3 or player2.y - highY <= 2 then
				player2.isAwake = false
				startMoving()
				bluInPitch = false
			elseif player2.x < leftPostX and player2.y - EllipseY(player2.x-display.contentCenterX+halfpost) <= 3 then
				player2.isAwake = false
				startMoving()
				bluInPitch = false
			elseif player2.x >rightPostX and player2.y - EllipseY(player2.x-display.contentCenterX-halfpost) <= 3 then
				player2.isAwake = false
				startMoving()
				bluInPitch = false
			end
		end
	end

	Runtime:addEventListener( "enterFrame", bluHooking)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> POWERUPS

	local used_red = true
	local ready_to_randomize = true
	local counter = -1


	local function restorePower()--ripristina potenza di tiro
	  shootPowerDefault=0.01
	end

	local function restoreDim()--ripristina dimensioni(?)
	  pdim=10
	end

	local function red_powerup_usage()
	   -- power_button_red.fill.effect = "filter.grayscale"
			power_button_red.alpha=0
	    used_red=true
			print ("X")
	    if current==1 then
				print ("a")
	      local powerup1_sound = audio.loadSound( "sounds/powerup1_sound.wav")
				audio.play(powerup1_sound, {channel=6})
	      ball.isAwake=false
	    elseif current==2 then
				print ("b")
	      local powerup2_sound = audio.loadSound( "sounds/powerup2_sound.wav" )
	      audio.play(powerup2_sound, {channel=6})
	    elseif current==3 then
				print ("c")
	      local powerup3_sound = audio.loadSound( "sounds/powerup3_sound.wav" )
	      audio.play(powerup3_sound, {channel=6})
	      shootPowerDefault=0.1
	      timer.performWithDelay(1500, restorePower)
	    elseif current==4 then
				print ("d")
	      local powerup4_sound = audio.loadSound( "sounds/powerup4_sound.wav" )
	      audio.play(powerup4_sound, {channel=6})
	      pdim=30
	      timer.performWithDelay(1500, restoreDim)
	    end
			print ("Y")
	  end

	local function powerup()
		if counter~=-1 then
			loading.alpha=0
		else
			counter=0
		end
	  if used_red and ready_to_randomize then
			print("A libero B libero")
	    rand_red=math.random(5)
	    if rand_red==1 then
	      loading=display.newImageRect("powerups/powerup1.png", 30, 30 )
				loading.alpha=1
				print("B1")
	    elseif rand_red==2 then
	      loading=display.newImageRect("powerups/powerup2.png", 30, 30 )
				loading.alpha=1
				print("B2")
	    elseif rand_red==3 then
	      loading=display.newImageRect("powerups/powerup3.png", 30, 30 )
				loading.alpha=1
				print("B3")
	    elseif rand_red==4 then
	      loading=display.newImageRect("powerups/powerup4.png", 30, 30 )
				loading.alpha=1
				print("B4")
	    elseif rand_red==5 then
	      loading=display.newImageRect("powerups/powerup5.png", 30, 30 )
				loading.alpha=1
				print("B5")
	    end
	    loading.x = display.contentCenterX + 115
	    loading.y = display.contentCenterY-45
	    counter=counter+1
	    if counter ~= 5 then
	      timer.performWithDelay(700, powerup)
				print("rieseguo")
	    else
				print("counter=5")
	      if rand_red==1 then
	        power_button_red=display.newImageRect("powerups/powerup1.png", 30, 30 )
	      elseif rand_red==2 then
	        power_button_red=display.newImageRect("powerups/powerup2.png", 30, 30 )
	      elseif rand_red==3 then
	        power_button_red=display.newImageRect("powerups/powerup3.png", 30, 30 )
	      elseif rand_red==4 then
	        power_button_red=display.newImageRect("powerups/powerup4.png", 30, 30 )
	      elseif rand_red==5 then
	        power_button_red=display.newImageRect("powerups/powerup5.png", 30, 30 )
	      end
	      power_button_red.x = display.contentCenterX + 78
	      power_button_red.y = display.contentCenterY - 65
				current=rand_red
	      power_button_red:addEventListener("tap", red_powerup_usage)
	      used_red=false
	      counter=0
	      timer.performWithDelay(700, powerup)
	    end
	  elseif not used_red and ready_to_randomize then
			print("A pieno B libero")
			loading.alpha=0
	    rand_red=math.random(5)
	    if rand_red==1 then
	      loading=display.newImageRect("powerups/powerup1.png", 30, 30 )
				loading.alpha=1
				print("B1")
	    elseif rand_red==2 then
	      loading=display.newImageRect("powerups/powerup2.png", 30, 30 )
				loading.alpha=1
				print("B1")
	    elseif rand_red==3 then
	      loading=display.newImageRect("powerups/powerup3.png", 30, 30 )
				loading.alpha=1
				print("B1")
	    elseif rand_red==4 then
	      loading=display.newImageRect("powerups/powerup4.png", 30, 30 )
				loading.alpha=1
				print("B1")
	    elseif rand_red==5 then
	      loading=display.newImageRect("powerups/powerup5.png", 30, 30 )
				loading.alpha=1
				print("B1")
	    end
	    loading.x = display.contentCenterX + 115
	    loading.y = display.contentCenterY-45
	    counter=counter+1
	    if counter ~= 5 then
				print("rieseguo")
	      timer.performWithDelay(700, powerup)
	    else
				print("counter=5")
	      staging_powerup=rand_red
	      ready_to_randomize=false
	      timer.performWithDelay(700, powerup)
	    end
	  elseif used_red and not ready_to_randomize then
			print("A libero, B pieno")
			power_button_red.alpha=0
	    rand_red = staging_powerup
	    if rand_red==1 then
	      power_button_red=display.newImageRect("powerups/powerup1.png", 30, 30 )
	    elseif rand_red==2 then
	      power_button_red=display.newImageRect("powerups/powerup2.png", 30, 30 )
	    elseif rand_red==3 then
	      power_button_red=display.newImageRect("powerups/powerup3.png", 30, 30 )
	    elseif rand_red==4 then
	      power_button_red=display.newImageRect("powerups/powerup4.png", 30, 30 )
	    elseif rand_red==5 then
	      power_button_red=display.newImageRect("powerups/powerup5.png", 30, 30 )
	    end
	    power_button_red.x = display.contentCenterX + 78
	    power_button_red.y = display.contentCenterY-65
			current=rand_red
	    power_button_red:addEventListener("tap", red_powerup_usage)
	    used_red=false
	    ready_to_randomize=true
	    counter=0
	    timer.performWithDelay(700, powerup)
		elseif not used_red and not ready_to_randomize then
			loading.alpha=1
			print("A pieno, B pieno")
			timer.performWithDelay(700, powerup)
	  end
	end

	timer.performWithDelay(700, powerup)


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> BACKGROUND
	if (global.fieldType==1) then
		background = display.newImageRect( "fields/field1.png", display.contentWidth, display.contentHeight*119/100 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
	elseif (global.fieldType==2) then
		background = display.newImageRect( "fields/field2.png", display.contentWidth, display.contentHeight*119/100 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
	elseif (global.fieldType==3) then
		background = display.newImageRect( "fields/field3.png", display.contentWidth, display.contentHeight*119/100 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
	else
		background = display.newImageRect( "fields/field0.png", display.contentWidth, display.contentHeight*119/100 )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
	end

	--> GOALS
	if (global.fieldType==0) then
		porta1 = display.newImageRect("fields/porta100.png", 80, 80)
		porta1.x = display.contentCenterX
		porta1.y = display.contentHeight*3.6/100
		porta2 = display.newImageRect("fields/porta200.png", 80, 80)
		porta2.x = display.contentCenterX
		porta2.y = display.contentHeight*96.4/100
	end

--[[ lasciate commentato plz
if (global.fieldType==0) then
	porta1 = display.newImageRect(".png", 80, 80)
	porta1.x = display.contentCenterX
	porta1.y = display.contentHeight*3.6/100
	porta2 = display.newImageRect(".png", 80, 80)
	porta2.x = display.contentCenterX
	porta2.y = display.contentHeight*96.4/100
elseif (global.fieldType==1) then
	porta1 = display.newImageRect(".png", 80, 80)
	porta1.x = display.contentCenterX
	porta1.y = display.contentHeight*3.6/100
	porta2 = display.newImageRect(".png", 80, 80)
	porta2.x = display.contentCenterX
	porta2.y = display.contentHeight*96.4/100
end
]]
--> ARENA

--player paths


--bluX and bluY tables, creation of timeTable
	X1 = display.contentCenterX - a - halfpost
	Y1 = display.contentCenterY
	X2 = display.contentCenterX - a - halfpost
	Y2 = display.contentCenterY - longside

	table.insert(bluX, X1)
	table.insert(bluX, X2)
	table.insert(bluY, Y1)
	table.insert(bluY, Y2)
	table.insert(timeTable, segmentTime(segmentLenght(X1, Y1, X2, Y2), v))
	X1 = X2
	Y1 = Y2

	for x = -a + 4, 0, 4 do
		X2 = display.contentCenterX + x - halfpost
		Y2 = display.contentCenterY - math.sqrt((1-(x^2)/(a^2))*b^2) - longside
		table.insert(bluX, X2)
		table.insert(bluY, Y2)
		table.insert(timeTable, segmentTime(segmentLenght(X1, Y1, X2, Y2), v))
		X1 = X2
		Y1 = Y2
	end

	X2 = display.contentCenterX + halfpost
	Y2 = display.contentCenterY - longside - b
	table.insert(bluX, X2)
	table.insert(bluY, Y2)
	table.insert(timeTable, segmentTime(segmentLenght(X1, Y1, X2, Y2), v)*netTimeK)
	X1 = X2
	Y1 = Y2

	for x = 4, a, 4 do
		X2 = display.contentCenterX + x + halfpost
		Y2 = display.contentCenterY - math.sqrt((1-(x^2)/(a^2))*b^2) - longside
		table.insert(bluX, X2)
		table.insert(bluY, Y2)
		table.insert(timeTable, segmentTime(segmentLenght(X1, Y1, X2, Y2), v))
		X1 = X2
		Y1 = Y2
	end

	X2 = display.contentCenterX + a + halfpost
	Y2 = display.contentCenterY
	table.insert(bluX, X2)
	table.insert(bluY, Y2)
	table.insert(timeTable, segmentTime(segmentLenght(X1, Y1, X2, Y2), v))

	lenBluX = tableSize(bluX)--lasciami qui
	print(bluX[lenBluX])


	--redX and redY tables
	redX = {display.contentCenterX - a - halfpost, display.contentCenterX - a - halfpost}
	redY = {display.contentCenterY, display.contentCenterY + longside}

	for x = - a + 4, 0, 4 do
		X = display.contentCenterX + x - halfpost
		Y = display.contentCenterY + math.sqrt((1-(x^2)/(a^2))*b^2) + longside
		table.insert(redX, X)
		table.insert(redY, Y)
	end

	for x = 0, a, 4 do
		X = display.contentCenterX + x + halfpost
		Y = display.contentCenterY + math.sqrt((1-(x^2)/(a^2))*b^2) + longside
		table.insert(redX, X)
		table.insert(redY, Y)
	end

	table.insert(redX, display.contentCenterX + a + halfpost)
	table.insert(redY, display.contentCenterY)


	--bluLine, bluTable and upBound physics
	local bluLine = display.newLine(display.contentCenterX - a - halfpost, display.contentCenterY, display.contentCenterX - a - halfpost, display.contentCenterY - longside)
	bluLine.strokeWidth = strokeWidth

	if (global.fieldType==2) then
		bluLine:setStrokeColor(0, 1, 0, 0.6)
	else
		--bluLine:setStrokeColor(0, 0, 1, 0.4)
		bluLine.alpha=0
	end

	bluTableL = {display.contentCenterX - a - halfpost, display.contentCenterY, display.contentCenterX - a - halfpost, display.contentCenterY - longside}
	for x = -a + 1, 0 do
		X = display.contentCenterX + x - halfpost
		Y = display.contentCenterY - math.sqrt((1-(x^2)/(a^2))*b^2) - longside
		bluLine:append(X,Y)
		table.insert(bluTableL, X)
		table.insert(bluTableL, Y)
	end

	for x = 0, a do
		X = display.contentCenterX + x + halfpost
		Y = display.contentCenterY - math.sqrt((1-(x^2)/(a^2))*b^2) - longside
		bluLine:append(X,Y)
		table.insert(bluTableR, X)
		table.insert(bluTableR, Y)
	end

	bluLine:append(display.contentCenterX + a + halfpost, display.contentCenterY)
	table.insert(bluTableR, display.contentCenterX + a + halfpost)
	table.insert(bluTableR, display.contentCenterY)

	upBoundL = display.newRect(0,0,21,21)
	upBoundL.alpha = 0
	physics.addBody(upBoundL, "static", {chain = bluTableL, filter = upperBoundCollisionFilter})
	upBoundR = display.newRect(0,0,21,21)
	upBoundR.alpha = 0
	physics.addBody(upBoundR, "static", {chain = bluTableR, filter = upperBoundCollisionFilter})


	--redLine, redTable and lowBound physics
	local redLine = display.newLine(display.contentCenterX - a - halfpost, display.contentCenterY, display.contentCenterX - a - halfpost, display.contentCenterY + longside)
	redLine.strokeWidth = strokeWidth

	if (global.fieldType==3) then
			redLine:setStrokeColor(153, 0, 153, 0.4)
	elseif (global.fieldType==2) then
		redLine:setStrokeColor(1, 0, 0, 0.6)
	else
		--redLine:setStrokeColor(1, 0, 0, 0.4)
		redLine.alpha=0
	end

	redTableL = {display.contentCenterX - a - halfpost, display.contentCenterY, display.contentCenterX - a - halfpost, display.contentCenterY + longside}
	for x = -a + 1, 0 do
		X = display.contentCenterX + x - halfpost
		Y = display.contentCenterY + math.sqrt((1-(x^2)/(a^2))*b^2) + longside
		redLine:append(X,Y)
		table.insert(redTableL, X)
		table.insert(redTableL, Y)
	end

	for x = 0, a do
		X = display.contentCenterX + x + halfpost
		Y = display.contentCenterY + math.sqrt((1-(x^2)/(a^2))*b^2) + longside
		redLine:append(X,Y)
		table.insert(redTableR, X)
		table.insert(redTableR, Y)
	end

	redLine:append(display.contentCenterX + a + halfpost, display.contentCenterY)
	table.insert(redTableR, display.contentCenterX + a + halfpost)
	table.insert(redTableR, display.contentCenterY)

	lowBoundL = display.newRect(0,0,21,21)
	lowBoundL.alpha = 0
	physics.addBody(lowBoundL, "static", {chain = redTableL, filter = lowerBoundCollisionFilter})
	lowBoundR = display.newRect(0,0,21,21)
	lowBoundR.alpha = 0
	physics.addBody(lowBoundR, "static", {chain = redTableR, filter = lowerBoundCollisionFilter})



--nets physics rectangles
	local upperNet = display.newRect(display.contentCenterX, display.contentCenterY - b - longside, 2*halfpost, strokeWidth)
	local lowerNet = display.newRect(display.contentCenterX, display.contentCenterY + b + longside, 2*halfpost, strokeWidth)
	upperNet.alpha = 0
	lowerNet.alpha = 0
	physics.addBody(upperNet, "static", {filter = upperNetCollisionFilter})
	physics.addBody(lowerNet, "static", {filter = LowerNetCollisionFilter})

--> SCORES
if (global.fieldType==3) then
	player1Score = display.newText('0',display.contentCenterX, display.contentHeight*80/100, 'Courier-Bold',display.contentHeight*20/100)
	player1Score:setTextColor(153, 0, 153, 0.4)
else
	player1Score = display.newText('0',display.contentCenterX, display.contentHeight*80/100, 'Courier-Bold',display.contentHeight*20/100)
	player1Score:setTextColor(1, 0, 0, 0.4)
end

if (global.fieldType==2) then
	player2Score = display.newText('0', display.contentCenterX, display.contentHeight*18/100, 'Courier-Bold', display.contentHeight*20/100)
	player2Score:setTextColor(0, 1, 0, 0.4)
else
	player2Score = display.newText('0', display.contentCenterX, display.contentHeight*18/100, 'Courier-Bold', display.contentHeight*20/100)
	player2Score:setTextColor(0, 0, 1, 0.4)
end

--> BALL
if(global.ballType==1) then
	ball = display.newImageRect( "balls/ball1.png", ballDim, ballDim)
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	physics.addBody( ball, "dynamic", {radius=ballDim/2, bounce=1, filter = ballCollisionFilter})
elseif(global.ballType==2) then
	ball = display.newImageRect( "balls/ball2.png", ballDim, ballDim)
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	physics.addBody( ball, "dynamic", {radius=ballDim/2, bounce=1, filter = ballCollisionFilter})
elseif(global.ballType==3) then
	ball = display.newImageRect( "balls/ball3.png", ballDim, ballDim)
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	physics.addBody( ball, "dynamic", {radius=ballDim/2, bounce=1, filter = ballCollisionFilter})
elseif(global.ballType==4) then
	ball = display.newImageRect( "balls/ball4.png", ballDim, ballDim)
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	physics.addBody( ball, "dynamic", {radius=ballDim/2, bounce=1, filter = ballCollisionFilter})
elseif(global.ballType==5) then
	ball = display.newImageRect( "balls/ball5.png", ballDim, ballDim)
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
	physics.addBody( ball, "dynamic", {radius=ballDim/2, bounce=1, filter = ballCollisionFilter})
else
	ball = display.newCircle(display.contentCenterX, display.contentCenterY, ballDim/2)
	ball:setFillColor(1)
	physics.addBody(ball, "dynamic", {radius=ballDim/2, bounce=1, filter = ballCollisionFilter})
end

--> PLAYERS
	player1 = display.newCircle(display.contentCenterX, display.contentCenterY + b + longside, pdim)
	player1:setFillColor(1, 0, 0, 1)
	physics.addBody(player1, "dynamic", {radius=pdim/2, bounce=1, filter = redPlayerCollisionFilter})

	player2 = display.newCircle(display.contentCenterX - a - halfpost, display.contentCenterY, pdim)
	player2:setFillColor(0, 0, 1, 1)
	physics.addBody(player2, "dynamic", {radius=pdim/2, bounce=1, filter = bluPlayerCollisionFilter})

	onCompleteMove(i)  -- start moving

--> BUTTONS
	button2 = display.newImageRect( "buttons/bottone1_prova.png", 150, 150  )
	button2.x = display.contentWidth*90/100
	button2.y = display.contentHeight*103/100

	button1 = display.newImageRect( "buttons/bottone2_prova.png", 150, 150  )
	button1.x = display.contentWidth*10/100
	button1.y = display.contentHeight*103/100

	restartBtn = display.newImageRect( "buttons/restart_round.png", display.contentWidth*20/100, display.contentWidth*20/100)
	restartBtn.x = display.contentWidth*92/100
	restartBtn.y = display.contentWidth*0,05/100

  menuBtn=display.newImageRect('buttons/menu_round.png',  display.contentWidth*20/100, display.contentWidth*20/100)
	menuBtn.x = display.contentWidth*8/100
	menuBtn.y = display.contentWidth*0,05/100
  menuBtn:addEventListener('tap', menuView)

	--button functions
	local function reset()
		ball.x = display.contentCenterX
		ball.y = display.contentCenterY
		ball.isAwake = false
	end

	local function removeGoal()
		display.remove(goal)
	end

	local flag=1

	local function check()
		if(flag==1) then
			if(ball.y > display.contentHeight) then
				goal = display.newImageRect("goal.png", 300, 200)
				goal.x = display.contentCenterX
				goal.y = display.contentCenterY
				if (global.soundFlag==0) then
					audio.play(goalSound, {channel=5})
				end
				timer.performWithDelay (1000, removeGoal)
	      player2Score.text = tostring(tonumber(player2Score.text) + 1)
	      ball.x = display.contentCenterX
	      ball.y = display.contentCenterY
	      ball.isAwake = false
	      score = score+1
	      return score
	    elseif(ball.y < -5) then
				goal = display.newImageRect("goal.png", display.contentWidth, display.contentHeight)
				goal.x = display.contentCenterX
				goal.y = display.contentCenterY
				if (global.soundFlag==0) then
					audio.play(goalSound, {channel=5})
				end
				timer.performWithDelay (1000, removeGoal)
	      player1Score.text = tostring(tonumber(player1Score.text) + 1)
	      ball.x = display.contentCenterX
	      ball.y = display.contentCenterY
	      ball.isAwake = false
	      score = score+1
	      return score
	    end
		end
	end

--> EVENT LISTENERS

--event listeners for powerup4_sound
	--timer.performWithDelay(9000, powerup, 0)

--event listerner for goal check function
	Runtime:addEventListener("enterFrame", check)

--event listeners for buttons
	button2:addEventListener( "tap", shoot)
	button1:addEventListener( "tap", invert)
	restartBtn:addEventListener( "tap", reset)



	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	if (porta1) then
	sceneGroup:insert( porta1 )
	end
	if (porta2) then
	sceneGroup:insert( porta2 )
	end
	sceneGroup:insert( redLine )
	sceneGroup:insert( bluLine )
	sceneGroup:insert( upperNet )
	sceneGroup:insert( lowerNet )
	sceneGroup:insert( player1Score )
	sceneGroup:insert( player2Score )
	sceneGroup:insert( ball )
	sceneGroup:insert( player1 )
	sceneGroup:insert( player2 )
	sceneGroup:insert( button1 )
	sceneGroup:insert( button2 )
	sceneGroup:insert( restartBtn )
	sceneGroup:insert( menuBtn )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		physics.start()
	end
end
]]
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function scene:hide( event )
	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		-- INSERT code here to pause the scene
		physics.stop()
		composer.removeScene("gameView") -- rimuove completamente la scena
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
	package.loaded[physics] = nil
	physics = nil
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
return scene
