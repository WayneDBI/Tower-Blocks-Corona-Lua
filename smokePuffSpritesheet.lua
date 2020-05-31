--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:7d02212c426aa1173f01ff272b0b08b6:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- puff1
            x=209,
            y=74,
            width=60,
            height=54,

            sourceX = 33,
            sourceY = 21,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff2
            x=125,
            y=74,
            width=82,
            height=74,

            sourceX = 25,
            sourceY = 1,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff3
            x=2,
            y=2,
            width=107,
            height=76,

            sourceX = 7,
            sourceY = 0,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff4
            x=125,
            y=150,
            width=115,
            height=72,

            sourceX = 3,
            sourceY = 3,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff5
            x=2,
            y=80,
            width=121,
            height=72,

            sourceX = 1,
            sourceY = 4,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff6
            x=111,
            y=2,
            width=121,
            height=70,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff7
            x=2,
            y=154,
            width=117,
            height=61,

            sourceX = 3,
            sourceY = 5,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff8
            x=2,
            y=217,
            width=115,
            height=56,

            sourceX = 4,
            sourceY = 5,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff9
            x=119,
            y=224,
            width=78,
            height=54,

            sourceX = 40,
            sourceY = 3,
            sourceWidth = 122,
            sourceHeight = 76
        },
        {
            -- puff10
            x=1,
            y=1,
            width=1,
            height=1,

            sourceX = 1,
            sourceY = 31,
            sourceWidth = 1,
            sourceHeight = 1
        },
    },
    
    sheetContentWidth = 280,
    sheetContentHeight = 280
}

SheetInfo.frameIndex =
{

    ["puff1"] = 1,
    ["puff2"] = 2,
    ["puff3"] = 3,
    ["puff4"] = 4,
    ["puff5"] = 5,
    ["puff6"] = 6,
    ["puff7"] = 7,
    ["puff8"] = 8,
    ["puff9"] = 9,
    ["puff10"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
