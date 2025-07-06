PlayState = Class {
    __includes = BaseState
}

function PlayState:init()

    self.image = love.graphics.newImage('Image/bg.png')
    self.player = Player()
    self.wall = love.graphics.newImage('Wall.png')
    self.flag = false
    bot = {
        x = 4000,
        y = 1000,
        speed = 140,
        width = 50,
        height = 5,
        direction = 1
    }

    circleBot = {
        centerX = 3800,
        centerY = 1200,
        radius = 100,
        angle = 0,
        speed = math.rad(60), -- degrees per second (converted to radians)
        image = nil
    }
    self.gate = {
        x = 3000,
        y = 1250 - 100,
        width = 5,
        height = 130
    }

    self.gate2 = {
        x = 3160,
        y = 1250 - 100,
        width = 5,
        height = 130
    }

    self.bot_image = love.graphics.newImage('Image/blockbott3.png')
    self.gear1 = love.graphics.newImage('Image/gear_1.png')
    self.gear2 = love.graphics.newImage('Image/gear_2.png')
    self.gear3 = love.graphics.newImage('Image/gear_3.png')
    items = {{
        key = "n",
        image = love.graphics.newImage("Image/duck_tape.png"),
        rect = {
            x = 2700,
            y = 1300,
            width = 30,
            height = 30
        }
    }, {
        key = "y",
        image = love.graphics.newImage("Image/iron.png"),
        rect = {
            x = 2700,
            y = 1200,
            width = 30,
            height = 30
        }
    }, {
        key = "y",
        image = love.graphics.newImage("Image/ore_2.png"),
        rect = {
            x = 2600,
            y = 1290,
            width = 30,
            height = 30
        }
    }, {
        key = "n",
        image = love.graphics.newImage("Image/TRASH.png"),
        rect = {
            x = 2500,
            y = 1270,
            width = 30,
            height = 30
        }
    }, {
        key = "n",
        image = love.graphics.newImage("Image/wooden_stick.png"),
        rect = {
            x = 2450,
            y = 1250,
            width = 30,
            height = 30
        }
    }, {
        key = "n",
        image = love.graphics.newImage("Image/wood.png"),
        rect = {
            x = 2550,
            y = 1200,
            width = 30,
            height = 30
        }
    }, {
        key = "n",
        image = love.graphics.newImage("Image/wood.png"),
        rect = {
            x = 2750,
            y = 1200,
            width = 30,
            height = 30
        }
    }, {
        key = "n",
        image = love.graphics.newImage("Image/wood.png"),
        rect = {
            x = 2650,
            y = 1280,
            width = 30,
            height = 30
        }
    }}
    -- self.miniPlayer = {
    --     x = 2,
    --     y = 2,
    --     tileSize = self.maze.tileSize
    -- } 
    -- dx,dy = push:toReal(self.player.x,self.player.y)  
    -- cam:lookAt(dx,dy) 

    -- cam:lookAt(self.player.x,self.player.y)
end

function PlayState:update(dt)
    self.player:update(dt)

    if self.player.x >= 2400 and self.player.x <= 2956 then

        limit_lx = 2400
        limit_rx = 2956

        limit_uy = 865
        limit_dy = 1300
        auto_play = false

    elseif self.player.x >= 3160 then
        auto_play = false
        limit_lx = 3160
        limit_rx = 38000
        limit_dy = 1500
        limit_uy = 300
    end

    if AABB(self.player, self.gate) and love.keyboard.isDown('return') then
        direction = 'right'
        auto_play = true
        limit_rx = 3160
    end

    if AABB(self.player, self.gate2) and love.keyboard.isDown('return') then
        auto_play = true
        direction = 'left'
        limit_lx = 2400
        limit_rx = 2956

        limit_uy = 865
        limit_dy = 1300
    end

    -- print(self.player.x)
    -- cam:lookAt(math.floor(self.player.x + 0.5), math.floor(self.player.y + 0.5))

    -- self.maze:update(dt)
    -- self.shooter:update(dt) 

    if self.flag == false then
        bot.x = bot.x + bot.speed * bot.direction * dt

        -- Change direction at limits
        if bot.x >= 4500 then
            bot.direction = -1 -- move left
        elseif bot.x <= 3999 then
            bot.direction = 1 -- move right
        end
    else
        local dx = self.player.x - bot.x - 20
        local dy = self.player.y - bot.y + 30
        local distance = math.sqrt(dx * dx + dy * dy)

        if distance > 1 then -- avoid jittering when very close
            local directionX = dx / distance
            local directionY = dy / distance

            bot.x = bot.x + directionX * bot.speed * dt
            bot.y = bot.y + directionY * bot.speed * dt

        end
    end 

    circleBot.angle = circleBot.angle + circleBot.speed * dt
    if circleBot.angle > math.pi * 2 then
        circleBot.angle = circleBot.angle - math.pi * 2
    end

    if AABB(self.player, bot) then
        -- BOT FOLLOWS PLAYER
        self.flag = true

    end

    if love.keyboard.wasPressed('x') then
        gStateStack:push(Sage())
    end  



    if love.keyboard.wasPressed('g') then
        gStateStack:push(Password())
    end 
    
    -- Check collisions and remove collided items
    for i = #items, 1, -1 do -- iterate backwards when removing
        local item = items[i]
        if AABB(self.player, {
            x = item.rect.x,
            y = item.rect.y,
            width = item.rect.width,
            height = item.rect.height
        }) and item.key == 'y' then
            table.remove(items, i)
        end
    end
end

function AABB(a, b)
    return a.x < b.x + b.width and b.x < a.x + a.width and a.y < b.y + b.height and b.y < a.y + a.height
end

function PlayState:render()
    love.graphics.push()

    -- Zoom factor
    local zoom = self.zoom or 1.5

    -- Step 1: Set scale (zoom) FIRST
    love.graphics.scale(zoom, zoom)

    -- Step 2: Calculate camera position after scaling
    local cameraX = self.player.x - (VIRTUAL_WIDTH / 2) / zoom
    local cameraY = self.player.y - (VIRTUAL_HEIGHT / 2) / zoom

    -- Step 3: Translate scene based on scaled camera
    love.graphics.translate(-cameraX, -cameraY)

    -- Draw background and world
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, 0, 0, 0, 1.5, 1.5)

    for _, item in ipairs(items) do
        -- Draw the image at the given position
        love.graphics.draw(item.image, item.rect.x, item.rect.y, 0, -- rotation
        item.rect.width / item.image:getWidth(), item.rect.height / item.image:getHeight())

        -- love.graphics.rectangle('line',item.rect.x,
        --     item.rect.y,item.rect.width ,
        --     item.rect.height)

        -- Optional: draw key label below the image
        love.graphics.setColor(1, 1, 1)
        -- love.graphics.print(item.key, item.rect.x, item.rect.y + item.rect.height + 5)
    end

    -- Player and other game objects
    self.player:render()
    love.graphics.draw(self.gear1, 2700, 820, love.timer.getTime(), 0.36, 0.36, self.gear1:getWidth() / 2,
        self.gear1:getHeight() / 2)
    love.graphics.draw(self.gear2, 2630, 820, -love.timer.getTime() * 0, 0.36, 0.36, self.gear1:getWidth() / 2,
        self.gear1:getHeight() / 2)
    love.graphics.draw(self.gear3, 2666, 820, -love.timer.getTime() * 0, 0.36, 0.36, self.gear1:getWidth() / 2,
        self.gear1:getHeight() / 2)
    --love.graphics.print(math.floor(self.player.y), self.player.x, self.player.y)
    --love.graphics.print(math.floor(self.player.x), self.player.x, self.player.y + 36)
    love.graphics.rectangle('fill', self.gate.x, self.gate.y, self.gate.width, self.gate.height)
    love.graphics.rectangle('fill', self.gate2.x, self.gate2.y, self.gate2.width, self.gate2.height)

    -- love.graphics.setColor(1, 0, 0) -- Red
    -- love.graphics.circle("fill", bot.x, bot.y, 10) 
    love.graphics.draw(self.bot_image, bot.x, bot.y, love.timer.getTime() * 5, 0.4, 0.4, self.bot_image:getWidth() / 2,
        self.bot_image:getHeight() / 2) 

         -- Calculate position on the circle
    local botXx = circleBot.centerX + circleBot.radius * math.cos(circleBot.angle)
    local botYy = circleBot.centerY + circleBot.radius * math.sin(circleBot.angle)

    -- Draw bot at calculated position
    local ox = self.bot_image:getWidth() / 2
    local oy = self.bot_image:getHeight() / 2
    love.graphics.draw(self.bot_image, botXx, botYy, 0, 1, 1, ox, oy)

    -- Optional: draw center point
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", circleBot.centerX, circleBot.centerY, 4)
    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

