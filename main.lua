if arg[2] == "debug" then
  require("lldebugger").start()
end

Object = require 'libraries/classic/classic'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
Input = require 'libraries/boipushy/Input'
fn = require 'libraries/moses/moses'
Camera = require 'libraries/hump/camera'
Physics = require 'libraries/windfield'


require 'utils'


function love.load()

    time = 0

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)
    local room_files = {}
    recursiveEnumerate('rooms', room_files)
    requireFiles(room_files)

    timer = Timer()
    input = Input()
    camera = Camera()

    init_input()

    gotoRoom("Stage")

    resize(2)

end

function love.update(dt)
    timer:update(dt)
    camera:update(dt)
    if current_room then current_room:update(dt) end
end

function love.draw()
    if current_room then current_room:draw() end
end

function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end


-- Load --
function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local info = love.filesystem.getInfo(file)
        if info.type == "file" then
            table.insert(file_list, file)
        elseif info.type == "directory" then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        require(file)
    end
end

-- bind input
function init_input()
    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count") / 1024 .. " MB")
        collectgarbage()
        print("After collection: " .. collectgarbage("count") / 1024 .. " MB")
        print("Object count: ")
        local counts = type_count()
        for k , v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)
    input:bind('f2', function() gotoRoom("Stage") end)
    input:bind('f3', function() 
        if current_room then
            current_room:destroy()
            current_room = nil
        end
    end)
    input:bind('left', 'left')
    input:bind('right', 'right')
end

-- Room --
function gotoRoom(room_type, ...)
    if current_room and current_room.destroy then
        current_room:destroy()
    end
    current_room = _G[room_type](...)
end

-- Memory --
function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
        f(t)
        seen[t] = true
        for k, v in pairs(t) do
            if type(v) == "table" then
                count_table(v)
            elseif type(v) == "userdata" then
                f(v)
            end
        end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function(o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
        for k, v in pairs(_G) do
            global_type_table[v] = k
        end
        global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"


end




local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

