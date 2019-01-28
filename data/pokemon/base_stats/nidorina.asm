	db NIDORINA ; 030

	db  70,  62,  67,  56,  55,  55
	;   hp  atk  def  spd  sat  sdf

	db POISON, POISON ; type
	db 120 ; catch rate
	db 117 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F100 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/nidorina/front.dimensions"
	db 0, 0, 0, 0 ; padding
	db GROWTH_MEDIUM_SLOW ; growth rate
	dn EGG_MONSTER, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm ATTRACT, BLIZZARD, CRUNCH, CUT, DOUBLE_TEAM, ENDURE, HEADBUTT, HIDDEN_POWER, ICE_BEAM, PLAY_ROUGH, PROTECT, RAIN_DANCE, REFLECT, REST, RETURN, ROCK_SLIDE, ROCK_SMASH, SLEEP_TALK, SLUDGE_BOMB, STRENGTH, SUBSTITUTE, SUNNY_DAY, SWAGGER, THIEF, THUNDER, THUNDERBOLT, TOXIC, LOVELY_KISS, SWEET_KISS, BODY_SLAM, BUBBLEBEAM
	; end
