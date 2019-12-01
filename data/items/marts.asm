Marts:
; entries correspond to MART_* constants
	dw MartOrchid
	dw MartViolet
	dw MartAzalea
	dw MartCianwood
	dw MartCianwoodRobbed
	dw MartGoldenrod2F1
	dw MartGoldenrod2F2
	dw MartGoldenrod3F
	dw MartGoldenrod4F
	dw MartGoldenrod5F
	dw MartOlivine
	dw MartEcruteak
	dw MartEcruteakTM
	dw MartMahogany1
	dw MartMahogany2
	dw MartMahogany3
	dw MartMahogany4
	dw MartBlackthorn
	dw MartBlackthornTM
	dw MartGoldenrod
	dw MartGoldenrodTM
	dw MartPewter
	dw MartCerulean
	dw MartLavender
	dw MartVermilion
	dw MartCeladon2F1
	dw MartCeladon2F2
	dw MartCeladon3F
	dw MartCeladon4F
	dw MartCeladon5F1
	dw MartCeladon5F2
	dw MartFuchsia
	dw MartSaffron
	dw MartMtMoon
	dw MartIndigoPlateau
	dw MartIndigoPlateauTM
	dw MartUnderground
.End

MartOrchid:
	db 4 ; # items
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db -1 ; end

MartViolet:
	db 6 ; # items
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db -1 ; end

MartAzalea:
	db 6 ; # items
	db POKE_BALL
	db POTION
	db ESCAPE_ROPE
	db REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db -1 ; end

MartCianwood:
	db 5 ; # items
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db REVIVE
	db -1 ; end
	
MartCianwoodRobbed:
	db 2
	db POTION
	db ANTIDOTE
	db -1

MartGoldenrod2F1:
	db 7 ; # items
	db POTION
	db SUPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db ICE_HEAL
	db -1 ; end

MartGoldenrod2F2:
	db 8 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ESCAPE_ROPE
	db REPEL
	db REVIVE
	db FULL_HEAL
	db POKE_DOLL
	db FLOWER_MAIL
	db -1 ; end

MartGoldenrod3F:
	db 7 ; # items
	db X_SPEED
	db X_SP_ATK
	db X_DEFEND
	db X_ATTACK
	db DIRE_HIT
	db GUARD_SPEC
	db X_ACCURACY
	db -1 ; end

MartGoldenrod4F:
	db 5 ; # items
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db HP_UP
	db -1 ; end

MartGoldenrod5F:
	db 3 ; # items
	db TM_THUNDERPUNCH
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db -1 ; end

MartOlivine:
	db 9 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db ICE_HEAL
	db SUPER_REPEL
	db SURF_MAIL
	db -1 ; end

MartEcruteak:
	db 6 ; # items
	db POKE_BALL
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db FULL_HEAL
	db REVIVE
	db -1 ; end
	
MartEcruteakTM:
	db 3
	db TM_REFLECT
	db TM_LIGHT_SCREEN
	db TM_SAFEGUARD
	db -1

MartMahogany1:
	db 8 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db ANTIDOTE
	db PARLYZ_HEAL
	db SUPER_REPEL
	db REVIVE
	db -1 ; end

MartMahogany2:
	db 3 ; # items
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db TM_THUNDERPUNCH
	db -1 ; end
	
MartMahogany3:
	db 5
	db HP_UP
	db PROTEIN
	db IRON
	db CALCIUM
	db CARBOS
	db -1
	
MartMahogany4:
	db 3
	db CHARCOAL
	db MYSTIC_WATER
	db MIRACLE_SEED
	db -1

MartBlackthorn:
	db 9 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db ETHER
	db MAX_ETHER
	db REVIVE
	db MAX_REPEL
	db -1 ; end
	
MartBlackthornTM:
	db 3
	db TM_PSYCHIC_M
	db TM_CRUNCH
	db TM_SHADOW_BALL
	db -1

MartGoldenrod:
	db 6 ; # items
	db POKE_BALL
	db GREAT_BALL
	db SUPER_POTION
	db REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db ETHER
	db -1 ; end
	
MartGoldenrodTM:
	db 3
	db TM_PROTECT
	db TM_ENDURE
	db TM_PSYCH_UP
	db -1
	
MartPewter:
	db 7 ; # items
	db GREAT_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db -1 ; end

MartCerulean:
	db 9 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db SUPER_POTION
	db SUPER_REPEL
	db FULL_HEAL
	db X_DEFEND
	db X_ATTACK
	db DIRE_HIT
	db SURF_MAIL
	db -1 ; end

MartLavender:
	db 8 ; # items
	db GREAT_BALL
	db POTION
	db SUPER_POTION
	db MAX_REPEL
	db ANTIDOTE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db -1 ; end

MartVermilion:
	db 8 ; # items
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db REVIVE
	db PARLYZ_HEAL
	db AWAKENING
	db BURN_HEAL
	db LITEBLUEMAIL
	db -1 ; end

MartCeladon2F1:
	db 7 ; # items
	db POTION
	db SUPER_POTION
	db HYPER_POTION
	db MAX_POTION
	db REVIVE
	db SUPER_REPEL
	db MAX_REPEL
	db -1 ; end

MartCeladon2F2:
	db 10 ; # items
	db POKE_BALL
	db GREAT_BALL
	db ULTRA_BALL
	db ESCAPE_ROPE
	db FULL_HEAL
	db ANTIDOTE
	db BURN_HEAL
	db ICE_HEAL
	db AWAKENING
	db PARLYZ_HEAL
	db -1 ; end

MartCeladon3F:
	db 5 ; # items
	db TM_PSYCH_UP
	db TM_PROTECT
	db TM_THUNDERPUNCH
	db TM_FIRE_PUNCH
	db TM_ICE_PUNCH
	db -1 ; end

MartCeladon4F:
	db 3 ; # items
	db POKE_DOLL
	db LOVELY_MAIL
	db SURF_MAIL
	db -1 ; end

MartCeladon5F1:
	db 5 ; # items
	db HP_UP
	db PROTEIN
	db IRON
	db CARBOS
	db CALCIUM
	db -1 ; end

MartCeladon5F2:
	db 7 ; # items
	db X_ACCURACY
	db GUARD_SPEC
	db DIRE_HIT
	db X_ATTACK
	db X_DEFEND
	db X_SPEED
	db X_SP_ATK
	db -1 ; end

MartFuchsia:
	db 7 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db SUPER_POTION
	db HYPER_POTION
	db FULL_HEAL
	db MAX_REPEL
	db FLOWER_MAIL
	db -1 ; end

MartSaffron:
	db 8 ; # items
	db GREAT_BALL
	db ULTRA_BALL
	db HYPER_POTION
	db MAX_POTION
	db FULL_HEAL
	db X_ATTACK
	db X_DEFEND
	db FLOWER_MAIL
	db -1 ; end

MartMtMoon:
	db 6 ; # items
	db POKE_DOLL
	db FRESH_WATER
	db SODA_POP
	db LEMONADE
	db REPEL
	db PORTRAITMAIL
	db -1 ; end

MartIndigoPlateau:
	db 7 ; # items
	db ULTRA_BALL
	db MAX_REPEL
	db HYPER_POTION
	db MAX_POTION
	db FULL_RESTORE
	db REVIVE
	db FULL_HEAL
	db -1 ; end
	
MartIndigoPlateauTM:
	db 4
	db FIRE_BLAST
	db BLIZZARD
	db THUNDER
	db HURRICANE
	db -1

MartUnderground:
	db 4 ; # items
	db ENERGYPOWDER
	db ENERGY_ROOT
	db HEAL_POWDER
	db REVIVAL_HERB
	db -1 ; end

DefaultMart:
	db 2 ; # items
	db POKE_BALL
	db POTION
	db -1 ; end
