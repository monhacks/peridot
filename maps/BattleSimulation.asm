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
	clearevent EVENT_BATTLE_SIM_CLEARED_1
	clearevent EVENT_BATTLE_SIM_CLEARED_2
	clearevent EVENT_BATTLE_SIM_CLEARED_3

	applymovement PLAYER, BattleSimulationPlayerLeaveMachine
	applymovement BATTLESIMULATION_SCIENTIST1, BattleSimulationBlockEntrance
	special LoadPokemonData
	clearflag ENGINE_BATTLE_SIMULATION_ACTIVE
	setscene SCENE_BATTLESIMULATION_DEFAULT
	turnobject PLAYER, UP
	opentext
	writetext BattleSimulationChallengeEndedText
	waitbutton
	closetext

	; Find a way to directly add the player's final score to the coin amount.
	; This may need to meet thresholds.

	loadvar wBlueCardBalance, 0
	opentext
	special DoQuickSave
	closetext
	end

.Scene3:
	applymovement PLAYER, BattleSimulationPlayerStepDown
	turnobject BATTLESIMULATION_SCIENTIST4, LEFT
	showemote EMOTE_SHOCK, BATTLESIMULATION_SCIENTIST4, 15
	applymovement BATTLESIMULATION_SCIENTIST4, BattleSimulationBlockEntrance
	applymovement PLAYER, BattleSimulationPlayerLeaveTimeMachine
	applymovement BATTLESIMULATION_SCIENTIST4, BattleSimulationTimeMachineBlock
	; Do the re-entry scene after the Celebi boss.
	checkevent EVENT_FOUGHT_BOSS_CELEBI
	iffalse .Fainted
	setscene SCENE_BATTLESIMULATION_DEFAULT
	end

.Fainted:
	setscene SCENE_BATTLESIMULATION_DEFAULT
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
	writetext BattleSimulationIntroductionText
	waitbutton
.MenuLoop
	writetext BattleSimulationMenuText
	loadmenu .MenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Challenge
	ifequal 2, .Explain
	closetext
	end

.Challenge
	writebyte EGG
	special FindPartyMonThatSpecies
	iftrue .Decline
	writetext BattleSimulationPrepareSaveText
	yesorno
	iffalse .Decline
	setscene SCENE_BATTLESIMULATION_CHALLENGE
	special TryQuickSave
	iffalse .Decline
	writetext BattleSimulationTakeASeatText
	waitbutton
	closetext
	follow BATTLESIMULATION_SCIENTIST1, PLAYER
	applymovement BATTLESIMULATION_SCIENTIST1, BattleSimulationEntrance
	stopfollow
	applymovement PLAYER, BattleSimulationPlayerEnterMachine
	setflag ENGINE_BATTLE_SIMULATION_ACTIVE
	special DropOffParty
; 20% chance of getting the Porygon2 with a Trick Mirror
; Every other set gets Leftovers
	random 5
	ifequal 1, .TrickMirror
	givepoke PORYGON2, 50, LEFTOVERS, TRUE, SimPorygon2Name, SimPorygon2OT
	jump .GiveMoves
.TrickMirror
	givepoke PORYGON2, 50, TRICK_MIRROR, TRUE, SimPorygon2Name, SimPorygon2OT
.GiveMoves
	special BattleSimGiftMon
	special UpdatePartyStats
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
	scall .ChooseRandomSpawn
;	warpfacing UP, BATTLE_SIMULATION_FINAL_ROOM, 2, 7
	warpcheck
	end

.Explain
	writetext BattleSimulationExplainationText
	waitbutton
	closetext
	jump .MenuLoop

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

.MenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 8,4, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw .MenuData
	db 1 ; default option

.MenuData:
	db STATICMENU_CURSOR ; flags
	db 3 ; items
	db "CHALLENGE@"
	db "EXPLAIN@"
	db "CANCEL@"

BattleSimulationBPExchange:
	faceplayer
	opentext
	pokemart MARTTYPE_SUBWAY, 0
	closetext
	end

BattleSimulationScientist1:
;	givecoins 20

	copybytetovar wBlueCardBalance
	addvar 40
	copyvartobyte wBlueCardBalance
	setflag ENGINE_BATTLE_SIMULATION_ACTIVE
	jumptextfaceplayer BattleSimulationScientist1Text

BattleSimulationScientist2:
;	givecoins 20
	scall BattleSimGrantBP
	jumptextfaceplayer BattleSimulationScientist2Text

BattleSimulationRocker:
	jumptextfaceplayer BattleSimulationRockerText
	
BattleSimulationTimeMachineGuy:
	jumptextfaceplayer BattleSimulationTimeMachineGuyUnavailableText

BattleSimItemball:
	random 15
	ifgreater 10, .WildEncounter
	ifgreater  4, .Found5Balls
	ifgreater  6, .Found10Balls
	ifequal 7, .Found20Balls
	writetext BattleSimFoundSacredAshText
	special HealParty
	playsound SFX_FULL_HEAL
	waitsfx
	writetext BattleSimPlayerUsedSacredAshText
	waitbutton
	jump .Done
.Found5Balls
	copybytetovar wParkBallsRemaining
	addvar 5
	copyvartobyte wParkBallsRemaining
	writetext BattleSimFound5CyberBallsText
	waitbutton
	jump .Done
.Found10Balls
	copybytetovar wParkBallsRemaining
	addvar 10
	copyvartobyte wParkBallsRemaining
	writetext BattleSimFound10CyberBallsText
	waitbutton
	jump .Done
.Found20Balls	
	copybytetovar wParkBallsRemaining
	addvar 20
	copyvartobyte wParkBallsRemaining
	writetext BattleSimFound20CyberBallsText
	waitbutton
.Done
	closetext
	end

.WildEncounter:
	writetext BattleSimItemballEncounterText
	waitbutton
	closetext
	jumpstd battlesimencounter

BattleSimMoveRelearner:
	faceplayer
	opentext
	special SpecialMoveRelearner
	waitbutton
	closetext
	end

BattleSimHealer:
	faceplayer
	opentext
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_8
	iftrue .NotFirstTime
	writetext BattleSimHealerFirstTimeText
	yesorno
	iffalse .Decline
.DoHeal
	closetext
	special FadeBlackQuickly
	special ReloadSpritesNoPalettes
	special StubbedTrainerRankings_Healings
	playmusic MUSIC_HEAL
	special HealParty
	pause 60
	special FadeInQuickly
	special RestartMapMusic
	opentext
	writetext BattleSimHealerAllSetText
	waitbutton
	writetext BattleSimHealerDeclineText
	waitbutton
	closetext
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_8
	end

.NotFirstTime
	writetext BattleSimHealerCostText
	yesorno
	iffalse .Decline
	copybytetovar wBlueCardBalance
	ifless 5, .NotEnoughPoints
	copybytetovar wBlueCardBalance
	addvar -5
	copyvartobyte wBlueCardBalance
	jump .DoHeal

.NotEnoughPoints
	writetext BattleSimHealerNotEnoughPointsText
	waitbutton
	closetext
	end

.Decline
	writetext BattleSimHealerDeclineText
	waitbutton
	closetext
	end

BattleSimGrantBP:
	copybytetovar wBlueCardBalance
	ifless 40, .Check35
	givecoins 9
.Check35
	ifless 35, .Check30
	givecoins 8
.Check30
	ifless 30, .Check25
	givecoins 7
.Check25
	ifless 25, .Check20
	givecoins 6
.Check20
	ifless 20, .Check15
	givecoins 5
.Check15
	ifless 15, .Check10
	givecoins 4
.Check10
	ifless 10, .Check5
	givecoins 3
.Check5
	ifless  5, .LessThan5
	givecoins 2
.LessThan5
	givecoins 1
	checkevent EVENT_BATTLE_SIM_DEFEATED_BOSS
	iffalse .End
	givecoins 11
.End
	end

SimulationStage1TrainerCheck:
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iffalse .end
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iffalse .end
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	iffalse .end
	setevent EVENT_BATTLE_SIM_CLEARED_1
	opentext
	writetext BattleSimDefeatedAllTrainersText
	waitbutton
	closetext
	copybytetovar wBlueCardBalance
	addvar 5
	copyvartobyte wBlueCardBalance
.end
	end

SimulationStage2TrainerCheck:
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iffalse .end
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iffalse .end
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	iffalse .end
	setevent EVENT_BATTLE_SIM_CLEARED_2
	copybytetovar wBlueCardBalance
	addvar 5
	copyvartobyte wBlueCardBalance
.end
	end

SimulationStage3TrainerCheck:
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1
	iffalse .end
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2
	iffalse .end
	checkevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3
	iffalse .end
	setevent EVENT_BATTLE_SIM_CLEARED_3
	copybytetovar wBlueCardBalance
	addvar 5
	copyvartobyte wBlueCardBalance
.end
	end

SimulationMoveReminder:
	faceplayer
	opentext
	special SimulationMoveRelearner
	waitbutton
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
	turn_head UP
	step_end

BattleSimulationPlayerStepDown:
	step DOWN
	step_resume

BattleSimulationPlayerLeaveTimeMachine:
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head LEFT
	step_end

BattleSimulationTimeMachineBlock:
	step UP
	step RIGHT
	step_end

BattleSimBlockerGuy:
	jumptextfaceplayer BattleSimBlockerGuyText

BattleSimBlockerGuyText:
	text "For the purposes"
	line "of this test, I"
	cont "can't allow you to"
	cont "leave this area."
	done

SimPorygon2Name:
	db "PORYGON2@"

SimPorygon2OT:
	db "BTTLSIM@"

BattleSimulationIntroductionText:
	text "Welcome to the"
	line "BATTLE SIMULATION."
	done

BattleSimulationMenuText:
	text "Would you like to"
	line "log in?"
	done

BattleSimulationExplainationText:
	text "In the BATTLE"
	line "SIMULATION, you"
	cont "will use a rental"
	cont "#MON in order"
	cont "to complete 3"
	cont "stages."

	para "BP will be awarded"
	line "for each completed"
	cont "stage, with a"
	cont "bonus for defeat-"
	cont "ing every trainer"
	cont "in a stage."
	done

BattleSimulationPrepareSaveText:
	text "Would you like to"
	line "save before we"
	cont "get you set up?"
	done

BattleSimulationTakeASeatText:
	text "Please take a seat"
	line "at the terminal"
	cont "and put on the"
	cont "headset."
	done

BattleSimulationChallengeEndedText:
	text "You gained @"
	text_decimal wBlueCardBalance, 1, 2
	line "POINTs during that"
	cont "run."
	done

BattleSimulationRewardText:
	text "Meaning you have"
	line "earned @"
	text_decimal wScriptVar, 1, 3
	text " BP."
	done

BattleSimulationBossRewardText:
	text "And for clearing"
	line "the battle against"
	cont "PROF. MAPLE, you"
	cont "have earned 11"
	cont "additional BP!"
	done

BattleSimulationChallengeCancelled:
	text "The connection to"
	line "virtual reality"
	cont "was lost."

	para "We're sorry, but"
	line "your challenge has"
	cont "been forfeit."
	done

BattleSimItemBallText:
	text "It's an ITEM"
	line "CAPSULE."

	para "Open it?"
	done

BattleSimFoundSacredAshText:
	text "<PLAYER> found"
	line "some SACRED ASH!"
	done

BattleSimPlayerUsedSacredAshText:
	text "<PLAYER>'s #MON"
	line "were restored to"
	cont "full health!"
	done

BattleSimFound5CyberBallsText:
	text "<PLAYER> found"
	line "5 CYBER BALLs!"
	done

BattleSimFound10CyberBallsText:
	text "<PLAYER> found"
	line "10 CYBER BALLs!"
	done

BattleSimFound20CyberBallsText:
	text "<PLAYER> found"
	line "20 CYBER BALLs!"
	done

BattleSimFound5PointsText:
	text "<PLAYER> found"
	line "5 points!"
	done

BattleSimHealerFirstTimeText:
	text "Would you like to"
	line "heal your #MON?"

	para "The first time is"
	line "free."
	done

BattleSimHealerCostText:
	text "Would you like to"
	line "heal your #MON?"

	para "It will cost you"
	line "5 points."
	done

BattleSimHealerDeclineText:
	text "Good luck,"
	line "<PLAYER>!"
	done

BattleSimHealerNotEnoughPointsText:
	text "Oh, I'm sorry…"

	para "You don't have"
	line "enough points to"
	cont "heal your #MON."
	done

BattleSimHealerAllSetText:
	text "All done!"

	para "Your #MON are"
	line "fighting fit!"
	done

BattleSimItemballEncounterText:
	text "There is a wild"
	line "#MON inside!"

	para "The wild #MON"
	line "attacked!"
	done

BattleSimTrainerText:
	text "Battle protocol"
	line "initiated."
	done

BattleSimTrainerWinText:
	text "Battle complete."
	
	para "Winner: <PLAYER>."
	done

BattleSimTrainerAfterText:
	text "Unable to battle."
	done

BattleSimDefeatedAllTrainersText:
	text "For defeating all"
	line "trainers on this"
	cont "stage, you have"
	cont "won an additional"
	cont "5 points!"
	done

BattleSimulationScientist1Text:
	text "This is PROF."
	line "MAPLE's dream!"

	para "A way to teach"
	line "people about"
	cont "#MON in a safe,"
	cont "controlled envi-"
	cont "ronment."
	done

BattleSimulationScientist2Text:
	text "We have been work-"
	line "ing dilligently to"
	cont "get the BATTLE"
	cont "SIMULATION online."
	done

BattleSimulationRockerText:
	text "I can't get past"
	line "the second stage"
	cont "of the BATTLE"
	cont "SIMULATION."

	para "I heard there is"
	line "a good reward if"
	cont "you can beat all"
	cont "3 stages."
	done

BattleSimulationTimeMachineGuyUnavailableText:
	text "The TIME MACHINE"
	line "is still missing a"
	cont "key component."

	para "Without it, this"
	line "MACHINE is comp-"
	cont "letely useless."
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
	warp_event  8,  6, BATTLE_SIMULATION, -1
	warp_event 13,  0, MAPLES_LAB_ELEVATOR, 1

	db 0 ; coord events

	db 0 ; bg events

	db 7 ; object events
	object_event  8,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, BattleSimulationGuy, -1
	object_event 16,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimulationScientist1, -1
	object_event 19,  4, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimulationScientist2, -1
	object_event 19,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimulationBPExchange, -1
	object_event  6, 11, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimulationTimeMachineGuy, -1
	object_event 11, 12, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimulationRocker, -1
	object_event 13,  2, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, BattleSimBlockerGuy, -1
