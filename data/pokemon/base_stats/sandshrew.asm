	db SANDSHREW ; 027

	db  50,  75,  85,  40,  20,  30
	;   hp  atk  def  spd  sat  sdf

	db GROUND, GROUND ; type
	db 255 ; catch rate
	db 93 ; base exp
	db NO_ITEM, NO_ITEM ; items
	db GENDER_F50 ; gender ratio
	db 100 ; unknown 1
	db 20 ; step cycles to hatch
	db 5 ; unknown 2
	INCBIN "gfx/pokemon/sandshrew/front.dimensions"
	db 0, 0, 0, 0 ; padding
	db GROWTH_MEDIUM_FAST ; growth rate
	dn EGG_GROUND, EGG_GROUND ; egg groups

	; tm/hm learnset
	tmhm ATTRACT, BULLDOZE, CUT, DOUBLE_TEAM, EARTHQUAKE, ENDURE, HEADBUTT, HIDDEN_POWER, IRON_HEAD, PROTECT, REST, RETURN, ROCK_SLIDE, ROCK_SMASH, SAFEGUARD, SANDSTORM, SLEEP_TALK, STRENGTH, SUBMISSION, SUBSTITUTE, SUNNY_DAY, SWAGGER, SWORDS_DANCE, THIEF, TOXIC, BODY_SLAM
	; end
