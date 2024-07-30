	const_def 2 ; object constants

Route19Gate_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

Route19GateGuardScript:
	jumptextfaceplayer Route19GateGuardText

Route19GateGuardText:
	text "Have you heard the"
	line "rumors about the"
	cont "GILDED HALL?"

	para "You must have."
	line "There's no reason"
	cont "anyone comes past"
	cont "this gate."

	para "I don't believe in"
	line "those rumors, but"
	cont "I can't stop a cur-"
	cont "ious child."
	done

Route19Gate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, ROUTE_18_SOUTH, 1
	warp_event  5,  0, ROUTE_18_SOUTH, 2
	warp_event  4,  7, ROUTE_19, 3
	warp_event  5,  7, ROUTE_19, 3

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event  0,  4, SPRITE_OFFICER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route19GateGuardScript, -1
