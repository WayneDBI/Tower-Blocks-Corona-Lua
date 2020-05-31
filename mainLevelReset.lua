------------------------------------------------------------------------------------------------------------------------------------
-- Tower Blocks Template
-- Version 5.0
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http://www.deepblueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
-- Abstract: Drop the blocks onto the blocks below to form a tower.
-- Be careful to accurately place the blocks else they'll all come falling down.
------------------------------------------------------------------------------------------------------------------------------------
-- mainLevelReset.lua
-- Corona 2016.2906 compatible
------------------------------------------------------------------------------------------------------------------------------------
-- 24th August 2016
------------------------------------------------------------------------------------------------------------------------------------

local composer 	= require( "composer" )
local scene 	= composer.newScene()


------------------------------------------------------------------------------------------------------------------------------------
-- This scene simply lets us PURGE the level and do a reset.
------------------------------------------------------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
	
	print("Level reset scene loaded....")
	composer.removeScene( "mainLevel1" )
	
	
	local function reset()
		composer.gotoScene( "mainLevel1", "crossFade",100 )
	end

	------------------------------------------------------------------------------------------------------------------------------------
	-- IMPORTANT: This timer delay, gives the Storyboard API time to PURGE the previous Scene.
	------------------------------------------------------------------------------------------------------------------------------------
	timer.performWithDelay(10, reset )
	
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view
	composer.removeScene( "mainLevel1" )
	
end


-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroy( event )
	local group = self.view
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