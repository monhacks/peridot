	const_def 2 ; object constants

PastRoute2_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks
	
PastRoute2_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event 39, 30, PAST_ROUTE_2_GATE, 1 ; Pectinia Gate
	warp_event 39, 31, PAST_ROUTE_2_GATE, 2 ; Pectinia Gate

	db 0 ; coord events

	db 0 ; bg events

	db 0 ; object events
