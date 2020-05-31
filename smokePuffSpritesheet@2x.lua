--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:ab4961e7b4ea9b5d7f6ef79d2636ac14:1/1$
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
            x=418,
            y=148,
            width=120,
            height=108,

            sourceX = 66,
            sourceY = 42,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff2
            x=250,
            y=148,
            width=164,
            height=148,

            sourceX = 50,
            sourceY = 2,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff3
            x=4,
            y=4,
            width=214,
            height=152,

            sourceX = 14,
            sourceY = 0,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff4
            x=250,
            y=300,
            width=230,
            height=144,

            sourceX = 6,
            sourceY = 6,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff5
            x=4,
            y=160,
            width=242,
            height=144,

            sourceX = 2,
            sourceY = 8,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff6
            x=222,
            y=4,
            width=242,
            height=140,

            sourceX = 0,
            sourceY = 8,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff7
            x=4,
            y=308,
            width=234,
            height=122,

            sourceX = 6,
            sourceY = 10,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff8
            x=4,
            y=434,
            width=230,
            height=112,

            sourceX = 8,
            sourceY = 10,
            sourceWidth = 243,
            sourceHeight = 152
        },
        {
            -- puff9
            x=238,
            y=448,
            width=156,
            height=108,

            sourceX = 80,
            sourceY = 6,
            sourceWidth = 243,
            sourceHeight = 152
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
    
    sheetContentWidth = 560,
    sheetContentHeight = 560
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
