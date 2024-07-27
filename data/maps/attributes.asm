map_attributes: MACRO
;\1: map name
;\2: map id
;\3: border block
;\4: connections: combo of NORTH, SOUTH, WEST, and/or EAST, or 0 for none
CURRENT_MAP_WIDTH = \2_WIDTH
CURRENT_MAP_HEIGHT = \2_HEIGHT
\1_MapAttributes::
	db \3
	db CURRENT_MAP_HEIGHT, CURRENT_MAP_WIDTH
	db BANK(\1_Blocks)
	dw \1_Blocks
	db BANK(\1_MapScripts) ; BANK(\1_MapEvents)
	dw \1_MapScripts
	dw \1_MapEvents
	db \4
ENDM

; Connections go in order: north, south, west, east
connection: MACRO
;\1: direction
;\2: map name
;\3: map id
;\4: offset of the target map relative to the current map
;    (x offset for east/west, y offset for north/south)
; LEGACY: Support for old connection macro
if _NARG == 6
	connection \1, \2, \3, (\4) - (\5)
else
; Calculate tile offsets for source (current) and target maps
_src = 0
_tgt = (\4) + 3
if _tgt < 0
_src = -_tgt
_tgt = 0
endc
if "\1" == "north"
_blk = \3_WIDTH * (\3_HEIGHT + -3) + _src
_map = _tgt
_win = (\3_WIDTH + 6) * \3_HEIGHT + 1
_y = \3_HEIGHT * 2 - 1
_x = (\4) * -2
_len = CURRENT_MAP_WIDTH + 3 - (\4)
if _len > \3_WIDTH
_len = \3_WIDTH
endc

elif "\1" == "south"
_blk = _src
_map = (CURRENT_MAP_WIDTH + 6) * (CURRENT_MAP_HEIGHT + 3) + _tgt
_win = \3_WIDTH + 7
_y = 0
_x = (\4) * -2
_len = CURRENT_MAP_WIDTH + 3 - (\4)
if _len > \3_WIDTH
_len = \3_WIDTH
endc

elif "\1" == "west"
_blk = (\3_WIDTH * _src) + \3_WIDTH + -3
_map = (CURRENT_MAP_WIDTH + 6) * _tgt
_win = (\3_WIDTH + 6) * 2 + -6
_y = (\4) * -2
_x = \3_WIDTH * 2 - 1
_len = CURRENT_MAP_HEIGHT + 3 - (\4)
if _len > \3_HEIGHT
_len = \3_HEIGHT
endc

elif "\1" == "east"
_blk = (\3_WIDTH * _src)
_map = (CURRENT_MAP_WIDTH + 6) * _tgt + CURRENT_MAP_WIDTH + 3
_win = \3_WIDTH + 7
_y = (\4) * -2
_x = 0
_len = CURRENT_MAP_HEIGHT + 3 - (\4)
if _len > \3_HEIGHT
_len = \3_HEIGHT
endc
else
fail "Invalid direction for 'connection'."
endc
	map_id \3
	dw \2_Blocks + _blk
	dw wOverworldMapBlocks + _map
	db _len - _src
	db \3_WIDTH
	db _y, _x
	dw wOverworldMapBlocks + _win
endc
ENDM

	map_attributes ElkhornTown, ELKHORN_TOWN, $05, NORTH | SOUTH
	connection north, Route10, ROUTE_10, 2
	connection south, Route1, ROUTE_1, -3

	map_attributes PavonaVillage, PAVONA_VILLAGE, $05, WEST | EAST
	connection west, PavonaOasis, PAVONA_OASIS, -1
	connection east, Route2, ROUTE_2, 7

	map_attributes RidgeVillage, RIDGE_VILLAGE, $05, NORTH | SOUTH
	connection north, Route6, ROUTE_6,  -11
	connection south, Route5, ROUTE_5, -9

	map_attributes PectiniaCity, PECTINIA_CITY, $05, 0

	map_attributes HepaticaTown, HEPATICA_TOWN, $35, 0

	map_attributes FaviaTown, FAVIA_TOWN, $05, 0

	map_attributes RugosaCoast, RUGOSA_COAST, $35, EAST
	connection east, SeaRoute1, SEA_ROUTE_1, 5

	map_attributes StaghornTown, STAGHORN_TOWN, $05, NORTH
	connection north, PaintersForest, PAINTERS_FOREST, 7
	
	map_attributes PaintersForest, PAINTERS_FOREST, $05, SOUTH
	connection south, StaghornTown, STAGHORN_TOWN, -7

	map_attributes RugosaCity, RUGOSA_CITY, $05, 0

	map_attributes AcroporaCity, ACROPORA_CITY, $05, SOUTH | WEST
	connection south, Route17, ROUTE_17, 8
	connection west, Route18North, ROUTE_18_NORTH, 2

	map_attributes Route17, ROUTE_17, $05, NORTH | WEST
	connection north, AcroporaCity, ACROPORA_CITY, -8
	connection west, Route18South, ROUTE_18_SOUTH, 0

	map_attributes Route18North, ROUTE_18_NORTH, $20, SOUTH | EAST
	connection south, Route18South, ROUTE_18_SOUTH, 1
	connection east, AcroporaCity, ACROPORA_CITY, -2

	map_attributes Route18South, ROUTE_18_SOUTH, $20, NORTH | EAST
	connection north, Route18North, ROUTE_18_NORTH, -1
	connection east, Route17, ROUTE_17, 0

	map_attributes PavonaOasis, PAVONA_OASIS, $05, NORTH | EAST
	connection north, Route9, ROUTE_9, 0
	connection east, PavonaVillage, PAVONA_VILLAGE, 1
	
	map_attributes Route9, ROUTE_9, $20, SOUTH | WEST
	connection south, PavonaOasis, PAVONA_OASIS, 0
	connection west, SuicuneLair, SUICUNE_LAIR, 4
	
	map_attributes SuicuneLair, SUICUNE_LAIR, $20, EAST
	connection east, Route9, ROUTE_9, -4

	map_attributes Route2, ROUTE_2, $05, WEST
	connection west, PavonaVillage, PAVONA_VILLAGE, -7

	map_attributes Route1, ROUTE_1, $05, NORTH
	connection north, ElkhornTown, ELKHORN_TOWN, 3

	map_attributes SeaRoute3, SEA_ROUTE_3, $71, WEST | EAST
	connection west, SeaRoute1, SEA_ROUTE_1, -1
	connection east, SeaRoute6, SEA_ROUTE_6, -5

	map_attributes SeaRoute2, SEA_ROUTE_2, $35, NORTH | SOUTH
	connection north, SeaRoute1, SEA_ROUTE_1, -3
	connection south, Route7, ROUTE_7, -6

	map_attributes SeaRoute4, SEA_ROUTE_4, $35, WEST | EAST
	connection west, Route7, ROUTE_7, 2
	connection east, Route6, ROUTE_6, -2

	map_attributes SeaRoute1, SEA_ROUTE_1, $35, SOUTH | WEST | EAST
	connection south, SeaRoute2, SEA_ROUTE_2, 3
	connection west, RugosaCoast, RUGOSA_COAST, -5
	connection east, SeaRoute3, SEA_ROUTE_3, 1
	
	map_attributes Route14, ROUTE_14, $13, 0
	
	map_attributes Route13, ROUTE_13, $05, SOUTH
	connection south, Route12, ROUTE_12, 0

	map_attributes Route12, ROUTE_12, $05, NORTH | SOUTH
	connection north, Route13, ROUTE_13, 0
	connection south, Route11, ROUTE_11, 5

	map_attributes Route11, ROUTE_11, $05, NORTH | SOUTH
	connection north, Route12, ROUTE_12,  -5
	connection south, Route10, ROUTE_10, 18

	map_attributes Route10, ROUTE_10, $05, NORTH | SOUTH
	connection north, Route11, ROUTE_11, -18
	connection south, ElkhornTown, ELKHORN_TOWN, -2

	map_attributes Route6, ROUTE_6, $35, SOUTH | WEST
	connection south, RidgeVillage, RIDGE_VILLAGE, 11
	connection west, SeaRoute4, SEA_ROUTE_4, 2
	
	map_attributes SeaRoute5, SEA_ROUTE_5, $35, NORTH
	connection north, SeaRoute6, SEA_ROUTE_6, 4

	map_attributes SeaRoute6, SEA_ROUTE_6, $35, SOUTH | WEST | EAST 
	connection south, SeaRoute5, SEA_ROUTE_5, -4
	connection west, SeaRoute3, SEA_ROUTE_3, 5
	connection east, Route21, ROUTE_21, -5

	map_attributes Route21, ROUTE_21, $05, NORTH | WEST
	connection north, Route22, ROUTE_22, -10
	connection west, SeaRoute6, SEA_ROUTE_6, 5

	map_attributes Route23, ROUTE_23, $05, 0

	map_attributes Route22Gate, ROUTE_22_GATE, $00, 0
	
	map_attributes Route22, ROUTE_22, $05, SOUTH
	connection south, Route21, ROUTE_21, 10

	map_attributes PokemonLeague, POKEMON_LEAGUE, $05, 0

	map_attributes Route5, ROUTE_5, $05, NORTH | SOUTH
	connection north, RidgeVillage, RIDGE_VILLAGE, 9
	connection south, Route4, ROUTE_4, -8

	map_attributes Route3, ROUTE_3, $05, 0

	map_attributes Route4, ROUTE_4, $05, NORTH
	connection north, Route5, ROUTE_5, 8

	map_attributes Route7, ROUTE_7, $05, NORTH | EAST
	connection north, SeaRoute2, SEA_ROUTE_2, 6
	connection east, SeaRoute4, SEA_ROUTE_4, -2

	map_attributes Route8, ROUTE_8, $05, 0
	
	map_attributes SafariZoneArea1, SAFARI_ZONE_AREA_1, $00, NORTH | WEST | EAST
	connection north, SafariZoneArea3, SAFARI_ZONE_AREA_3, 4
	connection west, SafariZoneArea5, SAFARI_ZONE_AREA_5, -1
	connection east, SafariZoneArea2, SAFARI_ZONE_AREA_2, 0

	map_attributes SafariZoneArea2, SAFARI_ZONE_AREA_2, $00, NORTH | WEST
	connection north, SafariZoneArea4, SAFARI_ZONE_AREA_4, 0
	connection west, SafariZoneArea1, SAFARI_ZONE_AREA_1, 0
	
	map_attributes SafariZoneArea3, SAFARI_ZONE_AREA_3, $00, SOUTH | EAST
	connection south, SafariZoneArea1, SAFARI_ZONE_AREA_1, -4
	connection east, SafariZoneArea4, SAFARI_ZONE_AREA_4, 0

	map_attributes SafariZoneArea4, SAFARI_ZONE_AREA_4, $00, SOUTH | WEST
	connection south, SafariZoneArea2, SAFARI_ZONE_AREA_2, 0
	connection west, SafariZoneArea3, SAFARI_ZONE_AREA_3, 0

	map_attributes SafariZoneArea5, SAFARI_ZONE_AREA_5, $00, NORTH | EAST
	connection north, SafariZoneArea6, SAFARI_ZONE_AREA_6, -7
	connection east, SafariZoneArea1, SAFARI_ZONE_AREA_1, 1
	
	map_attributes SafariZoneArea6, SAFARI_ZONE_AREA_6, $00, SOUTH
	connection south, SafariZoneArea5, SAFARI_ZONE_AREA_5, 7
	
	map_attributes CarnationTown, CARNATION_TOWN, $20, SOUTH
	connection south, Route15, ROUTE_15, -15
	
	map_attributes Route15, ROUTE_15, $05, NORTH | SOUTH
	connection north, CarnationTown, CARNATION_TOWN, 15
	connection south, Route16, ROUTE_16, 0
	
	map_attributes Route16, ROUTE_16, $05, NORTH
	connection north, Route15, ROUTE_15, 0
	
	map_attributes OrchidCity, ORCHID_CITY, $35, SOUTH
	connection south, Route20, ROUTE_20, 4
	
	map_attributes Route20, ROUTE_20, $35, NORTH
	connection north, OrchidCity, ORCHID_CITY, -4

	map_attributes VictoryCoast, VICTORY_COAST, $35, WEST
	connection west, SeaRoute7, SEA_ROUTE_7, 0

	map_attributes SeaRoute7, SEA_ROUTE_7, $35, NORTH | EAST
	connection north, Route24, ROUTE_24, 0
	connection east, VictoryCoast, VICTORY_COAST, 0

	map_attributes Route24, ROUTE_24, $05, SOUTH
	connection south, SeaRoute7, SEA_ROUTE_7, 0

	map_attributes PastElkhornTown, PAST_ELKHORN_TOWN, $05, NORTH | SOUTH
	connection north, PastRoute10, PAST_ROUTE_10, 5
	connection south, PastRoute1, PAST_ROUTE_1, -4

	map_attributes PastRoute1, PAST_ROUTE_1, $05, NORTH | SOUTH
	connection north, PastElkhornTown, PAST_ELKHORN_TOWN, 4
	connection south, PastPavonaVillage, PAST_PAVONA_VILLAGE, 1

	map_attributes PastPavonaVillage, PAST_PAVONA_VILLAGE, $05, NORTH | EAST
	connection north, PastRoute1, PAST_ROUTE_1, -1
	connection east, PastRoute2, PAST_ROUTE_2, 3

	map_attributes PastRoute2, PAST_ROUTE_2, $05, WEST
	connection west, PastPavonaVillage, PAST_PAVONA_VILLAGE, -3

	map_attributes PastFaviaTown, PAST_FAVIA_TOWN, $05, SOUTH | EAST
	connection south, PastRoute3, PAST_ROUTE_3, 7
	connection east, PastRoute7, PAST_ROUTE_7, 2

	map_attributes PastRoute3, PAST_ROUTE_3, $05, NORTH
	connection north, PastFaviaTown, PAST_FAVIA_TOWN, -7

	map_attributes PastRoute7, PAST_ROUTE_7, $05, WEST
	connection west, PastFaviaTown, PAST_FAVIA_TOWN, -2

	map_attributes PastRoute10, PAST_ROUTE_10, $05, SOUTH
	connection south, PastElkhornTown, PAST_ELKHORN_TOWN, -5

	map_attributes PastPectiniaCity, PAST_PECTINIA_CITY, $05, 0
	map_attributes PastPectiniaGym, PAST_PECTINIA_GYM, $00, 0
	map_attributes PastFaviaInn, PAST_FAVIA_INN, $00, 0
	map_attributes PastPavonaInn, PAST_FAVIA_INN, $00, 0
	map_attributes PastRoute10Inn, PAST_ROUTE_10_INN, $00, 0
	map_attributes PastIlexForest, PAST_ILEX_FOREST, $05, 0
	map_attributes PastPectiniaApartment1F, PAST_PECTINIA_APARTMENT_1F, $00, 0
	map_attributes PastPectiniaApartment2F, PAST_PECTINIA_APARTMENT_2F, $00, 0
	map_attributes PastPectiniaApartment3F, PAST_PECTINIA_APARTMENT_3F, $00, 0

	map_attributes UnionCave1F, UNION_CAVE_1F, $09, 0
	map_attributes UnionCaveB1F, UNION_CAVE_B1F, $09, 0
	map_attributes UnionCaveB2F, UNION_CAVE_B2F, $09, 0
	map_attributes IlexForest, ILEX_FOREST, $05, 0
	map_attributes Route6Underground, ROUTE_6_UNDERGROUND, $00, 0
	map_attributes AcroporaGym, ACROPORA_GYM, $00, 0
	map_attributes RugosaGym, RUGOSA_GYM, $00, 0
	map_attributes RugosaPokecenter1F, RUGOSA_POKECENTER_1F, $00, 0
	map_attributes DiglettsCave, DIGLETTS_CAVE, $09, 0
	map_attributes PalerockCave1F, PALEROCK_CAVE_1F, $09, 0
	map_attributes PalerockCaveB1F, PALEROCK_CAVE_B1F, $09, 0
	map_attributes StaghornPokecenter1F, STAGHORN_POKECENTER_1F, $00, 0
	map_attributes StaghornMart, STAGHORN_MART, $00, 0
	map_attributes StaghornGym, STAGHORN_GYM, $00, 0
	map_attributes OrchidGym1F, ORCHID_GYM_1F, $00, 0
	map_attributes OrchidGymB1F, ORCHID_GYM_B1F, $01, 0
	map_attributes OrchidGymLeaderRoom, ORCHID_GYM_LEADER_ROOM, $00, 0
	map_attributes AcroporaMart, ACROPORA_MART, $00, 0
	map_attributes AcroporaPokecenter1F, ACROPORA_POKECENTER_1F, $00, 0
	map_attributes MoveDeletersHouse, MOVE_DELETERS_HOUSE, $00, 0
	map_attributes PectiniaPokecenter1F, PECTINIA_POKECENTER_1F, $00, 0
	map_attributes CharcoalKiln, CHARCOAL_KILN, $00, 0
	map_attributes PectiniaMart, PECTINIA_MART, $00, 0
	map_attributes PectiniaGym, PECTINIA_GYM, $00, 0
	map_attributes RidgeCafe, RIDGE_CAFE, $00, 0
	map_attributes RidgeGym, RIDGE_GYM, $00, 0
	map_attributes RidgePokecenter1F, RIDGE_POKECENTER_1F, $00, 0
	map_attributes HepaticaGym, HEPATICA_GYM, $00, 0
	map_attributes FaviaHappinessRater, FAVIA_HAPPINESS_RATER, $00, 0
	map_attributes PectiniaMall, PECTINIA_MALL, $00, 0
	map_attributes CarnationFlowerShop, CARNATION_FLOWER_SHOP, $00, 0
	map_attributes NameRater, NAME_RATER, $00, 0
	map_attributes RugosaDeptStore1F, RUGOSA_DEPT_STORE_1F, $00, 0
	map_attributes RugosaDeptStore2F, RUGOSA_DEPT_STORE_2F, $00, 0
	map_attributes RugosaDeptStore3F, RUGOSA_DEPT_STORE_3F, $00, 0
	map_attributes RugosaDeptStore4F, RUGOSA_DEPT_STORE_4F, $00, 0
	map_attributes RugosaDeptStore5F, RUGOSA_DEPT_STORE_5F, $00, 0
	map_attributes RugosaDeptStore6F, RUGOSA_DEPT_STORE_6F, $00, 0
	map_attributes RugosaDeptStoreElevator, RUGOSA_DEPT_STORE_ELEVATOR, $00, 0
	map_attributes RugosaDeptStoreRoof, RUGOSA_DEPT_STORE_ROOF, $24, 0
	map_attributes FaviaPokecenter1F, FAVIA_POKECENTER_1F, $00, 0
	map_attributes DayCare, DAY_CARE, $00, 0
	map_attributes Route3PectiniaGate, ROUTE_3_PECTINIA_GATE, $00, 0
	map_attributes Route6SurfersHouse, ROUTE_6_SURFERS_HOUSE, $00, 0
	map_attributes PokemonLeaguePokecenter1F, POKEMON_LEAGUE_POKECENTER_1F, $00, 0
	map_attributes WilbursRoom, WILBURS_ROOM, $00, 0
	map_attributes RegansRoom, REGANS_ROOM, $00, 0
	map_attributes BredesRoom, BREDES_ROOM, $00, 0
	map_attributes AmbersRoom, AMBERS_ROOM, $00, 0
	map_attributes JosephsRoom, JOSEPHS_ROOM, $00, 0
	map_attributes EmilysRoom, EMILYS_ROOM, $00, 0
	map_attributes HallOfFame, HALL_OF_FAME, $00, 0
	map_attributes Route3Route4Gate, ROUTE_3_ROUTE_4_GATE, $00, 0
	map_attributes Route5SuperRodHouse, ROUTE_5_SUPER_ROD_HOUSE, $00, 0
	map_attributes Pokecenter2F, POKECENTER_2F, $00, 0
	map_attributes TradeCenter, TRADE_CENTER, $00, 0
	map_attributes Colosseum, COLOSSEUM, $00, 0
	map_attributes Route7Route8Gate, ROUTE_7_ROUTE_8_GATE, $00, 0
	map_attributes FaviaGym, FAVIA_GYM, $79, 0
	map_attributes HepaticaPokecenter1F, HEPATICA_POKECENTER_1F, $00, 0
	map_attributes HepaticaMart, HEPATICA_MART, $00, 0
	map_attributes HepaticaLugiaSpeechHouse, HEPATICA_LUGIA_SPEECH_HOUSE, $00, 0
	map_attributes PokeSeersHouse, POKE_SEERS_HOUSE, $00, 0
	map_attributes FaviaMart, FAVIA_MART, $00, 0
	map_attributes ViridianPokecenter1F, VIRIDIAN_POKECENTER_1F, $00, 0
	map_attributes Route2Gate, ROUTE_2_GATE, $00, 0
	map_attributes MaplesLab, MAPLES_LAB, $00, 0
	map_attributes PlayersHouse1F, PLAYERS_HOUSE_1F, $00, 0
	map_attributes PlayersHouse2F, PLAYERS_HOUSE_2F, $00, 0
	map_attributes PlayersNeighborsHouse, PLAYERS_NEIGHBORS_HOUSE, $00, 0
	map_attributes ElmsHouse, ELMS_HOUSE, $00, 0
	map_attributes Route1ElkhornGate, ROUTE_1_ELKHORN_GATE, $00, 0
	map_attributes Route1FaviaGate, ROUTE_1_FAVIA_GATE, $00, 0
	map_attributes Route1PavonaGate, ROUTE_1_PAVONA_GATE, $00, 0
	map_attributes OrchidMart, ORCHID_MART, $00, 0
	map_attributes PavonaGymSpeechHouse, PAVONA_GYM_SPEECH_HOUSE, $00, 0
	map_attributes PavonaInn, PAVONA_INN, $00, 0
	map_attributes Route2PectiniaGate, ROUTE_2_PECTINIA_GATE, $00, 0
	map_attributes RidgeGymB1, RIDGE_GYM_B1, $0A, 0
	map_attributes PalerockMountain1F, PALEROCK_MOUNTAIN_1F, $09, 0
	map_attributes PalerockMountain2F, PALEROCK_MOUNTAIN_2F, $09, 0
	map_attributes PalerockMountain3F, PALEROCK_MOUNTAIN_3F, $6D, 0
	map_attributes PalerockMountainOutside, PALEROCK_MOUNTAIN_OUTSIDE, $09, 0
	map_attributes PalerockMountainB1, PALEROCK_MOUNTAIN_B1, $09, 0
	map_attributes PalerockMountainStrengthRoom, PALEROCK_MOUNTAIN_STRENGTH_ROOM, $09, 0
	map_attributes Route9ForestGate, ROUTE_9_FOREST_GATE, $00, 0
	map_attributes StaghornForestGate, STAGHORN_FOREST_GATE, $00, 0
	map_attributes Route7FaviaGate, ROUTE_7_FAVIA_GATE, $00, 0
	map_attributes EastForest, EAST_FOREST, $05, 0
	map_attributes Route4ForestGate, ROUTE_4_FOREST_GATE, $00, 0
	map_attributes Route4PectiniaGate, ROUTE_4_PECTINIA_GATE, $00, 0
	map_attributes HiddenPowerCave, HIDDEN_POWER_CAVE, $09, 0
	map_attributes Factory1F, FACTORY_1F, $00, 0
	map_attributes FactoryB1, FACTORY_B1, $00, 0
	map_attributes Factory2F, FACTORY_2F, $00, 0
	map_attributes FactoryBack, FACTORY_BACK, $00, 0
	map_attributes HepaticaChurch, HEPATICA_CHURCH, $00, 0
	map_attributes PectiniaApartmentLeft, PECTINIA_APARTMENT_LEFT, $00, 0
	map_attributes PectiniaApartmentRight, PECTINIA_APARTMENT_RIGHT, $00, 0
	map_attributes PectiniaGymSpeechHouse, PECTINIA_GYM_SPEECH_HOUSE, $00, 0
	map_attributes PectiniaEvolutionHouse, PECTINIA_EVOLUTION_HOUSE, $00, 0
	map_attributes PectiniaBikeHouse, PECTINIA_BIKE_HOUSE, $00, 0
	map_attributes PectiniaBerryHouse, PECTINIA_BERRY_HOUSE, $00, 0
	map_attributes RidgeMoveTutor, RIDGE_MOVE_TUTOR, $00, 0
	map_attributes RidgeWeatherHouse, RIDGE_WEATHER_HOUSE, $00, 0
	map_attributes RidgeTradeHouse, RIDGE_TRADE_HOUSE, $00, 0
	map_attributes Route7SilkScarfHouse, ROUTE_7_SILK_SCARF_HOUSE, $00, 0
	map_attributes PaintersHouse, PAINTERS_HOUSE, $00, 0
	map_attributes Route10FaviaGate, ROUTE_10_FAVIA_GATE, $00, 0	
	map_attributes Route10Route11Gate, ROUTE_10_ROUTE_11_GATE, $00, 0	
	map_attributes HepaticaCave1F, HEPATICA_CAVE_1F, $6D, 0
	map_attributes HepaticaCaveB1F, HEPATICA_CAVE_B1F, $09, 0
	map_attributes HepaticaCaveB2F, HEPATICA_CAVE_B2F, $09, 0
	map_attributes OverlookMaze, OVERLOOK_MAZE, $05, 0
	map_attributes LostLand, LOST_LAND, $01, 0
	map_attributes Route11StaghornGate, ROUTE_11_STAGHORN_GATE, $00, 0
	map_attributes Route11Shelter, ROUTE_11_SHELTER, $00, 0
	map_attributes TheBoneyard1F, THE_BONEYARD_1F, $09, 0
	map_attributes TheBoneyard2F, THE_BONEYARD_2F, $09, 0
	map_attributes StaghornThiefHouse, STAGHORN_THIEF_HOUSE, $00, 0
	map_attributes Route13RugosaGate, ROUTE_13_RUGOSA_GATE, $00, 0
	map_attributes PowerPlant1F, POWER_PLANT_1F, $00, 0
	map_attributes PowerPlant2F, POWER_PLANT_2F, $00, 0
	map_attributes PowerPlant1FB, POWER_PLANT_1F_B, $00, 0
	map_attributes PowerPlant2FB, POWER_PLANT_2F_B, $00, 0
	map_attributes RugosaGate, RUGOSA_GATE, $00, 0
	map_attributes RugosaSurfHouse, RUGOSA_SURF_HOUSE, $00, 0
	map_attributes RugosaEmysHouse, EMYS_HOUSE, $00, 0
	map_attributes StaghornFriendBallHouse, FRIEND_BALL_HOUSE, $00, 0
	map_attributes SafariZoneGate1F, SAFARI_ZONE_GATE_1F, $00, 0
	map_attributes SafariZoneGate2F, SAFARI_ZONE_GATE_2F, $00, 0
	map_attributes CarnationPokecenter1F, CARNATION_POKECENTER_1F, $00, 0
	map_attributes CarnationWobbuffetHouse, WOBBUFFET_HOUSE, $00, 0
	map_attributes CarnationZoo, CARNATION_ZOO, $05, 0
	map_attributes Route17StaghornGate, ROUTE_17_STAGHORN_GATE, $00, 0
	map_attributes AcroporaRestTalkHouse, ACROPORA_REST_TALK_HOUSE, $00, 0
	map_attributes AcroporaLassHouse, ACROPORA_LASS_HOUSE, $00, 0
	map_attributes AcroporaCastleHouse, ACROPORA_CASTLE_HOUSE, $00, 0
	map_attributes FluteMasterHouse, FLUTE_MASTER_HOUSE, $00, 0
	map_attributes AcroporaCave1F, ACROPORA_CAVE_1F, $09, 0
	map_attributes AcroporaCave2F, ACROPORA_CAVE_2F, $09, 0
	map_attributes AcroporaCaveB1F, ACROPORA_CAVE_B1F, $09, 0
	map_attributes PectiniaApartmentLeft2F, PECTINIA_APARTMENT_LEFT_2F, $00, 0
	map_attributes PectiniaApartmentRight2F, PECTINIA_APARTMENT_RIGHT_2F, $00, 0
	map_attributes PectiniaApartmentLeft3F, PECTINIA_APARTMENT_LEFT_3F, $00, 0
	map_attributes PectiniaApartmentRight3F, PECTINIA_APARTMENT_RIGHT_3F, $00, 0
	map_attributes RugosaSubstituteHouse, SUBSTITUTE_HOUSE, $00, 0
	map_attributes RugosaApartment1F, RUGOSA_APARTMENT_1F, $00, 0
	map_attributes RugosaApartment2F, RUGOSA_APARTMENT_2F, $00, 0
	map_attributes RugosaApartment3F, RUGOSA_APARTMENT_3F, $00, 0
	map_attributes OrchidDragonbreathHouse, DRAGONBREATH_HOUSE, $00, 0
	map_attributes OrchidTeachersHouse, ORCHID_TEACHERS_HOUSE, $00, 0
	map_attributes OrchidGrannysHouse, ORCHID_GRANNYS_HOUSE, $00, 0
	map_attributes IlexForestSwordsDanceHouse, SWORDS_DANCE_HOUSE, $00, 0
	map_attributes BurglarHideout1F,  BURGLAR_HIDEOUT_1F, $00, 0
	map_attributes BurglarHideoutB1F, BURGLAR_HIDEOUT_B1F, $00, 0
	map_attributes BurglarHideoutB2F, BURGLAR_HIDEOUT_B2F, $00, 0
	map_attributes StaghornRichardsHouse, RICHARDS_HOUSE, $00, 0
	map_attributes RaikouLair, RAIKOU_LAIR, $00, 0
	map_attributes EnteiLair, ENTEI_LAIR, $09, 0
	map_attributes PavonaOasisCave1F, PAVONA_OASIS_CAVE_1F, $09, 0
	map_attributes PavonaOasisCaveB1F, PAVONA_OASIS_CAVE_B1F, $09, 0
	map_attributes Route9Cave1F, ROUTE_9_CAVE_1F, $09, 0
	map_attributes DrainPunchChamber, DRAIN_PUNCH_CHAMBER, $09, 0
	map_attributes OrchidPokecenter1F, ORCHID_POKECENTER_1F, $00, 0
	map_attributes MoltenPeak1F, MOLTEN_PEAK_1F, $09, 0
	map_attributes MoltenPeakB1F, MOLTEN_PEAK_B1F, $09, 0
	map_attributes MoltenPeakB2F, MOLTEN_PEAK_B2F, $09, 0
	map_attributes MoltenPeakOutside, MOLTEN_PEAK_OUTSIDE, $35, 0
	map_attributes HepaticaGymNorthChamber, HEPATICA_GYM_NORTH_CHAMBER, $00, 0
	map_attributes HepaticaGymEastChamber, HEPATICA_GYM_EAST_CHAMBER, $00, 0
	map_attributes HepaticaGymWestChamber, HEPATICA_GYM_WEST_CHAMBER, $00, 0
	map_attributes LugiaLair, LUGIA_LAIR, $0F, 0
	map_attributes MoltenPeakHiddenCave, MOLTEN_PEAK_HIDDEN_CAVE, $09, 0
	map_attributes Route10CurseHouse, ROUTE_10_CURSE_HOUSE, $00, 0
	map_attributes NevermelticeChamber, NEVERMELTICE_CHAMBER, $09, 0
	map_attributes Route16HeavyBallHouse, HEAVY_BALL_HOUSE, $00, 0
	map_attributes UnownChamberAG, UNOWN_CHAMBER_AG, $00, 0
	map_attributes UnownChamberHN, UNOWN_CHAMBER_HN, $00, 0
	map_attributes UnownChamberOU, UNOWN_CHAMBER_OU, $00, 0
	map_attributes UnownChamberVZ, UNOWN_CHAMBER_VZ, $00, 0
	map_attributes CoastalLab, COASTAL_LAB, $00, 0
	map_attributes RugosaPort, RUGOSA_PORT, $00, 0
	map_attributes Route10CleanseTagHouse, ROUTE_10_CLEANSE_TAG_HOUSE, $00, 0
	map_attributes RugosaCafe, RUGOSA_CAFE, $00, 0
	map_attributes EmilysHouse1F, EMILYS_HOUSE_1F, $00, 0
	map_attributes EmilysHouse2F, EMILYS_HOUSE_2F, $00, 0
	map_attributes Route4HiddenCave, ROUTE_4_HIDDEN_CAVE, $09, 0
	map_attributes Route7Cave1F, ROUTE_7_CAVE_1F, $09, 0
	map_attributes Route7CaveB1F, ROUTE_7_CAVE_B1F, $09, 0
	map_attributes Route7HiddenCave, ROUTE_7_HIDDEN_CAVE, $09, 0
	map_attributes PalerockMountainB2, PALEROCK_MOUNTAIN_B2, $09, 0
	map_attributes PalerockCaveB2F, PALEROCK_CAVE_B2F, $09, 0
	map_attributes PalerockMountainB3, PALEROCK_MOUNTAIN_B3, $09, 0
	map_attributes PalerockMountainWaterfallChamber, PALEROCK_MOUNTAIN_WATERFALL_CHAMBER, $09, 0
	map_attributes Route14Barn, ROUTE_14_BARN, $00, 0
	map_attributes Route14Farmhouse, ROUTE_14_FARMHOUSE, $00, 0
	map_attributes Route14CarnationGate, ROUTE_14_CARNATION_GATE, $00, 0
	map_attributes RidgeMagikarpHouse, RIDGE_MAGIKARP_HOUSE, $00, 0
	map_attributes SafariZoneArea1RestHouse, SAFARI_ZONE_AREA_1_REST_HOUSE, $00, 0
	map_attributes SafariZoneArea2RestHouse, SAFARI_ZONE_AREA_2_REST_HOUSE, $00, 0
	map_attributes SafariZoneArea3RestHouse, SAFARI_ZONE_AREA_3_REST_HOUSE, $00, 0
	map_attributes SafariZoneArea4RestHouse, SAFARI_ZONE_AREA_4_REST_HOUSE, $00, 0
	map_attributes SafariZoneArea5RestHouse, SAFARI_ZONE_AREA_5_REST_HOUSE, $00, 0
	map_attributes SafariZoneArea6RestHouse, SAFARI_ZONE_AREA_6_REST_HOUSE, $00, 0
	map_attributes Route10HiddenCave, ROUTE_10_HIDDEN_CAVE, $09, 0
	map_attributes Route6Gate, ROUTE_6_GATE, $00, 0
	map_attributes Route6WaterfallHouse, ROUTE_6_WATERFALL_HOUSE, $00, 0
	map_attributes LugiaCave1F, LUGIA_CAVE_1F, $09, 0
	map_attributes LugiaCaveB1F, LUGIA_CAVE_B1F, $09, 0
	map_attributes LugiaCaveB2F, LUGIA_CAVE_B2F, $09, 0
	map_attributes LugiaCaveGateChamber, LUGIA_CAVE_GATE_CHAMBER, $09, 0
	map_attributes CarnationZooGate, CARNATION_ZOO_GATE, $00, 0
	map_attributes BattleSubwayTrain, BATTLE_SUBWAY_TRAIN, $00, 0
	map_attributes BattleSubwayPlatform, BATTLE_SUBWAY_PLATFORM, $00, 0
	map_attributes BattleSubwayBossTrain, BATTLE_SUBWAY_BOSS_TRAIN, $00, 0
	map_attributes Route13Gate, ROUTE_13_GATE, $00, 0
	map_attributes PectiniaBedStore, PECTINIA_BED_STORE, $00, 0
	map_attributes PectiniaDollStore, PECTINIA_DOLL_STORE, $00, 0
	map_attributes HoOhCastle1FCentralRoom, HO_OH_CASTLE_1F_CENTER_ROOM, $00, 0
	map_attributes HoOhCastle1FSideRooms, HO_OH_CASTLE_1F_SIDE_ROOMS, $00, 0
	map_attributes HoOhCastle2F, HO_OH_CASTLE_2F, $00, 0
	map_attributes HoOhCastle3F, HO_OH_CASTLE_3F, $00, 0
	map_attributes Route16AcroporaGate, ROUTE_16_ACROPORA_GATE, $00, 0
	map_attributes Route19, ROUTE_19, $05, 0
	map_attributes HoOhCastleRoof, HO_OH_CASTLE_ROOF, $1c, 0
	map_attributes RemnantCave1F, REMNANT_CAVE_1F, $09, 0
	map_attributes RemnantCave2F, REMNANT_CAVE_2F, $09, 0
	map_attributes RemnantCaveOutside, REMNANT_CAVE_OUTSIDE, $21, 0
	map_attributes RemnantCave3F, REMNANT_CAVE_3F, $09, 0
	map_attributes LostLandCave1F, LOST_LAND_CAVE_1F, $09, 0
	map_attributes LostLandCaveB1F, LOST_LAND_CAVE_B1F, $09, 0
	map_attributes LostLandHiddenCave1F, LOST_LAND_HIDDEN_CAVE_1F, $09, 0
	map_attributes LostLandHiddenCave2F, LOST_LAND_HIDDEN_CAVE_2F, $09, 0
	map_attributes EnteiCave1F, ENTEI_CAVE_1F, $09, 0
	map_attributes EnteiCaveB1F, ENTEI_CAVE_B1F, $8c, 0
	map_attributes OrchidBlackbeltsHouse, ORCHID_BLACKBELTS_HOUSE, $09, 0
	map_attributes SSMako1F, SS_MAKO_1F, $00, 0
	map_attributes SSMako1FRooms, SS_MAKO_1F_ROOMS, $00, 0
	map_attributes SSMakoB1F, SS_MAKO_B1F, $00, 0
	map_attributes SSMakoEngineRoom, SS_MAKO_ENGINE_ROOM, $00, 0
	map_attributes SSMako2F, SS_MAKO_2F, $00, 0
	map_attributes SSMako2FRooms, SS_MAKO_2F_ROOMS, $00, 0
	map_attributes SSMakoDeck, SS_MAKO_DECK, $72, 0
	map_attributes SSMakoLowerDeck, SS_MAKO_LOWER_DECK, $72, 0
	map_attributes VictoryPort, VICTORY_PORT, $00, 0
	map_attributes MoonBallCave, MOON_BALL_CAVE, $09, 0
	map_attributes PokemonLeagueGate1F, POKEMON_LEAGUE_GATE_1F, $00, 0
	map_attributes PokemonLeagueGate2F, POKEMON_LEAGUE_GATE_2F, $00, 0
	map_attributes FastEddiesHouse, FAST_EDDIES_HOUSE, $00, 0
	map_attributes VitaminShop, VITAMIN_SHOP, $00, 0
	map_attributes PokemonLeagueCafe, POKEMON_LEAGUE_CAFE, $00, 0
	map_attributes TrainerHouse, TRAINER_HOUSE, $00, 0
	map_attributes PokemonLeagueHotel1F, POKEMON_LEAGUE_HOTEL_1F, $00, 0
	map_attributes PokemonLeagueHotel2F, POKEMON_LEAGUE_HOTEL_2F, $00, 0
	map_attributes Route21HiddenCave, ROUTE_21_HIDDEN_CAVE, $09, 0
	map_attributes BattleSimulation, BATTLE_SIMULATION, $00, 0
	map_attributes Route19Gate, ROUTE_19_GATE, $00, 0
	map_attributes PectiniaCarpetStore, PECTINIA_CARPET_STORE, $00, 0
	map_attributes PectiniaComicStore, PECTINIA_COMIC_STORE, $00, 0
	map_attributes PectiniaBattleItemStore, PECTINIA_BATTLE_ITEM_STORE, $00, 0
	map_attributes PectiniaArcade, PECTINIA_ARCADE, $00, 0
	map_attributes Route18HiddenCave1F, ROUTE_18_HIDDEN_CAVE_1F, $09, 0
	map_attributes Route18HiddenCaveB1F, ROUTE_18_HIDDEN_CAVE_B1F, $09, 0
	map_attributes DugtriosDen, DUGTRIOS_DEN, $09, 0
	map_attributes PalerockMountainHiddenCave, PALEROCK_MOUNTAIN_HIDDEN_CAVE, $6d, 0
	map_attributes SkarmorysDen, SKARMORYS_DEN, $6d, 0
	map_attributes TentacruelsDen, TENTACRUELS_DEN, $09, 0
	map_attributes MaplesLabElevator, MAPLES_LAB_ELEVATOR, $00, 0
	map_attributes TreasureHuntersHouse, TREASURE_HUNTERS_HOUSE, $09, 0
	map_attributes OrchidEnteiShrine, ORCHID_ENTEI_SHRINE, $59, 0
	map_attributes Route23Cave1F, ROUTE_23_CAVE_1F, $09, 0
	map_attributes Route23CaveB1F, ROUTE_23_CAVE_B1F, $09, 0
	map_attributes Route21Gate, ROUTE_21_GATE, $00, 0
	map_attributes Route23Gate, ROUTE_23_GATE, $00, 0
	map_attributes Route24Gate, ROUTE_24_GATE, $00, 0
	map_attributes NorthForest, NORTH_FOREST, $07, 0
	map_attributes DevelopersHouse, DEVELOPERS_HOUSE, $00, 0
	map_attributes PastRoute10Gate, PAST_ROUTE_10_GATE, $00, 0
	map_attributes PastRoute10House1, PAST_ROUTE_10_HOUSE_1, $00, 0
	map_attributes PastRoute10House2, PAST_ROUTE_10_HOUSE_2, $00, 0
	map_attributes PastRoute10House3, PAST_ROUTE_10_HOUSE_3, $00, 0
	map_attributes PastRoute10House4, PAST_ROUTE_10_HOUSE_4, $00, 0
	map_attributes PastRoute10House5, PAST_ROUTE_10_HOUSE_5, $00, 0
	map_attributes MewtwoLab1F, MEWTWO_LAB_1F, $00, 0
	map_attributes MewtwoLabB1F, MEWTWO_LAB_B1F, $00, 0
	map_attributes MewtwoLab2F, MEWTWO_LAB_2F, $00, 0
	map_attributes VictoryCoastOfficersHouse, VICTORY_COAST_OFFICERS_HOUSE, $00, 0
; Battle Simulation Maps
	map_attributes SkyWorld1, BATTLE_SIM_SKY_1, $04, 0
	map_attributes SkyWorld2, BATTLE_SIM_SKY_2, $04, 0
	map_attributes SkyWorld3, BATTLE_SIM_SKY_3, $04, 0
	map_attributes CyberspaceWorld1, BATTLE_SIM_COMP_1, $00, 0
	map_attributes CyberspaceWorld2, BATTLE_SIM_COMP_2, $00, 0
	map_attributes CyberspaceWorld3, BATTLE_SIM_COMP_3, $00, 0
	map_attributes GraveyardWorld1, BATTLE_SIM_GRAVE_1, $6d, 0
	map_attributes GraveyardWorld2, BATTLE_SIM_GRAVE_2, $6d, 0
	map_attributes GraveyardWorld3, BATTLE_SIM_GRAVE_3, $6d, 0
	map_attributes IceWorld1, BATTLE_SIM_ICE_1, $01, 0
	map_attributes IceWorld2, BATTLE_SIM_ICE_2, $01, 0
	map_attributes IceWorld3, BATTLE_SIM_ICE_3, $01, 0
	map_attributes CastleWorld1, BATTLE_SIM_CASTLE_1, $00, 0
	map_attributes CastleWorld2, BATTLE_SIM_CASTLE_2, $00, 0
	map_attributes CastleWorld3, BATTLE_SIM_CASTLE_3, $00, 0
	map_attributes LavaWorld1, BATTLE_SIM_LAVA_1, $8c, 0
	map_attributes LavaWorld2, BATTLE_SIM_LAVA_2, $8c, 0
	map_attributes LavaWorld3, BATTLE_SIM_LAVA_3, $8c, 0
	map_attributes ForestWorld1, BATTLE_SIM_FOREST_1, $07, 0
	map_attributes ForestWorld2, BATTLE_SIM_FOREST_2, $07, 0
	map_attributes ForestWorld3, BATTLE_SIM_FOREST_3, $06, 0
	map_attributes BattleSimulationFinalRoom, BATTLE_SIMULATION_FINAL_ROOM, $00, 0
	map_attributes PastElkhornMomsHouse, PAST_ELKHORN_MOMS_HOUSE, $00, 0
	map_attributes PastElkhornLakesideHouse, PAST_ELKHORN_LAKESIDE_HOUSE, $00, 0
	map_attributes PastElkhornRichardsHouse, PAST_ELKHORN_RICHARDS_HOUSE, $00, 0
	map_attributes PastForestGate, PAST_FOREST_GATE, $00, 0
	map_attributes PastPectiniaGate, PAST_PECTINIA_GATE, $00, 0
	map_attributes PastFaviaDayCare, PAST_FAVIA_DAY_CARE, $00, 0
	map_attributes PastRoute2Gate, PAST_ROUTE_2_GATE, $00, 0
	map_attributes PastFaviaEggTutorHouse, PAST_FAVIA_EGG_TUTOR_HOUSE, $00, 0
	map_attributes PastFaviaFriendshipHouse, PAST_FAVIA_FRIENDSHIP_HOUSE, $00, 0
	map_attributes PastPectiniaMart, PAST_PECTINIA_MART, $00, 0
	map_attributes PastFaviaMart, PAST_FAVIA_MART, $00, 0
	map_attributes PastRoute10Schoolhouse, PAST_ROUTE_10_SCHOOLHOUSE, $00, 0
	map_attributes PastRoute10Schoolhouse2, PAST_ROUTE_10_SCHOOLHOUSE_2, $00, 0
	map_attributes PastPavonaHouse1, PAST_PAVONA_HOUSE_1, $00, 0
	map_attributes PastPavonaHouse2, PAST_PAVONA_HOUSE_2, $00, 0
	map_attributes PastPectiniaBerryHouse, PAST_PECTINIA_BERRY_HOUSE, $00, 0
	map_attributes PastPectiniaGymSpeechHouse, PAST_PECTINIA_GYM_SPEECH_HOUSE, $00, 0
	map_attributes PastPectiniaEggMoveHouse, PAST_PECTINIA_EGG_MOVE_HOUSE, $00, 0
	map_attributes PastPectiniaBikeHouse, PAST_PECTINIA_BIKE_HOUSE, $00, 0
	map_attributes PastHiddenPowerCave, PAST_HIDDEN_POWER_CAVE, $09, 0
	map_attributes PastRoute1House, PAST_ROUTE_1_HOUSE, $00, 0
	map_attributes GenesisIsland, GENESIS_ISLAND, $35, 0
	map_attributes GenesisIslandInside, GENESIS_ISLAND_INSIDE, $07, 0
