-- require the lib, call it whatever you want
io.stdout:setvbuf("no")
local softbody = require("softbody")

-- create our world and a boundry
world = love.physics.newWorld(0, 9.81*64, false)
surface = {}
surface.body = love.physics.newBody(world, 0, 0)
surface.shape = love.physics.newChainShape(true, 0, 0, 800, 0, 800, 600, 0, 600)
surface.fixture = love.physics.newFixture(surface.body, surface.shape)

-- a table to store each instance of a softbody
softbodyTable = {}

-- a function to create and insert softbody instances into our table
function createSoftbody(type,x, y, r)
	-- a random color
	local red = love.math.random(80,255)
	local green = love.math.random(20,255)
	local blue = love.math.random(100,255)
	local rgb = {red, green, blue}
	if type=="ball" then
		table.insert(softbodyTable, {object = softbody(world, "ball",{x=x,y=y,r=r}), rgb = rgb})
	elseif type=="polygon" then
		table.insert(softbodyTable, {object = softbody(world, "polygon",{x=x,y=y,vert=r}), rgb = rgb})
	elseif type=="rect" then
		table.insert(softbodyTable, {object = softbody(world, "rect",{x=x,y=y,w=r[1],h=r[2]}), rgb = rgb})
	end
end

function love.mousepressed(x, y,key)
	-- create a softbody with a random radius
	if love.keyboard.isDown("1") then
		createSoftbody("ball",x, y, love.math.random(60, 120))
	elseif love.keyboard.isDown("2") then
		createSoftbody("polygon",x,y,{0,-love.math.random(60, 120),-love.math.random(60, 120),0,love.math.random(60, 120),0})
	elseif love.keyboard.isDown("3") then
		createSoftbody("rect",x,y,{love.math.random(60, 120),love.math.random(60, 120)})
	end
end

function love.update(dt)
	--[[ 
		call the update for each instance
		this updates the tessellation for drawing
		only call this when you are drawing the softbody
	--]]
	for i,v in ipairs(softbodyTable) do
		v.object:update(dt)
	end

	world:update(dt)
end

local txt=[[
hold button 1 and click to create a soft ball
hold button 2 and click to create a soft triangle
hold button 3 and click to create a soft rectangle
]]

function love.draw()
	love.graphics.print(txt, x, y, r, sx, sy, ox, oy, kx, ky)
	for i,v in ipairs(softbodyTable) do
		love.graphics.setColor(v.rgb[1], v.rgb[2], v.rgb[3])
		v.object:draw(_)
	end
end

function love.keypressed(key)
	if key=="a" then
		softbodyTable[1].object.centerBody:applyForce(200000,-200000)
	end
end