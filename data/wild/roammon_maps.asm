; Maps that roaming monsters can be on, and possible maps they can jump to.
; Notably missing are Route 40 and Route 41, which are water routes.

roam_map: MACRO
	map_id \1
	db _NARG - 1
rept _NARG + -1
	map_id \2
	shift
endr
	db 0
ENDM

RoamMaps:
; there are NUM_ROAMMON_MAPS entries
	; start map, ...other maps
	roam_map ROUTE_1, ROUTE_6, ROUTE_8
	roam_map ROUTE_2, ROUTE_4, ROUTE_3
	db -1 ; end
