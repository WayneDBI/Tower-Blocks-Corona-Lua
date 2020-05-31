------------------------------------------------------------------------------------------------------------------------------------
-- Tower Blocks Template
-- Version 5.0
------------------------------------------------------------------------------------------------------------------------------------
-- Developed by Deep Blue Ideas.com [http://www.deepblueideas.com]
------------------------------------------------------------------------------------------------------------------------------------
-- Abstract: Drop the blocks onto the blocks below to form a tower.
-- Be careful to accurately place the blocks else they'll all come falling down.
------------------------------------------------------------------------------------------------------------------------------------
-- main.lua
-- Corona 2016.2906 compatible
------------------------------------------------------------------------------------------------------------------------------------
-- 24th August 2016
------------------------------------------------------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local composer 		= require "composer"
local physics 		= require( "physics" )
local myGlobalData 	= require( "lib.globalData" )
local loadsave 		= require( "lib.loadsave" )
local device 		= require( "lib.device" )

---------------------------------------------------------------------------------
-- Setup Ads integration
-- Note: For the purposes of this template only Ad-Mob V2 has been integrated
-- Add Apple iAds, Vungle, RevMob etc as required.
---------------------------------------------------------------------------------
myGlobalData.adsShow					= true
myGlobalData.ads_AdMobEnabled			= true  -- Are we showing ads in the app?
myGlobalData.ads_VungleEnabled			= true 	-- Are Vungle Video ads Enabled?
myGlobalData.adBannersRequired			= true 	-- Are Banner Ads required?
myGlobalData.adIntersRequired			= true 	-- Are Interstitial Ads Required?
myGlobalData.adShowFullOnGameOver		= true 	-- Show Interstitial on Game Over?
---------------------------------------------------------------------------------
myGlobalData.bannerAppID                = ""  --leave as is - configure variables below
myGlobalData.interstitialAppID          = ""  --leave as is - configure variables below
myGlobalData.vungleAd 					= ""  --leave as is - configure variables below
---------------------------------------------------------------------------------
myGlobalData.adMob_Banner_iOS           = "ca-app-pub-1618794709010396/8748539063"  --for your AdMob iOS banner
myGlobalData.adMob_Interstitial_iOS     = "ca-app-pub-1618794709010396/2702005464"  --for your AdMob iOS interstitial
myGlobalData.adMob_RewardVideo_iOS     	= "ca-app-pub-1618794709010396/8763068661"  --for your AdMob iOS Reward Video
---------------------------------------------------------------------------------
myGlobalData.adMob_Banner_Android       = "ca-app-pub-1618794709010396/2856135869"  --for your AdMob Android banner
myGlobalData.adMob_Interstitial_Android = "ca-app-pub-1618794709010396/4332869068"  --for your AdMob Android interstitial
myGlobalData.adMob_RewardVideo_Android 	= "ca-app-pub-1618794709010396/5809602267"  --for your AdMob Android Reward Video
---------------------------------------------------------------------------------
myGlobalData.vungleAd_iOS               = "5714ddcaea00e90120000009"	-- your Vungle iOS Ads ID
myGlobalData.vungleAd_Android           = "5714de617e6ce0781e0000c5"	-- your Vungle Android Ads ID

myGlobalData.bannerAd_Menu_Position     = "bottom"	-- Position of Banner Ads (top, bottom)
myGlobalData.bannerAd_Game_Position     = "bottom"	-- Position of Banner Ads (top, bottom)
---------------------------------------------------------------------------------
local adsConfig  						= require( "adsLibrary" )

---------------------------------------------------------------------------------
--<< Start Ads initialisation----------------------------------------------------
---------------------------------------------------------------------------------
-- If Ads are enabled - AND AdMob adverts are enabled - setup here.
---------------------------------------------------------------------------------
if ( myGlobalData.adsShow == true ) then
   
	------------------------------------------------------------------------------
	--Initialise Ad Mob ads if enabled.
	------------------------------------------------------------------------------
    if ( myGlobalData.ads_AdMobEnabled ) then
		
		--------------------------------------------------------------------------
	    --Pre load the AdMob Interstitial ads
		--------------------------------------------------------------------------
		if (myGlobalData.adIntersRequired ) then
			adsConfig.initAdmobInterstitialAd()
	        adsConfig.loadAdmobInterstitialAd()
	    end
		--------------------------------------------------------------------------

		--------------------------------------------------------------------------
		--Initialise Banner Ads - if enabled.
		--------------------------------------------------------------------------
	    if ( myGlobalData.adBannersRequired ) then
	        --Pre load the AdMob Banner ads
			adsConfig.initAdmobBannerAd()	    
	    end
		--------------------------------------------------------------------------

	end

	--------------------------------------------------------------------------
	--Initialise Vungle ads if enabled.
 	--------------------------------------------------------------------------
	if ( myGlobalData.ads_VungleEnabled) then
    	adsConfig.initVungleInterstitialAd()
    end
 	--------------------------------------------------------------------------

end
--<< End Ads initialisation----------------------------------------------------------


---------------------------------------------------------------------------------
-- Setup Game Global variables to share thoughout the game engine
---------------------------------------------------------------------------------

myGlobalData.audioPath	= "assets/audio/"
myGlobalData.audioType	= "mp3"
myGlobalData.imagePath	= "assets/images/"

myGlobalData.sheetPuffInfo1 = require("smokePuffSpritesheet")
myGlobalData.imagePuffSheet1 = graphics.newImageSheet( myGlobalData.imagePath.."smokePuffSpritesheet.png", myGlobalData.sheetPuffInfo1:getSheet() )
myGlobalData.animationSequencePuffData = {
  { name = "puffAnimation", sheet=imagePuffSheet1, frames={ 10,1,2,3,4,5,6,7,8,9,10 }, time=800, loopCount=1 },
}

myGlobalData.adsShow	= true

myGlobalData._w 		= display.actualContentWidth  	-- Get the devices Width
myGlobalData._h 		= display.actualContentHeight 					-- Get the devices Height
myGlobalData._cw 		= display.actualContentWidth * 0.5 	-- Get the devices Width
myGlobalData._ch 		= display.actualContentHeight * 0.5					-- Get the devices Height
myGlobalData._dw 		= display.contentWidth  	-- Get the devices Width
myGlobalData._dh 		= display.contentHeight 					-- Get the devices Height
myGlobalData._cdw 		= display.contentWidth * 0.5   	-- Get the devices Width
myGlobalData._cdh 		= display.contentHeight * 0.5  					-- Get the devices Height

---------------------------------------------------------------------------------
-- Setup Audio Volumes and variables
--------------------------------------------------------------------------------
myGlobalData.volumeSFX				= 0.8							-- Define the SFX Volume
myGlobalData.volumeMusic			= 0.8							-- Define the Music Volume
myGlobalData.resetVolumeSFX			= myGlobalData.volumeSFX		-- Define the SFX Volume Reset Value
myGlobalData.resetVolumeMusic		= myGlobalData.volumeMusic		-- Define the Music Volume Reset Value
myGlobalData.soundON				= true							-- Is the sound ON or Off?
myGlobalData.musicON				= true							-- Is the sound ON or Off?
audio.setVolume( myGlobalData.volumeMusic, 	{ channel=0 } ) -- set the volume on channel 1
audio.setVolume( myGlobalData.volumeMusic, 	{ channel=1 } ) -- set the volume on channel 1
audio.setVolume( myGlobalData.volumeMusic, 	{ channel=2 } ) -- set the volume on channel 2
audio.setVolume( myGlobalData.volumeMusic, 	{ channel=3 } ) -- set the volume on channel 3

for i = 4, 32 do
	audio.setVolume( myGlobalData.volumeSFX, { channel=i } )
end 
-- Reserve channels 1 - 4 for the Music. All Other channels can be used for SFX Audio
audio.reserveChannels( 4 )

---------------------------------------------------------------------------------
-- Setup Scaling factors if required.
--------------------------------------------------------------------------------
myGlobalData.factorX				= 0.4166	
myGlobalData.factorY				= 0.46875	

---------------------------------------------------------------------------------
-- Save / Load game data
--------------------------------------------------------------------------------
_G.saveDataTable					= {}							-- Define the Save/Load base Table to hold our data
myGlobalData.saveDataFileName		= "dbi_TowerBlock005"		 	-- Save file name in JSON format on the device
---------------------------------------------------------------------------------
-- Load in the saved data to our game table
-- Check the files exists before !
---------------------------------------------------------------------------------
if loadsave.fileExists(myGlobalData.saveDataFileName..".json", system.DocumentsDirectory) then
	saveDataTable = loadsave.loadTable(myGlobalData.saveDataFileName..".json")
else
	saveDataTable.currentLevel 			= 1
	saveDataTable.highesetLevel			= 1
	saveDataTable.highScore 			= 0
	saveDataTable.adsShow 				= myGlobalData.adsShow
	---------------------------------------------------------------------------------
	-- Save the new json file, for referencing later..
	---------------------------------------------------------------------------------
	loadsave.saveTable(saveDataTable, myGlobalData.saveDataFileName..".json")
end
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Load in the Data
---------------------------------------------------------------------------------
saveDataTable = loadsave.loadTable(myGlobalData.saveDataFileName..".json")
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Assign the Level and other variables to the game variables.
---------------------------------------------------------------------------------
myGlobalData.currentLevel				= saveDataTable.currentLevel 	-- Saved Level value
myGlobalData.highesetLevel				= saveDataTable.highesetLevel 	-- Saved Highest level reached
myGlobalData.highScore					= saveDataTable.highScore 		-- Saved highscore

---------------------------------------------------------------------------------
-- Surpress the print statements?
---------------------------------------------------------------------------------
myGlobalData.supressPrint 				= false							-- Surpress PRINT statements?
if (myGlobalData.supressPrint) then
	_G.print = function() end 
end




---------------------------------------------------------------------------------
-- Enable debug by setting to [true] to see FPS and Memory usage.
---------------------------------------------------------------------------------
myGlobalData.doDebug 					= false	-- show the Memory and FPS box?

if (myGlobalData.doDebug) then
	composer.isDebug = true
	local fps = require("lib.fps")
	local performance = fps.PerformanceOutput.new();
	performance.group.x, performance.group.y = (display.contentWidth/2)-50,  display.contentWidth/2-70;
	performance.alpha = 0.3; -- So it doesn't get in the way of the rest of the scene
end



---------------------------------------------------------------------------------
-- Establish which device the game is being run on.
---------------------------------------------------------------------------------
if ( device.isApple ) then
	myGlobalData.Android	= false
	print("Running on iOS")	
	if ( device.is_iPad ) then
		myGlobalData.iPad = true
		print("Device Type: iPad")
	else
		myGlobalData.iPad = false
		if (display.pixelHeight > 960) then
			myGlobalData.iPhone5 = true
			print("Device Type: iPhone 5-6")
		else
			myGlobalData.iPhone5 = false
			print("Device Type: iPhone 3-4")
		end
	end
else
	myGlobalData.Android = true
	myGlobalData.iPad = false
	myGlobalData.iPhone5 = false
	print("Running on Android")
end



------------------------------------------------------------------------------------------------------------------------------------
-- Call the START GAME Function
------------------------------------------------------------------------------------------------------------------------------------
function startGame()	
	composer.gotoScene( "mainStart", "crossFade", 800 )
end


------------------------------------------------------------------------------------------------------------------------------------
--Start Game after a short delay.
------------------------------------------------------------------------------------------------------------------------------------
timer.performWithDelay(100, startGame )


------------------------------------------------------------------------------------------------------------------------------------
-- Define some globally loaded / accesible Audio Assets
------------------------------------------------------------------------------------------------------------------------------------
sndBoxDrop 		= audio.loadSound( myGlobalData.audioPath..myGlobalData.audioType.."/".."BoxDrop".."."..myGlobalData.audioType )
sndBoxLand 		= audio.loadSound( myGlobalData.audioPath..myGlobalData.audioType.."/".."BoxLand".."."..myGlobalData.audioType )
sndFail 		= audio.loadSound( myGlobalData.audioPath..myGlobalData.audioType.."/".."Fail".."."..myGlobalData.audioType )
sndTowerFail	= audio.loadSound( myGlobalData.audioPath..myGlobalData.audioType.."/".."TowerFalls".."."..myGlobalData.audioType )
musicTrack 		= audio.loadSound( myGlobalData.audioPath..myGlobalData.audioType.."/".."bgMusic".."."..myGlobalData.audioType )

