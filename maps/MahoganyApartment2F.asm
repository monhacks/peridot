	const_def 2 ; object constants

MahoganyApartment2F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks

MahoganyApartment2F_MapEvents:
	db 0, 0 ; filler

	db 2 ; warp events
	warp_event  6,  0, MAHOGANY_APARTMENT_1F, 3
	warp_event  7,  0, MAHOGANY_APARTMENT_3F, 1

	db 0 ; coord events

	db 0 ; bg events

	db 0 ; object events
