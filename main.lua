require 'src/Dependencies' 

local screenWidth, screenHeight = love.window.getDesktopDimensions()

function love.load()
    
    -- push:setupScreen(WINDOW_WIDTH,WINDOW_HEIGHT,screenWidth, screenHeight, {
    --     fullscreen = true,
    --     vsync = true,
    --     resizable = false,
    --     stretched = true
    -- }) 

VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

local screenWidth, screenHeight = love.window.getDesktopDimensions() 

TERMINAL_WIDTH = 700
TERMINAL_HEIGHT = 500
TERMINAL_X = 100
TERMINAL_Y = 300 

TERMINAL_X = (1280 - TERMINAL_WIDTH) / 2
TERMINAL_Y = (720 - TERMINAL_HEIGHT) / 2 

lastStickY = 0
stickCooldown = 0
stickThreshold = 0.5


love.window.setMode(screenWidth, screenHeight, {fullscreen = true})

scaleX = screenWidth / VIRTUAL_WIDTH
scaleY = screenHeight / VIRTUAL_HEIGHT


    gStateStack = StateStack()
    gStateStack:push(MainMenu()) 
    -- keep track of keypressed
    love.keyboard.keysPressed = {}
end

function love.update(dt)
    gStateStack:update(dt) 

    -- Cooldown to prevent repeated fast movement
    if stickCooldown > 0 then
        stickCooldown = stickCooldown - dt
    end

    local joystick = love.joystick.getJoysticks()[1]
    if joystick and terminal.state == "question" and not terminal.typing.active and not terminal.typing.delay then
        local y = joystick:getAxis(2) -- Y axis of left stick

        if y > stickThreshold and lastStickY <= stickThreshold and stickCooldown <= 0 then
            -- simulate keypress "down"
            love.keypressed("down")
            stickCooldown = 0.25
        elseif y < -stickThreshold and lastStickY >= -stickThreshold and stickCooldown <= 0 then
            -- simulate keypress "up"
            love.keypressed("up")
            stickCooldown = 0.25
        end

        lastStickY = y
    end
    love.keyboard.keysPressed = {}
end  

-- function love.resize(w, h)
--     push:resize(w, h)
    
-- end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true 

    if terminal.typing.active or terminal.typing.delay then
        return
    end

    local options = getCurrentQuestions()

    if terminal.state == "question" then
        if key == "down" then
            terminal.selected = terminal.selected % #options + 1
        elseif key == "up" then
            terminal.selected = (terminal.selected - 2 + #options) % #options + 1
        elseif key == "space" then
            local selected = options[terminal.selected]
            addToLog("> User selected: " .. selected.text)
            addToLog("[Processing...]")

            -- ✅ Lock answer domain on Round 1
            if terminal.round == 1 then
                terminal.answerDomain = selected.domain
            end

            -- ✅ Always use answers from locked domain
            local answer = getAnswerFromDomain(terminal.answerDomain, terminal.round)

            terminal.typing.delay = true
            terminal.typing.delayText = answer
            terminal.state = "answer"
        end
    elseif terminal.state == "answer" then
        terminal.round = terminal.round + 1
        local nextQ = getCurrentQuestions()
        if #nextQ > 0 then
            addToLog("")
            addToLog("> ---- Round " .. terminal.round .. " ----")
            addToLog("")
            terminal.selected = 1
            terminal.state = "question"
        else
            addToLog("> [Session Terminated]")
            terminal.state = "done"
        end
    end 

    
end   



function love.joystickpressed(joystick, button) 

    if button == 1 then -- 'A' button on Xbox/generic controllers
        love.keyboard.keysPressed['x'] = true
    elseif button == 2 then -- If you want 'g' for another button
        love.keyboard.keysPressed['g'] = true
    end  

    -- A (1) or X (3) = simulate "space"
    if button == 3 then
        love.keypressed("space")
    end

    
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    --push:start() 
    love.graphics.scale(scaleX, scaleY)
    gStateStack:render() 
   -- push:finish()
end
