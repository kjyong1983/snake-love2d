title = {}

function title:load()
    
    print 'title'
    title.key = nil
    title.state = nil
    
    
end

function title:update(dt)

    if title.key ~= nil then
        --state = 'game'
        print 'game start'
        title.key = nil
        title.state = 'game'
    end
    
end

function title:draw()

    love.graphics.print('S   N   A   K   E', 200, 400, 0, 4, 4)
    love.graphics.print('press any key', 300, 500, 0, 2, 2)

end

function love.keypressed(key, button, keyRep)
    title.key = key
end


return title
