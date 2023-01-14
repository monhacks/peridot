	const_def 2 ; object constants

GraveyardWorld2_MapScripts:
	db 0 ; scene scripts

	db 2 ; callbacks
	callback MAPCALLBACK_NEWMAP, .SetRandomWarps
	callback MAPCALLBACK_TILES, .Gates

.SetRandomWarps
	setevent EVENT_BATTLE_SIM_VISITED_GRAVEYARD
.Reroll
	random 6
	ifequal 1, .WarpComputer
	ifequal 2, .WarpSky
	ifequal 3, .WarpVolcano
	ifequal 4, .WarpIceCave
	ifequal 5, .WarpForest

	checkevent EVENT_BATTLE_SIM_VISITED_CASTLE
	iftrue .Reroll
	warpmod 1, BATTLE_SIM_CASTLE_3
	return

.WarpComputer:
	checkevent EVENT_BATTLE_SIM_VISITED_COMPUTER
	iftrue .Reroll
	warpmod 1, BATTLE_SIM_COMP_3
	return

.WarpSky:
	checkevent EVENT_BATTLE_SIM_VISITED_SKY
	iftrue .Reroll
	warpmod 1, BATTLE_SIM_SKY_3
	return

.WarpVolcano:
	checkevent EVENT_BATTLE_SIM_VISITED_VOLCANO
	iftrue .Reroll
	warpmod 1, BATTLE_SIM_LAVA_3
	return

.WarpIceCave:
	checkevent EVENT_BATTLE_SIM_VISITED_ICE_CAVE
	iftrue .Reroll
	warpmod 1, BATTLE_SIM_ICE_3
	return

.WarpForest:
	checkevent EVENT_BATTLE_SIM_VISITED_FOREST
	iftrue .Reroll
	warpmod 1, BATTLE_SIM_FOREST_3
	return

.Gates:
	checkevent EVENT_BATTLE_SIM_GRAVE_GATE_1
	iffalse .Gate2
	changeblock 14, 16, $1e
	changeblock 16, 18, $6f
.Gate2
	checkevent EVENT_BATTLE_SIM_GRAVE_GATE_2
	iffalse .Gate3
	changeblock 14,  4, $71
	changeblock  6,  6, $6f
.Gate3
	checkevent EVENT_BATTLE_SIM_GRAVE_GATE_3
	iffalse .Gate4
	changeblock  6, 12, $35
	changeblock 10, 10, $6f
.Gate4
	checkevent EVENT_BATTLE_SIM_GRAVE_GATE_4
	iffalse .NoGates
	changeblock 12,  2, $1e
	changeblock  6, 16, $6f
.NoGates
	return

Graveyard2Switch1:
	opentext
	changeblock 14, 16, $1e
	changeblock 16, 18, $6f
	reloadmappart
	closetext
	setevent EVENT_BATTLE_SIM_GRAVE_GATE_1
	end

Graveyard2Switch2:
	opentext
	changeblock 14,  4, $71
	changeblock  6,  6, $6f
	reloadmappart
	closetext
	setevent EVENT_BATTLE_SIM_GRAVE_GATE_2
	end

Graveyard2Switch3:
	opentext
	changeblock  6, 12, $35
	changeblock 10, 10, $6f
	reloadmappart
	closetext
	setevent EVENT_BATTLE_SIM_GRAVE_GATE_3
	end

Graveyard2Switch4:
	opentext
	changeblock 12,  2, $1e
	changeblock  6, 16, $6f
	reloadmappart
	closetext
	setevent EVENT_BATTLE_SIM_GRAVE_GATE_4
	end

GraveyardWorld2_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 14, 19, BATTLE_SIMULATION, -1 ; Entrance
	warp_event  5,  0, BATTLE_SIMULATION, -1 ; Exit

	db 0 ; coord events

	db 4 ; bg events
	bg_event 16, 18, BGEVENT_UP, Graveyard2Switch1
	bg_event  6,  6, BGEVENT_UP, Graveyard2Switch2
	bg_event 10, 10, BGEVENT_UP, Graveyard2Switch3
	bg_event  6, 16, BGEVENT_UP, Graveyard2Switch4

	db 0 ; object events
