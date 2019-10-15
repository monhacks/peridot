map: MACRO
;\1: map name: for the MapAttributes pointer (see data/maps/attributes.asm)
;\2: tileset: a TILESET_* constant
;\3: environment: TOWN, ROUTE, INDOOR, CAVE, ENVIRONMENT_5, GATE, or DUNGEON
;\4: location: from constants/landmark_constants.asm
;\5: music: a MUSIC_* constant
;\6: phone service flag: TRUE to prevent phone calls
;\7: time of day: a PALETTE_* constant
;\8: fishing group: a FISHGROUP_* constant
	db BANK(\1_MapAttributes), \2, \3
	dw \1_MapAttributes
	db \4, \5
	dn \6, \7
	db \8
ENDM

MapGroupPointers::
; pointers to the first map of each map group
	dw MapGroup_Olivine     ;  1
	dw MapGroup_Mahogany    ;  2
	dw MapGroup_Dungeons    ;  3
	dw MapGroup_Ecruteak    ;  4
	dw MapGroup_Blackthorn  ;  5
	dw MapGroup_Cinnabar    ;  6
	dw MapGroup_Cerulean    ;  7
	dw MapGroup_Azalea      ;  8
	dw MapGroup_LakeOfRage  ;  9
	dw MapGroup_Violet      ; 10
	dw MapGroup_Goldenrod   ; 11
	dw MapGroup_Vermilion   ; 12
	dw MapGroup_Pallet      ; 13
	dw MapGroup_Pewter      ; 14
	dw MapGroup_FastShip    ; 15
	dw MapGroup_Indigo      ; 16
	dw MapGroup_Fuchsia     ; 17
	dw MapGroup_Lavender    ; 18
	dw MapGroup_Silver      ; 19
	dw MapGroup_CableClub   ; 20
	dw MapGroup_Celadon     ; 21
	dw MapGroup_Cianwood    ; 22
	dw MapGroup_Viridian    ; 23
	dw MapGroup_NewBark     ; 24
	dw MapGroup_Saffron     ; 25
	dw MapGroup_Cherrygrove ; 26
	dw MapGroup_Palerock    ; 27

MapGroup_Olivine:
	map OlivinePokecenter1F, TILESET_POKECENTER, INDOOR, OLIVINE_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OlivineGym, TILESET_CHAMPIONS_ROOM, INDOOR, OLIVINE_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map OlivineMart, TILESET_MART, INDOOR, OLIVINE_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OlivineCity, TILESET_JOHTO, TOWN, OLIVINE_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route14OlivineGate, TILESET_GATE, GATE, ROUTE_14, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OlivineSurfHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, OLIVINE_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route15, TILESET_JOHTO, ROUTE, ROUTE_15, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route16, TILESET_JOHTO, ROUTE, ROUTE_16, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route17, TILESET_JOHTO, ROUTE, ROUTE_17, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_NONE

MapGroup_Mahogany:
	map MahoganyGym, TILESET_ELITE_FOUR_ROOM, INDOOR, MAHOGANY_TOWN, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map MahoganyPokecenter1F, TILESET_POKECENTER, INDOOR, MAHOGANY_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MahoganyTown, TILESET_JOHTO_CITY, TOWN, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_GRIMER
	map PowerPlant1F, TILESET_FACILITY, DUNGEON, MAHOGANY_TOWN, MUSIC_DARK_CAVE, TRUE, PALETTE_NITE, FISHGROUP_GRIMER
	map PowerPlant2F, TILESET_FACILITY, DUNGEON, MAHOGANY_TOWN, MUSIC_DARK_CAVE, TRUE, PALETTE_NITE, FISHGROUP_GRIMER
	map PowerPlant1FB, TILESET_FACILITY, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, TRUE, PALETTE_DAY, FISHGROUP_NONE
	map PowerPlant2FB, TILESET_FACILITY, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, TRUE, PALETTE_DAY, FISHGROUP_NONE
	map MahoganyGate, TILESET_GATE, GATE, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map MahoganyMagnetTrainStation, TILESET_TRAIN_STATION, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MahoganyEmysHouse, TILESET_HOUSE, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MoveDeletersHouse, TILESET_HOUSE, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MahoganySubstituteHouse, TILESET_HOUSE, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MahoganyApartment1F, TILESET_MANSION, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map MahoganyApartment2F, TILESET_MANSION, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map MahoganyApartment3F, TILESET_MANSION, INDOOR, MAHOGANY_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

MapGroup_Dungeons:
	map NationalPark, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, FALSE, PALETTE_AUTO, FISHGROUP_DRATINI
	map NationalParkBugContest, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_BUG_CATCHING_CONTEST, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RadioTower1F, TILESET_RADIO_TOWER, INDOOR, GOLDENROD_CITY, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower2F, TILESET_RADIO_TOWER, INDOOR, GOLDENROD_CITY, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower3F, TILESET_RADIO_TOWER, INDOOR, GOLDENROD_CITY, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower4F, TILESET_RADIO_TOWER, INDOOR, GOLDENROD_CITY, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower5F, TILESET_RADIO_TOWER, INDOOR, GOLDENROD_CITY, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map UnionCave1F, TILESET_CAVE, CAVE, UNION_CAVE, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map UnionCaveB1F, TILESET_CAVE, CAVE, UNION_CAVE, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map UnionCaveB2F, TILESET_CAVE, CAVE, UNION_CAVE, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map MahoganyMart1F, TILESET_TRADITIONAL_HOUSE, INDOOR, MAHOGANY_TOWN, MUSIC_MAHOGANY_MART, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map MountMortar1FOutside, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map MountMortar1FInside, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map MountMortar2FInside, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map MountMortarB1F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map DiglettsCave, TILESET_CAVE, CAVE, DIGLETTS_CAVE, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map MountMoon, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map UndergroundPath, TILESET_UNDERGROUND, GATE, UNDERGROUND_PATH, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockCave1F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockCaveB1F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map VictoryRoad, TILESET_CAVE, CAVE, VICTORY_ROAD, MUSIC_VICTORY_ROAD, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map CianwoodCave1F, TILESET_CAVE, CAVE, CIANWOOD_CITY, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map CianwoodCaveB1F, TILESET_CAVE, CAVE, CIANWOOD_CITY, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map CianwoodCaveB2F, TILESET_CAVE, CAVE, CIANWOOD_CITY, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map OverlookMaze, TILESET_JOHTO, INDOOR, ROUTE_11, MUSIC_MT_MOON, TRUE, PALETTE_AUTO, FISHGROUP_SHORE
	map LostLand, TILESET_JOHTO, ROUTE, LOST_LAND, MUSIC_MT_MOON, TRUE, PALETTE_AUTO, FISHGROUP_OCEAN
	map EastForest, TILESET_JOHTO, ROUTE, ROUTE_4, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map Factory1F, TILESET_FACILITY, INDOOR, ROUTE_4, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map FactoryB1, TILESET_FACILITY, INDOOR, ROUTE_4, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map FactoryBack, TILESET_FACILITY, INDOOR, ROUTE_4, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map BurglarHideout1F, TILESET_UNDERGROUND, INDOOR, ROUTE_21, MUSIC_ROCKET_HIDEOUT, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BurglarHideoutB1F, TILESET_UNDERGROUND, INDOOR, ROUTE_21, MUSIC_ROCKET_HIDEOUT, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BurglarHideoutB2F, TILESET_UNDERGROUND, INDOOR, ROUTE_21, MUSIC_ROCKET_HIDEOUT, FALSE, PALETTE_DAY, FISHGROUP_NONE

MapGroup_Ecruteak:
	map EcruteakPokecenter1F, TILESET_POKECENTER, INDOOR, ECRUTEAK_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map EcruteakMart, TILESET_MART, INDOOR, ECRUTEAK_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map EcruteakGym, TILESET_PARK, INDOOR, ECRUTEAK_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map EcruteakCity, TILESET_JOHTO, TOWN, ECRUTEAK_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map EcruteakForestGate, TILESET_GATE, GATE, ECRUTEAK_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map PaintersForest, TILESET_JOHTO, ROUTE, PAINTERS_FOREST, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map PaintersHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, PAINTERS_FOREST, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_LAKE
	map Route12EcruteakGate, TILESET_GATE, GATE, ROUTE_12, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map EcruteakThiefHouse, TILESET_HOUSE, INDOOR, ECRUTEAK_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map EcruteakFriendBallHouse, TILESET_HOUSE, INDOOR, ECRUTEAK_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	
MapGroup_Blackthorn:
	map BlackthornGym1F, TILESET_CAVE, INDOOR, BLACKTHORN_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map BlackthornGym2F, TILESET_ELITE_FOUR_ROOM, INDOOR, BLACKTHORN_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map BlackthornMart, TILESET_MART, INDOOR, BLACKTHORN_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map BlackthornPokecenter1F, TILESET_POKECENTER, INDOOR, BLACKTHORN_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map BlackthornCity, TILESET_JOHTO, TOWN, BLACKTHORN_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route21, TILESET_JOHTO, TOWN, ROUTE_21, MUSIC_AZALEA_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route21EcruteakGate, TILESET_GATE, GATE, ROUTE_21, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BlackthornRestTalkHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, BLACKTHORN_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map FluteMasterHouse, TILESET_HOUSE, INDOOR, BLACKTHORN_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BlackthornCave1F, TILESET_CAVE, CAVE, BLACKTHORN_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map BlackthornCave2F, TILESET_CAVE, CAVE, BLACKTHORN_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map BlackthornCaveB1F, TILESET_CAVE, CAVE, BLACKTHORN_CITY, MUSIC_GYM, TRUE, PALETTE_NITE, FISHGROUP_SHORE

MapGroup_Cinnabar:
	map SafariZoneGate1F, TILESET_GATE, INDOOR, CARNATION_TOWN, MUSIC_NATIONAL_PARK, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map SafariZoneGate2F, TILESET_GATE, INDOOR, CARNATION_TOWN, MUSIC_NATIONAL_PARK, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map SafariZoneArea1, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea2, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea3, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea4, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map CarnationZoo, TILESET_JOHTO_CITY, ROUTE, CARNATION_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND

MapGroup_Cerulean:
	map Route18, TILESET_JOHTO_CITY, ROUTE, ROUTE_18, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map CarnationTown, TILESET_JOHTO, TOWN, CARNATION_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map CarnationPokecenter1F, TILESET_POKECENTER, INDOOR, CARNATION_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CarnationWobbuffetHouse, TILESET_HOUSE, INDOOR, CARNATION_TOWN, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route19, TILESET_JOHTO, ROUTE, ROUTE_19, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route20, TILESET_JOHTO, ROUTE, ROUTE_20, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE

MapGroup_Azalea:
	map Route3, TILESET_JOHTO, ROUTE, ROUTE_3, MUSIC_ROUTE_26, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route3AzaleaGate, TILESET_GATE, GATE, ROUTE_3, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaPokecenter1F, TILESET_POKECENTER, INDOOR, AZALEA_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CharcoalKiln, TILESET_HOUSE, INDOOR, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaMart, TILESET_MART, INDOOR, AZALEA_TOWN, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map KurtsHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, AZALEA_TOWN, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaGym, TILESET_TRAIN_STATION, INDOOR, AZALEA_TOWN, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaTown, TILESET_JOHTO_CITY, TOWN, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map AzaleaApartmentLeft, TILESET_MANSION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map AzaleaApartmentLeft2F, TILESET_MANSION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map AzaleaApartmentLeft3F, TILESET_MANSION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map AzaleaApartmentRight, TILESET_MANSION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaApartmentRight2F, TILESET_MANSION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaApartmentRight3F, TILESET_MANSION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaGymSpeechHouse, TILESET_HOUSE, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaEvolutionHouse, TILESET_HOUSE, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaBikeHouse, TILESET_HOUSE, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AzaleaBerryHouse, TILESET_HOUSE, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route4ForestGate, TILESET_GATE, GATE, ROUTE_4, MUSIC_ROUTE_3, TRUE, PALETTE_DAY, FISHGROUP_POND
	map Route4AzaleaGate, TILESET_GATE, GATE, ROUTE_4, MUSIC_ROUTE_3, TRUE, PALETTE_DAY, FISHGROUP_POND

MapGroup_LakeOfRage:

MapGroup_Violet:
	map Route4, TILESET_JOHTO, ROUTE, ROUTE_4, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route5, TILESET_JOHTO, ROUTE, ROUTE_5, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route6, TILESET_JOHTO, ROUTE, ROUTE_6, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map Route7, TILESET_JOHTO, ROUTE, ROUTE_7, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map Route8, TILESET_JOHTO, ROUTE, ROUTE_8, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map Route10North, TILESET_JOHTO, ROUTE, ROUTE_10, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map VioletCity, TILESET_JOHTO, TOWN, VIOLET_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map VioletMart, TILESET_MART, INDOOR, VIOLET_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map VioletGym, TILESET_PORT, INDOOR, VIOLET_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_NONE
	map VioletPokecenter1F, TILESET_POKECENTER, INDOOR, VIOLET_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map VioletGymB1, TILESET_PORT, INDOOR, VIOLET_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_POND
	map VioletMoveTutor, TILESET_HOUSE, INDOOR, VIOLET_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map VioletWeatherHouse, TILESET_HOUSE, INDOOR, VIOLET_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map VioletTradeHouse, TILESET_HOUSE, INDOOR, VIOLET_CITY, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route8SilkScarfHouse, TILESET_HOUSE, INDOOR, ROUTE_8, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Goldenrod:
	map GoldenrodCity, TILESET_JOHTO, TOWN, GOLDENROD_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map GoldenrodGym, TILESET_LIGHTHOUSE, INDOOR, CIANWOOD_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodBikeShop, TILESET_CHAMPIONS_ROOM, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodHappinessRater, TILESET_TRADITIONAL_HOUSE, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map BillsFamilysHouse, TILESET_HOUSE, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodMagnetTrainStation, TILESET_TRAIN_STATION, INDOOR, AZALEA_TOWN, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodFlowerShop, TILESET_HOUSE, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodPPSpeechHouse, TILESET_HOUSE, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodNameRater, TILESET_HOUSE, INDOOR, VIOLET_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodGameCorner, TILESET_GAME_CORNER, INDOOR, GOLDENROD_CITY, MUSIC_GAME_CORNER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodPokecenter1F, TILESET_POKECENTER, INDOOR, GOLDENROD_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route8GoldenrodGate, TILESET_GATE, GATE, ROUTE_8, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map IlexForestAzaleaGate, TILESET_GATE, GATE, ROUTE_9, MUSIC_ROUTE_36, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map DayCare, TILESET_HOUSE, INDOOR, GOLDENROD_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route1GoldenrodGate, TILESET_GATE, GATE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodMart, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route11GoldenrodGate, TILESET_GATE, GATE, ROUTE_11, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route11Route12Gate, TILESET_GATE, GATE, ROUTE_11, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Vermilion:
	map GoldenrodDeptStore1F, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStore2F, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStore3F, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStore4F, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStore5F, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStore6F, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStoreElevator, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GoldenrodDeptStoreRoof, TILESET_MART, INDOOR, GOLDENROD_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route6SurfersHouse, TILESET_HOUSE, INDOOR, ROUTE_6, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Pallet:
	map Route11, TILESET_JOHTO, ROUTE, ROUTE_11, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

MapGroup_Pewter:

MapGroup_FastShip:

MapGroup_Indigo:
	map IndigoPlateauPokecenter1F, TILESET_POKECENTER, INDOOR, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map WillsRoom, TILESET_ELITE_FOUR_ROOM, INDOOR, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map KogasRoom, TILESET_ELITE_FOUR_ROOM, INDOOR, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map BrunosRoom, TILESET_ELITE_FOUR_ROOM, INDOOR, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map KarensRoom, TILESET_ELITE_FOUR_ROOM, INDOOR, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map LancesRoom, TILESET_CHAMPIONS_ROOM, INDOOR, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map HallOfFame, TILESET_ICE_PATH, INDOOR, INDIGO_PLATEAU, MUSIC_NEW_BARK_TOWN, TRUE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Fuchsia:
	map IlexForest, TILESET_JOHTO, ROUTE, ILEX_FOREST, MUSIC_UNION_CAVE, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map IlexForestSwordsDanceHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ILEX_FOREST, MUSIC_UNION_CAVE, FALSE, PALETTE_DAY, FISHGROUP_POND
	map Route9, TILESET_JOHTO, ROUTE, ROUTE_9, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route9ForestGate, TILESET_GATE, GATE, ROUTE_9, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_LAKE

MapGroup_Lavender:
	map Route12, TILESET_JOHTO, ROUTE, ROUTE_12, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route12Shelter, TILESET_HOUSE, INDOOR, ROUTE_12, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_LAKE
	map Route13, TILESET_JOHTO, ROUTE, ROUTE_13, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route14, TILESET_JOHTO, ROUTE, ROUTE_14, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route14Cave1F, TILESET_CAVE, CAVE, ROUTE_14, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map Route14Cave2F, TILESET_CAVE, CAVE, ROUTE_14, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map Route10South, TILESET_JOHTO, ROUTE, ROUTE_10, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route3Route4Gate, TILESET_GATE, GATE, ROUTE_3, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route5SuperRodHouse, TILESET_HOUSE, INDOOR, ROUTE_5, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Silver:
	map SilverCaveOutside, TILESET_JOHTO, TOWN, INDIGO_PLATEAU, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map SilverCavePokecenter1F, TILESET_POKECENTER, INDOOR, INDIGO_PLATEAU, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_CableClub:
	map Pokecenter2F, TILESET_POKECENTER, INDOOR, SPECIAL_MAP, MUSIC_POKEMON_CENTER, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map TradeCenter, TILESET_GATE, INDOOR, SPECIAL_MAP, MUSIC_CHERRYGROVE_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map Colosseum, TILESET_GATE, INDOOR, SPECIAL_MAP, MUSIC_CHERRYGROVE_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Celadon:
	map Route6Underground, TILESET_GATE, GATE, ROUTE_6, MUSIC_UNION_CAVE, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map Route16Gate, TILESET_GATE, GATE, ROUTE_16, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map NewBarkForestGate, TILESET_GATE, GATE, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route8Route10Gate, TILESET_GATE, GATE, ROUTE_8, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Cianwood:
	map CianwoodCity, TILESET_MOUNTAIN, TOWN, CIANWOOD_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map ManiasHouse, TILESET_HOUSE, INDOOR, CIANWOOD_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CianwoodGym, TILESET_ELITE_FOUR_ROOM, INDOOR, GOLDENROD_CITY, MUSIC_GYM, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map CianwoodPokecenter1F, TILESET_POKECENTER, INDOOR, CIANWOOD_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CianwoodMart, TILESET_MART, INDOOR, CIANWOOD_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CianwoodPhotoStudio, TILESET_HOUSE, INDOOR, CIANWOOD_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CianwoodLugiaSpeechHouse, TILESET_HOUSE, INDOOR, CIANWOOD_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PokeSeersHouse, TILESET_HOUSE, INDOOR, CIANWOOD_CITY, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CianwoodChurch, TILESET_TOWER, INDOOR, CIANWOOD_CITY, MUSIC_TIN_TOWER, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

MapGroup_Viridian:
	map ViridianPokecenter1F, TILESET_POKECENTER, INDOOR, NEW_BARK_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route2Gate, TILESET_GATE, GATE, ROUTE_2, MUSIC_ROUTE_2, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OrchidCity, TILESET_MOUNTAIN, TOWN, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map OrchidDragonbreathHouse, TILESET_HOUSE, INDOOR, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE

MapGroup_NewBark:
	map Route1, TILESET_JOHTO, ROUTE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map NewBarkTown, TILESET_JOHTO, TOWN, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map ElmsLab, TILESET_LAB, INDOOR, CHERRYGROVE_CITY, MUSIC_PROF_ELM, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PlayersHouse1F, TILESET_PLAYERS_HOUSE, INDOOR, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PlayersHouse2F, TILESET_PLAYERS_ROOM, INDOOR, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PlayersNeighborsHouse, TILESET_HOUSE, INDOOR, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map ElmsHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, NEW_BARK_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route1NewBarkGate, TILESET_GATE, GATE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Saffron:
	map Route5UndergroundPathEntrance, TILESET_GATE, GATE, ROUTE_5, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route5CleanseTagHouse, TILESET_HOUSE, INDOOR, ROUTE_5, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Cherrygrove:
	map Route30, TILESET_JOHTO, ROUTE, ROUTE_30, MUSIC_ROUTE_30, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route1CherrygroveGate, TILESET_GATE, GATE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route2, TILESET_JOHTO, ROUTE, ROUTE_2, MUSIC_ROUTE_30, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map CherrygroveCity, TILESET_JOHTO, TOWN, CHERRYGROVE_CITY, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map CherrygroveMart, TILESET_MART, INDOOR, CHERRYGROVE_CITY, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CherrygrovePokecenter1F, TILESET_POKECENTER, INDOOR, CHERRYGROVE_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CherrygroveGymSpeechHouse, TILESET_PLAYERS_HOUSE, INDOOR, CHERRYGROVE_CITY, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map GuideGentsHouse, TILESET_HOUSE, INDOOR, CHERRYGROVE_CITY, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CherrygroveInn, TILESET_PLAYERS_HOUSE, INDOOR, CHERRYGROVE_CITY, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route2AzaleaGate, TILESET_GATE, GATE, ROUTE_2, MUSIC_ROUTE_30, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Palerock:
	map PalerockMountain1F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountain2F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountain3F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainOutside, TILESET_CAVE, ROUTE, ROUTE_3, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map PalerockMountainB1, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainStrengthRoom, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map HiddenPowerCave, TILESET_CAVE, CAVE, CHERRYGROVE_CITY, MUSIC_MT_MOON, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	