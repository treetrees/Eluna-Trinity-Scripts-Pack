print("+-+-+-+-+-+-+-+-+-+-+-+")
print("+CheaterStone Loading +")
local itemid = nil -- 400582 -- default

local offset = 10000 -- must be higher than the highest entry in world.game_tele table.
local CHEATER = {};
local CHEATSTONE = {};

local Q = WorldDBQuery("SELECT * FROM world.game_tele;");

	if(Q)then
		repeat
			CHEATER[Q:GetUInt32(0)] = {
							entry = Q:GetUInt32(0),
							x = Q:GetUInt32(1),
							y = Q:GetUInt32(2),
							z = Q:GetUInt32(3),
							o = Q:GetUInt32(4),
							map = Q:GetUInt32(5),
							name = Q:GetString(6),
										};
			until not Q:NextRow()
	end

local pages = (#CHEATER / 15)

local function CheaterStoneOnHello(event, player, unit, sender, intid, code)
CHEATSTONE[player:GetGUIDLow()] = {	page = 0,};

	if(pages > 15)then
			
		for page=1, 15 do
			
			player:GossipMenuAddItem(2, page, (offset+page), 0)
				
		end
	
		player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)

	else
		for page=1, pages do
			player:GossipMenuAddItem(2, page, (offset+page), 0)
		end
			

	end
player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
player:GossipSendMenu(1, unit)
end

local function back(player, unit)

	if(CHEATSTONE[player:GetGUIDLow()].page > 1)then
		CHEATSTONE[player:GetGUIDLow()].page = (CHEATSTONE[player:GetGUIDLow()].page - 15)

		for page=CHEATSTONE[player:GetGUIDLow()].page, CHEATSTONE[player:GetGUIDLow()].page+15 do
			player:GossipMenuAddItem(2, page, (offset+page), 0)
		end

		player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
		player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)
		player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
		player:GossipSendMenu(1, unit)
	end
end

local function next(player, unit)

	if(CHEATSTONE[player:GetGUIDLow()].page < (#CHEATER/15))then
		CHEATSTONE[player:GetGUIDLow()].page = (CHEATSTONE[player:GetGUIDLow()].page + 15)

		for page=CHEATSTONE[player:GetGUIDLow()].page, CHEATSTONE[player:GetGUIDLow()].page+15 do
			
			if(page <=pages)then
				player:GossipMenuAddItem(2, page, (offset+page), 0)
			else
			end
		end

		player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
		player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)
		player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
		player:GossipSendMenu(1, unit)
	end
end

local function returnz(player, unit)

		for page=CHEATSTONE[player:GetGUIDLow()].page, CHEATSTONE[player:GetGUIDLow()].page+15 do
			player:GossipMenuAddItem(2, page, (offset+page), 0)
		end

	player:GossipMenuAddItem(1, "<- back", (offset+offset+0), 0)
	player:GossipMenuAddItem(1, "next ->", (offset+offset+1), 0)
	player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
	player:GossipSendMenu(1, unit)
end

local function CheaterStoneOnSelect(event, player, unit, sender, intid, code)

	if(sender == (offset+offset+0))then
		back(player, unit)
		return false;
	end
	
	if(sender == (offset+offset+1))then
		next(player, unit)
		return false;
	end
	
	if(sender == (offset+offset+2))then
		player:GossipComplete()
		return false;
	end
	
	if(sender == (offset+offset+3))then -- return
		returnz(player, unit)
	end
	
	if(intid == 0)then
		for loc=(((sender-offset)*15)-14), ((sender-offset)*15) do
			player:GossipMenuAddItem(2, CHEATER[loc].name, loc, loc)
		end
		player:GossipMenuAddItem(1, "<- back", (offset+offset+3), 0)
		player:GossipMenuAddItem(1, "goodbye <->", (offset+offset+2), 0)
		player:GossipSendMenu(1, unit)
	else
        player:Teleport(CHEATER[sender].map, CHEATER[sender].x, CHEATER[sender].y, CHEATER[sender].z, CHEATER[sender].o)
	end			
end

print("+-+-+-+-+-+-+-+-+-+-+-+")
if(itemid ~= nil)then
	RegisterItemGossipEvent(itemid, 1, CheaterStoneOnHello)
	RegisterItemGossipEvent(itemid, 2, CheaterStoneOnSelect)
	print("+    Item active.     +")
else
	print("+      Item nil.      +")
end
print("+-+-+-+-+-+-+-+-+-+-+-+")
print("+CheaterStone Loaded  +")
print("+-+-+-+-+-+-+-+-+-+-+-+")
