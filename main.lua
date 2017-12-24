function love.load(arg)
	if arg[#arg] == "-debug" then 
		require("mobdebug").start()     
	end

	local screenWidth, screenHeight = love.graphics.getDimensions()
	local screenCenterX = screenWidth / 2
	local screenCenterY = screenHeight / 2
end

function love.update(dt)
  
end

function love.draw()
	love.graphics.clear(0, 0, 0)
	love.graphics.setColor(255, 255, 255)
  
end