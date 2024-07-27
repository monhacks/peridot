	const_def 2 ; object constants

Route10_MapScripts:
	db 0 ; scene scripts

	db 1 ; callbacks
	callback MAPCALLBACK_TILES, .Tiles
	
.Tiles:
	checkevent EVENT_ROUTE_10_LEDGE
	iffalse .checkcave
	changeblock  28, 20, $4b
.checkcave
	checkevent EVENT_ROUTE_10_HIDDEN_CAVE_OPEN
	iffalse .skip
	changeblock  58,  6, $73
.skip
	return

Route10MoveTutor:
	faceplayer
	opentext
	writetext Route10TutorText
	waitbutton
	checkitem SILVER_LEAF
	iffalse .NoLeaf
	writetext Route10TutorTeach
	yesorno
	iftrue .Bubblebeam
	jump .Refused
	
.Bubblebeam
	writetext Route10TutorWhichOne
	buttonsound
	writebyte BUBBLEBEAM
	special MoveTutor
	ifequal $0, .TeachMove
	jump .Refused
	
.TeachMove
	takeitem SILVER_LEAF
	writetext Route10TutorThankYou
	waitbutton
	closetext
	end
	
.Refused
	writetext Route10TutorRefused
	waitbutton
	closetext
	end
	
.NoLeaf
	writetext Route10TutorExplainSilverLeaf
	waitbutton
	closetext
	end
	
Route10CooltrainerFScript:
	jumptextfaceplayer Route10CooltrainerFText

Route10HikerScript:
	jumptextfaceplayer Route10HikerText

Route10SpellTag:
	itemball SPELL_TAG

Route10LeafStone:
	itemball LEAF_STONE

Route10TMGigaDrain:
	itemball TM_GIGA_DRAIN
	
Route10HiddenRevivalHerb:
	hiddenitem REVIVAL_HERB, EVENT_ROUTE_10_HIDDEN_REVIVAL_HERB

Route10HiddenGoldLeaf:
	hiddenitem GOLD_LEAF, EVENT_ROUTE_10_HIDDEN_GOLD_LEAF

Route10FruitTree:
	fruittree FRUITTREE_ROUTE_10

Route10GoldenrodSign:
	jumptext Route10GoldenrodSignText

Route10Route11Sign:
	jumptext Route10Route11SignText
	
Route10TutorText:
	text "Blub, blub, blub."

	para "So many #MON"
	line "can learn to blow"
	cont "bubbles. Even ones"
	cont "that aren't WATER-"
	cont "type! I find that"
	cont "so interesting!"
	
	para "I can teach your"
	line "#MON to blow"
	cont "bubbles too. I"
	cont "just need one"
	cont "SILVER LEAF to do"
	cont "it."
	done

Route10TutorTeach:
	text "Would you like to"
	line "teach BUBBLEBEAM"
	cont "to one of your"
	cont "#MON?"
	done
	
Route10TutorWhichOne:
	text "Which #MON will"
	line "I tutor?"
	done
	
Route10TutorThankYou:
	text "Blub, blub, blub."
	line "Thank you!"
	
	para "It's amazing how"
	line "many #MON can"
	cont "learn BUBBLEBEAM."
	done
	
Route10TutorRefused:
	text "Wow, you must have"
	line "the only #MON"
	cont "that can't learn"
	cont "my move!"
	done
	
Route10TutorExplainSilverLeaf:
	text "You don't have"
	line "one?"
	
	para "That's okay, lots"
	line "of people don't!"
	
	para "If you ever do"
	line "find a SILVER"
	cont "LEAF, you can come"
	cont "back here."
	done
	
Route10CooltrainerFText:
	text "Rumor has it that"
	line "an evil spirit"
	cont "dwells on this"
	cont "ROUTE."
	
	para "But the only other"
	line "person I've seen"
	cont "is a nice old man."
	done
	
Route10HikerText:
	text "Some day, through"
	line "sheer willpower, I"
	cont "hope to make this"
	cont "ledge accessible"
	cont "from the south."
	
	para "It will be my"
	line "destiny."
	done
	
Route10GoldenrodSignText:
	text "ROUTE 11 -"
	line "FAVIA TOWN"
	done
	
Route10Route11SignText:
	text "ROUTE 10 -"
	line "ROUTE 11"
	done

Route10_MapEvents:
	db 0, 0 ; filler

	db 6 ; warp events
	warp_event 29, 27, ROUTE_10_FAVIA_GATE, 1
	warp_event 30, 27, ROUTE_10_FAVIA_GATE, 2
	warp_event 21,  3, ROUTE_10_ROUTE_11_GATE, 1
	warp_event 51, 21, ROUTE_10_CURSE_HOUSE, 1
	warp_event  9, 11, ROUTE_10_CLEANSE_TAG_HOUSE, 1
	warp_event 58,  7, ROUTE_10_HIDDEN_CAVE, 1

	db 0 ; coord events

	db 4 ; bg events
	bg_event 32, 23, BGEVENT_READ, Route10GoldenrodSign
	bg_event 18,  9, BGEVENT_READ, Route10Route11Sign
	bg_event  3,  5, BGEVENT_ITEM, Route10HiddenRevivalHerb
	bg_event 48,  4, BGEVENT_ITEM, Route10HiddenGoldLeaf

	db 7 ; object events
	object_event 41, 20, SPRITE_BUG_CATCHER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, Route10MoveTutor, -1
	object_event 23, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route10CooltrainerFScript, -1
	object_event 29, 23, SPRITE_POKEFAN_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BROWN, OBJECTTYPE_SCRIPT, 0, Route10HikerScript, EVENT_ROUTE_10_LEDGE
	object_event 53,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_ITEMBALL, 0, Route10TMGigaDrain, EVENT_GOT_TM_GIGA_DRAIN
	object_event  0, 20, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route10SpellTag, EVENT_ROUTE_10_SPELL_TAG
	object_event 44,  4, SPRITE_POKE_BALL, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_ITEMBALL, 0, Route10LeafStone, EVENT_ROUTE_10_LEAF_STONE
	object_event 39, 27, SPRITE_FRUIT_TREE, SPRITEMOVEDATA_STILL, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, Route10FruitTree, -1
