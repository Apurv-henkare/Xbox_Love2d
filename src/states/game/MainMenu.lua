--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]] MainMenu = Class {
    __includes = BaseState
}

-- glevel=0

-- whether we're highlighting "Start" or "High Scores"
local highlighted = 1

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('Image/Starry_night_Layer_8.png')
local background2 = love.graphics.newImage('Image/Starry_night_Layer_7.png') 
local background3 = love.graphics.newImage('Image/Starry_night_Layer_6.png') 
local background4 = love.graphics.newImage('Image/Starry_night_Layer_5.png')
local backgroundScroll = 0
local backgroundScroll2 = 0 
local backgroundScroll3 = 0

-- ground image and starting scroll location (X axis)
-- local ground = love.graphics.newImage('ground.png')
-- local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 50
local BACKGROUND_SCROLL_SPEED2 = 80
local BACKGROUND_SCROLL_SPEED3 = 120
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 1280

function MainMenu:init()

    self.bg2 = 0
    -- self.image = love.graphics.newImage ('Images/safeimagekit-batch-court.png')
    -- self.bg2_image = love.graphics.newImage('sprites/planet.png')

end

function MainMenu:update(dt)

    self.bg2 = (self.bg2 + 100 * dt) % 4500

    -- toggle highlighted option if we press an arrow key up or down
    if love.keyboard.wasPressed('up') then
        if highlighted == 1 then
            highlighted = 5
        end

        highlighted = (highlighted - 1) % 5
        -- gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('down') then
        if highlighted == 4 then
            highlighted = 0
        end
        highlighted = (highlighted + 1) % 5
        -- gSounds['paddle-hit']:play()
    end

    -- confirm whichever option we have selected to change screens
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- gSounds['confirm']:play()

        if highlighted == 1 then

            gStateStack:pop()
            gStateStack:push(Intro())
            -- gStateStack:push(DialogueState())

        elseif highlighted == 2 then
            -- gStateStack:pop()
            -- gStateStack:push(Instructions())
        elseif highlighted == 3 then
            -- gStateStack:pop()
            -- gStateStack:push(Credit())

        elseif highlighted == 4 then
            -- gStateStack:pop()
            -- gStateStack:push(End()) 
            love.event.quit()
        end

    end

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    backgroundScroll2 = (backgroundScroll2 + BACKGROUND_SCROLL_SPEED2 * dt) % BACKGROUND_LOOPING_POINT
    backgroundScroll3 = (backgroundScroll3 + BACKGROUND_SCROLL_SPEED3 * dt) % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    -- groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH 
    print(highlighted)

end

function MainMenu:render()

    love.graphics.setColor(1, 1, 1, 0.95)

    -- love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.draw(self.image,0,0)  
    love.graphics.draw(background,0,0) 
    love.graphics.draw(background2,-backgroundScroll,0)
    love.graphics.draw(background2,1280-backgroundScroll)  

    love.graphics.draw(background3,-backgroundScroll2,0)
    love.graphics.draw(background3,1280-backgroundScroll2)  

    love.graphics.draw(background4,-backgroundScroll3,0)
    love.graphics.draw(background4,1280-backgroundScroll3) 

    

    -- love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.setFont(love.graphics.newFont('eight-bit-dragon.otf', 30))
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Amdocs Innovation Club", 0, VIRTUAL_HEIGHT / 2 + 50 - 250, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(love.graphics.newFont('eight-bit-dragon.otf', 20))
    if highlighted == 1 then
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 50 - 70, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf("INSTRUCTIONS", 0, VIRTUAL_HEIGHT / 2 + 100 - 70, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
    if highlighted == 3 then
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end
    love.graphics.printf("CREDITS", 0, VIRTUAL_HEIGHT / 2 + 150 - 70, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 4 then
        love.graphics.setColor(103 / 255, 1, 1, 1)
    end

    love.graphics.printf("EXIT", 0, VIRTUAL_HEIGHT / 2 + 200 - 70, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1) 

    --love.graphics.print(WINDOW_WIDTH,300,300)

end
