local upFunc, downFunc, confirmFunc, backFunc, drawFunc, musicStop

local menuState

local menuNum = 1

local songNum, songAppend
local songDifficulty = 2

local selectSound = love.audio.newSource("sounds/menu/select.ogg", "static")
local confirmSound = love.audio.newSource("sounds/menu/confirm.ogg", "static")
local transparency
local danceRight

local function switchMenu(menu)
	function backFunc()
		graphics.fadeOut(0.5, love.event.quit)
	end

	menuState = 1
end

return {
	enter = function(self, previous)
		if not music[1]:isPlaying() then
			music[1]:play()
		end
		music[1]:onBeat(function()
			self:onBeat(music[1]:getBeat())
		end)
		danceRight = false
		transparency = {0}
		Timer.tween(
			1,
			transparency,
			{[1] = 1},
			"out-quad"
		)
		titleBG = graphics.newImage(love.graphics.newImage(graphics.imagePath("menu/titleBG")))
		changingMenu = false
		logo = sprite(-800, -450)
		logo:setFrames(paths.getSparrowFrames("logoBumpin"))
   		logo:addAnimByPrefix("bump", "logo bumpin", 24)
		
		logo:animate("bumpin", false)

		if love.system.getOS() == "OS X" and gamejoltLogin["useGamejolt"] then
			gamejolt.giveTrophy(175141)
		end

		songNum = 0

		switchMenu(1)

		graphics.setFade(0)
		graphics.fadeIn(0.5)

		updatePres("Press Enter", "In the Menu")
	end,
	onBeat = function(self, n)
		--if logo then logo:animate("anim", false) end
		if logo then logo:animate("bump", false) end
	end,

	update = function(self, dt)
		logo:update(dt)

		music[1]:updateBeat()

		if not graphics.isFading() then
			if input:pressed("confirm") then
				
				if not changingMenu then
					audio.playSound(confirmSound)
					changingMenu = true
					graphics.fadeOut(0.2, function()
						Gamestate.switch(menuSelect)
						status.setLoading(false)
					end)
				end
			elseif input:pressed("back") then
				audio.playSound(selectSound)

				backFunc()
			end
		end
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)

			love.graphics.push()
				love.graphics.push()
					love.graphics.translate(menuDetails.titleBG.x, menuDetails.titleBG.y)
					titleBG:draw()
				love.graphics.pop()
				love.graphics.push()
					love.graphics.scale(0.9, 0.9)
					love.graphics.translate(menuDetails.titleLogo.x, menuDetails.titleLogo.y)
					logo:draw()
				love.graphics.pop()
				love.graphics.push()
					love.graphics.scale(0.9, 0.9)
					--love.graphics.translate(menuDetails.girlfriendTitle.x, menuDetails.girlfriendTitle.y)
				love.graphics.pop()
				love.graphics.push()
					graphics.setColor(0, 0, 0, 0.9)
					graphics.setColor(1, 1, 1)
				love.graphics.pop()
			love.graphics.pop()

		love.graphics.pop()
	end,

	leave = function(self)
		--girlfriendTitle = nil
		logo = nil

		Timer.clear()
	end
}
