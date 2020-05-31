------------------------------------------------------------------------------------------------------------------------------------
-- Tower Blocks Template
-- Version 5.0
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http://www.deepblueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
-- Abstract: Drop the blocks onto the blocks below to form a tower.
-- Be careful to accurately place the blocks else they'll all come falling down.
------------------------------------------------------------------------------------------------------------------------------------
-- mainStart.lua
-- Corona 2016.2906 compatible
------------------------------------------------------------------------------------------------------------------------------------
-- 24th August 2016
------------------------------------------------------------------------------------------------------------------------------------

local composer 		= require( "composer" )
local scene 		= composer.newScene()
local myGlobalData 	= require( "lib.globalData" )

local adsConfig     = require( "adsLibrary" )


local startScreenImage
local instructionsImage
local infoPage 		= 0


-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
	local screenGroup = self.view
	
	------------------------------------------------------------------------------------------------------------------------------------
	-- IMPORTANT: We need to draw something into the ScreeGroup to avoid a crash on pre 2012.762 Corona SDK
	------------------------------------------------------------------------------------------------------------------------------------
		local duffObjectForBug = display.newRect(0,0,1,1)
		duffObjectForBug:setFillColor(255,255,255,0)
		screenGroup:insert( duffObjectForBug )

		function startGame()
			-- load first screen
			startScreenImage:removeSelf()
			startScreenImage=nil
			instructionsImage:removeSelf()
			instructionsImage=nil
			composer.gotoScene( "mainLevel1", "crossFade", 800 )
		end
		
		
		local function onSceneTouch(event)
			if  (event.phase == 'ended' ) then
				
				-- Here we are going to work out which image to show the user
				-- based on how many touches have been received so far.
				-- When we get to touch number 2 - we start the game.
				infoPage = infoPage + 1
				if (infoPage==1) then
					instructionsImage.x = display.contentWidth/2 --Move info page back - onto the screen.
					transition.to ( instructionsImage, {alpha=1.0, time=600} )
				elseif  (infoPage==2) then
					startGame()
				end
				
			end
		end
		
		---------------------------------------------------------------------------------
		-- Set up the Start and Info Screens
		---------------------------------------------------------------------------------
		startScreenImage = display.newImageRect( myGlobalData.imagePath.."menuScreen.png", 360,570 )
		startScreenImage.x = display.contentWidth/2 -- Centre on Screen
		startScreenImage.y = display.contentHeight/2
		startScreenImage.touch = onSceneTouch
		screenGroup:insert(startScreenImage)
		
		instructionsImage = display.newImageRect( myGlobalData.imagePath.."gameInstructions.png", 360,570 )
		instructionsImage.x = display.contentWidth*2 -- Move Off scree for start procedure
		instructionsImage.y = display.contentHeight/2
		instructionsImage.alpha=0
		instructionsImage.touch = onSceneTouch
		screenGroup:insert(instructionsImage)
		
		---------------------------------------------------------------------------------
		-- Set up Listener events for the images
		---------------------------------------------------------------------------------
		startScreenImage:addEventListener( "touch", onSceneTouch)
		instructionsImage:addEventListener( "touch", onSceneTouch)
		---------------------------------------------------------------------------------
	
	    ---------------------------------------------------------------------------------
        -- If Ads are enabled - AND AdMob adverts are enabled - setup here.
        ---------------------------------------------------------------------------------
        if ( myGlobalData.adsShow ) then
            if ( myGlobalData.ads_AdMobEnabled ) then
                if ( myGlobalData.adIntersRequired ) then
                --adsConfig.showAdmobInterstitialAd()
                end

                if ( myGlobalData.adBannersRequired ) then
                    adsConfig.showAdmobBannerAd( myGlobalData.bannerAd_Menu_Position )
                end
            end
        end


end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	--storyboard.purgeScene( "main" )
	composer.removeScene( "mainLevel1" )
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
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