--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    self.states[#self.states]:update(dt)
end

function StateStack:processAI(params, dt)
    self.states[#self.states]:processAI(params, dt)
end

function StateStack:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

function StateStack:Info()
    
    local info=""

    for i,state in ipairs(self.states) do
        info=info.."key "..i.." name:"
    end

    return info
end  
function StateStack:Name()
     
    local info=""
    for i,state in ipairs(self.states[#self.states]) do 
        info = state
    end 
    
    return info

end 

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state,enterParams)
    table.insert(self.states, state)

    state:enter(enterParams)
   -- print(enterParams)
end

function StateStack:pop(enterParams)
    self.states[#self.states]:exit()
    table.remove(self.states)
end