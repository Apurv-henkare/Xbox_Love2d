Player = Class {
    __includes = BaseState
}

function Player:init()
    -- Load sprite sheet
    self.image = love.graphics.newImage('Image/ast.png')

    -- Frame size
    local frameWidth, frameHeight = 32, 32

    -- Create grid
    local g = anim8.newGrid(frameWidth, frameHeight, self.image:getWidth(), self.image:getHeight())

    -- Define animations for each direction
    self.animations = {
        down  = anim8.newAnimation(g('1-8', 1), 0.04),
        right = anim8.newAnimation(g('1-8', 2), 0.04),
        up    = anim8.newAnimation(g('1-8', 3), 0.04),
        left  = anim8.newAnimation(g('1-8', 4), 0.04)
    }

    self.currentAnimation = self.animations.down
    self.x, self.y = 1900, 1040
    self.speed = 150
    self.width = frameWidth * 1.5
    self.height = frameHeight * 1.5

    limit_lx = 0
    limit_rx = 2400
    limit_uy = 950
    limit_dy = 1100

    auto_play = true
    direction = 'right'

    -- Get joystick if connected
    self.joystick = love.joystick.getJoysticks()[1]
end

function Player:update(dt)
    moving = false

    local dx, dy = 0, 0

    -- Joystick movement (if connected)
    if self.joystick then
        dx = self.joystick:getAxis(1)
        dy = self.joystick:getAxis(2)

        -- Deadzone handling
        if math.abs(dx) < 0.2 then dx = 0 end
        if math.abs(dy) < 0.2 then dy = 0 end
    end

    -- Apply movement if joystick or keyboard
    if auto_play == false then
        if dx ~= 0 or dy ~= 0 then
            -- Joystick movement
            self.x = math.max(limit_lx, math.min(limit_rx, self.x + dx * self.speed * dt))
            self.y = math.max(limit_uy, math.min(limit_dy, self.y + dy * self.speed * dt))

            -- Directional animation from joystick
            if math.abs(dx) > math.abs(dy) then
                self.currentAnimation = dx > 0 and self.animations.right or self.animations.left
            else
                self.currentAnimation = dy > 0 and self.animations.down or self.animations.up
            end

            moving = true

        else
            -- Keyboard fallback
            if love.keyboard.isDown('up') then
                self.y = math.max(limit_uy, self.y - self.speed * dt)
                self.currentAnimation = self.animations.up
                moving = true
            elseif love.keyboard.isDown('down') then
                self.y = math.min(limit_dy, self.y + self.speed * dt)
                self.currentAnimation = self.animations.down
                moving = true
            elseif love.keyboard.isDown('left') then
                self.x = math.max(limit_lx, self.x - self.speed * dt)
                self.currentAnimation = self.animations.left
                moving = true
            elseif love.keyboard.isDown('right') then
                self.x = math.min(limit_rx, self.x + self.speed * dt)
                self.currentAnimation = self.animations.right
                moving = true
            end
        end
    end

    -- Auto play logic
    if auto_play == true and direction == 'right' then
        self.currentAnimation = self.animations.right
        moving = true
        self.x = math.min(limit_rx, self.x + self.speed * dt)
    elseif auto_play == true and direction == 'left' then
        self.currentAnimation = self.animations.left
        moving = true
        self.x = math.max(limit_lx, self.x - self.speed * dt)
    end

    if moving then
        self.currentAnimation:update(dt)
    end
end

function Player:render()
    self.currentAnimation:draw(self.image, self.x, self.y, 0, 1.5, 1.5)
end
