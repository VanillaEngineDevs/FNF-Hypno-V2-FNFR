local difficulty

local stageBack, stageFront, curtains

return {
	enter = function(self, from, songNum, songAppend)
		usePendulum = false
		pauseColor = {129, 100, 223}
		weeksShitno:enter()
		cold = true

		week = 1

		cam.sizeX, cam.sizeY = 0.75, 0.75
		camScale.x, camScale.y = 0.75, 0.75

		song = songNum
		difficulty = songAppend

        bg = graphics.newImage(love.graphics.newImage(graphics.imagePath("frostbite/bg")))

		
		boyfriend = love.filesystem.load("sprites/shitno/Grey_Assets.lua")()
		enemy = love.filesystem.load("sprites/shitno/shitno.lua")()

		boyfriend.sizeX, boyfriend.sizeY = 3, 3

		healthBarColorEnemy = {175,102,206}

		enemyIcon:animate("daddy dearest", false)
		boyfriend:animate("coldidle", false)

		enemy.colours = {175,102,206}		
		boyfriend.colours = {183,216,85}



		self:load()

	end,

	load = function(self)
		weeksShitno:load()
		inst = waveAudio:newSource("songs/shitno/Inst.ogg", "stream")
		voices = waveAudio:newSource("songs/shitno/Voices.ogg", "stream")
		self:initUI()
		weeksShitno:setupCountdown()

		--inst:setPitch(1.25)
		--voices:setPitch(1.25)

		--inst:seek(80)
		--voices:seek(80)
	end,

	initUI = function(self)
		weeksShitno:initUI()
		weeksShitno:generateNotes("songs/shitno/chart.json")
	end,

	update = function(self, dt)
		weeksShitno:update(dt)

		if health >= 80 then
			if enemyIcon:getAnimName() == "daddy dearest" then
				enemyIcon:animate("daddy dearest losing", false)
			end
		else
			if enemyIcon:getAnimName() == "daddy dearest losing" then
				enemyIcon:animate("daddy dearest", false)
			end
		end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) and not paused then
			if score > highscores[weekNum-1].scores[song] then
				highscores[weekNum-1].scores[song] = score
				saveHighscores()
			end
			newAccuracy = convertedAcc:gsub("%%", "")
			if tonumber(newAccuracy) > highscores[weekNum-1].accuracys[song] then
				print("New accuracy: " .. newAccuracy)
				highscores[weekNum-1].accuracys[song] = tonumber(newAccuracy)
				saveHighscores()
			end
			if storyMode and song < 3 then
				song = song + 1
				Timer.clear()
				pendulum.orientation = 0
				self:load()
			else
				status.setLoading(true)

				graphics.fadeOut(
					0.5,
					function()
						Gamestate.switch(menu)

						status.setLoading(false)
					end
				)
			end
		end



		--print(cold)
		if musicTime >= 7333.33333333333 and musicTime < 7358.33333333333 then 
			--boyfriend:animate("coldTalk", false)

			weeks:safeAnimate(boyfriend, "coldTalk", false, 2)
		end

		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			boyfriend:animate("turn", false, function()
				cold = false
			end)
		end

		if musicTime >= 46333.3333333333 and musicTime < 46358.3333333333 then 
			weeks:safeAnimate(boyfriend, "talk1", false, 2)

			--boyfriend:animate("talk1", false)
		end

		--if musicTime >= 46333.3333333333 and musicTime < 46358.3333333333 then 
		--	weeks:safeAnimate(boyfriend, "talk2", false, 2)
		--end
		if musicTime >= 170500 and musicTime < 170525 then 
			weeks:safeAnimate(boyfriend, "talk2", false, 2)
		end

--[[
		if musicTime >= 0 and musicTime < 25 then 
			HideP2Icon()
		end
		if musicTime >= 0 and musicTime < 25 then 
			FadeInIntro()
		end
		if musicTime >= 7333.33333333333 and musicTime < 7358.33333333333 then 
			GreyCold()
		end
		if musicTime >= 9333.33333333333 and musicTime < 9358.33333333333 then 
			HUDFade()
		end
		if musicTime >= 33333.3333333333 and musicTime < 33358.3333333333 then 
			HUDFadeMidSong()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			GreyTurnAround()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			ShitnoLaugh()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			ShitnoLaugh()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			ShitnoLaugh()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			ShitnoLaugh()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			ChromaticRiser()
		end
		if musicTime >= 34666.6666666667 and musicTime < 34691.6666666667 then 
			ChromaticRiser()
		end
		if musicTime >= 36000 and musicTime < 36025 then 
			ShitnoLaugh()
		end
		if musicTime >= 36000 and musicTime < 36025 then 
			ShitnoLaugh()
		end
		if musicTime >= 36000 and musicTime < 36025 then 
			ShitnoLaugh()
		end
		if musicTime >= 36000 and musicTime < 36025 then 
			ShitnoLaugh()
		end
		if musicTime >= 37333.3333333333 and musicTime < 37358.3333333333 then 
			HUDFadeMidSong()
		end
		if musicTime >= 46333.3333333333 and musicTime < 46358.3333333333 then 
			GreyFreak()
		end
		if musicTime >= 59000 and musicTime < 59025 then 
			CameraBopSpeed()
		end
		if musicTime >= 101333.333333333 and musicTime < 101358.333333333 then 
			CameraBopSpeed()
		end
		if musicTime >= 170500 and musicTime < 170525 then 
			GreyYell()
		end

		--]]

		weeksShitno:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(extraCamZoom.sizeX, extraCamZoom.sizeY)
			love.graphics.scale(cam.sizeX, cam.sizeY)

            love.graphics.push()
                love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				--enemy:draw()

				boyfriend:draw()
				--love.graphics.setColor(1, 1, 1, 0.6)


            love.graphics.pop()
            love.graphics.push()
                love.graphics.translate(cam.x, cam.y)
            love.graphics.pop()
            love.graphics.push()
                love.graphics.translate(cam.x * 1.1, cam.y * 1.1)
                -- stage foreground (in front of characters)
            love.graphics.pop()
			weeksShitno:drawRating(0.9)
		love.graphics.pop()
		
		weeksShitno:drawTimeLeftBar()
		weeksShitno:drawHealthBar()
		if not paused then
			weeksShitno:drawUI()
		end
	end,

	leave = function(self)
		usePendulum = false
		weeksShitno:leave()
	end
}