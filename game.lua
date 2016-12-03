game = {}
game.snake = {}
gsnake = game.snake
game.map = {}
game.fruit = {}

function game:load()
    
    game.head = love.graphics.newImage('head.png')
    game.cube = love.graphics.newImage('cube.png')
    game.cube2 = love.graphics.newImage('fruit.png')
    game.width = love.graphics.getWidth()
    game.height = love.graphics.getHeight()
    
    game.minWidth = 0
    game.maxWidth = 800
    game.minHeight = 0
    game.maxHeight = 800
    
    game.moveUnit = 50
    game.moveTime = 0.4
    game.difficult = 1
    
    game.mapInitialize()
    
    game.snake.spr = game.cube
    game.snake.startX = game.width / 2
    game.snake.startY = game.width / 2    
    game.snake.x = game.snake.startX
    game.snake.y = game.snake.startY
    game.snake.dirX = 0
    game.snake.dirY = -1
    game.snake.lastDirX = 0
    game.snake.lastDirY = -1
    
    game.snake.torso = { }
    
    game.snake.torso[1] = {}
    game.snake.torso[1].x = game.snake.startX;
    game.snake.torso[1].y = game.snake.startY + 1 * game.moveUnit;
    
    game.snake.torso[2] = {}
    game.snake.torso[2].x = game.snake.startX;
    game.snake.torso[2].y = game.snake.startY + 2 * game.moveUnit;
    
    
    game.snake.eatFruit = false
    
    game.fruit.spr = game.cube2
    game.fruitRespawn()
    
    game.score = 0
    game.play = true
    
    game.elapsedTime = 0
    
end

function game:update(dt)
--movements
    --local dt = love.timer.getDelta()
    game.elapsedTime = game.elapsedTime + dt;
    game.getMoveKey()
    
    if game.elapsedTime >= game.moveTime / game.difficult and game.play then
        game.move()
        
        if game.snake.eatFruit == true then
            game.fruitRespawn()
        end
        
        --print('move')
        game.elapsedTime = 0;
        if game.difficult < 10 then
            game.difficult = game.difficult + 0.02
        end
        --print(game.difficult)
    end
    
    game.checkQuit()

    game.fruitEat()
    
end



function game.draw()
    
    love.graphics.draw(game.head, game.snake.x, game.snake.y, 0, 1, 1)
    love.graphics.draw(game.fruit.spr, game.fruit.x, game.fruit.y, 0, 1, 1)
   
    for i = 1, #game.snake.torso do
        love.graphics.draw(game.snake.spr, game.snake.torso[i].x, game.snake.torso[i].y, 0, 1, 1)
    end
    
    love.graphics.print('score : '..game.score, game.maxWidth - 100, game.minHeight + 50, 0, 1, 1)
    
    if game.play == false then
        love.graphics.print('G  A   M   E   O   V   E   R', 100, 400, 0, 4, 4)
        love.graphics.print('Press R to restart', 350, 500, 0, 1, 1)
    end
    
end

--snake movements

function game.getMoveKey()
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        game.setDirection(0, -1)
    end
    
    if love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        game.setDirection(0, 1)
    end
    
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        game.setDirection(-1, 0)
    end
    
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        game.setDirection(1, 0)
    end

end

function game.setDirection(i, j)
    
    if game.snake.lastDirX == -i and game.snake.lastDirY == j then
        return
    end
    if game.snake.lastDirX == i and game.snake.lastDirY == -j then
        return
    end
    
    game.snake.dirX, game.snake.dirY = i, j
    --print(i, j)
end

function game.move(i, j)

    game.moveTorso()
   
    if game.snake.x < game.minWidth or game.snake.x > game.maxWidth  then        
        print 'x out'
        game.play = false
        --game.load()
    end

    if game.snake.y < game.minHeight or game.snake.y > game.maxHeight then
        print 'y out'
        game.play = false
        --game.load()
    end

    --print(snake.x, snake.y, minWidth, maxWidth, minHeight, maxHeight)
    
    local lastX = game.snake.x
    local lastY = game.snake.y
    
    game.snake.x  = game.snake.x + game.snake.dirX * game.moveUnit
    game.snake.y  = game.snake.y + game.snake.dirY * game.moveUnit

    game.snake.lastDirX = (game.snake.x - lastX) / game.moveUnit
    game.snake.lastDirY = (game.snake.y - lastY) / game.moveUnit
    
--collision check    
    for i = 1, #game.snake.torso do
        if game.snake.x == game.snake.torso[i].x and game.snake.y == game.snake.torso[i].y then
            print ('collision X: '..game.snake.x..', '..game.snake.torso[i].x..' Y: '..game.snake.y..', '..game.snake.torso[i].y)
            game.play = false
            --game.load()
            break
        end
    end

end

function game.moveTorso()
    for i = #game.snake.torso, 1, -1  do
        if i == 1 then
            game.snake.torso[i].x = game.snake.x
            game.snake.torso[i].y = game.snake.y
        else
            game.snake.torso[i].x = game.snake.torso[i-1].x
            game.snake.torso[i].y = game.snake.torso[i-1].y
        end
        
    end
    
end

function game.fruitEat()
--fruit eating

    if game.snake.x == game.fruit.x and game.snake.y == game.fruit.y then
        --debug.debug()
        game.snake.eatFruit = true
        print'eatFruit true'
        game.score = game.score + 1
        game.fruitRemove()
        game.fruitRespawn()
    end
    
--snake expanding
    if game.snake.eatFruit then
        --torso expanding
        local last_torso = {}
        last_torso.x = game.snake.torso[#game.snake.torso].x
        last_torso.y = game.snake.torso[#game.snake.torso].y

        game.snake.torso[#game.snake.torso+1] = last_torso
        
        game.snake.eatFruit = false
        print('eatFruit false')
    end
end



function game.fruitRespawn()
    game.fruit.x = love.math.random(7) * game.moveUnit
    game.fruit.y = love.math.random(7) * game.moveUnit  
    print('fruit : ', game.fruit.x, game.fruit.y)
    game.fruitLocCheck()
end

function game.fruitLocCheck()
    
    if game.fruit.x == game.snake.x and game.fruit.y == game.snake.y then
        print 'fruit respawning...(by head)'
        game.fruitRespawn()
        game.fruitLocCheck()
    end
    
    for i = 1, #game.snake.torso do
        if game.fruit.x == game.snake.torso[i].x and game.fruit.y == game.snake.torso[i].y then
            print 'fruit respawning...'
            game.fruitRespawn()
            game.fruitLocCheck()
        end
    end
    
end

function game.fruitRemove()
    game.fruit.x = nil
    game.fruit.y = nil
end

--not used
function game.mapInitialize()
    for i = 1, 8 do
        game.map[i] = {}
        for j = 1, 8 do
            game.map[i][j] = {i * game.moveUnit, j * game.moveUnit}
        end
    end
end

function game.checkQuit()
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
    if love.keyboard.isDown('r') then
        game.load()
    end
end

function game.test()
    print 'hello world'
end

return game



