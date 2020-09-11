	const_def 2 ; object constants
	const MAHOGANYDEPTSTOREROOF_CLERK1
	const MAHOGANYDEPTSTOREROOF_SCIENTIST
	const MAHOGANYDEPTSTOREROOF_SUPER_NERD
	const MAHOGANYDEPTSTOREROOF_CLERK2
	const MAHOGANYDEPTSTOREROOF_YOUNGSTER
	const MAHOGANYDEPTSTOREROOF_POKEFAN_F
	const MAHOGANYDEPTSTOREROOF_CLERK3
	const MAHOGANYDEPTSTOREROOF_LASS
	const MAHOGANYDEPTSTOREROOF_ROCKER
	const MAHOGANYDEPTSTOREROOF_FISHER

MahoganyDeptStoreRoof_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_TILES, .Morning
	
.Morning:
	checktime MORN
	iffalse .CheckNight
	changeblock   2, 0, $1f
	changeblock   4, 0, $1f
	changeblock   6, 0, $1f
	changeblock   8, 0, $1f
	changeblock  10, 0, $1f
	changeblock  12, 0, $1f
	changeblock  14, 0, $1f
	changeblock  16, 0, $1f
	changeblock  18, 0, $1f
	changeblock  20, 0, $1f
	changeblock  22, 0, $1f
	changeblock  24, 0, $1f
	changeblock   0, 2, $1e
	changeblock   2, 2, $1e
	changeblock   4, 2, $1e
	changeblock   6, 2, $1d
	changeblock   8, 2, $1e
	changeblock  10, 2, $1e
	changeblock  12, 2, $1e
	changeblock  14, 2, $1e
	changeblock  16, 2, $1e
	changeblock  18, 2, $1e
	changeblock  20, 2, $1e
	changeblock  22, 2, $1e
	changeblock  24, 2, $1e
	jump .skip
.CheckNight
	checktime NITE
	iffalse .skip
	changeblock   2, 0, $19
	changeblock   4, 0, $1b
	changeblock   6, 0, $19
	changeblock   8, 0, $1b
	changeblock  10, 0, $19
	changeblock  12, 0, $1a
	changeblock  14, 0, $1b
	changeblock  16, 0, $19
	changeblock  18, 0, $1b
	changeblock  20, 0, $19
	changeblock  22, 0, $1b
	changeblock  24, 0, $19
.skip
	return

MahoganyDeptStoreRoofMorningClerkScript:
	faceplayer
	opentext
	writetext MahoganyDeptStoreRoofMorningClerkText
	waitbutton
	jump MahoganyDeptStoreRoofClerkMart
	
MahoganyDeptStoreRoofDayClerkScript:
	faceplayer
	opentext
	writetext MahoganyDeptStoreRoofDayClerkText
	waitbutton
	jump MahoganyDeptStoreRoofClerkMart
	
MahoganyDeptStoreRoofNightClerkScript:
	faceplayer
	opentext
	writetext MahoganyDeptStoreRoofNightClerkText
	waitbutton
	
MahoganyDeptStoreRoofClerkMart:
	pokemart MARTTYPE_ROOFTOP, 0
	closetext
	end

MahoganyDeptStoreRoofScientistScript:
	jumptextfaceplayer MahoganyDeptStoreRoofScientistText

MahoganyDeptStoreRoofPokefanFScript:
	jumptextfaceplayer MahoganyDeptStoreRoofPokefanFText
	
MahoganyDeptStoreRoofLassScript:
	faceplayer
	opentext
	writetext MahoganyDeptStoreRoofLassText1
	waitbutton
	closetext
	turnobject LAST_TALKED, UP
	turnobject PLAYER, UP
	opentext
	writetext MahoganyDeptStoreRoofLassText2
	waitbutton
	closetext
	end

MahoganyDeptStoreRoofFisherScript:
	faceplayer
	opentext
	writetext MahoganyDeptStoreRoofFisherText
	waitbutton
	closetext
	turnobject MAHOGANYDEPTSTOREROOF_FISHER, UP
	end

MahoganyDeptStoreRoofYoungsterScript:
	opentext
	writetext MahoganyDeptStoreRoofYoungsterOhWowText
	waitbutton
	closetext
	turnobject MAHOGANYDEPTSTOREROOF_SUPER_NERD, UP
	opentext
	writetext MahoganyDeptStoreRoofYoungsterQuitBotheringMeText
	waitbutton
	closetext
	turnobject MAHOGANYDEPTSTOREROOF_SUPER_NERD, RIGHT
	end

MahoganyDeptStoreRoofSuperNerdScript:
	jumptextfaceplayer MahoganyDeptStoreRoofSuperNerdText

MahoganyDeptStoreRoofRockerScript:
	jumptextfaceplayer MahoganyDeptStoreRoofRockerText

MahoganyDeptStoreBinoculars:
	random 7
	ifequal 0, Binoculars1
	ifequal 1, Binoculars1
	ifequal 2, Binoculars2
	ifequal 3, Binoculars2
	ifequal 4, Binoculars3
	jumptext Binoculars4Text

Binoculars1:
	jumptext Binoculars1Text

Binoculars2:
	jumptext Binoculars2Text

Binoculars3:
	jumptext Binoculars3Text

PokeDollVendingMachine:
	jumptext PokeDollVendingMachineText

MahoganyDeptStoreRoofScientistText:
	text "Huff… Puff…"
	
	para "Jogging up to the"
	line "roof before work"
	cont "is part of my"
	cont "daily routine."

	para "Huff… Puff…"
	
	para "Gotta stay in"
	line "shape somehow,"
	cont "right?"
	done

MahoganyDeptStoreRoofPokefanFText:
	text "Whew, I'm tired."

	para "I sometimes come"
	line "up to the rooftop"
	cont "to get some fresh"
	cont "air."
	
	para "It can get awfully"
	line "stuffy in those"
	cont "shops."
	done

MahoganyDeptStoreRoofLassText1:
	text "Ah… Don't you"
	line "just love the"
	cont "night sky?"

	para "There's something"
	line "about it that"
	cont "fills me with joy."
	done
	
MahoganyDeptStoreRoofLassText2:
	text "Sigh…"
	
	para "Some day I hope to"
	line "explore the stars…"
	done

MahoganyDeptStoreRoofFisherText:
	text "Pardon? How much"
	line "money I spend on"
	cont "these #MON fig-"
	cont "ures is none of"
	cont "your business!"
	
	para "I just want to get"
	line "a cute one!"
	done

MahoganyDeptStoreRoofYoungsterOhWowText:
	text "Oh, wow!"
	done

MahoganyDeptStoreRoofYoungsterQuitBotheringMeText:
	text "Will you quit"
	line "bothering me?"
	done

MahoganyDeptStoreRoofSuperNerdText:
	text "Aw, man!"
	
	para "I must have missed"
	line "the guy selling a"
	cont "SLOWPOKETAIL…"
	
	para "I hear it can"
	line "cause a SHELLDER"
	cont "to evolve."
	done
	
MahoganyDeptStoreRoofRockerText:
	text "The items sold up"
	line "on the roof here"
	cont "are pretty rare."
	
	para "They're also expe-"
	line "nsive, but it sure"
	cont "beats trying to"
	cont "find them out in"
	cont "the wild!"
	done

MahoganyDeptStoreRoofMorningClerkText:
	text "Good morning!"
	done

MahoganyDeptStoreRoofDayClerkText:
	text "Hello! Welcome!"
	done

MahoganyDeptStoreRoofNightClerkText:
	text "Good evening!"
	done

Binoculars1Text:
	text "These binoculars"
	line "let me see so far"
	cont "away. Maybe I can"
	cont "see my own house!"

	para "…Wait, no."
	
	para "My house in in the"
	line "other direction…"
	done

Binoculars2Text:
	text "Hey! A man just"
	line "caught a really"
	cont "big FISH #MON!"
	
	para "It almost looked"
	line "like his ROD was"
	cont "going to snap"
	cont "right in half!"
	done

Binoculars3Text:
	text "Woah! I can see"
	line "the #MON LEAGUE"
	cont "from here!"

	para "I wonder what kind"
	line "of battles are go-"
	cont "ing on there."
	done

Binoculars4Text:
	text "Hm…"
	
	para "Not much is going"
	line "on right now, it"
	cont "seems."
	done

PokeDollVendingMachineText:
	text "It's a vending ma-"
	line "chine for #MON"
	cont "figures."

	para "Insert money, then"
	line "turn the crank…"

	para "But it's complet-"
	line "ely empty!"
	done

MahoganyDeptStoreRoof_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event 17,  5, MAHOGANY_DEPT_STORE_6F, 3

	db 0 ; coord events

	db 4 ; bg events
	bg_event 19,  7, BGEVENT_RIGHT, MahoganyDeptStoreBinoculars
	bg_event 19,  9, BGEVENT_RIGHT, MahoganyDeptStoreBinoculars
	bg_event 19, 10, BGEVENT_RIGHT, MahoganyDeptStoreBinoculars
	bg_event  7,  4, BGEVENT_UP, PokeDollVendingMachine

	db 10 ; object events
	object_event  9,  5, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, MORN, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofMorningClerkScript, -1
	object_event  5,  8, SPRITE_SCIENTIST, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, MORN, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofScientistScript, -1
	object_event 10,  8, SPRITE_SUPER_NERD, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 0, 2, -1, MORN, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofSuperNerdScript, -1
	object_event 10, 10, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, DAY, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofDayClerkScript, -1
	object_event 18, 10, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, DAY, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofYoungsterScript, -1
	object_event 14,  6, SPRITE_POKEFAN_F, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, DAY, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofPokefanFScript, -1
	object_event  6,  9, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, NITE, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofNightClerkScript, -1
	object_event 13,  4, SPRITE_LASS, SPRITEMOVEDATA_STANDING_UP, 1, 0, -1, NITE, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofLassScript, -1
	object_event 17,  9, SPRITE_ROCKER, SPRITEMOVEDATA_WANDER, 0, 0, -1, NITE, 0, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofRockerScript, -1
	object_event  6,  5, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, MahoganyDeptStoreRoofFisherScript, -1
