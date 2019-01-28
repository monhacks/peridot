	db LANTURN ; 171

	db 125,  58,  58,  67,  76,  76
	;   hp  atk  def  spd  sat  sdf

	db WATER, ELECTRIC ; type
	db 75 ; catch rate
	db 156 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/lanturn/front.dimensions"
	db 0, 0, 0, 0 ; padding
	db GROWTH_SLOW ; growth rate
	dn EGG_WATER_2, EGG_WATER_2 ; egg groups

	; tm/hm learnset
	tmhm WHIRLPOOL, ATTRACT, BLIZZARD, DOUBLE_TEAM, ENDURE, HIDDEN_POWER, HYPER_BEAM, ICE_BEAM, ICY_WIND, PROTECT, PSYCHIC_M, RAIN_DANCE, REST, RETURN, SLEEP_TALK, SUBSTITUTE, SWAGGER, THUNDER, THUNDERBOLT, THUNDER_WAVE, TOXIC, WATERFALL, SURF, HEAL_BELL, BUBBLEBEAM
	; end
