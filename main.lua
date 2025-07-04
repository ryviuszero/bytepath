if arg[2] == "debug" then
  require("lldebugger").start()
end

Object = require 'libraries/classic/classic'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
Input = require 'libraries/boipushy/Input'
fn = require 'libraries/moses/moses'
Camera = require 'libraries/hump/camera'
Physics = require 'libraries/windfield'
Vector = require 'libraries/hump/vector'
draft = require('libraries/draft/draft')()
bitser = require 'libraries/bitser/bitser'


require 'libraries/utf8'
require 'GameObject'
require 'globals'
require 'utils'
require 'tree'



function love.load()

    time = 0

    -- 有些函数在新版本被丢弃了，这里设置为不显示这个提示信息了。
    love.setDeprecationOutput(false)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    love.graphics.setBackgroundColor(background_color)
   
    loadFonts('resources/fonts')
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

    current_room = nil
    gotoRoom("Stage")
    
    resize(2)

    -- 这里的slow_amount是用来控制慢动作的速度的?
    slow_amount = 1

end

function love.update(dt)
    timer:update(dt * slow_amount)
    camera:update(dt * slow_amount)
    if current_room then current_room:update(dt * slow_amount) end
end

function love.draw()
    if current_room then current_room:draw() end

    -- flash_frames: 抽帧？用来显示慢动作的效果？
    if flash_frames then
        flash_frames = flash_frames - 1
        if flash_frames == -1 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, sx * gw, sy * gh)
        love.graphics.setColor(1, 1, 1)
    end
end

function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end

function love.textinput(t)
    if current_room.textinput then current_room:textinput(t) end
end

function flash(frames)
    flash_frames = frames
end

function slow(amount, duration)
    slow_amount = amount
    -- timer:tween 的各个参数后面也了解一下？
    timer:tween('slow', duration, _G, {slow_amount = 1}, 'in-out-cubic')
end

-- Save/Load --
function save()
    local save_data = {}

    bitser.dumpLoveFile('save', save_data)
end

function load()
    if love.filesystem.getInfo('save') then
        local save_data = bitser.loadLoveFile('save')
    else
        first_run_ever = true
    end
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

function loadFonts(path)
    fonts = {}
    local font_paths = {}
    recursiveEnumerate(path, font_paths)
    for i = 8, 16, 1 do
        for _, font_path in pairs(font_paths) do
            local last_forward_slash_index = font_path:find("/[^/]*$")
            local font_name = font_path:sub(last_forward_slash_index+1, -5)
            local font = love.graphics.newFont(font_path, i)
            font:setFilter('nearest', 'nearest')
            fonts[font_name .. '_' .. i] = font
        end
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
        print("destroying current room")
        if current_room then    
            current_room:destroy()
            current_room = nil
        end
    end)
    input:bind('left', 'left')
    input:bind('right', 'right')
    input:bind('up', 'up')
    input:bind('down', 'down')
    input:bind('mouse1', 'left_click')
    input:bind('wheelup', 'zoom_in')
    input:bind('wheeldown', 'zoom_out')
    input:bind('return', 'return')
    input:bind('backspace', 'backspace')
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

