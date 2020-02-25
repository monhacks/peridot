	const_def 2 ; object constants

AzaleaApartmentLeft3F_MapScripts:
	db 0 ; scene scripts

	db 0 ; callbacks
	
MysteryGiftGirl:
	faceplayer
	opentext
	checkflag ENGINE_DAILY_MYSTERY_GIFT
	iftrue .NoGift
	writetext MysterGiftText
	yesorno
	iffalse .Decline
	random 4
	ifequal 0, .RandomItemBank1
	ifequal 1, .RandomItemBank2
	ifequal 2, .RandomItemBank3
	ifequal 3, .RandomItemBank4
	verbosegiveitem SILVER_LEAF
.continue
	iffalse .NoRoom
	writetext MysteryGiftReceivedText
	waitbutton
	setflag ENGINE_DAILY_MYSTERY_GIFT
	closetext
	turnobject LAST_TALKED, DOWN
	end
	
.NoRoom
	writetext MysterGiftNoRoom
	waitbutton
	closetext
	turnobject LAST_TALKED, DOWN
	end

.NoGift
	writetext NoMysteryGiftText
	waitbutton
	closetext
	turnobject LAST_TALKED, DOWN
	end
	
.Decline
	writetext DeclineMysteryGiftText
	waitbutton
	closetext
	turnobject LAST_TALKED, DOWN
	end
	
.RandomItemBank1:
	random X_SP_ATK - MOON_STONE + 1
	addvar MOON_STONE
	verbosegiveitem ITEM_FROM_MEM
	jump .continue

.RandomItemBank2:
	random POKE_BALL - ULTRA_BALL + 1
	addvar ULTRA_BALL
	verbosegiveitem ITEM_FROM_MEM
	jump .continue

.RandomItemBank3:
	random ELIXER - PP_UP + 1
	addvar PP_UP
	verbosegiveitem ITEM_FROM_MEM
	jump .continue
	
.RandomItemBank4:
	random MINT_BERRY - MOOMOO_MILK + 1
	addvar MOOMOO_MILK
	verbosegiveitem ITEM_FROM_MEM
	jump .continue

MysterGiftText:
	text "MYSTERY GIFT!"
	line "MYSTERY GIFT!"
	
	para "Do you want to"
	line "share a MYSTERY"
	cont "GIFT!"
	done

MysterGiftNoRoom:
	text "I guess too many"
	line "people shared with"
	cont "you! Hehe!"
	done
	
MysteryGiftReceivedText:
	text "Wow, I got a"
	line "really cool item!"
	cont "I hope you got"
	cont "something good"
	cont "too!"
	
	para "Let's do this"
	line "again tomorrow!"
	done
	
NoMysteryGiftText:
	text "We've already"
	line "shared today."
	
	para "But I'd be happy"
	line "to share again"
	cont "tomorrow."
	done
	
DeclineMysteryGiftText:
	text "Oh..."
	
	para "Some other time,"
	line "okay?"
	done

AzaleaApartmentLeft3F_MapEvents:
	db 0, 0 ; filler

	db 1 ; warp events
	warp_event  7,  0, AZALEA_APARTMENT_LEFT_2F, 2

	db 0 ; coord events

	db 0 ; bg events

	db 1 ; object events
	object_event  7,  5, SPRITE_GAMEBOY_GIRL, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, MysteryGiftGirl, -1
