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
	dw MapGroup_Ocean		;  1
	dw MapGroup_Rugosa    	;  2
	dw MapGroup_Dungeons    ;  3
	dw MapGroup_Staghorn    ;  4
	dw MapGroup_Acropora 	;  5
	dw MapGroup_Cinnabar    ;  6
	dw MapGroup_Cerulean    ;  7
	dw MapGroup_Pectinia    ;  8
	dw MapGroup_LakeOfRage  ;  9
	dw MapGroup_Ridge      	; 10
	dw MapGroup_Favia   	; 11
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
	dw MapGroup_Hepatica    ; 22
	dw MapGroup_Orchid	    ; 23
	dw MapGroup_Elkhorn     ; 24
	dw MapGroup_Saffron     ; 25
	dw MapGroup_Pavona	    ; 26
	dw MapGroup_Palerock    ; 27

MapGroup_Ocean:
	map RugosaCoast, TILESET_OCEAN, TOWN, RUGOSA_COAST, MUSIC_VIOLET_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route14RugosaGate, TILESET_GATE, GATE, ROUTE_13, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaSurfHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, RUGOSA_COAST, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CoastalLab, TILESET_LAB, INDOOR, RUGOSA_COAST, MUSIC_PROF_ELM, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaPort, TILESET_PORT, INDOOR, RUGOSA_COAST, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map SeaRoute4, TILESET_OCEAN, ROUTE, SEA_ROUTE_4, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map Route8, TILESET_OCEAN, ROUTE, ROUTE_7, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map SeaRoute1, TILESET_OCEAN, ROUTE, SEA_ROUTE_1, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map SeaRoute2, TILESET_OCEAN, ROUTE, SEA_ROUTE_2, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map SeaRoute3, TILESET_OCEAN, ROUTE, SEA_ROUTE_3, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map SeaRoute5, TILESET_OCEAN, ROUTE, SEA_ROUTE_5, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map SeaRoute6, TILESET_OCEAN, ROUTE, SEA_ROUTE_6, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map Route6Gate, TILESET_GATE, GATE, ROUTE_6, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_NONE

MapGroup_Rugosa:
	map RugosaGym, TILESET_ELITE_FOUR_ROOM, INDOOR, RUGOSA_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaPokecenter1F, TILESET_POKECENTER, INDOOR, RUGOSA_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaCity, TILESET_JOHTO_CITY, TOWN, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_AUTO, FISHGROUP_GRIMER
	map PowerPlant1F, TILESET_FACILITY, DUNGEON, RUGOSA_CITY, MUSIC_DARK_CAVE, TRUE, PALETTE_NITE, FISHGROUP_GRIMER
	map PowerPlant2F, TILESET_FACILITY, DUNGEON, RUGOSA_CITY, MUSIC_DARK_CAVE, TRUE, PALETTE_NITE, FISHGROUP_GRIMER
	map PowerPlant1FB, TILESET_FACILITY, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, TRUE, PALETTE_DAY, FISHGROUP_NONE
	map PowerPlant2FB, TILESET_FACILITY, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, TRUE, PALETTE_DAY, FISHGROUP_NONE
	map RugosaGate, TILESET_GATE, GATE, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map RugosaEmysHouse, TILESET_HOUSE, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MoveDeletersHouse, TILESET_HOUSE, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaSubstituteHouse, TILESET_HOUSE, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaApartment1F, TILESET_MANSION, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RugosaApartment2F, TILESET_MANSION, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RugosaApartment3F, TILESET_MANSION, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RugosaCafe, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_CELADON_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route30Cave1F, TILESET_CAVE, CAVE, ROUTE_30, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map Route30CaveB1F, TILESET_CAVE, CAVE, ROUTE_30, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map Route9Cave1F, TILESET_CAVE, CAVE, ROUTE_30, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE

MapGroup_Dungeons:
	map NationalPark, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, FALSE, PALETTE_AUTO, FISHGROUP_DRATINI
	map NationalParkBugContest, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_BUG_CATCHING_CONTEST, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map RadioTower1F, TILESET_RADIO_TOWER, INDOOR, FAVIA_TOWN, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower2F, TILESET_RADIO_TOWER, INDOOR, FAVIA_TOWN, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower3F, TILESET_RADIO_TOWER, INDOOR, FAVIA_TOWN, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower4F, TILESET_RADIO_TOWER, INDOOR, FAVIA_TOWN, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map RadioTower5F, TILESET_RADIO_TOWER, INDOOR, FAVIA_TOWN, RADIO_TOWER_MUSIC | MUSIC_GOLDENROD_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map UnionCave1F, TILESET_CAVE, CAVE, UNION_CAVE, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map UnionCaveB1F, TILESET_CAVE, CAVE, UNION_CAVE, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map UnionCaveB2F, TILESET_CAVE, CAVE, UNION_CAVE, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map MountMortar1FOutside, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map MountMortar1FInside, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map MountMortar2FInside, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map MountMortarB1F, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_LAKE
	map DiglettsCave, TILESET_CAVE, CAVE, DIGLETTS_CAVE, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map DrainPunchChamber, TILESET_CAVE, CAVE, DIGLETTS_CAVE, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map MountMoon, TILESET_CAVE, CAVE, ROUTE_3, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockCave1F, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockCaveB1F, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockCaveB2F, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map VictoryRoad, TILESET_CAVE, CAVE, VICTORY_ROAD, MUSIC_VICTORY_ROAD, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map HepaticaCave1F, TILESET_CAVE, CAVE, HEPATICA_TOWN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map HepaticaCaveB1F, TILESET_CAVE, CAVE, HEPATICA_TOWN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map NevermelticeChamber, TILESET_CAVE, CAVE, HEPATICA_TOWN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map HepaticaCaveB2F, TILESET_CAVE, CAVE, HEPATICA_TOWN, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map OverlookMaze, TILESET_JOHTO, INDOOR, ROUTE_10, MUSIC_MT_MOON, TRUE, PALETTE_AUTO, FISHGROUP_SHORE
	map BurglarHideout1F, TILESET_UNDERGROUND, INDOOR, ROUTE_17, MUSIC_ROCKET_HIDEOUT, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BurglarHideoutB1F, TILESET_UNDERGROUND, INDOOR, ROUTE_17, MUSIC_ROCKET_HIDEOUT, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BurglarHideoutB2F, TILESET_UNDERGROUND, INDOOR, ROUTE_17, MUSIC_ROCKET_HIDEOUT, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map Route7Cave1F, TILESET_CAVE, CAVE, SEA_ROUTE_4, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_OCEAN
	map Route7CaveB1F, TILESET_CAVE, CAVE, SEA_ROUTE_4, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_OCEAN
	map KinglersDen, TILESET_CAVE, CAVE, SEA_ROUTE_4, MUSIC_MT_MOON, TRUE, PALETTE_DAY, FISHGROUP_OCEAN

MapGroup_Staghorn:
	map StaghornPokecenter1F, TILESET_POKECENTER, INDOOR, STAGHORN_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map StaghornMart, TILESET_MART, INDOOR, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map StaghornGym, TILESET_PARK, INDOOR, STAGHORN_TOWN, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map StaghornTown, TILESET_JOHTO, TOWN, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map StaghornForestGate, TILESET_GATE, GATE, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map PaintersForest, TILESET_JOHTO, ROUTE, PAINTERS_FOREST, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map PaintersHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, PAINTERS_FOREST, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_LAKE
	map Route12StaghornGate, TILESET_GATE, GATE, ROUTE_11, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map StaghornThiefHouse, TILESET_HOUSE, INDOOR, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map StaghornFriendBallHouse, TILESET_HOUSE, INDOOR, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map StaghornRichardsHouse, TILESET_HOUSE, INDOOR, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map EmilysHouse1F, TILESET_PLAYERS_HOUSE, INDOOR, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map EmilysHouse2F, TILESET_PLAYERS_ROOM, INDOOR, STAGHORN_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	
MapGroup_Acropora:
	map AcroporaGym, TILESET_CHAMPIONS_ROOM, INDOOR, ACROPORA_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map AcroporaMart, TILESET_MART, INDOOR, ACROPORA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AcroporaPokecenter1F, TILESET_POKECENTER, INDOOR, ACROPORA_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map AcroporaCity, TILESET_JOHTO, TOWN, ACROPORA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route20AcroporaGate, TILESET_GATE, GATE, ROUTE_16, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route21, TILESET_JOHTO, TOWN, ROUTE_17, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route21StaghornGate, TILESET_GATE, GATE, ROUTE_17, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map AcroporaRestTalkHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ACROPORA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map AcroporaLassHouse, TILESET_HOUSE, INDOOR, ACROPORA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map AcroporaCastleHouse, TILESET_HOUSE, INDOOR, ACROPORA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map FluteMasterHouse, TILESET_HOUSE, INDOOR, ACROPORA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map Route24, TILESET_JOHTO, ROUTE, ROUTE_20, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map AcroporaCave1F, TILESET_CAVE, DUNGEON, ACROPORA_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map AcroporaCave2F, TILESET_CAVE, DUNGEON, ACROPORA_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map AcroporaCaveB1F, TILESET_CAVE, DUNGEON, ACROPORA_CITY, MUSIC_DARK_CAVE, TRUE, PALETTE_NITE, FISHGROUP_SHORE

MapGroup_Cinnabar:
	map SafariZoneGate1F, TILESET_GATE, INDOOR, CARNATION_TOWN, MUSIC_NATIONAL_PARK, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map SafariZoneGate2F, TILESET_GATE, INDOOR, CARNATION_TOWN, MUSIC_NATIONAL_PARK, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map SafariZoneArea1, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea2, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea3, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea4, TILESET_PARK, ROUTE, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_DRATINI
	map SafariZoneArea5, TILESET_PARK, ROUTE, SPECIAL_MAP, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_NONE
	map SafariZoneArea6, TILESET_PARK, ROUTE, SPECIAL_MAP, MUSIC_EVOLUTION, TRUE, PALETTE_AUTO, FISHGROUP_NONE
	map SafariZoneArea1RestHouse, TILESET_PLAYERS_HOUSE, INDOOR, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_DAY, FISHGROUP_DRATINI
	map SafariZoneArea2RestHouse, TILESET_PLAYERS_HOUSE, INDOOR, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_DAY, FISHGROUP_DRATINI
	map SafariZoneArea3RestHouse, TILESET_PLAYERS_HOUSE, INDOOR, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_DAY, FISHGROUP_DRATINI
	map SafariZoneArea4RestHouse, TILESET_PLAYERS_HOUSE, INDOOR, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_DAY, FISHGROUP_DRATINI
	map SafariZoneArea5RestHouse, TILESET_PLAYERS_HOUSE, INDOOR, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_DAY, FISHGROUP_DRATINI
	map SafariZoneArea6RestHouse, TILESET_PLAYERS_HOUSE, INDOOR, SAFARI_ZONE, MUSIC_EVOLUTION, TRUE, PALETTE_DAY, FISHGROUP_DRATINI
	map CarnationZoo, TILESET_JOHTO_CITY, TOWN, CARNATION_TOWN, MUSIC_NATIONAL_PARK, FALSE, PALETTE_AUTO, FISHGROUP_POND

MapGroup_Cerulean:
	map Route18, TILESET_JOHTO_CITY, ROUTE, ROUTE_14, MUSIC_ROUTE_37, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route18Barn, TILESET_TRADITIONAL_HOUSE, INDOOR, ROUTE_14, MUSIC_ROUTE_37, FALSE, PALETTE_DAY, FISHGROUP_POND
	map Route18Farmhouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ROUTE_14, MUSIC_ROUTE_37, FALSE, PALETTE_DAY, FISHGROUP_POND
	map Route18CarnationGate, TILESET_GATE, GATE, ROUTE_14, MUSIC_ROUTE_37, FALSE, PALETTE_DAY, FISHGROUP_POND
	map CarnationTown, TILESET_JOHTO, TOWN, CARNATION_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map CarnationZooGate, TILESET_GATE, GATE, CARNATION_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map CarnationPokecenter1F, TILESET_POKECENTER, INDOOR, CARNATION_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CarnationWobbuffetHouse, TILESET_HOUSE, INDOOR, CARNATION_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route19, TILESET_JOHTO, ROUTE, ROUTE_15, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route20, TILESET_JOHTO, ROUTE, ROUTE_16, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route20HeavyBallHouse, TILESET_HOUSE, INDOOR, ROUTE_16, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Pectinia:
	map Route3, TILESET_JOHTO, ROUTE, ROUTE_3, MUSIC_ROUTE_26, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route3PectiniaGate, TILESET_GATE, GATE, ROUTE_3, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaPokecenter1F, TILESET_POKECENTER, INDOOR, PECTINIA_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CharcoalKiln, TILESET_HOUSE, INDOOR, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaMart, TILESET_MART, INDOOR, PECTINIA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map KurtsHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, PECTINIA_CITY, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaGym, TILESET_TRAIN_STATION, INDOOR, PECTINIA_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaCity, TILESET_JOHTO_CITY, TOWN, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map PectiniaApartmentLeft, TILESET_MANSION, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map PectiniaApartmentLeft2F, TILESET_MANSION, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map PectiniaApartmentLeft3F, TILESET_MANSION, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map PectiniaApartmentRight, TILESET_MANSION, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaApartmentRight2F, TILESET_MANSION, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaApartmentRight3F, TILESET_MANSION, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaGymSpeechHouse, TILESET_HOUSE, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaEvolutionHouse, TILESET_HOUSE, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaBikeHouse, TILESET_HOUSE, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaBerryHouse, TILESET_HOUSE, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route4ForestGate, TILESET_GATE, GATE, ROUTE_4, MUSIC_ROUTE_3, TRUE, PALETTE_DAY, FISHGROUP_POND
	map Route4PectiniaGate, TILESET_GATE, GATE, ROUTE_4, MUSIC_ROUTE_3, TRUE, PALETTE_DAY, FISHGROUP_POND

MapGroup_LakeOfRage:
	map EastForest, TILESET_FOREST, ROUTE, VIRIDIAN_FOREST, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map Factory1F, TILESET_FACILITY, DUNGEON, VIRIDIAN_FOREST, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map FactoryB1, TILESET_FACILITY, DUNGEON, VIRIDIAN_FOREST, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map FactoryBack, TILESET_FACILITY, DUNGEON, VIRIDIAN_FOREST, MUSIC_UNION_CAVE, TRUE, PALETTE_NITE, FISHGROUP_POND
	map RaikouLair, TILESET_FACILITY, INDOOR, VIRIDIAN_FOREST, MUSIC_RUINS_OF_ALPH_INTERIOR, TRUE, PALETTE_NITE, FISHGROUP_POND

MapGroup_Ridge:
	map Route4, TILESET_JOHTO, ROUTE, ROUTE_4, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route5, TILESET_OCEAN, ROUTE, ROUTE_5, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route6, TILESET_OCEAN, ROUTE, ROUTE_6, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map Route10North, TILESET_JOHTO, ROUTE, ROUTE_9, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map RidgeVillage, TILESET_OCEAN, TOWN, RIDGE_VILLAGE, MUSIC_VIOLET_CITY, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map RidgeCafe, TILESET_MART, INDOOR, RIDGE_VILLAGE, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RidgeGym, TILESET_PORT, INDOOR, RIDGE_VILLAGE, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_NONE
	map RidgePokecenter1F, TILESET_POKECENTER, INDOOR, RIDGE_VILLAGE, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RidgeGymB1, TILESET_PORT, INDOOR, RIDGE_VILLAGE, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_POND
	map RidgeMoveTutor, TILESET_HOUSE, INDOOR, RIDGE_VILLAGE, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RidgeWeatherHouse, TILESET_HOUSE, INDOOR, RIDGE_VILLAGE, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RidgeTradeHouse, TILESET_HOUSE, INDOOR, RIDGE_VILLAGE, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RidgeMagikarpHouse, TILESET_HOUSE, INDOOR, RIDGE_VILLAGE, MUSIC_VIOLET_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route8SilkScarfHouse, TILESET_HOUSE, INDOOR, ROUTE_7, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route4HiddenCave, TILESET_CAVE, CAVE, ROUTE_4, MUSIC_MT_MOON, TRUE, PALETTE_DAY, FISHGROUP_POND
	map Route8HiddenCave, TILESET_CAVE, CAVE, ROUTE_7, MUSIC_MT_MOON, TRUE, PALETTE_DAY, FISHGROUP_POND

MapGroup_Favia:
	map FaviaTown, TILESET_JOHTO, TOWN, FAVIA_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map FaviaGym, TILESET_ELITE_FOUR_ROOM, INDOOR, FAVIA_TOWN, MUSIC_GYM, TRUE, PALETTE_NITE, FISHGROUP_SHORE
	map FaviaHappinessRater, TILESET_TRADITIONAL_HOUSE, INDOOR, FAVIA_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaTrainStation, TILESET_GATE, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map CarnationFlowerShop, TILESET_HOUSE, INDOOR, CARNATION_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map NameRater, TILESET_HOUSE, INDOOR, RIDGE_VILLAGE, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map FaviaPokecenter1F, TILESET_POKECENTER, INDOOR, FAVIA_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route8FaviaGate, TILESET_GATE, GATE, ROUTE_7, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map DayCare, TILESET_HOUSE, INDOOR, FAVIA_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route1FaviaGate, TILESET_GATE, GATE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map FaviaMart, TILESET_MART, INDOOR, FAVIA_TOWN, MUSIC_ECRUTEAK_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route11FaviaGate, TILESET_GATE, GATE, ROUTE_10, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route11Route12Gate, TILESET_GATE, GATE, ROUTE_10, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaBedStore, TILESET_PLAYERS_ROOM, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PectiniaDollStore, TILESET_PLAYERS_ROOM, INDOOR, PECTINIA_CITY, MUSIC_GOLDENROD_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Vermilion:
	map RugosaDeptStore1F, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaDeptStore2F, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaDeptStore3F, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaDeptStore4F, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaDeptStore5F, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaDeptStore6F, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RugosaDeptStoreElevator, TILESET_MART, INDOOR, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route6SurfersHouse, TILESET_HOUSE, INDOOR, ROUTE_6, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route6WaterfallHouse, TILESET_HOUSE, INDOOR, ROUTE_6, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Pallet:
	map Route11, TILESET_JOHTO, ROUTE, ROUTE_10, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route11CurseHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ROUTE_10, MUSIC_NONE, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map Route11CleanseTagHouse, TILESET_HOUSE, INDOOR, ROUTE_10, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route11HiddenCave, TILESET_CAVE, CAVE, ROUTE_11, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_POND

MapGroup_Pewter:
	map RugosaDeptStoreRoof, TILESET_ROOF, TOWN, RUGOSA_CITY, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map HoOhCastleRoof, TILESET_ROOF, TOWN, ROUTE_21, MUSIC_RUINS_OF_ALPH_INTERIOR, FALSE, PALETTE_AUTO, FISHGROUP_SHORE

MapGroup_FastShip:
	map Route25, TILESET_FOREST, ROUTE, ROUTE_21, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map SSMako1F, TILESET_LIGHTHOUSE, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map SSMako1FRooms, TILESET_LIGHTHOUSE, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map SSMakoB1F, TILESET_LIGHTHOUSE, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map SSMakoEngineRoom, TILESET_LIGHTHOUSE, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map SSMako2F, TILESET_LIGHTHOUSE, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map SSMako2FRooms, TILESET_LIGHTHOUSE, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map SSMakoDeck, TILESET_PORT, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map SSMakoLowerDeck, TILESET_PORT, INDOOR, FAST_SHIP, MUSIC_SS_AQUA, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN

MapGroup_Indigo:
	map PokemonLeague, TILESET_BATTLE_TOWER_OUTSIDE, TOWN, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map VictoryPort, TILESET_BATTLE_TOWER_OUTSIDE, TOWN, VICTORY_ROAD, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map VictoryPortInside, TILESET_PORT, INDOOR, VICTORY_ROAD, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_DAY, FISHGROUP_OCEAN
	map PokemonLeaguePokecenter1F, TILESET_POKECENTER, INDOOR, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map OrvillesRoom, TILESET_POKEMON_LEAGUE, INDOOR, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_MORN, FISHGROUP_NONE
	map RegansRoom, TILESET_POKEMON_LEAGUE, INDOOR, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_NITE, FISHGROUP_NONE
	map BredesRoom, TILESET_POKEMON_LEAGUE, INDOOR, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DAY, FISHGROUP_QWILFISH_NO_SWARM
	map AmbersRoom, TILESET_POKEMON_LEAGUE, INDOOR, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_DARK, FISHGROUP_NONE
	map VictorsRoom, TILESET_CHAMPIONS_ROOM, INDOOR, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, TRUE, PALETTE_MORN, FISHGROUP_NONE
	map HallOfFame, TILESET_ICE_PATH, INDOOR, POKEMON_LEAGUE, MUSIC_POKEMON_LULLABY, TRUE, PALETTE_DAY, FISHGROUP_NONE

MapGroup_Fuchsia:
	map IlexForest, TILESET_FOREST, ROUTE, ILEX_FOREST, MUSIC_UNION_CAVE, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map IlexForestSwordsDanceHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ILEX_FOREST, MUSIC_UNION_CAVE, FALSE, PALETTE_DAY, FISHGROUP_POND
	map Route9ForestGate, TILESET_GATE, GATE, ROUTE_9, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_LAKE

MapGroup_Lavender:
	map Route12, TILESET_JOHTO, ROUTE, ROUTE_11, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route12Shelter, TILESET_HOUSE, INDOOR, ROUTE_11, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_LAKE
	map Route13, TILESET_JOHTO, ROUTE, ROUTE_12, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route14, TILESET_JOHTO, ROUTE, ROUTE_13, MUSIC_ROUTE_12, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map Route14Gate, TILESET_GATE, GATE, ROUTE_13, MUSIC_ROUTE_12, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route14Cave1F, TILESET_CAVE, CAVE, BONEYARD, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map Route14Cave2F, TILESET_CAVE, CAVE, BONEYARD, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map Route10South, TILESET_JOHTO, ROUTE, ROUTE_9, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map Route3Route4Gate, TILESET_GATE, GATE, ROUTE_3, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route5SuperRodHouse, TILESET_HOUSE, INDOOR, ROUTE_5, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Silver:
	map SilverCaveOutside, TILESET_JOHTO, TOWN, POKEMON_LEAGUE, MUSIC_INDIGO_PLATEAU, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map SilverCavePokecenter1F, TILESET_POKECENTER, INDOOR, POKEMON_LEAGUE, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map RemnantCave1F, TILESET_CAVE, CAVE, REMNANT_CAVE, MUSIC_ROUTE_3, FALSE, PALETTE_NITE, FISHGROUP_OCEAN
	map RemnantCave2F, TILESET_CAVE, CAVE, REMNANT_CAVE, MUSIC_ROUTE_3, FALSE, PALETTE_NITE, FISHGROUP_OCEAN
	map RemnantCaveOutside, TILESET_LOST_LAND, ROUTE, REMNANT_CAVE, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map RemnantCave3F, TILESET_CAVE, CAVE, REMNANT_CAVE, MUSIC_ROUTE_3, FALSE, PALETTE_NITE, FISHGROUP_OCEAN
	map LostLand, TILESET_LOST_LAND, ROUTE, LOST_LAND, MUSIC_MT_MOON, TRUE, PALETTE_AUTO, FISHGROUP_FOSSIL
	map LostLandCave1F, TILESET_CAVE, ROUTE, LOST_LAND, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_FOSSIL
	map LostLandCaveB1F, TILESET_CAVE, ROUTE, LOST_LAND, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_FOSSIL
	map LostLandHiddenCave1F, TILESET_CAVE, CAVE, LOST_LAND, MUSIC_ROUTE_3, FALSE, PALETTE_NITE, FISHGROUP_OCEAN
	map LostLandHiddenCave2F, TILESET_CAVE, CAVE, LOST_LAND, MUSIC_ROUTE_3, FALSE, PALETTE_NITE, FISHGROUP_OCEAN

MapGroup_CableClub:
	map Pokecenter2F, TILESET_POKECENTER, INDOOR, SPECIAL_MAP, MUSIC_POKEMON_CENTER, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map TradeCenter, TILESET_GATE, INDOOR, SPECIAL_MAP, MUSIC_CHERRYGROVE_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map Colosseum, TILESET_GATE, INDOOR, SPECIAL_MAP, MUSIC_CHERRYGROVE_CITY, TRUE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Celadon:
	map Route6Underground, TILESET_GATE, GATE, ROUTE_6, MUSIC_UNION_CAVE, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map Route8Route10Gate, TILESET_GATE, GATE, ROUTE_7, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map LugiaCave1F, TILESET_CAVE, CAVE, SEA_ROUTE_5, MUSIC_LIGHTHOUSE, FALSE, PALETTE_NITE, FISHGROUP_NONE
	map LugiaCaveB1F, TILESET_CAVE, CAVE, SEA_ROUTE_5, MUSIC_LIGHTHOUSE, FALSE, PALETTE_NITE, FISHGROUP_NONE
	map LugiaCaveB2F, TILESET_CAVE, CAVE, SEA_ROUTE_5, MUSIC_LIGHTHOUSE, FALSE, PALETTE_NITE, FISHGROUP_NONE
	map LugiaCaveGateChamber, TILESET_CAVE, ENVIRONMENT_5, SEA_ROUTE_5, MUSIC_LIGHTHOUSE, FALSE, PALETTE_NITE, FISHGROUP_NONE
	map LugiaLair, TILESET_CAVE, CAVE, SEA_ROUTE_5, MUSIC_RUINS_OF_ALPH_INTERIOR, FALSE, PALETTE_NITE, FISHGROUP_NONE
	map HoOhCastle1FCentralRoom, TILESET_CASTLE, DUNGEON, ROUTE_21, MUSIC_LIGHTHOUSE, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map HoOhCastle1FSideRooms, TILESET_CASTLE, DUNGEON, ROUTE_21, MUSIC_LIGHTHOUSE, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map HoOhCastle2F, TILESET_CASTLE, DUNGEON, ROUTE_21, MUSIC_LIGHTHOUSE, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map HoOhCastle3F, TILESET_CASTLE, DUNGEON, ROUTE_21, MUSIC_LIGHTHOUSE, FALSE, PALETTE_DAY, FISHGROUP_NONE

MapGroup_Hepatica:
	map HepaticaTown, TILESET_MOUNTAIN, TOWN, HEPATICA_TOWN, MUSIC_AZALEA_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map HepaticaPokecenter1F, TILESET_POKECENTER, INDOOR, HEPATICA_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map HepaticaMart, TILESET_MART, INDOOR, HEPATICA_TOWN, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map HepaticaLugiaSpeechHouse, TILESET_HOUSE, INDOOR, HEPATICA_TOWN, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PokeSeersHouse, TILESET_HOUSE, INDOOR, HEPATICA_TOWN, MUSIC_AZALEA_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map HepaticaChurch, TILESET_TOWER, INDOOR, HEPATICA_TOWN, MUSIC_TIN_TOWER, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map HepaticaGym, TILESET_LIGHTHOUSE, INDOOR, HEPATICA_TOWN, MUSIC_GYM, TRUE, PALETTE_MORN, FISHGROUP_SHORE
	map HepaticaGymNorthChamber, TILESET_LIGHTHOUSE, INDOOR, HEPATICA_TOWN, MUSIC_GYM, TRUE, PALETTE_DARK, FISHGROUP_SHORE
	map HepaticaGymEastChamber, TILESET_LIGHTHOUSE, INDOOR, HEPATICA_TOWN, MUSIC_GYM, TRUE, PALETTE_DARK, FISHGROUP_SHORE
	map HepaticaGymWestChamber, TILESET_LIGHTHOUSE, INDOOR, HEPATICA_TOWN, MUSIC_GYM, TRUE, PALETTE_DARK, FISHGROUP_SHORE

MapGroup_Orchid:
	map Route2Gate, TILESET_GATE, GATE, ROUTE_2, MUSIC_ROUTE_26, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OrchidCity, TILESET_VOLCANO, TOWN, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map OrchidGym1F, TILESET_ELITE_FOUR_ROOM, INDOOR, ORCHID_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map OrchidGymB1F, TILESET_ELITE_FOUR_ROOM, INDOOR, ORCHID_CITY, MUSIC_GYM, TRUE, PALETTE_MORN, FISHGROUP_SHORE
	map OrchidGymLeaderRoom, TILESET_ELITE_FOUR_ROOM, INDOOR, ORCHID_CITY, MUSIC_GYM, TRUE, PALETTE_DAY, FISHGROUP_SHORE
	map OrchidPokecenter1F, TILESET_POKECENTER, INDOOR, ORCHID_CITY, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OrchidMart, TILESET_MART, INDOOR, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map OrchidDragonbreathHouse, TILESET_HOUSE, INDOOR, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map OrchidTeachersHouse, TILESET_PLAYERS_HOUSE, INDOOR, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map OrchidGrannysHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map OrchidBlackbeltsHouse, TILESET_CAVE, INDOOR, ORCHID_CITY, MUSIC_VERMILION_CITY, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map EnteiLair, TILESET_CAVE, CAVE, ORCHID_CITY, MUSIC_RUINS_OF_ALPH_INTERIOR, TRUE, PALETTE_DAY, FISHGROUP_POND
	map MoltenPeak1F, TILESET_CAVE, CAVE, MOLTEN_PEAK, MUSIC_MT_MOON, TRUE, PALETTE_DARK, FISHGROUP_POND
	map MoltenPeakB1F, TILESET_CAVE, CAVE, MOLTEN_PEAK, MUSIC_MT_MOON, TRUE, PALETTE_DARK, FISHGROUP_POND
	map MoltenPeakB2F, TILESET_CAVE, CAVE, MOLTEN_PEAK, MUSIC_MT_MOON, TRUE, PALETTE_DARK, FISHGROUP_POND
	map Route22, TILESET_VOLCANO, ROUTE, ROUTE_18, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map MoltenPeakOutside, TILESET_VOLCANO, ROUTE, MOLTEN_PEAK, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_NONE
	map MoltenPeakHiddenCave, TILESET_CAVE, CAVE, MOLTEN_PEAK, MUSIC_MT_MOON, TRUE, PALETTE_NITE, FISHGROUP_POND
	map EnteiCave1F, TILESET_CAVE, CAVE, MOLTEN_PEAK, MUSIC_MT_MOON, TRUE, PALETTE_DARK, FISHGROUP_POND
	map EnteiCaveB1F, TILESET_CAVE, CAVE, MOLTEN_PEAK, MUSIC_MT_MOON, TRUE, PALETTE_DARK, FISHGROUP_POND

MapGroup_Elkhorn:
	map Route1, TILESET_JOHTO, ROUTE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map ElkhornTown, TILESET_JOHTO, TOWN, ELKHORN_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map ViridianPokecenter1F, TILESET_POKECENTER, INDOOR, ELKHORN_TOWN, MUSIC_POKEMON_CENTER, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map MaplesLab, TILESET_LAB, INDOOR, PAVONA_VILLAGE, MUSIC_PROF_ELM, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PlayersHouse1F, TILESET_PLAYERS_HOUSE, INDOOR, ELKHORN_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PlayersHouse2F, TILESET_PLAYERS_ROOM, INDOOR, ELKHORN_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PlayersNeighborsHouse, TILESET_HOUSE, INDOOR, ELKHORN_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map ElmsHouse, TILESET_TRADITIONAL_HOUSE, INDOOR, ELKHORN_TOWN, MUSIC_NEW_BARK_TOWN, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route1ElkhornGate, TILESET_GATE, GATE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE

MapGroup_Saffron:
	map Route5UndergroundPathEntrance, TILESET_GATE, GATE, ROUTE_5, MUSIC_ROUTE_3, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route5CleanseTagHouse, TILESET_HOUSE, INDOOR, ROUTE_5, MUSIC_VIRIDIAN_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route23, TILESET_JOHTO, ROUTE, ROUTE_19, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_OCEAN
	map BattleSubwayTrain, TILESET_BATTLE_TOWER, INDOOR, PECTINIA_CITY, MUSIC_NONE, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map BattleSubwayPlatform, TILESET_BATTLE_TOWER, INDOOR, PECTINIA_CITY, MUSIC_BATTLE_TOWER_THEME, FALSE, PALETTE_DAY, FISHGROUP_NONE

MapGroup_Pavona:
	map Route30, TILESET_JOHTO, ROUTE, ROUTE_30, MUSIC_ROUTE_30, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map Route1PavonaGate, TILESET_GATE, GATE, ROUTE_1, MUSIC_ROUTE_29, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route2, TILESET_JOHTO, ROUTE, ROUTE_2, MUSIC_ROUTE_30, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map PavonaVillage, TILESET_JOHTO, TOWN, PAVONA_VILLAGE, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_AUTO, FISHGROUP_POND
	map PavonaGymSpeechHouse, TILESET_PLAYERS_HOUSE, INDOOR, PAVONA_VILLAGE, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map PavonaInn, TILESET_PLAYERS_HOUSE, INDOOR, PAVONA_VILLAGE, MUSIC_CHERRYGROVE_CITY, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route2PectiniaGate, TILESET_GATE, GATE, ROUTE_2, MUSIC_ROUTE_30, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map Route9, TILESET_JOHTO, ROUTE, ROUTE_9, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_LAKE
	map SuicuneLair, TILESET_JOHTO, ROUTE, ROUTE_9, MUSIC_RUINS_OF_ALPH_INTERIOR, TRUE, PALETTE_AUTO, FISHGROUP_NONE

MapGroup_Palerock:
	map PalerockMountain1F, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountain2F, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountain3F, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainOutside, TILESET_MOUNTAIN, ROUTE, PALEROCK_MOUNTAIN, MUSIC_ROUTE_3, FALSE, PALETTE_AUTO, FISHGROUP_SHORE
	map PalerockMountainB1, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainB2, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainB3, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainWaterfallChamber, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map PalerockMountainStrengthRoom, TILESET_CAVE, CAVE, PALEROCK_MOUNTAIN, MUSIC_MT_MOON, FALSE, PALETTE_NITE, FISHGROUP_SHORE
	map HiddenPowerCave, TILESET_CAVE, CAVE, PAVONA_VILLAGE, MUSIC_MT_MOON, FALSE, PALETTE_DAY, FISHGROUP_SHORE
	map UnownChamberAG, TILESET_RUINS_OF_ALPH, DUNGEON, ROUTE_5, MUSIC_RUINS_OF_ALPH_INTERIOR, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map UnownChamberHN, TILESET_RUINS_OF_ALPH, DUNGEON, ILEX_FOREST, MUSIC_RUINS_OF_ALPH_INTERIOR, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map UnownChamberOU, TILESET_RUINS_OF_ALPH, DUNGEON, ROUTE_12, MUSIC_RUINS_OF_ALPH_INTERIOR, FALSE, PALETTE_DAY, FISHGROUP_NONE
	map UnownChamberVZ, TILESET_RUINS_OF_ALPH, DUNGEON, SEA_ROUTE_6, MUSIC_RUINS_OF_ALPH_INTERIOR, FALSE, PALETTE_DAY, FISHGROUP_NONE
	