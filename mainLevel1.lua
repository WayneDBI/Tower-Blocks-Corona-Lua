------------------------------------------------------------------------------------------------------------------------------------
-- Tower Blocks Template
-- Version 5.0
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http://www.deepblueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
-- Abstract: Drop the blocks onto the blocks below to form a tower.
-- Be careful to accurately place the blocks else they'll all come falling down.
------------------------------------------------------------------------------------------------------------------------------------
-- mainLevel1.lua
-- Corona 2016.2906 compatible
------------------------------------------------------------------------------------------------------------------------------------
-- 24th August 2016
------------------------------------------------------------------------------------------------------------------------------------

local composer 		= require( "composer" )
local scene 		= composer.newScene()
local physics 		= require( "physics" )
local myGlobalData 	= require( "lib.globalData" )
local loadsave 		= require( "lib.loadsave" )
local adsConfig     = require( "adsLibrary" )

local progressRing 		= require( "lib.progressRing" )

physics.start()
--physics.setDrawMode( "hybrid" )
--physics.setDrawMode( "debug" )
physics.setScale( 30 )
physics.setGravity( 0, 50 )	-- Increase the Gravity to have the blocks FALL FASTER
physics.setPositionIterations(130)

---------------------------------------------------------------------------------
-- Create a Randomseed value from the os.time()
---------------------------------------------------------------------------------
math.randomseed( os.time() )

------------------------------------------------------------------------------------------------------------------------------------
-- Game Setup Controls and Variables. Change these parameters to customise your game
------------------------------------------------------------------------------------------------------------------------------------

local startTime				= 60	-- How many seconds to complete the level - before game over?
local startSpeed			= 2.8  	-- NOTE - the start speed is also tied to the FPS of the device.
local speedMultiplyer		= 7 	-- This controls how much FASTER the blocks get, the less time you have!
local numberOfBlocks		= 25 	-- How many blocks to COMPLETE the level?



local cameraGroup 		= display.newGroup();
local hudGroup 			= display.newGroup();
local blocksGroup 		= display.newGroup();
local hazardsGroup 		= display.newGroup();

local rnd 				= math.random
local blockSet				= {}

local cameraMoveY 			= 48	--How much to move the Camera after each Drop - NOTE: this should be the value of the blocks as they are staggered up the stage
local gameOverBool			= false
local releaseBlock			= false
local showFailedScreen		= false
local showSuccessScreen		= false
local offScreenLeft			= 20 	-- The LEFT position for the blocks to Bounce From
local offScreenRight		= 288 	-- The RIGHT position for the blocks to Bounce From
local offScreenLeftStart	= -25 	-- The LEFT hand side - Start position for the blocks
local offScreenRightStart	= myGlobalData._w 	-- The RIGHT hand side - Start position for the blocks

local cameraStartPos		= 0
local blockMoveSpeed 		= startSpeed
local textScore				= 0
local textTime				= 0
local countDownTime			= startTime

local gameOverInfo 			= nil
local levelWinInfo 			= nil
local hitHazard				= false
local showHazardBars		= false		-- Show or Hide the Hazard Bars?
local showGuide				= false		-- Show or Hide the Drop Placement Path indicator (Can be controlled in game)
local hazard1				= nil
local hazard2				= nil
local GuideBar				= nil
local hudGoHome				= nil
local heightClimbed			= 0			-- We track the height, so at the end of the game we zoom back to the start, over a controlled amount of time

local score					= 0
local textHighScore 		= myGlobalData.highScore
local blocksSetUp			= false
 
------------------------------------------------------------------------------------------------------------------------------------
-- Setup Block and Hazard Physics data
------------------------------------------------------------------------------------------------------------------------------------
local blockBoundry 			= { -23,-23,23,-23,23,23,-23,23 } 							-- this is a 1 pixel smaller area than our block
local fixedAssetPhysics 	= { density=0.1, friction=1, bounce=0 } 					-- Define some basic Physics attributes for our base actors
local blockPhysics 			= { shape=blockBoundry, density=1, friction=1, bounce=0 } 	-- Define some basic Physics attributes for our Falling Blocks

local ringObject
local smokePuff			= nil


------------------------------------------------------------------------------------------------------------------------------------
-- Restart the Level Procedure
------------------------------------------------------------------------------------------------------------------------------------
local function restartTheLevel(event)
	if (event.phase == "ended") then
		audio.rewind( musicTrack )  -- rewind channel 1
		audio.rewind( sndTowerFail )  -- rewind channel 1
		composer.gotoScene( "mainLevelReset", "crossFade",100 )
		return true
	end
end


------------------------------------------------------------------------------------------------------------------------------------
-- Restart the Level from a WIN :-)
------------------------------------------------------------------------------------------------------------------------------------
local function restartfromWin(event)
	if (event.phase == "ended") then
		audio.rewind( musicTrack )
		audio.rewind( sndTowerFail )
		composer.gotoScene( "mainStart", "crossFade",500 )
		return true
	end
end





------------------------------------------------------------------------------------------------------------------------------------
-- Called when the scene's view does not exist:
------------------------------------------------------------------------------------------------------------------------------------
function scene:create( event )
	local screenGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local duffObjectForBug = display.newRect(0,0,1,1)
	duffObjectForBug:setFillColor(255,255,255,0)
	screenGroup:insert( duffObjectForBug )


	local function createTheScene()
		------------------------------------------------------------------------------------------------------------------------------------
		-- Create the Background Scenery
		------------------------------------------------------------------------------------------------------------------------------------
		local function createSceneBackdrops()
			for i=0,2 do
				local BG = display.newImageRect( myGlobalData.imagePath.."background_"..(i+1)..".png", 360,570 )
				BG.x = myGlobalData._w /2; BG.y = (myGlobalData._h /2) - (i*570) -- Repeat the background, offsetting by 570 (myGlobalData._h )..
				cameraGroup:insert(BG) 				-- Insert the Backdrops into a Layer we'll control with the Camera Later
			end
		end
		
		-- Call the Background Scenery creation Function.
		createSceneBackdrops()
		
		------------------------------------------------------------------------------------------------------------------------------------
		-- Create the initial fixed Base and Blocks. We'll put these into the Background Group and move with the Camera too.
		------------------------------------------------------------------------------------------------------------------------------------
		local Base = display.newImageRect( myGlobalData.imagePath.."obj_blockbase.png", 178, 48 )
		Base.x = myGlobalData._w /2 -- Centre to the Screen
		Base.y = 408
		Base.myName = "hazard"
		physics.addBody( Base, "static", fixedAssetPhysics )
		cameraGroup:insert(Base)
		
		local FixedBlock1 = display.newImageRect( myGlobalData.imagePath.."obj_block1_2.png", 48, 48 )
		FixedBlock1.x = myGlobalData._w /2 -- Centre to the Screen
		FixedBlock1.y = 360
		FixedBlock1.myName = "block"
		physics.addBody( FixedBlock1, "static", fixedAssetPhysics )
		cameraGroup:insert(FixedBlock1)
		
		local FixedBlock2 = display.newImageRect( myGlobalData.imagePath.."obj_block1_1.png", 48, 48 )
		FixedBlock2.x = myGlobalData._w /2 -- Centre to the Screen
		FixedBlock2.y = 312
		FixedBlock2.myName = "block"
		physics.addBody( FixedBlock2, "static", fixedAssetPhysics )
		cameraGroup:insert(FixedBlock2)
		------------------------------------------------------------------------------------------------------------------------------------
		screenGroup:insert( cameraGroup ) -- Insert the cameraGroup into the SCENE group
	
		
		------------------------------------------------------------------------------------------------------------------------------------
		-- Create the Guide Bar.
		------------------------------------------------------------------------------------------------------------------------------------
		GuideBar = display.newImageRect( myGlobalData.imagePath.."guideGreen.png", 70, 570 )
		GuideBar.x = myGlobalData._w /2 -- Centre to the Screen
		GuideBar.y = myGlobalData._h /2
		if (showGuide==true)then
			GuideBar.alpha=1.0
		else
			GuideBar.alpha=0.0
		end
		screenGroup:insert(GuideBar)
	
		------------------------------------------------------------------------------------------------------------------------------------
		-- Place our BLOCKS up the screen.
		------------------------------------------------------------------------------------------------------------------------------------
		local function createBlocks ()
			
			math.randomseed( os.time() )

			for i = 0,numberOfBlocks do
				blockRand = rnd(1,3) -- Randomly choose 1 of 3 images in the group set for these blocks
				
				-- Here we are simply adding different VISUAL blocks the more we add.
				-- If you only had a few types of DROPPING OBJECTS - simply change this code
				-- to how fit with how ever many items you have.
				if (i<=7) then
					blockSet[i] = display.newImageRect( myGlobalData.imagePath.."obj_block1_"..blockRand..".png", 48, 48 )
				elseif (i>=8 and i<18) then
					blockSet[i] = display.newImageRect( myGlobalData.imagePath.."obj_block2_"..blockRand..".png", 48, 48 )
				else
					blockSet[i] = display.newImageRect( myGlobalData.imagePath.."obj_block3_"..blockRand..".png", 48, 48 )
				end
				
				-- Stagger the Boxes from the LEFT and RIGHT hand side of the screenGroup
				-- We'll use a MOD function % to see if the number returned is 1 or 0
				if (i%2 == 0) then
					-- Position to the Left
					blockSet[i].x = offScreenLeftStart
				else
					-- Position to the Right
					blockSet[i].x = offScreenRightStart + 28
				end
				
				blockSet[i].y = 169 - (i*48) 	-- Stagger the Blocks up the screen
				blockSet[i].id = i				-- Assign an ID number to the Block - We'll use this to determine the blocks actions.
				blockSet[i].myName = "block"
				blockSet[i].landed = false
				physics.addBody( blockSet[i], blockPhysics )
				blockSet[i].bodyType = "static"
				blocksGroup:insert(blockSet[i])
			end

			
		------------------------------------------------------------------------------------------------------------------------------------
		-- Place our HAZARDS on the Screen (Black and Yellow Bars) Hit these and it's over.
		------------------------------------------------------------------------------------------------------------------------------------
		local hazardAssetPhysics = { density=0.1, friction=1020, bounce=0 } -- Define some basic Physics attributes for our hazards
		hazard1 = display.newImageRect( myGlobalData.imagePath.."obj_hazard001.png", 96, 24 )
		hazard1.anchorX = 0.0
		hazard1.x = 0-30
		hazard1.y = 432
		if (showHazardBars==false) then
			hazard1.alpha = 0.0
		end
		hazard1.myName = "hazard"
		physics.addBody( hazard1, "static", hazardAssetPhysics )
		blocksGroup:insert(hazard1)
	
		hazard2 = display.newImageRect( myGlobalData.imagePath.."obj_hazard101.png", 96, 24 )
		hazard2.anchorX = 1.0
		hazard2.x = myGlobalData._w+30
		hazard2.y = 432
		if (showHazardBars==false) then
			hazard2.alpha = 0.0
		end
		hazard2.myName = "hazard"
		physics.addBody( hazard2, "static", hazardAssetPhysics )
		blocksGroup:insert(hazard2)
			
			
		screenGroup:insert( blocksGroup ) --Insert the Block Set into the SCENE group
			
		end --createBlocks
		
		createBlocks()
		blocksSetUp = true	
		
		------------------------------------------------------------------------------------------------------------------------------------
		-- Create the HUD Graphics and Layer Group (This Layer group WILL NOT be in the Camera Group)
		------------------------------------------------------------------------------------------------------------------------------------

		local HUD_Blocks = display.newImageRect( myGlobalData.imagePath.."ico_blocks.png", 36, 36 )
		HUD_Blocks.x = 22
		HUD_Blocks.y = 23
		hudGroup:insert(HUD_Blocks) --Insert the HUD actor into the Hud Layer Group
		
		local HUD_Target = display.newImageRect( myGlobalData.imagePath.."ico_target.png", 36, 36 )
		HUD_Target.x = myGlobalData._w - 22
		HUD_Target.y = 23
		hudGroup:insert(HUD_Target) --Insert the HUD actor into the Hud Layer Group
		
		-- Display the Score
		textScore = display.newText( score, 0, 0, native.systemFontBold, 24 )
		textScore:setTextColor( 255 )
		textScore.anchorX = 0		-- Graphics 2.0 Anchoring method
		textScore.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		
		textScore.x = (HUD_Blocks.x + (HUD_Blocks.width/2)) + 10
		textScore.y = 23
		hudGroup:insert( textScore )


		-- Display the HighScore
		textHighScore = display.newText( myGlobalData.highScore, 0, 0, native.systemFontBold, 24 )
		textHighScore:setTextColor( 255 )
		textHighScore.anchorX = 1		-- Graphics 2.0 Anchoring method
		textHighScore.anchorY = 0.5		-- Graphics 2.0 Anchoring method
		textHighScore.x = (HUD_Target.x - (HUD_Target.width/2)) - 10
		textHighScore.y = 23
		hudGroup:insert( textHighScore )
		
		-- Display the Countdown Ring 
		
		local gametimer = startTime * 1000
		ringObject = progressRing.new({
									     radius = 35,
									     bgColor = {0, 0, 0, 0.1},
									     ringColor = {1, 1, 1, 1},
									     ringDepth = .48,
									     time = gametimer,
									})

		ringObject.x = myGlobalData._w * 0.5
		ringObject.y = 40
		--ringObject.alpha = 0.8
		ringObject:goTo(1)

		ringObject:addEventListener("completed", onTimerComplete)
		hudGroup:insert( ringObject )

		local HUD_Timer = display.newImageRect( myGlobalData.imagePath.."ico_timer.png", 24, 24 )
		HUD_Timer.x = myGlobalData._w * 0.5
		HUD_Timer.y = ringObject.y
		hudGroup:insert(HUD_Timer) --Insert the HUD actor into the Hud Layer Group

		------------------------------------------------------------------------------------------------------------------------------------
		-- SHOW/HIDE the Hazard bars and Fall Indicator Path routine
		------------------------------------------------------------------------------------------------------------------------------------
		local function showHideGuideBar(event)
			if (event.phase == "began") then
				if (showGuide==true)then
					showGuide=false
					showHazardBars=false
					GuideBar.alpha=0.0
					hazard1.alpha=0.0
					hazard2.alpha=0.0
				else
					showGuide=true
					showHazardBars=false
					GuideBar.alpha=1.0
					hazard1.alpha=1.0
					hazard2.alpha=1.0
				end
				return true
			end
		end
		
		buttonShowGuide = display.newImageRect( myGlobalData.imagePath.."heart.png", 26, 26 )
		buttonShowGuide.x = 26

		if(myGlobalData.adsShow==true and myGlobalData.adBannersRequired==true) then
			buttonShowGuide.y = myGlobalData._h - 76
		else
			buttonShowGuide.y = myGlobalData._h - 26
		end

		buttonShowGuide.touch = showHideGuideBar
		hudGroup:insert( buttonShowGuide )
		buttonShowGuide:addEventListener( "touch", showHideGuideBar)
		------------------------------------------------------------------------------------------------------------------------------------


		------------------------------------------------------------------------------------------------------------------------------------
		-- We're also going to put the [GAME OVER] & [LEVEL WIN] screens into the HUD layer (Off screen)
		------------------------------------------------------------------------------------------------------------------------------------
		gameOverInfo = display.newImageRect( myGlobalData.imagePath.."gameOverScreen.png", 360,570 )
		gameOverInfo.x = myGlobalData._dw*2 -- Move Off screen until needed
		gameOverInfo.y = myGlobalData._dh/2
		gameOverInfo.alpha=0
		gameOverInfo.touch = restartTheLevel
		hudGroup:insert(gameOverInfo)

		levelWinInfo = display.newImageRect( myGlobalData.imagePath.."levelComplete.png", 360,570 )
		levelWinInfo.x = myGlobalData._dw*2 -- Move Off screen until needed
		levelWinInfo.y = myGlobalData._dh/2
		levelWinInfo.alpha=0
		levelWinInfo.touch = restartfromWin
		hudGroup:insert(levelWinInfo)


		gameOverInfo:addEventListener( "touch", restartTheLevel)
		levelWinInfo:addEventListener( "touch", restartfromWin)
		
		-- Add a GO HOME button
		hudGoHome = display.newImageRect( myGlobalData.imagePath.."ico_home.png", 26, 26 )
		hudGoHome.x = myGlobalData._w-26
		if(myGlobalData.adsShow==true and myGlobalData.adBannersRequired==true) then
			hudGoHome.y = myGlobalData._h - 76
		else
			hudGoHome.y = myGlobalData._h - 26
		end
		--buttonShowGuide.touch = hudGoHome
		hudGroup:insert( hudGoHome )
		hudGoHome:addEventListener( "touch", userQuitGame)


		screenGroup:insert( hudGroup ) --Insert the hudGroup into the SCENE group
		------------------------------------------------------------------------------------------------------------------------------------

	end --createTheSene Function

	
	------------------------------------------------------------------------------------------------------------------------------------
	-- Create the Main Scene
	------------------------------------------------------------------------------------------------------------------------------------
	createTheScene()
	
	------------------------------------------------------------------------------------------------------------------------------------
	-- Grab the start location of our Camera
	------------------------------------------------------------------------------------------------------------------------------------
	cameraStartPos = cameraGroup.y
	

	
end --end scene:createScene


------------------------------------------------------------------------------------------------------------------------------------
-- Called immediately after scene has moved onscreen:
------------------------------------------------------------------------------------------------------------------------------------
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
		composer.removeScene( "mainStart" )
		composer.removeScene( "mainLevelReset" )
		print("--Previous scene data removed from memory--")

		--Setup the smoke animation
		smokePuff = display.newSprite( myGlobalData.imagePuffSheet1, myGlobalData.animationSequencePuffData )
		smokePuff:setSequence( "puffAnimation" )
		smokePuff.x = myGlobalData._w/2
		smokePuff.y = myGlobalData._h-180
		blocksGroup:insert( smokePuff )


    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

		------------------------------------------------------------------------------------------------------------------------------------
		-- Start the BG Music - Looping
		------------------------------------------------------------------------------------------------------------------------------------
		audio.play(musicTrack, {channel=1, loops =-1})
		audio.stop(2)
		audio.rewind(2)

	    ---------------------------------------------------------------------------------
		-- If Ads are enabled - AND AdMob adverts are enabled - setup here.
		---------------------------------------------------------------------------------
		if ( myGlobalData.adsShow ) then
			if ( myGlobalData.ads_AdMobEnabled ) then
			    if ( myGlobalData.adIntersRequired ) then
			        --adsConfig.showAdmobInterstitialAd()
			    end

			    if ( myGlobalData.adBannersRequired ) then
			        adsConfig.showAdmobBannerAd( myGlobalData.bannerAd_Game_Position )
			    end
			end
		end
		---------------------------------------------------------------------------------

    end
	
end




------------------------------------------------------------------------------------------------------------------------------------
-- Routine to check for NEW HIGH SCORES
------------------------------------------------------------------------------------------------------------------------------------
local function checkForNewHighScore()
	if (score > myGlobalData.highScore) then
		myGlobalData.highScore = score
		textHighScore.text = score

		--Save the new highscore to the device
		saveDataTable.highScore  = myGlobalData.highScore
		loadsave.saveTable(saveDataTable, myGlobalData.saveDataFileName..".json")

	end

end

------------------------------------------------------------------------------------------------------------------------------------
-- Do we show the GAME OVER SCREENS?
------------------------------------------------------------------------------------------------------------------------------------
local function showGameOverScreen()


    ---------------------------------------------------------------------------------
    -- If Ads are enabled - Play a VUNGLE or ADMOB Interstitial Ad
    ---------------------------------------------------------------------------------
    local function showAds()
    	math.randomseed( os.time() )

		if ( myGlobalData.adsShow and myGlobalData.adShowFullOnGameOver and myGlobalData.adIntersRequired ) then
			local randomAd = math.random( 1,6 )
			
			if ( randomAd > 5 ) then -- If Greater than 4 we show the Vungle Ad
				print("Ad Numer > 5 - Preparing Vungle Ad")
				-- Show the Vungle Interstitial Ad
				if ( myGlobalData.ads_VungleEnabled ) then
					adsConfig.showVungleInterstitialAd()
				end
			else
				print("Ad Numer < 5 - Preparing Admob Ad")
				-- Show the AdMob Interstitial Ad
				if ( myGlobalData.ads_AdMobEnabled ) then
					adsConfig.showAdmobInterstitialAd()
				end
			end

		end
	end



	gameOverInfo.x = myGlobalData._dw/2 --Move info page back - onto the screen.
	transition.to ( gameOverInfo, {alpha=1.0, time=900, onComplete=showAds} )
	transition.to ( hudGoHome, {alpha=1.0, x=myGlobalData._w*0.5, time=300} )



end

------------------------------------------------------------------------------------------------------------------------------------
-- Do we show the GAME WIN Screens
------------------------------------------------------------------------------------------------------------------------------------
local function showWinScreen()

	Runtime:removeEventListener( "enterFrame", blocksMove )
	Runtime:removeEventListener ( "collision", onGlobalCollision )

	levelWinInfo.x = myGlobalData._dw/2 --Move info page back - onto the screen.
	transition.to ( levelWinInfo, {alpha=1.0, time=900} )
end


------------------------------------------------------------------------------------------------------------------------------------
-- Release the next block in the que
------------------------------------------------------------------------------------------------------------------------------------
local function releaseTheNextBlock()
	releaseBlock = false
	hazard1.y = hazard1.y-48
	hazard2.y = hazard2.y-48
	heightClimbed = heightClimbed + 48
end

------------------------------------------------------------------------------------------------------------------------------------
-- Game over routine. Move camera - call game over functions
------------------------------------------------------------------------------------------------------------------------------------
local function triggerGameOverFail()
	print("--Game Over--")

	hazard1.isSensor = true
	hazard2.isSensor = true

	checkForNewHighScore()

	audio.stop(1)
	audio.play(sndTowerFail, {channel=2})
	
	Runtime:removeEventListener( "enterFrame", blocksMove )
	Runtime:removeEventListener ( "collision", onGlobalCollision )

	--Move the Cameras back to the bottom
	transition.to (cameraGroup, {y=cameraStartPos, time=400+heightClimbed} )
	transition.to (blocksGroup, {y=cameraStartPos, time=400+heightClimbed} )
	timer.performWithDelay (1200, showGameOverScreen)	
end

------------------------------------------------------------------------------------
-- RING EVENT LISTENER
-- Triggered when the ring has completed.
------------------------------------------------------------------------------------
function onTimerComplete(event)
	print(event.name)
	countDownTime = 0
	releaseBlock = false
	gameOverBool = true
	triggerGameOverFail()
end


------------------------------------------------------------------------------------
-- Trigger go home
------------------------------------------------------------------------------------
function userQuitGame(event)
	ringObject:pause() 


	-- Handler that gets notified when the alert closes
	local function onComplete( event )
	    if ( event.action == "clicked" ) then
	        local i = event.index
	        if ( i == 1 ) then

				countDownTime = 0
				releaseBlock = false
				gameOverBool = true

				audio.stop(1)
				Runtime:removeEventListener( "enterFrame", blocksMove )
				Runtime:removeEventListener ( "collision", onGlobalCollision )

				audio.rewind( musicTrack )
				audio.rewind( sndTowerFail )
				composer.gotoScene( "mainStart", "crossFade",500 )


	        elseif ( i == 2 ) then
				ringObject:resume() 
	        end
	    end
	end

	-- Show alert with two buttons
	local alert = native.showAlert( "Quit Game", "Are you sure you want to quit the game?", { "Yes", "No" }, onComplete )



	return true

end


------------------------------------------------------------------------------------------------------------------------------------
-- This is our MAIN LISTENER to check for collisions
------------------------------------------------------------------------------------------------------------------------------------
local function onGlobalCollision( event )
	
	--print( "Collision: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision began" )

	if ( event.object1.myName =="block" and event.object2.myName =="block" and gameOverBool==false) then
		--box landed, increase its linear damping to remove JELLO effect...
		event.object1.linearDamping = 28
	elseif ( event.object1.myName =="hazard" and gameOverBool==false) then
		hitHazard = true
		event.object2.myName = "blockFailed"
	elseif (event.object2.myName =="hazard" and gameOverBool==false) then
		hitHazard = true
		event.object1.myName = "blockFailed"
	else
		hitHazard = false
	end

	if ( hitHazard == true) then
	
	print ("HIT Hazard - Call Game Over Routines")
		releaseBlock = false
		gameOverBool = true

		ringObject:pause() 

		triggerGameOverFail()
	end


	if ( event.phase == "began" and releaseBlock==true and gameOverBool==false and 
		 event.object1.myName == "block" and event.object2.myName == "block" and
		 event.object2.landed == false) then
		 
		blockSet[score].landed = true -- Set the LANDED flag of the block to true - this stops further Collision events firing
		audio.play(sndBoxLand)
		score = score + 1  --  Increment the Score + 1
		
		textScore.text = score
		checkForNewHighScore()
			
		smokePuff.x = blockSet[score-1].x
		smokePuff.y = blockSet[score-1].y
		smokePuff:play()						


		if (score==numberOfBlocks) then
			print("Call - Game WIN routine")
			releaseBlock = false
			gameOverBool = true
			ringObject:pause() 
			showWinScreen()
		else
			local oldY = cameraGroup.y
			local oldY2 = blocksGroup.y
			transition.to (cameraGroup, {y=oldY+48, time=200} )
			transition.to (blocksGroup, {y=oldY2+48, time=200} )
			timer.performWithDelay(200, releaseTheNextBlock )
		end

	end
end




------------------------------------------------------------------------------------------------------------------------------------
-- Move the Blocks left and right along the screen
------------------------------------------------------------------------------------------------------------------------------------
local function blocksMove (event)

	if (score<=numberOfBlocks) then
		if (blockSet[score].x ~= nil and blocksSetUp == true and releaseBlock == false and gameOverBool==false) then
					
			if blockSet[score].x > offScreenRight then
				blockMoveSpeed = -startSpeed - ((startTime/countDownTime)/speedMultiplyer)
			end
			
			if blockSet[score].x < offScreenLeft then
				blockMoveSpeed = startSpeed + ((startTime/countDownTime)/speedMultiplyer)
			end
			
			blockSet[score].x = blockSet[score].x + blockMoveSpeed
			
			-- Are we showing the Guide Bar indicator.
			-- If so track the bars position to the currently active block
			if (showGuide==true) then
				GuideBar.x = blockSet[score].x
			end
			
		end
	end	
end 

------------------------------------------------------------------------------------------------------------------------------------
-- Detect a TAP on the screen to trigger the next block being released.
------------------------------------------------------------------------------------------------------------------------------------
local function touch(event)
	if  (event.phase == 'began'and releaseBlock == false and gameOverBool == false and score<=numberOfBlocks ) then
		releaseBlock = true
		audio.play(sndBoxDrop)
		blockSet[score].bodyType = "dynamic"
		blockSet[score].angularDamping = 8
	end
	
	if  (event.phase == 'ended' and gameOverBool == false ) then
	end

end




------------------------------------------------------------------------------------------------------------------------------------
-- Lets get this party Started
------------------------------------------------------------------------------------------------------------------------------------
cameraGroup:addEventListener( "touch", touch)
Runtime:addEventListener( "enterFrame", blocksMove )
Runtime:addEventListener ( "collision", onGlobalCollision )




-- Called when scene is about to move offscreen:
function scene:hide( event )
	audio.rewind(musicTrack)
	
	cameraGroup:removeEventListener( "touch", cameraGroup)
	Runtime:removeEventListener( "enterFrame", blocksMove )
	Runtime:removeEventListener ( "collision", onGlobalCollision )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------


return scene