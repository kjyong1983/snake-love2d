snake = {}
map = {}
fruit = {}
--nextSnake = {}

function love.load()
    head = love.graphics.newImage('head.png')
    cube = love.graphics.newImage('cube.png')
    cube2 = love.graphics.newImage('fruit.png')
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    
    minWidth = 0
    maxWidth = 800
    minHeight = 0
    maxHeight = 800
    
    moveUnit = 50
    moveTime = 0.4
  
    mapInitialize()
    
    snake.spr = cube
    snake.startX = width / 2
    snake.startY = width / 2    
    snake.x = snake.startX
    snake.y = snake.startY
    snake.dirX = 0
    snake.dirY = -1
    
    snake.torso = { }
    snake.torso[1] = {}
    snake.torso[1].x = snake.startX + 1 * moveUnit;
    snake.torso[1].y = snake.startY;
    
    snake.torso[2] = {}
    snake.torso[2].x = snake.startX + 2 * moveUnit;
    snake.torso[2].y = snake.startY;
    
    
    snake.eatFruit = false
    
    fruit.spr = cube2
    fruitRespawn()
    
    
    elapsedTime = 0
end

function love.update(dt)

--movements

    elapsedTime = elapsedTime + dt;
    getMoveKey()
    
    if elapsedTime >= moveTime then
        move()
        
        if snake.eatFruit == true then
            --snake.eatFruit = false
            fruitRespawn()
        end
        
        --print('move')
        elapsedTime = 0;
    end
    
    checkQuit()

--fruit eating

    if snake.x == fruit.x and snake.y == fruit.y then
        --debug.debug()
        snake.eatFruit = true
        print'fruit eat'
        fruitRemove()
        fruitRespawn()
    end
    
--snake expanding
    if snake.eatFruit then
        --torso expanding
        for i = #snake.torso, 1, -1 do
            snake.torso[i + 1] = {}
            snake.torso[i + 1].x = snake.torso[i].x
            snake.torso[i + 1].y = snake.torso[i].y
            print ('torso '..(i+1)..' created')
            if i == 1 then
                snake.torso[i].x = snake.x
                snake.torso[i].y = snake.y
                print('first torso created')
            end
        end
        snake.torso[1].x = snake.x
        snake.torso[1].y = snake.y
        print('snake head changed')
    end
    
    if snake.eatFruit then
        snake.eatFruit = false
        print('eatFruit false')
    end
    
end

function love.draw()
    
    love.graphics.draw(head, snake.x, snake.y, 0, 1, 1)
    love.graphics.draw(fruit.spr, fruit.x, fruit.y, 0, 1, 1)
   
    for i = 1, #snake.torso do
        love.graphics.draw(snake.spr, snake.torso[i].x, snake.torso[i].y, 0, 1, 1)
    end
   
end




--snake movements

function move()
    moveTowardDirection()
end

function getMoveKey()
    if love.keyboard.isDown('w') then
        setDirection(0, -1)
    end
    if love.keyboard.isDown('up') then
        setDirection(0, -1)
    end
    
    if love.keyboard.isDown('s') then
        setDirection(0, 1)
    end
    if love.keyboard.isDown('down') then
        setDirection(0, 1)
    end
    
    if love.keyboard.isDown('a') then
        setDirection(-1, 0)
    end
    if love.keyboard.isDown('left') then
        setDirection(-1, 0)
    end
    
    if love.keyboard.isDown('d') then
        setDirection(1, 0)
    end
    if love.keyboard.isDown('right') then
        setDirection(1, 0)
    end

end

function setDirection(i, j)
    if snake.dirX == -i and snake.dirY == j then
        return
    end
    if snake.dirX == i and snake.dirY == -j then
        return
    end
    
    snake.dirX, snake.dirY = i, j
    --print(i, j)
end

function moveTowardDirection(i, j)

    moveTorso()

    if snake.x < minWidth or snake.x > maxWidth  then        
        print 'x out'
--        snake.x = snake.startX
        love.load()
    end

    if snake.y < minHeight or snake.y > maxHeight then
        print 'y out'
        --snake.y = snake.startY
        love.load()
    end

    --print(snake.x, snake.y, minWidth, maxWidth, minHeight, maxHeight)
    
    snake.x  = snake.x + snake.dirX * moveUnit
    snake.y  = snake.y + snake.dirY * moveUnit
       
end

function moveTorso()
    for i = #snake.torso, 1, -1  do
        if i == 1 then
            snake.torso[i].x = snake.x
            snake.torso[i].y = snake.y
        else
            snake.torso[i].x = snake.torso[i-1].x
            snake.torso[i].y = snake.torso[i-1].y
        end
        
    end

end

function fruitRespawn()
    fruit.x = love.math.random(7) * moveUnit
    fruit.y = love.math.random(7) * moveUnit  
    --nextSnake.x = fruit.x
    --nextSnake.y = fruit.y
    print('fruit : ', fruit.x, fruit.y)

end

function fruitRemove()
    fruit.x = nil
    fruit.y = nil
end

function mapInitialize()
    for i = 1, 8 do
        map[i] = {}
        for j = 1, 8 do
            map[i][j] = {i * moveUnit, j * moveUnit}
        end
    end
end

function checkQuit()
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
    if love.keyboard.isDown('r') then
        love.load()
    end
end







