--====================================================================--
-- SCENE: [MASTER TEMPLATE]
--====================================================================--

--[[

 - Version: [1.0]
 - Made by: [Fully Croisened, NJR Studios LLC - Nathanial Ryan]
 - Website: [www.fullycroisened.com]
 - Mail: [croisened@gmail.com]

******************
 - Conway's Game of Life for Corona SDK
 
 - References and Credits:
 - Conway's game of life: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
 - Lua: http://www.lua.org/home.html
 - Based on code provided by Dave Bollinger and shipped with Lua, http://lua-users.org/lists/lua-l/1999-12/msg00003.html
 ******************

  - [XXXXXXXXXX]

--]]


local gen=1
local thisgen, nextgen 
local group = display.newGroup()
local lifeCount, prevlifeCount, stabilizedCount = 0,0,0
local gameOver = false
local zoom = 8
local timerText, statusText


function ARRAY2D(w,h)
  local t = {}
  t.w=w
  t.h=h
  while h>0 do
    t[h] = {}
    local x=w
    while x>0 do
      t[h][x]=0
      x=x-1
    end
    h=h-1
  end
  return t
end

_CELLS = {}

-- give birth to a "shape" within the cell array
function _CELLS:spawn(shape,left,top)
  local y=0
  while y<shape.h do
    local x=0
    while x<shape.w do
      self[top+y][left+x] = shape[y*shape.w+x+1]
      x=x+1
    end
    y=y+1
  end
end


-- run the CA and produce the next generation
function _CELLS:evolve(next)
  local ym1,y,yp1,yi=self.h-1,self.h,1,self.h
  while yi > 0 do
    local xm1,x,xp1,xi=self.w-1,self.w,1,self.w
    while xi > 0 do
      local sum = self[ym1][xm1] + self[ym1][x] + self[ym1][xp1] +
                  self[y][xm1] + self[y][xp1] +
                  self[yp1][xm1] + self[yp1][x] + self[yp1][xp1]
      next[y][x] = ((sum==2) and self[y][x]) or ((sum==3) and 1) or 0
      xm1,x,xp1,xi = x,xp1,xp1+1,xi-1
    end
    ym1,y,yp1,yi = y,yp1,yp1+1,yi-1
  end
end

-- output the array to screen
function _CELLS:draw()
  --local out="" -- accumulate to reduce flicker
  local y=1

  display.remove(group)
  group = nil
  group = display.newGroup()
  
  prevlifeCount = lifeCount  --store the count from last time so we know when we stabilize
  lifeCount = 0  --reset because we are going to re-evaluate on each tick/generation

  --Just positioning the group that will house the markers
  group.x = -250
  group.y = -100
  
  while y <= self.h do
    local x=1
    while x <= self.w do
      if (self[y][x]>0) then
        --print(x)
        
         -- we can use different markers to reperesent each living cell, try them all
         local myMarker = display.newCircle(x, y, zoom / 2 )      --circle marker
         --local myMarker = display.newRect(0, 0, zoom, zoom)     --square marker
         --local myMarker = display.newImage("corona.png", true)  --an image marker
         myMarker.x = (zoom * x)
         myMarker.y = (zoom * y)
    
         --print("coords: " .. tostring(x) .. "," .. tostring(y))

         --Set colors
         myMarker:setFillColor(0,255,0)
         --myMarker:setFillColor( math.random(255), math.random(255), math.random(255), math.random(200) + 55 )

         group:insert(myMarker)
         lifeCount = lifeCount + 1
      end
      x=x+1
    end
    y=y+1
  end
  
end


function CELLS(w,h)
  local c = ARRAY2D(w,h)
  c.spawn = _CELLS.spawn
  c.evolve = _CELLS.evolve
  c.draw = _CELLS.draw
  return c
end

--
-- shapes suitable for use with spawn() above
-- Pretty self explanatory, set the W and H to represent teh width and height of yrou shape
-- 0 = dead cell, 1 = alive cell

--Some shapes for you to play with, create your own random shapes and just see what happens!!!!!!

--You can many shapes to use online

HEART = { 1,0,1,1,0,1,1,1,1; w=3,h=3 }
GLIDER = { 0,0,1,1,0,1,0,1,1; w=3,h=3 }
EXPLODE = { 0,1,0,1,1,1,1,0,1,0,1,0; w=3,h=4 }
FISH = { 0,1,1,1,1,1,0,0,0,1,0,0,0,0,1,1,0,0,1,0; w=5,h=4 }
BUTTERFLY = { 1,0,0,0,1,0,1,1,1,0,1,0,0,0,1,1,0,1,0,1,1,0,0,0,1; w=5,h=5 }
METH = { 0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0; w=5,h=5 }
GUN = { 1,1,1,0,1,
        1,0,0,0,0,
        0,0,0,1,1,
        0,1,1,0,1,
        1,0,1,0,1; w=5,h=5 }
DIEHARD = { 0,0,0,0,0,0,1,0,
            1,1,0,0,0,0,0,0,
            0,1,0,0,0,1,1,1; w=8,h=3 }        
        
GOSPER = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
           0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
           0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
           1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
           1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,
           0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,
           0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
           0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; w=36,h=9 }

CORONA = { 0,0,1,1,1,0,0,0,0,1,1,0,0,0,1,1,1,1,0,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,1,1,0,0,
           0,1,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,1,1,0,0,0,1,0,0,1,0,0,1,0,
           1,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1,0,0,0,0,1,
           1,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1,0,0,0,0,1,
           1,0,0,0,0,0,0,1,0,0,0,0,1,0,1,1,1,1,1,0,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,1,
           1,0,0,0,0,0,0,1,0,0,0,0,1,0,1,0,1,0,0,0,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,1,0,0,0,0,1,
           1,0,0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,0,0,1,0,1,0,0,1,0,1,0,1,0,0,0,0,1,
           0,1,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,1,0,0,1,0,0,0,1,1,0,1,0,0,0,0,1,
           0,0,1,1,1,0,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,0,0,1,1,0,0,0,1,0,0,0,0,1,0,1,0,0,0,0,1; w=41,h=9 }



 local function listener( event )

    thisgen:evolve(nextgen)
    thisgen,nextgen = nextgen,thisgen
   
    thisgen:draw()
    --print("Generation: "..gen.."\n")
    --print("Life Forms: " .. tostring(lifeCount))

    timerText.text = "Generations: ".. gen .. "  --  " ..  "Life Forms: " .. tostring(lifeCount) 

    if lifeCount == prevlifeCount then
      statusText.text = "STABILIZED" .. " AT " .. tostring(stabilizedCount) .. " GENERATIONS"
      statusText:setTextColor( 255, 50, 100, 255 )	
    else  
      statusText.text = "IN FLUX"
      statusText:setTextColor( 255, 200, 100, 255 )	
      stabilizedCount = stabilizedCount + 1
    end  

    gen = gen + 1

 end

-- the main routine
function LIFE(w,h)
  -- create two arrays

  thisgen = CELLS(w,h)
  nextgen = CELLS(w,h)
  
  bg = display.newImage("bg.jpg",true)
  

  timerText = display.newText("Generation", 470, 22, native.systemFont, 24 )
  timerText:setTextColor( 100, 255, 255, 255 )
  timerText.x = 300
  timerText.y = 920  


  statusText = display.newText("IN FLUX", 470, 22, native.systemFont, 24 )
  statusText:setTextColor( 255, 200, 100, 255 )	
  statusText.x = 300
  statusText.y = 860  

  -- create some life using the defined shapes from above - experiemnt and see what happens!
  --This is where we create a shape as defined above at the given coordinates within our bounding grid box below,
  --In this example our bounding grid box is 128 x 128 - set when we call LIFE(12,128)
  --Experiement with the size of the bounding box and remember to give your spawn shapes a starting location that 
  --falls within the bounding box
  
  --thisgen:spawn(GLIDER,64,64)
  --thisgen:spawn(BUTTERFLY,64,64)

  --Gosper's Gun!
  thisgen:spawn(GOSPER,52,64)

  timer.performWithDelay( 30, listener, 0)
  
end

LIFE(128,128) 