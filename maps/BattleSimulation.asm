	const_def 2 ; object constants
	const BATTLESIMULATION_SCIENTIST1
	const BATTLESIMULATION_SCIENTIST2
	const BATTLESIMULATION_SCIENTIST3
	const BATTLESIMULATION_SCIENTIST4
	const BATTLESIMULATION_SCIENTIST5
	const BATTLESIMULATION_SUPER_NERD

BattleSimulation_MapScripts:
	db 4 ; scene scripts
	scene_script .Scene0 ; SCENE_BATTLESIMULATION_DEFAULT
	scene_script .Scene1 ; SCENE_BATTLESIMULATION_CHALLENGE
	scene_script .Scene2 ; SCENE_BATTLESIMULATION_FINISHED
	scene_script .Scene3 ; SCENE_BATTLESIMULATION_RETURNED_TO_PRESENT

	db 1 ; callbacks
	callback MAPCALLBACK_OBJECTS, .Scientist

.Scene0:
	end

.Scene1:
	opentext
	writetext BattleSimulationChallengeCancelled
	waitbutton
	closetext
	setscene SCENE_BATTLESIMULATION_DEFAULT
	end
	
.Scene2:
	playsound SFX_WARP_FROM
	waitsfx
	playsound SFX_SHUT_DOWN_PC
	waitsfx
	playsound SFX_MENU
	waitsfx
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	special ReplaceKrisSprite
	applymovement PLAYER, BattleSimulationPlayerLeaveMachine
	applymovement BATTLESIMULATION_SCIENTIST1, BattleSimulationBlockEntrance
	special LoadPokemonData
	clearflag ENGINE_BATTLE_SIMULATION_ACTIVE
	setscene SCENE_BATTLESIMULATION_DEFAULT
	special UpdatePartyStats
;	special DoQuickSave
	; Check the player's score an issue a reward.
	end

.Scene3:
	; Do the re-entry scene after the Celebi boss.
	end

.Scientist
	checkscene SCENE_BATTLESIMULATION_FINISHED
	iffalse .nothing
	moveobject BATTLESIMULATION_SCIENTIST1, 9, 7
	turnobject BATTLESIMULATION_SCIENTIST1, RIGHT
.nothing
	return

BattleSimulationGuy:
	opentext
	setscene SCENE_BATTLESIMULATION_CHALLENGE
;	special TryQuickSave
;	iffalse .Decline
	writetext BattleSimulationTakeASeatText
	waitbutton
	closetext
	follow BATTLESIMULATION_SCIENTIST1, PLAYER
	applymovement BATTLESIMULATION_SCIENTIST1, BattleSimulationEntrance
	stopfollow
	applymovement PLAYER, BattleSimulationPlayerEnterMachine
	setflag ENGINE_BATTLE_SIMULATION_ACTIVE
	special UpdatePartyStats
	special DropOffParty
	givepoke MEWTWO, 100
;	special GiveShuckle
	loadvar wParkBallsRemaining, 30
	playsound SFX_MENU
	writecode VAR_MOVEMENT, PLAYER_HEADSET
	special ReplaceKrisSprite
;	waitsfx
	wait 5
	applymovement BATTLESIMULATION_SCIENTIST1, BattleSimulationActivateComputer
	playsound SFX_BOOT_PC
	wait 15
	playsound SFX_WARP_TO
	special FadeOutPalettes
	waitsfx
	writecode VAR_MOVEMENT, PLAYER_NORMAL
	clearevent EVENT_BATTLE_SIM_VISITED_SKY
	clearevent EVENT_BATTLE_SIM_VISITED_GRAVEYARD
	clearevent EVENT_BATTLE_SIM_VISITED_COMPUTER
	clearevent EVENT_BATTLE_SIM_VISITED_VOLCANO
	clearevent EVENT_BATTLE_SIM_VISITED_ICE_CAVE
	clearevent EVENT_BATTLE_SIM_VISITED_FOREST
	clearevent EVENT_BATTLE_SIM_VISITED_CASTLE
	clearevent EVENT_BATTLE_SIM_GRAVE_GATE_1
	clearevent EVENT_BATTLE_SIM_GRAVE_GATE_2
	clearevent EVENT_BATTLE_SIM_GRAVE_GATE_3
	clearevent EVENT_BATTLE_SIM_GRAVE_GATE_4
	scall .ChooseRandomSpawn
;	warpfacing UP, BATTLE_SIMULATION_FINAL_ROOM, 2, 7
	warpcheck
	end

.Decline
	closetext
	setscene SCENE_BATTLESIMULATION_DEFAULT
	end

.ChooseRandomSpawn
	random 7
	ifequal 1, .WarpSky
	ifequal 2, .WarpComputer
	ifequal 3, .WarpGraveyard
	ifequal 4, .WarpIce
	ifequal 5, .WarpVolcano
	ifequal 6, .WarpForest

	warpmod 1, BATTLE_SIM_CASTLE_1
	return

.WarpSky:
	warpmod 1, BATTLE_SIM_SKY_1
	return

.WarpComputer:
	warpmod 1, BATTLE_SIM_COMP_1
	return

.WarpGraveyard:
	warpmod 1, BATTLE_SIM_GRAVE_1
	return

.WarpIce:
	warpmod 1, BATTLE_SIM_LAVA_1
	return

.WarpVolcano:
	warpmod 1, BATTLE_SIM_LAVA_1
	return

.WarpForest:
	warpmod 1, BATTLE_SIM_FOREST_1
	return

BattleSimulationBPExchange:
	faceplayer
	opentext
	pokemart MARTTYPE_SUBWAY, 0
	closetext
	end

BattleSimulationEntrance:
	step UP
	step RIGHT
	turn_head LEFT
	step_end

BattleSimulationActivateComputer:
	step RIGHT
	turn_head UP
	step_end

BattleSimulationPlayerEnterMachine:
	step UP
	turn_head DOWN
	step_sleep 10
	step_resume

BattleSimulationBlockEntrance:
	step LEFT
	step DOWN
	step_resume

BattleSimulationPlayerLeaveMachine:
	step DOWN
	step DOWN
	step DOWN
	step DOWN
	turn_head UP
	step_end

BattleSimulationTakeASeatText:
	text "Please take a seat"
	line "at the terminal"
	cont "and put on the"
	cont "headset."
	done

BattleSimulationChallengeCancelled:
	text "The connection to"
	line "virtual reality"
	cont "was lost."

	para "We're sorry, but"
	line "your challenge has"
	cont "been forfeit."
	done

;	setflag ENGINE_BATTLE_SIMULATION_ACTIVE
;	special DropOffParty
;	special GiveShuckle
;	loadvar wParkBallsRemaining, 30

; When leaving...
;	special LoadPokemonData

; For the interior maps, make sure to set a random warp with a callback.
; 1F-4F will be randomized between 4 different maps each time.
; 5F will contain a boss battle and always be the same.

BattleSimulation_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 13,  1, MAPLES_LAB_ELEVATOR, 1
	warp_event  8,  6, BATTLE_SIMULATION, -1

	db 0 ; coord events

	db 0 ; bg events

	db 6 ; object events
	object_event  8,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, BattleSimulationGuy, -1
	object_event 16,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 19,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 19,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimulationBPExchange, -1
	object_event  6, 11, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
	object_event 11, 12, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ObjectEvent, -1
