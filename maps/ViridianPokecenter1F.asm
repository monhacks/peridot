	const_def 2 ; object constants
	const VIRIDIANPOKECENTER1F_NURSE
	const VIRIDIANPOKECENTER1F_COOLTRAINER_M
	const VIRIDIANPOKECENTER1F_COOLTRAINER_F
	const VIRIDIANPOKECENTER1F_BUG_CATCHER

ViridianPokecenter1F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

ViridianPokecenter1FNurseScript:
	jumpstd pokecenternurse

ViridianPokecenter1FCooltrainerMScript:
	faceplayer
	opentext
	checkevent EVENT_BLUE_IN_CINNABAR
	iftrue .BlueReturned
	writetext ViridianPokecenter1FCooltrainerMText
	waitbutton
	closetext
	end

.BlueReturned:
	writetext ViridianPokecenter1FCooltrainerMText_BlueReturned
	waitbutton
	closetext
	end

ViridianPokecenter1FCooltrainerFScript:
	faceplayer
	opentext
	writetext ViridianPokecenter1FCooltrainerFText
	waitbutton
	closetext
	turnobject VIRIDIANPOKECENTER1F_COOLTRAINER_F, UP
	end

ViridianPokecenter1FBugCatcherScript:
	jumptextfaceplayer ViridianPokecenter1FBugCatcherText


ViridianPokecenter1FCooltrainerMText:
	text "Where in the world"
	line "is VIRIDIAN's GYM"

	para "LEADER? I wanted"
	line "to challenge him."
	done

ViridianPokecenter1FCooltrainerMText_BlueReturned:
	text "There are no GYM"
	line "TRAINERS at the"
	cont "VIRIDIAN GYM."

	para "The LEADER claims"
	line "his policy is to"

	para "win without having"
	line "any underlings."
	done

ViridianPokecenter1FCooltrainerFText:
	text "I'm sorry, my"
	line "#MON were badly"
	cont "hurt."

	para "I'm letting the"
	line "NURSE heal them."
	done

ViridianPokecenter1FBugCatcherText:
	text "My dream is to be-"
	line "come a GYM LEADER."
	done

ViridianPokecenter1F_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  3,  7, NEW_BARK_TOWN, 5
	warp_event  4,  7, NEW_BARK_TOWN, 5

	db 0 ; coord events

	db 0 ; bg events

	db 4 ; object events
	object_event  3,  1, SPRITE_NURSE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FNurseScript, -1
	object_event  9,  4, SPRITE_COOLTRAINER_M, SPRITEMOVEDATA_STANDING_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FCooltrainerMScript, -1
	object_event  3,  3, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FCooltrainerFScript, EVENT_GOT_A_POKEMON_FROM_ELM
	object_event  1,  6, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, ViridianPokecenter1FBugCatcherScript, -1