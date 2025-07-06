Password = Class {
    __includes = BaseState
} 


-- secret code to match
secretCode = {1, 2, 3, 4, 0}

-- user state
selectedDigits = {}
currentDigit = 0
currentIndex = 1
totalDigits = 5
matched = false
submitted = false


function Password:init()

end


function Password:update(dt) 

    if currentIndex <= totalDigits then
        if love.keyboard.wasPressed("right") then
            currentDigit = (currentDigit + 1) % 5
        elseif love.keyboard.wasPressed("left") then
            currentDigit = (currentDigit - 1) % 5
        elseif love.keyboard.wasPressed("return") then
            selectedDigits[currentIndex] = currentDigit
            currentIndex = currentIndex + 1
            currentDigit = 0
        end
    elseif not submitted then
        submitted = true
        matched = true
        for i = 1, totalDigits do
            if selectedDigits[i] ~= secretCode[i] then
                matched = false
                break
            end
        end
    end

    if love.keyboard.wasPressed('k') then 
        gStateStack:pop()
    end 

end

function Password:render()

    love.graphics.printf("Choose 5-digit code (0–4):", 0, 50, WINDOW_WIDTH, "center")

    if currentIndex <= totalDigits then
        love.graphics.printf("Digit #" .. currentIndex .. ": " .. currentDigit, 0, 100, WINDOW_WIDTH, "center")
        love.graphics.printf("Use  and  to change. Press Enter to confirm.", 0, 140, WINDOW_WIDTH, "center")
    end

    -- Draw selected digits
    local display = ""
    for i = 1, totalDigits do
        local digit = selectedDigits[i] or "_"
        display = display .. digit .. " "
    end
    love.graphics.printf("Your Code: " .. display, 0, 200, WINDOW_WIDTH, "center")

    if submitted then
        if matched then
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("Correct Code!", 0, 300, WINDOW_WIDTH, "center")
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf("Wrong Code!", 0, 300, WINDOW_WIDTH, "center")
        end
        love.graphics.setColor(1, 1, 1)
    end


end