	const_def 2 ; object constants

CyberspaceWorld3_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_NEWMAP, .GrantPoints

.GrantPoints
	; Make sure this only gives points once.
	; Adjust the amount of points gained later.
	copybytetovar wBlueCardBalance
	addvar 5
	copyvartobyte wBlueCardBalance
	return

BattleSimComp3Trainer1:
	trainer SCIENTIST, COMP3_TRAINER1, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_1, BattleSimTrainerText, BattleSimTrainerWinText, 0, .Script

.Script:
	checkjustbattled
	iffalse .After
	; Text telling the player they gained points
	; Alternatively, this text should be shown in the victory screen.
	copybytetovar wBlueCardBalance
	addvar 1
	copyvartobyte wBlueCardBalance
	end
.After
	opentext
	writetext BattleSimTrainerAfterText
	waitbutton
	closetext
	end

BattleSimComp3Trainer2:
	trainer ENGINEER, COMP3_TRAINER2, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_2, BattleSimTrainerText, BattleSimTrainerWinText, 0, .Script

.Script:
	checkjustbattled
	iffalse .After
	; Text telling the player they gained points
	; Alternatively, this text should be shown in the victory screen.
	copybytetovar wBlueCardBalance
	addvar 1
	copyvartobyte wBlueCardBalance
	end
.After
	opentext
	writetext BattleSimTrainerAfterText
	waitbutton
	closetext
	end

BattleSimComp3Trainer3:
	trainer SUPER_NERD, COMP3_TRAINER3, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_3, BattleSimTrainerText, BattleSimTrainerWinText, 0, .Script

.Script:
	checkjustbattled
	iffalse .After
	; Text telling the player they gained points
	; Alternatively, this text should be shown in the victory screen.
	copybytetovar wBlueCardBalance
	addvar 1
	copyvartobyte wBlueCardBalance
	end
.After
	opentext
	writetext BattleSimTrainerAfterText
	waitbutton
	closetext
	end

BattleSimComp3BonusTrainer:
	trainer TEACHER, COMP3_BONUS, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_8, BattleSimTrainerText, BattleSimTrainerWinText, 0, .Script

.Script:
	checkjustbattled
	iffalse .After
	; Text telling the player they gained points
	; Alternatively, this text should be shown in the victory screen.
	copybytetovar wBlueCardBalance
	addvar 10
	copyvartobyte wBlueCardBalance
	end
.After
	opentext
	writetext BattleSimTrainerAfterText
	waitbutton
	closetext
	end

BattleSimComp3Itemball1:
	opentext
	writetext BattleSimItemBallText
	yesorno
	iffalse .No
	scall BattleSimItemball
	disappear LAST_TALKED
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_4
.No
	closetext
	end

BattleSimComp3Itemball2:
	opentext
	writetext BattleSimItemBallText
	yesorno
	iffalse .No
	scall BattleSimItemball
	disappear LAST_TALKED
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_5
.No
	closetext
	end

BattleSimComp3Itemball3:
	opentext
	writetext BattleSimItemBallText
	yesorno
	iffalse .No
	scall BattleSimItemball
	disappear LAST_TALKED
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_6
.No
	closetext
	end

BattleSimComp3Itemball4:
	opentext
	writetext BattleSimItemBallText
	yesorno
	iffalse .No
	scall BattleSimItemball
	disappear LAST_TALKED
	setevent EVENT_TEMPORARY_UNTIL_MAP_RELOAD_7
.No
	closetext
	end

CyberspaceWorld3_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 11, 20, BATTLE_SIMULATION, -1 ; Entrance
	warp_event 14,  3, BATTLE_SIMULATION_FINAL_ROOM, 1

	db 0 ; coord events

	db 0 ; bg events

	db 9 ; object events
	object_event 10, 15, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_DOWN, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, BattleSimComp3Trainer1, -1
	object_event 24, 13, SPRITE_ROCKER, SPRITEMOVEDATA_WALK_UP_DOWN, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_TRAINER, 1, BattleSimComp3Trainer2, -1
	object_event 14, 26, SPRITE_SUPER_NERD, SPRITEMOVEDATA_STANDING_UP, 1, 1, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 2, BattleSimComp3Trainer3, -1
	object_event 22,  5, SPRITE_POKEFAN_F, SPRITEMOVEDATA_SPINRANDOM_FAST, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_TRAINER, 0, BattleSimComp3BonusTrainer, -1
	object_event 27, 21, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimComp3Itemball1, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_4
	object_event 18, 12, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimComp3Itemball2, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_5
	object_event 20, 16, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimComp3Itemball3, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_6
	object_event 18, 21, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 1, 1, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, BattleSimComp3Itemball4, EVENT_TEMPORARY_UNTIL_MAP_RELOAD_7
	object_event  7,  6, SPRITE_GYM_GUY, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, BattleSimMoveRelearner, -1
