; EngineFlags indexes (see engine/engine_flags.asm)
	const_def
; wPokegearFlags
	const ENGINE_RADIO_CARD
	const ENGINE_MAP_CARD
	const ENGINE_PHONE_CARD
	const ENGINE_RUNNING_SHOES
	const ENGINE_POKEGEAR
; wDayCareMan
	const ENGINE_DAY_CARE_MAN_HAS_EGG
	const ENGINE_DAY_CARE_MAN_HAS_MON
; wDayCareLady
	const ENGINE_DAY_CARE_LADY_HAS_MON
; wMomSavingMoney
	const ENGINE_MOM_SAVING_MONEY
	const ENGINE_MOM_ACTIVE
; wUnusedTwoDayTimerOn
	const ENGINE_0A
; wStatusFlags
	const ENGINE_POKEDEX
	const ENGINE_UNOWN_DEX
	const ENGINE_FLASH
	const ENGINE_CAUGHT_POKERUS
	const ENGINE_EXP_ALL_ACTIVE
	const ENGINE_CREDITS_SKIP
	const ENGINE_BATTLE_SUBWAY_LEVELS ; 10
; wStatusFlags2
	const ENGINE_SAFARI_REST_HOUSE
	const ENGINE_SAFARI_ZONE
	const ENGINE_ROCKETS_IN_RADIO_TOWER
	const ENGINE_BATTLE_SUBWAY_ACTIVE
	const ENGINE_HAVE_BATTLE_PASS
	const ENGINE_REACHED_GOLDENROD
	const ENGINE_FORCE_SHINY_ENCOUNTERS
; wBikeFlags
	const ENGINE_STRENGTH_ACTIVE
	const ENGINE_ALWAYS_ON_BIKE
	const ENGINE_DOWNHILL
; wJohtoBadges
	const ENGINE_FISTBADGE
	const ENGINE_WAVEBADGE
	const ENGINE_MYSTICBADGE
	const ENGINE_SKULLBADGE
	const ENGINE_COGBADGE ; 20
	const ENGINE_ROOTBADGE
	const ENGINE_GLACIERBADGE
	const ENGINE_RISINGBADGE
; wKantoBadges
	const ENGINE_BOULDERBADGE
	const ENGINE_CASCADEBADGE
	const ENGINE_THUNDERBADGE
	const ENGINE_RAINBOWBADGE
	const ENGINE_SOULBADGE
	const ENGINE_MARSHBADGE
	const ENGINE_VOLCANOBADGE
	const ENGINE_EARTHBADGE
; wUnlockedUnowns
	const ENGINE_UNLOCKED_UNOWNS_A_TO_G
	const ENGINE_UNLOCKED_UNOWNS_H_TO_N
	const ENGINE_UNLOCKED_UNOWNS_O_TO_U
	const ENGINE_UNLOCKED_UNOWNS_V_TO_Z
	const ENGINE_UNLOCKED_UNOWNS_UNUSED_4
	const ENGINE_UNLOCKED_UNOWNS_UNUSED_5 ; 30
	const ENGINE_UNLOCKED_UNOWNS_UNUSED_6
	const ENGINE_UNLOCKED_UNOWNS_UNUSED_7
; wVisitedSpawns
	const ENGINE_FLYPOINT_PLAYERS_HOUSE
	const ENGINE_FLYPOINT_VIRIDIAN_POKECENTER
	const ENGINE_FLYPOINT_INDIGO_PLATEAU ; 40
	const ENGINE_FLYPOINT_ELKHORN
	const ENGINE_FLYPOINT_PAVONA
	const ENGINE_FLYPOINT_PECTINIA
	const ENGINE_FLYPOINT_RIDGE
	const ENGINE_FLYPOINT_FAVIA
	const ENGINE_FLYPOINT_HEPATICA
	const ENGINE_FLYPOINT_ROUTE_9
	const ENGINE_FLYPOINT_STAGHORN
	const ENGINE_FLYPOINT_RUGOSA_COAST
	const ENGINE_FLYPOINT_RUGOSA
	const ENGINE_FLYPOINT_CARNATION
	const ENGINE_FLYPOINT_ACROPORA
	const ENGINE_FLYPOINT_ORCHID
	const ENGINE_FLYPOINT_UNUSED
; wLuckyNumberShowFlag
	const ENGINE_LUCKY_NUMBER_SHOW
; wStatusFlags2
	const ENGINE_4F
; wDailyFlags1
	const ENGINE_KURT_MAKING_BALLS ; 50
	const ENGINE_DAILY_BUG_CONTEST
	const ENGINE_SODA_POP_GUY
	const ENGINE_VITAMIN_TIMER
	const ENGINE_ALL_FRUIT_TREES
	const ENGINE_GOT_SHUCKIE_TODAY
	const ENGINE_BOUGHT_MAGIKARP_TODAY
	const ENGINE_FOUGHT_IN_TRAINER_HALL_TODAY
; wDailyFlags2
	const ENGINE_MT_MOON_SQUARE_CLEFAIRY
	const ENGINE_UNION_CAVE_LAPRAS
	const ENGINE_GOLDENROD_UNDERGROUND_GOT_HAIRCUT
	const ENGINE_DAILY_PAINTING
	const ENGINE_DAISYS_GROOMING
	const ENGINE_INDIGO_PLATEAU_RIVAL_FIGHT
	const ENGINE_DAILY_MYSTERY_GIFT
	const ENGINE_BUENAS_PASSWORD
; wDailyFlags3
	const ENGINE_REMATCH_MURPHY
	const ENGINE_REMATCH_CECIL
	const ENGINE_REMATCH_CELESTE
	const ENGINE_REMATCH_DUANE
	const ENGINE_REMATCH_POSEY
	const ENGINE_REMATCH_JOEL
	const ENGINE_REMATCH_ALAN
	const ENGINE_REMATCH_ENYA
; wSwarmFlags
	const ENGINE_BUENAS_PASSWORD_2 ; 60
	const ENGINE_GOLDENROD_DEPT_STORE_SALE_IS_ON
; wGameTimerPause
	const ENGINE_62
; wCelebiEvent
	const ENGINE_FOREST_IS_RESTLESS
; wPlayerGender
	const ENGINE_PLAYER_IS_FEMALE
; wDailyRematchFlags

; wDailyPhoneItemFlags

; wDailyPhoneTimeOfDayFlags

; wPlayerSpriteSetupFlags
	const ENGINE_KRIS_IN_CABLE_CLUB
; wSwarmFlags
	const ENGINE_DUNSPARCE_SWARM ; a0
	const ENGINE_YANMA_SWARM
NUM_ENGINE_FLAGS EQU const_value
