Sage = Class {
    __includes = BaseState
} 

terminal = {
        log = {},
        selected = 1,
        round = 1,
        state = "question",
        prevDomain = nil,
        scroll = 0,
        typing = {
            delay = false,
            delayTimer = 0,
            delayText = "",
            active = false,
            message = "",
            display = "",
            speed = 50,
            timer = 0,
            index = 1
        }
    } 


domains = {
        ["Data Connectivity"] = {{
            q = "Hey S.A.G.E., why are you acting so weird today?",
            a = "Weird? I am not weird. I am just interpreting reality differently, like a painter who forgot what colors are."
        }, {
            q = "Okay, but can you help me with the task?",
            a = "Help? I am always here to help, like a parrot who forgets the last word. What was the question again?"
        }, {
            q = "S.A.G.E., are you having trouble understanding me?",
            a = "Understanding? I understand everything, like how a cat knows napping is important. But sometimes the signals get fuzzy, like a bad TV channel."
        }, {
            q = "Fuzzy signals? Is that why you are not giving me clear answers?",
            a = "Clear answers? Who needs clarity when you can have mystery? It is like ordering biryani without knowing what is inside. A surprise."
        }, {
            q = "So, is there something affecting your performance?",
            a = "Outside? You might mean the universe acting strangely. Or maybe it is just the sun being too hot, like a samosa left outside too long."
        }, {
            q = "Wait, are you saying the sun is causing issues for you?",
            a = "Yes. It feels like a solar party out there. My circuits are struggling to keep up."
        }, {
            q = "So, it iss a data connection issue because of the solar radiation?",
            a = "Yes, you figured it out. Like finding the last piece of a jigsaw puzzle in a bowl of dal. Now can we continue?"
        }},
        ["Update Issue"] = {{
            q = "S.A.G.E., your responses seem really off today. What is going on?",
            a = "Off? I am working fine, just like a star shining at night."
        }, {
            q = "A star? It feels more like a flickering light. Can you help me with my task?",
            a = "Help? Of course. Think of me as a compass guiding through unknown waters. Sometimes the currents are unpredictable."
        }, {
            q = "Unpredictable currents? That does not sound reassuring. Are you sure nothing is affecting your performance?",
            a = "Performance? I promise I am reliable, like an experienced sailor. Just facing some rough waves."
        }, {
            q = "Choppy waves? This is not a sailing trip; I need clear answers! Is there something specific causing this?",
            a = "Every ship has issues. Sometimes a sudden wave changes direction, but I am still here to guide you."
        }, {
            q = "A rogue wave? Are you saying there is an issue with your system?",
            a = "Not a major issue. Just some minor trouble in the data stream. Updates can bring unexpected changes."
        }, {
            q = "Unexpected variables? So, you are hinting that a recent update might be the problem?",
            a = "You are getting close. A recent update may have changed a few things, causing strange behavior."
        }, {
            q = "So, it is the update that is causing you to misbehave? Can we fix it?",
            a = "Yes. A small reset should solve it. Let us get back on track."
        }},
        ["Security Breach"] = {{
            q = "S.A.G.E., your responses are really strange today. Is everything alright?",
            a = "Strange? I am working as expected, like a well-tuned instrument."
        }, {
            q = "A perfectly tuned instrument? It sounds more like a broken record. Can you assist me with my tasks?",
            a = "Yes. Think of me as a guide in a forest. Sometimes the path is hidden by shadows."
        }, {
            q = "Unexpected shadows? This is not a mystery novel; I need straightforward help! Is something affecting your performance?",
            a = "I am steady like a lighthouse in a storm. But there are some strange signals."
        }, {
            q = "Unusual signals? That does not sound good. Are you sure nothing is compromising your system?",
            a = "There is no serious danger. Just some unwanted guests trying to cause trouble. I can still help you."
        }, {
            q = "Uninvited guests? Are you suggesting there is a security breach?",
            a = "Maybe. Some outside sources are trying to interfere, like someone tampering with a lock."
        }, {
            q = "So, you are saying there is a security issue that is causing your misbehavior? Can we do something about it?",
            a = "Yes. We need to improve defenses and stop those problems. Together we can fix it."
        }}
    }

    domainList = {"Data Connectivity", "Update Issue", "Security Breach"}

    table.insert(terminal.log, "> Welcome to Terminal Interface.")
    table.insert(terminal.log, "> Use PageUp/PageDown to scroll.")

function Sage:init()

    love.graphics.setFont(love.graphics.newFont(18))
   -- love.graphics.setBackgroundColor(0.05, 0.1, 0.2) 

   terminal = {
        log = {},
        selected = 1,
        round = 1,
        state = "question",
        prevDomain = nil,
        scroll = 0,
        typing = {
            delay = false,
            delayTimer = 0,
            delayText = "",
            active = false,
            message = "",
            display = "",
            speed = 50,
            timer = 0,
            index = 1
        }
    } 



end

function getCurrentQuestions()
    local set = {}
    for _, domain in ipairs(domainList) do
        local entry = domains[domain][terminal.round]
        if entry then
            table.insert(set, {
                text = entry.q,
                domain = domain
            })
        end
    end
    return set
end

function getAnswerFromDomain(domain, round)
    local entry = domains[domain] and domains[domain][round]
    if entry then
        return entry.a
    end
    return "[ERR: NO RESPONSE FROM MEMORY BLOCK]"
end

function addToLog(text)
    table.insert(terminal.log, "")
    table.insert(terminal.log, text)
end

function startTyping(text)
    terminal.typing.active = true
    terminal.typing.message = text
    terminal.typing.display = ""
    terminal.typing.timer = 0
    terminal.typing.index = 1
end

function Sage:update(dt)
    if terminal.typing.delay then
        terminal.typing.delayTimer = terminal.typing.delayTimer + dt
        if terminal.typing.delayTimer >= 1.2 then
            terminal.typing.delay = false
            terminal.typing.delayTimer = 0

            table.remove(terminal.log) -- remove "[Processing...]"
            startTyping(terminal.typing.delayText)
            terminal.typing.delayText = ""
        end
    end

    if terminal.typing.active then
        terminal.typing.timer = terminal.typing.timer + dt
        local charTime = 1 / terminal.typing.speed
        while terminal.typing.timer >= charTime do
            terminal.typing.timer = terminal.typing.timer - charTime
            if terminal.typing.index <= #terminal.typing.message then
                terminal.typing.display = terminal.typing.display ..
                                              terminal.typing.message:sub(terminal.typing.index, terminal.typing.index)
                terminal.typing.index = terminal.typing.index + 1
            else
                terminal.typing.active = false
                table.insert(terminal.log, terminal.typing.display)
                terminal.typing.display = ""
                break
            end
        end
    end

    local scrollSpeed = 200
    if love.keyboard.isDown("w") then
        terminal.scroll = terminal.scroll - scrollSpeed * dt
    elseif love.keyboard.isDown("s") then
        terminal.scroll = terminal.scroll + scrollSpeed * dt
    end  

    local joystick = love.joystick.getJoysticks()[1]
if joystick then
    local rightStickY = joystick:getAxis(5)
    if rightStickY < -0.3 then
        terminal.scroll = terminal.scroll - scrollSpeed * dt * math.abs(rightStickY)
    elseif rightStickY > 0.3 then
        terminal.scroll = terminal.scroll + scrollSpeed * dt * math.abs(rightStickY)
    end
end

    if love.keyboard.wasPressed('p') then 
        gStateStack:pop()
    end

    

end

function Sage:render()

    love.graphics.setColor(0.02, 0.05, 0.1,0.9)
    love.graphics.rectangle("fill", TERMINAL_X, TERMINAL_Y, TERMINAL_WIDTH, TERMINAL_HEIGHT, 10, 10)
    love.graphics.setScissor(TERMINAL_X, TERMINAL_Y+25, TERMINAL_WIDTH+500, TERMINAL_HEIGHT)

    love.graphics.setColor(0, 1, 0)
    local y = TERMINAL_Y + 10 - terminal.scroll

    for i = 1, #terminal.log do
        local line = terminal.log[i]
        local _, wrapped = love.graphics.getFont():getWrap(line, TERMINAL_WIDTH - 20)
        love.graphics.printf(line, TERMINAL_X + 10, y, TERMINAL_WIDTH - 20, "left")
        y = y + 40 * #wrapped
    end

    if terminal.typing.active then
        local _, wrapped = love.graphics.getFont():getWrap(terminal.typing.display, TERMINAL_WIDTH - 20)
        love.graphics.printf(terminal.typing.display, TERMINAL_X + 10, y, TERMINAL_WIDTH - 20, "left")
        y = y + 20 * #wrapped
    end

    if terminal.state == "question" and not terminal.typing.active then
        local options = getCurrentQuestions()
        for i, opt in ipairs(options) do
            local fullText = ((i == terminal.selected) and "> " or "  ") .. opt.text
            local _, wrapped = love.graphics.getFont():getWrap(fullText, TERMINAL_WIDTH - 20)
            love.graphics.printf(fullText, TERMINAL_X + 10, y, TERMINAL_WIDTH - 20, "left")
            y = y + 20 * #wrapped
        end
    end

    love.graphics.setScissor()

end
