	const_def 2 ; object constants

SilverCaveRoom1_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

SilverCaveRoom1_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  9, 33, SILVER_CAVE_OUTSIDE, 2
	warp_event 15,  1, SILVER_CAVE_ROOM_2, 1

	db 0 ; coord events

	db 0 ; bg events

	db 0 ; object events
