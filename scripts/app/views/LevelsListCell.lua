
local ScrollViewCell = import("..ui.ScrollViewCell")
local LevelsListCell = class("LevelsListCell", ScrollViewCell)

function LevelsListCell:ctor(size, beginLevelIndex, endLevelIndex, rows, cols)
    local rowHeight = math.floor((display.height - 340) / rows)
    local colWidth = math.floor(display.width * 0.9 / cols)

    local batch = display.newBatchNode(GAME_TEXTURE_IMAGE_FILENAME)
    self:addChild(batch)
    self.pageIndex = pageIndex
    self.beginLevelIndex = beginLevelIndex
    self.endLevelIndex = endLevelIndex
    self.buttons = {}

    local startX = (display.width - colWidth * (cols - 1)) / 2
    local y = display.top - 220
    local levelIndex = beginLevelIndex

    for row = 1, rows do
        local x = startX
        for column = 1, cols do
            local icon = display.newSprite("#LockedLevelIcon.png", x, y)
            batch:addChild(icon)
            icon.levelIndex = levelIndex 
            self.buttons[#self.buttons + 1] = icon

            local label = ui.newBMFontLabel({
                text  = tostring(levelIndex),
                font  = "UIFont.fnt",
                x     = x,
                y     = y - 4,
                align = ui.TEXT_ALIGEN_CENTER,
            })
            self:addChild(label)

            x = x + colWidth
            levelIndex = levelIndex + 1
            if levelIndex > endLevelIndex then break end
        end

        y = y - rowHeight
        if levelIndex > endLevelIndex then break end
    end

    -- add highlight level icon
    self.highlightButton = display.newSprite("#HighlightLevelIcon.png")
    self.highlightButton:setVisible(false)
    self:addChild(self.highlightButton)

    -- self:addEventListener("CHECK_LEVEL_LOCK", handler(self, self.checkLevelLock))
    -- CCNotificationCenter:sharedNotificationCenter():registerScriptObserver(self,handler(self, self.checkLevelLock),"CHECK_LEVEL_LOCK")
end

function LevelsListCell:checkUnlockLevel()
    for i,v in ipairs(self.buttons) do
        if v.levelIndex <= GameData.levelIndex then
            local icon = display.newSpriteFrame("UnlockedLevelIcon.png")    
            v:setDisplayFrame(icon)        
        end
    end
end

function LevelsListCell:onTouch(event, x, y)
    if event == "began" then
        local button = self:checkButton(x, y)
        if button then
            if button.levelIndex <= GameData.levelIndex then                    
                self.highlightButton:setVisible(true)
                self.highlightButton:setPosition(button:getPosition())
            end
        end
    elseif event ~= "moved" then
        self.highlightButton:setVisible(false)
    end
end

function LevelsListCell:onTap(x, y)
    local button = self:checkButton(x, y)
    if button then
        if button.levelIndex <= GameData.levelIndex then
            self:dispatchEvent({name = "onTapLevelIcon", levelIndex = button.levelIndex})
        end
    end
end

function LevelsListCell:checkButton(x, y)
    local pos = CCPoint(x, y)
    for i = 1, #self.buttons do
        local button = self.buttons[i]
        if button:getBoundingBox():containsPoint(pos) then
            return button
        end
    end
    return nil
end

return LevelsListCell
