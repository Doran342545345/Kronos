local url = "https://raw.githubusercontent.com/Saersa/ExploitingGuest_ScriptHub/main/Final_Scripts"

local games = {
	[90568084448279] = "One_Tap"; -- GameID, script name
    
	
	
}

for i,v in next, games do
    games[i] = table.concat(v:split(' '), '_')
end

local name = games[game.PlaceId] or games[game.GameId]
return loadstring(game:HttpGet(url.. "/"..(name or "Universal")..".lua"))()
