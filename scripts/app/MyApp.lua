
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")
GameState=require(cc.PACKAGE_NAME .. ".api.GameState")

GameData={}     
levelIndex = 0

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}

    --init GameState
    GameState.init(function(param)
        local returnValue = nil
        if param.errorCode then
            print("GameState error")
        else
        -- crypto
        if param.name=="save" then
            local str=json.encode(param.values)
            str=crypto.encryptXXTEA(str, "abcd")
            returnValue={data=str}
        elseif param.name=="load" then
            local str=crypto.decryptXXTEA(param.values.data, "abcd")
            returnValue=json.decode(str)
        end
        -- returnValue=param.values
    end
    return returnValue
    end, "data.txt","1234")

    GameData = GameState.load()
    if not GameData then
        GameData={}         
        GameData.levelIndex = 1
        GameState.save(GameData)
    end

    levelIndex = GameData.levelIndex
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

    -- preload all sounds
    for k, v in pairs(GAME_SFX) do
        audio.preloadSound(v)
    end

    self:enterMenuScene()
end

function MyApp:enterMenuScene()
    self:enterScene("MenuScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterMoreGamesScene()
    self:enterScene("MoreGamesScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:enterChooseLevelScene()
    self:enterScene("ChooseLevelScene", nil, "fade", 0.6, display.COLOR_WHITE)
end

function MyApp:playLevel(levelIndex)
    self:enterScene("PlayLevelScene", {levelIndex}, "fade", 0.6, display.COLOR_WHITE)
end

return MyApp
