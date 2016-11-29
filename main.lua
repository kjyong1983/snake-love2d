game = require 'game'
title = require 'title'
state = 'title'

function love.load()
    
    if state == 'title' then
        title.load()
        game.load()
    end
    --debug.debug()
    if state == 'game' then
        --game.test()
        --game.load()
    end
    
    
end

function love.update(dt)

    if state == 'title' then
    
        title.update(dt)
        if title.state == 'game' then
            state = 'game'
            print 'state = game'
        end
    end

    if state == 'game' then
        game.update(dt)
    end
    
    checkQuit()
    
end

function love.draw()
    
    if state == 'title' then
        title.draw()
    end
    
    if state == 'game' then
        game.draw()
    end
    
end

function checkQuit()
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
end