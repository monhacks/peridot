	const_def 2 ; object constants

PastRoute11Gate_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_TILES, .RemoveComputer

.RemoveComputer
	changeblock 0, 2, $92
	return

PastRoute11GateOfficer:
	jumptext PastRoute11GateOfficerText

PastRoute11GateZubat:
	opentext
	writetext PastRoute11GateZubatText
	cry ZUBAT
	waitbutton
	closetext
	end

PastRoute11GateOfficerText:
	text "One night a ZUBAT"
	line "flew in here while"
	cont "the door was open."

	para "I've taken quite a"
	line "liking to this"
	cont "little fella."
	done

PastRoute11GateZubatText:
	text "ZUBAT: Screee!"
	done

PastRoute11Gate_MapEvents:
	db 0, 0 ; filler

	db 4 ; warp events
	warp_event  4,  0, PAST_ROUTE_10, 2
	warp_event  5,  0, PAST_ROUTE_10, 3
	warp_event  4,  7, PAST_FAVIA_TOWN, 5
	warp_event  5,  7, PAST_FAVIA_TOWN, 5

	db 0 ; coord events

	db 0 ; bg events

	db 2 ; object events
	object_event 0, 4, SPRITE_OFFICER_M, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, PastRoute11GateOfficer, -1
	object_event 0, 3, SPRITE_ZUBAT, SPRITEMOVEDATA_POKEMON, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, PastRoute11GateZubat, -1
