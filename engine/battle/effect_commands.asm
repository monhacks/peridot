DoPlayerTurn:
	call SetPlayerTurn

	ld a, [wBattlePlayerAction]
	and a ; BATTLEPLAYERACTION_USEMOVE?
	ret nz

	jr DoTurn

DoEnemyTurn:
	call SetEnemyTurn

	ld a, [wLinkMode]
	and a
	jr z, DoTurn

	ld a, [wBattleAction]
	cp BATTLEACTION_STRUGGLE
	jr z, DoTurn
	cp BATTLEACTION_SWITCH1
	ret nc

	; fallthrough

DoTurn:
; Read in and execute the user's move effects for this turn.

	xor a
	ld [wTurnEnded], a

	; Effect command checkturn is called for every move.
	call CheckTurn

	ld a, [wTurnEnded]
	and a
	ret nz

	call UpdateMoveData

DoMove:
; Get the user's move effect.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	ld c, a
	ld b, 0
	ld hl, MoveEffectsPointers
	add hl, bc
	add hl, bc
	ld a, BANK(MoveEffectsPointers)
	call GetFarHalfword

	ld de, wBattleScriptBuffer

.GetMoveEffect:
	ld a, BANK(MoveEffects)
	call GetFarByte
	inc hl
	ld [de], a
	inc de
	cp endmove_command
	jr nz, .GetMoveEffect

; Start at the first command.
	ld hl, wBattleScriptBuffer
	ld a, l
	ld [wBattleScriptBufferAddress], a
	ld a, h
	ld [wBattleScriptBufferAddress + 1], a

.ReadMoveEffectCommand:
; ld a, [wBattleScriptBufferAddress++]
	ld a, [wBattleScriptBufferAddress]
	ld l, a
	ld a, [wBattleScriptBufferAddress + 1]
	ld h, a

	ld a, [hli]

	push af
	ld a, l
	ld [wBattleScriptBufferAddress], a
	ld a, h
	ld [wBattleScriptBufferAddress + 1], a
	pop af

; endturn_command (-2) is used to terminate branches without ending the read cycle.
	cp endturn_command
	jr nc, .powerherb

; The rest of the commands (01-af) are read from BattleCommandPointers.
	push bc
	dec a
	ld c, a
	ld b, 0
	ld hl, BattleCommandPointers
	add hl, bc
	add hl, bc
	pop bc

	ld a, BANK(BattleCommandPointers)
	call GetFarHalfword

	call .DoMoveEffectCommand

	jr .ReadMoveEffectCommand

.DoMoveEffectCommand:
	jp hl
	
.powerherb
	push af
	call CheckPowerHerb
	pop af
	ret

CheckTurn:
BattleCommand_CheckTurn:
; checkturn

; Repurposed as hardcoded turn handling. Useless as a command.

; NO_MOVE immediately ends the turn.
	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	and a ; NO_MOVE?
	jp z, EndTurn

	xor a
	ld [wAttackMissed], a
	ld [wEffectFailed], a
	ld [wKickCounter], a
	ld [wAlreadyDisobeyed], a
	ld [wAlreadyFailed], a
	ld [wSomeoneIsRampaging], a

	ld a, EFFECTIVE
	ld [wTypeModifier], a

	ldh a, [hBattleTurn]
	and a
	jp nz, CheckEnemyTurn

CheckPlayerTurn:
	ld hl, wPlayerSubStatus4
	bit SUBSTATUS_RECHARGE, [hl]
	jr z, .no_recharge

	res SUBSTATUS_RECHARGE, [hl]
	ld hl, MustRechargeText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.no_recharge

	ld hl, wBattleMonStatus
	ld a, [hl]
	and SLP
	jr z, .not_asleep

	dec a
	ld [wBattleMonStatus], a
	and SLP
	jr z, .woke_up

	xor a
	ld [wNumHits], a
	ld de, ANIM_SLP
	call FarPlayBattleAnimation

	ld hl, FastAsleepText
	call StdBattleTextBox

	; Snore and Sleep Talk bypass sleep.
	ld a, [wCurPlayerMove]
	cp SNORE
	jr z, .not_asleep
	cp SLEEP_TALK
	jr z, .not_asleep

	call CantMove
	jp EndTurn

.woke_up
	ld hl, WokeUpText
	call StdBattleTextBox
	call CantMove
	call UpdateBattleMonInParty
	ld hl, UpdatePlayerHUD
	call CallBattleCore
	ld a, $1
	ldh [hBGMapMode], a

.not_asleep
	ld hl, wBattleMonStatus
	bit FRZ, [hl]
	jr z, .not_frozen

	; Flame Wheel and Sacred Fire thaw the user.
	ld a, [wCurPlayerMove]
	cp FLAME_WHEEL
	jr z, .not_frozen
	cp SACRED_FIRE
	jr z, .not_frozen

	ld hl, FrozenSolidText
	call StdBattleTextBox

	call CantMove
	jp EndTurn

.not_frozen

	ld hl, wPlayerSubStatus3
	bit SUBSTATUS_FLINCHED, [hl]
	jr z, .not_flinched

	res SUBSTATUS_FLINCHED, [hl]
	ld hl, FlinchedText
	call StdBattleTextBox

	call CantMove
	jp EndTurn

.not_flinched

	ld hl, wPlayerDisableCount
	ld a, [hl]
	and a
	jr z, .not_disabled

	dec a
	ld [hl], a
	and $f
	jr nz, .not_disabled

	ld [hl], a
	ld [wDisabledMove], a
	ld hl, DisabledNoMoreText
	call StdBattleTextBox

.not_disabled

	ld a, [wPlayerSubStatus3]
	add a
	jr nc, .not_confused
	ld hl, wPlayerConfuseCount
	dec [hl]
	jr nz, .confused

	ld hl, wPlayerSubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .not_confused

.confused
	ld hl, IsConfusedText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call FarPlayBattleAnimation

	; 33% chance of hitting itself
	call BattleRandom
	cp 33 percent + 1
	jr nc, .not_confused

	; clear confusion-dependent substatus
	ld hl, wPlayerSubStatus3
	ld a, [hl]
	and 1 << SUBSTATUS_CONFUSED
	ld [hl], a

	call HitConfusion
	call CantMove
	jp EndTurn

.not_confused

	ld a, [wPlayerSubStatus1]
	add a ; bit SUBSTATUS_ATTRACT
	jr nc, .not_infatuated

	ld hl, InLoveWithText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_LOVE
	call FarPlayBattleAnimation

	; 50% chance of infatuation
	call BattleRandom
	cp 50 percent + 1
	jr c, .not_infatuated

	ld hl, InfatuationText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_infatuated

	; We can't disable a move that doesn't exist.
	ld a, [wDisabledMove]
	and a
	jr z, .no_disabled_move

	; Are we using the disabled move?
	ld hl, wCurPlayerMove
	cp [hl]
	jr nz, .no_disabled_move

	call MoveDisabled
	call CantMove
	jp EndTurn

.no_disabled_move

	ld hl, wBattleMonStatus
	bit PAR, [hl]
	ret z

	; 25% chance to be fully paralyzed
	call BattleRandom
	cp 25 percent
	ret nc

	ld hl, FullyParalyzedText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

CantMove:
	ld a, BATTLE_VARS_SUBSTATUS1
	call GetBattleVarAddr
	res SUBSTATUS_ROLLOUT, [hl]

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	ld a, [hl]
	and $ff ^ (1 << SUBSTATUS_BIDE | 1 << SUBSTATUS_RAMPAGE | 1 << SUBSTATUS_CHARGED)
	ld [hl], a

	call ResetFuryCutterCount

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .fly_dig

	cp DIG
	ret nz

.fly_dig
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	jp AppearUserRaiseSub

OpponentCantMove:
	call BattleCommand_SwitchTurn
	call CantMove
	jp BattleCommand_SwitchTurn

CheckEnemyTurn:
	ld hl, wEnemySubStatus4
	bit SUBSTATUS_RECHARGE, [hl]
	jr z, .no_recharge

	res SUBSTATUS_RECHARGE, [hl]
	ld hl, MustRechargeText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.no_recharge

	ld hl, wEnemyMonStatus
	ld a, [hl]
	and SLP
	jr z, .not_asleep

	dec a
	ld [wEnemyMonStatus], a
	and a
	jr z, .woke_up

	ld hl, FastAsleepText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_SLP
	call FarPlayBattleAnimation
	jr .fast_asleep

.woke_up
	ld hl, WokeUpText
	call StdBattleTextBox
	call CantMove
	call UpdateEnemyMonInParty
	ld hl, UpdateEnemyHUD
	call CallBattleCore
	ld a, $1
	ldh [hBGMapMode], a
;	ld hl, wEnemySubStatus1
;	res SUBSTATUS_NIGHTMARE, [hl]
	jr .not_asleep

.fast_asleep
	; Snore and Sleep Talk bypass sleep.
	ld a, [wCurEnemyMove]
	cp SNORE
	jr z, .not_asleep
	cp SLEEP_TALK
	jr z, .not_asleep
	call CantMove
	jp EndTurn

.not_asleep

	ld hl, wEnemyMonStatus
	bit FRZ, [hl]
	jr z, .not_frozen

	; Flame Wheel and Sacred Fire thaw the user.
	ld a, [wCurEnemyMove]
	cp FLAME_WHEEL
	jr z, .not_frozen
	cp SACRED_FIRE
	jr z, .not_frozen

	ld hl, FrozenSolidText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_frozen

	ld hl, wEnemySubStatus3
	bit SUBSTATUS_FLINCHED, [hl]
	jr z, .not_flinched

	res SUBSTATUS_FLINCHED, [hl]
	ld hl, FlinchedText
	call StdBattleTextBox

	call CantMove
	jp EndTurn

.not_flinched

	ld hl, wEnemyDisableCount
	ld a, [hl]
	and a
	jr z, .not_disabled

	dec a
	ld [hl], a
	and $f
	jr nz, .not_disabled

	ld [hl], a
	ld [wEnemyDisabledMove], a

	ld hl, DisabledNoMoreText
	call StdBattleTextBox

.not_disabled

	ld a, [wEnemySubStatus3]
	add a ; bit SUBSTATUS_CONFUSED
	jr nc, .not_confused

	ld hl, wEnemyConfuseCount
	dec [hl]
	jr nz, .confused

	ld hl, wEnemySubStatus3
	res SUBSTATUS_CONFUSED, [hl]
	ld hl, ConfusedNoMoreText
	call StdBattleTextBox
	jr .not_confused

.confused
	ld hl, IsConfusedText
	call StdBattleTextBox

	xor a
	ld [wNumHits], a
	ld de, ANIM_CONFUSED
	call FarPlayBattleAnimation

	; 33% chance of hitting itself
	call BattleRandom
	cp 33 percent + 1
	jr nc, .not_confused

	; clear confusion-dependent substatus
	ld hl, wEnemySubStatus3
	ld a, [hl]
	and 1 << SUBSTATUS_CONFUSED
	ld [hl], a

	ld hl, HurtItselfText
	call StdBattleTextBox
	call HitSelfInConfusion
	call ConfusionDamageCalc
	call BattleCommand_LowerSub
	xor a
	ld [wNumHits], a

	; Flicker the monster pic unless flying or underground.
	ld de, ANIM_HIT_CONFUSION
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, PlayFXAnimID

	ld c, TRUE
	call DoEnemyDamage
	call BattleCommand_RaiseSub
	call CantMove
	jp EndTurn

.not_confused

	ld a, [wEnemySubStatus1]
	add a ; bit SUBSTATUS_ATTRACT
	jr nc, .not_infatuated

	ld hl, InLoveWithText
	call StdBattleTextBox
	xor a
	ld [wNumHits], a
	ld de, ANIM_IN_LOVE
	call FarPlayBattleAnimation

	; 50% chance of infatuation
	call BattleRandom
	cp 50 percent + 1
	jr c, .not_infatuated

	ld hl, InfatuationText
	call StdBattleTextBox
	call CantMove
	jp EndTurn

.not_infatuated

	; We can't disable a move that doesn't exist.
	ld a, [wEnemyDisabledMove]
	and a
	jr z, .no_disabled_move

	; Are we using the disabled move?
	ld hl, wCurEnemyMove
	cp [hl]
	jr nz, .no_disabled_move

	call MoveDisabled

	call CantMove
	jp EndTurn

.no_disabled_move

	ld hl, wEnemyMonStatus
	bit PAR, [hl]
	ret z

	; 25% chance to be fully paralyzed
	call BattleRandom
	cp 25 percent
	ret nc

	ld hl, FullyParalyzedText
	call StdBattleTextBox
	call CantMove

	; fallthrough

EndTurn:
	ld a, $1
	ld [wTurnEnded], a
	jp ResetDamage

MoveDisabled:
	; Make sure any charged moves fail
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_CHARGED, [hl]

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld [wNamedObjectIndexBuffer], a
	call GetMoveName

	ld hl, DisabledMoveText
	jp StdBattleTextBox

HitConfusion:
	ld hl, HurtItselfText
	call StdBattleTextBox

	xor a
	ld [wCriticalHit], a

	call HitSelfInConfusion
	call BattleCommand_DamageCalc
	call BattleCommand_LowerSub

	xor a
	ld [wNumHits], a

	; Flicker the monster pic unless flying or underground.
	ld de, ANIM_HIT_CONFUSION
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, PlayFXAnimID

	ld hl, UpdatePlayerHUD
	call CallBattleCore
	ld a, $1
	ldh [hBGMapMode], a
	ld c, TRUE
	call DoPlayerDamage
	jp BattleCommand_RaiseSub

BattleCommand_CheckObedience:
; checkobedience

	; Everything obeys in postgame
	ld hl, wStatusFlags
	bit STATUSFLAGS_HALL_OF_FAME_F, [hl]
	ret nz

	; Enemy can't disobey
	ldh a, [hBattleTurn]
	and a
	ret nz

	call CheckUserIsCharging
	ret nz

	; If we've already checked this turn
	ld a, [wAlreadyDisobeyed]
	and a
	ret nz

	xor a
	ld [wAlreadyDisobeyed], a

	; No obedience in link battles
	; (since no handling exists for enemy)
	ld a, [wLinkMode]
	and a
	ret nz

	ld a, [wInBattleTowerBattle]
	and a
	ret nz

	; If the monster's id doesn't match the player's,
	; some conditions need to be met.
	; ...But only in easy mode.
	ld a, [wDifficultyMode]
	cp DIFFICULTY_RELAXED_F
	jp nz, .obeylevel
	
	ld a, MON_ID
	call BattlePartyAttr

	ld a, [wPlayerID]
	cp [hl]
	jr nz, .obeylevel
	inc hl
	ld a, [wPlayerID + 1]
	cp [hl]
	ret z

.obeylevel
	; The maximum obedience level is constrained by owned badges:
	ld hl, wJohtoBadges

	; Enya
	bit RISINGBADGE, [hl]
	ld a, 70
	jr nz, .getlevel

	; Alan
	bit GLACIERBADGE, [hl]
	ld a, 60
	jr nz, .getlevel
	
	; Joel
	bit STORMBADGE, [hl]
	ld a, 50
	jr nz, .getlevel

	; Celeste
	bit PLAINBADGE, [hl]
	ld a, 40
	jr nz, .getlevel

	; Cecil
	bit HIVEBADGE, [hl]
	ld a, 30
	jr nz, .getlevel

	; Murphy
	bit ZEPHYRBADGE, [hl]
	ld a, 30
	jr nz, .getlevel

	; no badges
	ld a, 20

.getlevel
; c = obedience level
; d = monster level
; b = c + d

	ld b, a
	ld c, a

	ld a, [wBattleMonLevel]
	ld d, a

	add b
	ld b, a

; No overflow (this should never happen)
	jr nc, .checklevel
	ld b, $ff

.checklevel
; If the monster's level is lower than the obedience level, it will obey.
	ld a, c
	cp d
	ret nc

; Random number from 0 to obedience level + monster level
.rand1
	call BattleRandom
	swap a
	cp b
	jr nc, .rand1

; The higher above the obedience level the monster is,
; the more likely it is to disobey.
	cp c
	ret c

; Sleep-only moves have separate handling, and a higher chance of
; being ignored. Lazy monsters like their sleep.
	call IgnoreSleepOnly
	ret c

; Another random number from 0 to obedience level + monster level
.rand2
	call BattleRandom
	cp b
	jr nc, .rand2

; A second chance.
	cp c
	jr c, .UseInstead

; No hope of using a move now.

; b = number of levels the monster is above the obedience level
	ld a, d
	sub c
	ld b, a

; The chance of napping is the difference out of 256.
	call BattleRandom
	swap a
	sub b
	jr c, .Nap

; The chance of not hitting itself is the same.
	cp b
	jr nc, .DoNothing

	ld hl, WontObeyText
	call StdBattleTextBox
	call HitConfusion
	jp .EndDisobedience

.Nap:
	call BattleRandom
	add a
	swap a
	and SLP
	jr z, .Nap

	ld [wBattleMonStatus], a

	ld hl, BeganToNapText
	jr .Print

.DoNothing:
	; 4 random choices
	call BattleRandom
	and %11

	ld hl, LoafingAroundText
	and a ; 0
	jr z, .Print

	ld hl, WontObeyText
	dec a ; 1
	jr z, .Print

	ld hl, TurnedAwayText
	dec a ; 2
	jr z, .Print

	ld hl, IgnoredOrdersText

.Print:
	call StdBattleTextBox
	jp .EndDisobedience

.UseInstead:
; Can't use another move if the monster only has one!
	ld a, [wBattleMonMoves + 1]
	and a
	jr z, .DoNothing

; Don't bother trying to handle Disable.
	ld a, [wDisabledMove]
	and a
	jr nz, .DoNothing

	ld hl, wBattleMonPP
	ld de, wBattleMonMoves
	ld b, 0
	ld c, NUM_MOVES

.GetTotalPP:
	ld a, [hli]
	and PP_MASK
	add b
	ld b, a

	dec c
	jr z, .CheckMovePP

; Stop at undefined moves.
	inc de
	ld a, [de]
	and a
	jr nz, .GetTotalPP

.CheckMovePP:
	ld hl, wBattleMonPP
	ld a, [wCurMoveNum]
	ld e, a
	ld d, 0
	add hl, de

; Can't use another move if only one move has PP.
	ld a, [hl]
	and PP_MASK
	cp b
	jr z, .DoNothing

; Make sure we can actually use the move once we get there.
	ld a, 1
	ld [wAlreadyDisobeyed], a

	ld a, [w2DMenuNumRows]
	ld b, a

; Save the move we originally picked for afterward.
	ld a, [wCurMoveNum]
	ld c, a
	push af

.RandomMove:
	call BattleRandom
	maskbits NUM_MOVES

	cp b
	jr nc, .RandomMove

; Not the move we were trying to use.
	cp c
	jr z, .RandomMove

; Make sure it has PP.
	ld [wCurMoveNum], a
	ld hl, wBattleMonPP
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	and PP_MASK
	jr z, .RandomMove

; Use it.
	ld a, [wCurMoveNum]
	ld c, a
	ld b, 0
	ld hl, wBattleMonMoves
	add hl, bc
	ld a, [hl]
	ld [wCurPlayerMove], a

	call SetPlayerTurn
	call UpdateMoveData
	call DoMove

; Restore original move choice.
	pop af
	ld [wCurMoveNum], a

.EndDisobedience:
	xor a
	ld [wLastPlayerMove], a
	ld [wLastPlayerCounterMove], a

	; Break Encore too.
	ld hl, wPlayerSubStatus5
	res SUBSTATUS_ENCORED, [hl]
	xor a
	ld [wPlayerEncoreCount], a

	jp EndMoveEffect

IgnoreSleepOnly:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	; Snore and Sleep Talk bypass sleep.
	cp SNORE
	jr z, .CheckSleep
	cp SLEEP_TALK
	jr z, .CheckSleep
	and a
	ret

.CheckSleep:
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret z

; 'ignored orders…sleeping!'
	ld hl, IgnoredSleepingText
	call StdBattleTextBox

	call EndMoveEffect

	scf
	ret

BattleCommand_UsedMoveText:
; usedmovetext
	farcall DisplayUsedMoveText
	ret

CheckUserIsCharging:
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerCharging] ; player
	jr z, .end
	ld a, [wEnemyCharging] ; enemy
.end
	and a
	ret

BattleCommand_DoTurn:
	call CheckUserIsCharging
	ret nz

	ld hl, wBattleMonPP
	ld de, wPlayerSubStatus3
	ld bc, wPlayerTurnsTaken

	ldh a, [hBattleTurn]
	and a
	jr z, .proceed

; Bosses and Legendaries do not lose PP.
	ld a, [wBattleType]
	cp BATTLETYPE_LEGENDARY
	ret z
	cp BATTLETYPE_BOSS
	ret z

	ld hl, wEnemyMonPP
	ld de, wEnemySubStatus3
	ld bc, wEnemyTurnsTaken

.proceed

; If we've gotten this far, this counts as a turn.
	ld a, [bc]
	inc a
	ld [bc], a

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp STRUGGLE
	ret z

	ld a, [de]
	and 1 << SUBSTATUS_IN_LOOP | 1 << SUBSTATUS_RAMPAGE | 1 << SUBSTATUS_BIDE
	ret nz

	call .consume_pp
	ld a, b
	and a
	jp nz, EndMoveEffect

	; SubStatus5
	inc de
	inc de

	ld a, [de]
	bit SUBSTATUS_TRANSFORMED, a
	ret nz

	ldh a, [hBattleTurn]
	and a

	ld hl, wPartyMon1PP
	ld a, [wCurBattleMon]
	jr z, .player

; mimic this part entirely if wildbattle
	ld a, [wBattleMode]
	dec a
	jr z, .wild

	ld hl, wOTPartyMon1PP
	ld a, [wCurOTMon]

.player
	call GetPartyLocation
	push hl
	call CheckMimicUsed
	pop hl
	ret c

.consume_pp
	ldh a, [hBattleTurn]
	and a
	ld a, [wCurMoveNum]
	jr z, .okay
	ld a, [wCurEnemyMoveNum]

.okay
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	and PP_MASK
	jr z, .out_of_pp
	dec [hl]
	ld b, 0
	ret

.wild
	ld hl, wEnemyMonMoves
	ld a, [wCurEnemyMoveNum]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp MIMIC
	jr z, .mimic
	ld hl, wWildMonMoves
	add hl, bc
	ld a, [hl]
	cp MIMIC
	ret z

.mimic
	ld hl, wWildMonPP
	 jp .consume_pp

.out_of_pp
	call BattleCommand_MoveDelay
; get move effect
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
; continuous?
	ld hl, .continuousmoves
	ld de, 1
	call IsInArray

; 'has no pp left for [move]'
	ld hl, HasNoPPLeftText
	jr c, .print
; 'but no pp is left for the move'
	ld hl, NoPPLeftText
.print
	call StdBattleTextBox
	ld b, 1
	ret

.continuousmoves
	db EFFECT_RAZOR_WIND
	db EFFECT_SKY_ATTACK
	db EFFECT_SKULL_BASH
	db EFFECT_SOLARBEAM
	db EFFECT_FLY
	db EFFECT_ROLLOUT
	db EFFECT_BIDE
	db EFFECT_RAMPAGE
	db -1

CheckMimicUsed:
	ldh a, [hBattleTurn]
	and a
	ld a, [wCurMoveNum]
	jr z, .player
	ld a, [wCurEnemyMoveNum]

.player
	ld c, a
	ld a, MON_MOVES
	call UserPartyAttr

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	cp MIMIC
	jr z, .mimic
;
	ld b, 0
	add hl, bc
	ld a, [hl]
	cp MIMIC
	jr nz, .mimic

	scf
	ret

.mimic
	and a
	ret

BattleCommand_Critical:
; critical

; Determine whether this attack's hit will be critical.

	xor a
	ld [wCriticalHit], a

	ld a, BATTLE_VARS_MOVE_POWER
	call GetBattleVar
	and a
	ret z

	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonItem
	ld a, [wEnemyMonSpecies]
	jr nz, .Item
	ld hl, wBattleMonItem
	ld a, [wBattleMonSpecies]

.Item:
	ld c, 0

	cp CHANSEY
	jr z, .checkluckypunch
	cp BLISSEY
	jr nz, .Farfetchd
.checkluckypunch
	ld a, [hl]
	cp LUCKY_PUNCH
	jr nz, .FocusEnergy

; +4 critical level
	ld c, 4
	jr .Tally

.Farfetchd:
	cp FARFETCH_D
	jr z, .checkstick
.MallarkY:
	cp MALLARK_Y
	jr nz, .Beedrill
.checkstick
	ld a, [hl]
	cp STICK
	jr nz, .FocusEnergy
	jr .docritlevel

.Beedrill:
	cp BEEDRILL
	jr nz, .Smeargle
	ld a, [hl]
	cp BARBED_SPEAR
	jr nz, .FocusEnergy
	jr .docritlevel

.Smeargle:
	cp SMEARGLE
	jr nz, .FocusEnergy

	ld a, [hl]
	cp PALETTE
	jr nz, .FocusEnergy
.docritlevel
; +3 critical level
	ld c, 3
	jr .Tally

.FocusEnergy:
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_FOCUS_ENERGY, a
	jr z, .CheckCritical

; +1 critical level
	inc c

.CheckCritical:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld de, 1
	ld hl, CriticalHitMoves
	push bc
	call IsInArray
	pop bc
	jr nc, .RunicPower

; +2 critical level
	inc c
	inc c

.RunicPower
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp RUNIC_POWER
	jr nz, .ScopeLens

; +4 critical level
	ld c, 4
	jr .Tally

.ScopeLens:
	push bc
	call GetUserItem
	ld a, b
	cp HELD_CRITICAL_UP ; Increased critical chance. Only Scope Lens has this.
	pop bc
	jr nz, .Tally

; +1 critical level
	inc c

.Tally:
	ld hl, CriticalHitChances
	ld b, 0
	add hl, bc
	call BattleRandom
	cp [hl]
	ret nc
	ld a, 1
	ld [wCriticalHit], a
	ret

INCLUDE "data/moves/critical_hit_moves.asm"

INCLUDE "data/battle/critical_hit_chances.asm"

BattleCommand_Stab:
; STAB = Same Type Attack Bonus
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp STRUGGLE
	ret z

	ld hl, wBattleMonType1
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]

	ldh a, [hBattleTurn]
	and a
	jr z, .go ; Who Attacks and who Defends

	ld hl, wEnemyMonType1
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wBattleMonType1
	ld a, [hli]
	ld d, a
	ld e, [hl]

.go
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	ld [wCurType], a

	push hl
	push de
	push bc
	farcall DoWeatherModifiers
	pop bc
	pop de
	pop hl

	ld a, [wCurType]
	cp b
	jr z, .stab
	cp c
	jr z, .stab

	jr .SkipStab

.stab
	ld hl, wCurDamage + 1
	ld a, [hld]
	ld h, [hl]
	ld l, a

	ld b, h
	ld c, l
	srl b
	rr c
	add hl, bc

	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a

	ld hl, wTypeModifier
	set 7, [hl]

.SkipStab:
	call CheckSpecialMatchupMoves
	jr z, .alternate

	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	ld b, a
	ld hl, TypeMatchups
	jr .TypesLoop
	
.alternate
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	ld b, a
	ld hl, AlternateMatchups
.TypesLoop:
	ld a, [hli]

	cp -1
	jr z, .end

	; foresight
	cp -2
	jr nz, .SkipForesightCheck
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	jr nz, .end

	jr .TypesLoop

.SkipForesightCheck:
	cp b
	jr nz, .SkipType
	ld a, [hl]
	cp d
	jr z, .GotMatchup
	cp e
	jr z, .GotMatchup
	jr .SkipType

.GotMatchup:
	push hl
	push bc
	inc hl
	ld a, [wTypeModifier]
	and %10000000
	ld b, a
; If the target is immune to the move, treat it as a miss and calculate the damage as 0
	ld a, [hl]
	and a
	jr nz, .NotImmune

	inc a
	ld [wAttackMissed], a
	xor a
.NotImmune:
	ldh [hMultiplier], a
	add b
	ld [wTypeModifier], a

	xor a
	ldh [hMultiplicand + 0], a

	ld hl, wCurDamage
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hld]
	ldh [hMultiplicand + 2], a

	call Multiply

	ldh a, [hProduct + 1]
	ld b, a
	ldh a, [hProduct + 2]
	or b
	ld b, a
	ldh a, [hProduct + 3]
	or b
	jr z, .ok ; This is a very convoluted way to get back that we've essentially dealt no damage.

; Take the product and divide it by 10.
	ld a, 10
	ldh [hDivisor], a
	ld b, 4
	call Divide
	ldh a, [hQuotient + 2]
	ld b, a
	ldh a, [hQuotient + 3]
	or b
	jr nz, .ok

	ld a, 1
	ldh [hMultiplicand + 2], a

.ok
	ldh a, [hMultiplicand + 1]
	ld [hli], a
	ldh a, [hMultiplicand + 2]
	ld [hl], a
	pop bc
	pop hl

.SkipType:
	inc hl
	inc hl
	jr .TypesLoop

.end
	call BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	ld b, a
	ld a, [wTypeModifier]
	and %10000000
	or b
	ld [wTypeModifier], a
	ret

BattleCheckTypeMatchup:
	ld hl, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .get_type
	ld hl, wBattleMonType1
.get_type
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar ; preserves hl, de, and bc
CheckTypeMatchup:
	push hl
	push de
	push bc
	ld d, a
	ld b, [hl]
	inc hl
	ld c, [hl]
	ld a, 10 ; 1.0
	ld [wTypeMatchup], a

	call CheckSpecialMatchupMoves
	jr z, .alternate

	ld hl, TypeMatchups
	jr .TypesLoop

.alternate
	ld hl, AlternateMatchups
.TypesLoop:
	ld a, [hli]
	cp -1
	jr z, .End
	cp -2
	jr nz, .Next
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	jr nz, .End
	jr .TypesLoop

.Next:
	cp d
	jr nz, .Nope
	ld a, [hli]
	cp b
	jr z, .Yup
	cp c
	jr z, .Yup
	jr .Nope2

.Nope:
	inc hl
.Nope2:
	inc hl
	jr .TypesLoop

.Yup:
	xor a
	ldh [hDividend + 0], a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [hli]
	ldh [hMultiplicand + 2], a
	ld a, [wTypeMatchup]
	ldh [hMultiplier], a
	call Multiply
	ld a, 10
	ldh [hDivisor], a
	push bc
	ld b, 4
	call Divide
	pop bc
	ldh a, [hQuotient + 3]
	ld [wTypeMatchup], a
	jr .TypesLoop

.End:
	pop bc
	pop de
	pop hl
	ret

CheckSpecialMatchupMoves:
	; Bonemerang ignores Flying's immunity to Ground.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_BONEMERANG
	jr z, .alternate
	; Freeze-Dry is super-effective against Water.
	cp EFFECT_FREEZE_DRY
	jr z, .alternate
	ret

.alternate
	ld a, 1
	ret

BattleCommand_ResetTypeMatchup:
; Reset the type matchup multiplier to 1.0, if the type matchup is not 0.
; If there is immunity in play, the move automatically misses.
	call BattleCheckTypeMatchup
	ld a, [wTypeMatchup]
	and a
	ld a, 10 ; 1.0
	jr nz, .reset
	call ResetDamage
	xor a
	ld [wTypeModifier], a
	inc a
	ld [wAttackMissed], a
	ret

.reset
	ld [wTypeMatchup], a
	ret

INCLUDE "engine/battle/ai/switch.asm"

INCLUDE "data/types/type_matchups.asm"

BattleCommand_DamageVariation:
; damagevariation

; Modify the damage spread between 85% and 100%.

; Because of the method of division the probability distribution
; is not consistent. This makes the highest damage multipliers
; rarer than normal.

; No point in reducing 1 or 0 damage.
	ld hl, wCurDamage
	ld a, [hli]
	and a
	jr nz, .go
	ld a, [hl]
	cp 2
	ret c

.go
; Start with the maximum damage.
	xor a
	ldh [hMultiplicand + 0], a
	dec hl
	ld a, [hli]
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a

; Multiply by 85-100%...
.loop
	call BattleRandom
	rrca
	cp 85 percent + 1
	jr c, .loop

	ldh [hMultiplier], a
	call Multiply

; ...divide by 100%...
	ld a, $ff ; 100%
	ldh [hDivisor], a
	ld b, $4
	call Divide

; ...to get .85-1.00x damage.
	ldh a, [hQuotient + 2]
	ld hl, wCurDamage
	ld [hli], a
	ldh a, [hQuotient + 3]
	ld [hl], a
	ret

BattleCommand_CheckHit:
; checkhit

	call .DreamEater
	jp z, .Miss

	call .Protect
	jp nz, .Miss

	call .LockOn
	ret nz

	call .FlyDigMoves
	jp nz, .Miss

	call .Toxic
	ret z

	call .ThunderRain
	ret z

; Skip the accuracy check if Foresight is active.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_IDENTIFIED, a
	ret nz

	; Perfect-accuracy moves
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ALWAYS_HIT
	ret z
	cp EFFECT_BIDE
	ret z
	cp EFFECT_FORCE_SWITCH
	ret z
	cp EFFECT_FORESIGHT
	ret z

	call .StatModifiers

	ld a, [wPlayerMoveStruct + MOVE_ACC]
	ld b, a
	ldh a, [hBattleTurn]
	and a
	jr z, .BrightPowder
	ld a, [wEnemyMoveStruct + MOVE_ACC]
	ld b, a

.BrightPowder:
	push bc
	call GetOpponentItem
	ld a, b
	cp HELD_BRIGHTPOWDER
	ld a, c ; % miss
	pop bc
	jr nz, .skip_brightpowder

	ld c, a
	ld a, b
	sub c
	ld b, a
	jr nc, .skip_brightpowder
	ld b, 0

.skip_brightpowder
	; If the user is a rock-type using a rock-type move, boost its accuracy by 16%.
	push bc
	ld a, ROCK
	call CheckIfUserIsGivenType
	ld a, c ; % hit
	pop bc
	jr nz, .skip_rockaccuracybonus

	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVarAddr
	ld [wCurType], a
	cp ROCK
	jr nz, .skip_rockaccuracybonus

	ld c, a
	ld a, b
	add c
	jr c, .skip_rockaccuracybonus
	ld b, a
	jr nc, .skip_rockaccuracybonus
	ld c, a
	ld b, 0

.skip_rockaccuracybonus
	; If a Butterfree is holding a [CHANGE THIS], boost its accuracy by 16%.
	
	ld a, [hli]
	ld l, [hl]
	ld h, a

	push hl
	ld a, MON_SPECIES
	call BattlePartyAttr
	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .Butterfree
	ld a, [wTempEnemyMonSpecies]
.Butterfree:
	pop hl
	cp BUTTERFREE
	jr z, .skip_butterfreeaccuracybonus

	push bc
	call GetUserItem
	ld a, [hl]
	pop bc
	cp GLOW_SCALES
	jr nz, .skip_butterfreeaccuracybonus

	ld c, a
	ld a, b
	add c
	jr c, .skip_butterfreeaccuracybonus
	add c
	jr c, .skip_butterfreeaccuracybonus
	add c
	jr c, .skip_butterfreeaccuracybonus
	add c
	jr c, .skip_butterfreeaccuracybonus
	ld b, a
	jr nc, .skip_butterfreeaccuracybonus
	ld c, a
	ld b, 0

.skip_butterfreeaccuracybonus
	ld a, b
	cp -1
	ret z

	call BattleRandom
	cp b
	ret c

.Miss:
	call ResetDamage
	ld a, 1
	ld [wAttackMissed], a
	ret

.DreamEater:
; Return z if we're trying to eat the dream of
; a monster that isn't sleeping.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_DREAM_EATER
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and SLP
	ret

.Protect:
; Return nz if the opponent is protected.
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	ret z

	ld c, 20
	call DelayFrames

; 'protecting itself!'
	ld hl, ProtectingItselfText
	call StdBattleTextBox

	ld c, 20
	call DelayFrames

	ld a, 1
	and a
	ret

.LockOn:
; Return nz if we are locked-on and aren't trying to use Earthquake or
; Fissure on a monster that is flying.
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_LOCK_ON, [hl]
	res SUBSTATUS_LOCK_ON, [hl]
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	jr z, .LockedOn

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp EARTHQUAKE
	ret z
	cp FISSURE
	ret z

.LockedOn:
	ld a, 1
	and a
	ret

.FlyDigMoves:
; Check for moves that can hit underground/flying opponents.
; Return z if the current move can hit the opponent.

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret z

	bit SUBSTATUS_FLYING, a
	jr z, .DigMoves

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	
	ld de, 1
	ld hl, FlyHitMoves
	push bc
	call IsInArray
	pop bc
	ret c

.DigMoves:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp EARTHQUAKE
	ret z
	cp FISSURE
	ret z

.Toxic:
; Return z if the user is a Poison-type.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_TOXIC
	ret nz

	ld a, POISON
	jp CheckIfUserIsGivenType

.ThunderRain:
; Return z if the current move always hits in rain, and it is raining.
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_HURRICANE
	jr z, .continue
	cp EFFECT_THUNDER
	ret nz

.continue
	ld a, [wBattleWeather]
	cp WEATHER_RAIN
	ret

.StatModifiers:
	ldh a, [hBattleTurn]
	and a

	; load the user's accuracy into b and the opponent's evasion into c.
	ld hl, wPlayerMoveStruct + MOVE_ACC
	ld a, [wPlayerAccLevel]
	ld b, a
	ld a, [wEnemyEvaLevel]
	ld c, a

	jr z, .got_acc_eva

	ld hl, wEnemyMoveStruct + MOVE_ACC
	ld a, [wEnemyAccLevel]
	ld b, a
	ld a, [wPlayerEvaLevel]
	ld c, a

.got_acc_eva
	; subtract evasion from 14
	ld a, MAX_STAT_LEVEL + 1
	sub c
	ld c, a
	; store the base move accuracy for math ops
	xor a
	ldh [hMultiplicand + 0], a
	ldh [hMultiplicand + 1], a
	ld a, [hl]
	ldh [hMultiplicand + 2], a
	push hl
	ld d, 2 ; do this twice, once for the user's accuracy and once for the target's evasion

.accuracy_loop
	; look up the multiplier from the table
	push bc
	ld hl, AccuracyLevelMultipliers
	dec b
	sla b
	ld c, b
	ld b, 0
	add hl, bc
	pop bc
	; multiply by the first byte in that row...
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
	; ... and divide by the second byte
	ld a, [hl]
	ldh [hDivisor], a
	ld b, 4
	call Divide
	; minimum accuracy is $0001
	ldh a, [hQuotient + 3]
	ld b, a
	ldh a, [hQuotient + 2]
	or b
	jr nz, .min_accuracy
	ldh [hQuotient + 2], a
	ld a, 1
	ldh [hQuotient + 3], a

.min_accuracy
	; do the same thing to the target's evasion
	ld b, c
	dec d
	jr nz, .accuracy_loop

	; if the result is more than 2 bytes, max out at 100%
	ldh a, [hQuotient + 2]
	and a
	ldh a, [hQuotient + 3]
	jr z, .finish_accuracy
	ld a, $ff

.finish_accuracy
	pop hl
	ld [hl], a
	ret

INCLUDE "data/battle/accuracy_multipliers.asm"

INCLUDE "data/moves/fly_hit_moves.asm"

BattleCommand_EffectChance:
; effectchance

	xor a
	ld [wEffectFailed], a
	call CheckSubstituteOpp
	jr nz, .failed

	push hl
	ld hl, wPlayerMoveStruct + MOVE_CHANCE
	ldh a, [hBattleTurn]
	and a
	jr z, .got_move_chance
	ld hl, wEnemyMoveStruct + MOVE_CHANCE
.got_move_chance

	ld a, [hl]
	sub 100 percent
	; If chance was 100%, RNG won't be called (carry not set)
	; Thus chance will be subtracted from 0, guaranteeing a carry
	call c, BattleRandom
	cp [hl]
	pop hl
	ret c

.failed
	ld a, 1
	ld [wEffectFailed], a
	and a
	ret

BattleCommand_LowerSub:
; lowersub

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret z

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CHARGED, a
	jr nz, .already_charged

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_RAZOR_WIND
	jr z, .charge_turn
	cp EFFECT_SKY_ATTACK
	jr z, .charge_turn
	cp EFFECT_SKULL_BASH
	jr z, .charge_turn
	cp EFFECT_SOLARBEAM
	jr z, .charge_turn
	cp EFFECT_FLY
	jr z, .charge_turn

.already_charged
	call .Rampage
	jr z, .charge_turn

	call CheckUserIsCharging
	ret nz

.charge_turn
	call _CheckBattleScene
	jr c, .mimic_anims

	xor a
	ld [wNumHits], a
	ld [wFXAnimID + 1], a
	inc a
	ld [wKickCounter], a
	ld a, SUBSTITUTE
	jp LoadAnim

.mimic_anims
	call BattleCommand_LowerSubNoAnim
	jp BattleCommand_MoveDelay

.Rampage:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ROLLOUT
	jr z, .rollout_rampage
	cp EFFECT_RAMPAGE
	jr z, .rollout_rampage

	ld a, 1
	and a
	ret

.rollout_rampage
	ld a, [wSomeoneIsRampaging]
	and a
	ld a, 0
	ld [wSomeoneIsRampaging], a
	ret

BattleCommand_MoveAnim:
; moveanim
	call BattleCommand_LowerSub
	call BattleCommand_MoveAnimNoSub
	jp BattleCommand_RaiseSub

BattleCommand_MoveAnimNoSub:
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	ldh a, [hBattleTurn]
	and a
	ld de, wPlayerRolloutCount
	ld a, BATTLEANIM_ENEMY_DAMAGE
	jr z, .got_rollout_count
	ld de, wEnemyRolloutCount
	ld a, BATTLEANIM_PLAYER_DAMAGE

.got_rollout_count
	ld [wNumHits], a
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	jr z, .alternate_anim
	cp EFFECT_PURSUIT
	jr z, .pursuit
	cp EFFECT_CONVERSION
	jr z, .alternate_anim
	cp EFFECT_DOUBLE_HIT
	jr z, .alternate_anim
	cp EFFECT_BONEMERANG
	jr z, .alternate_anim
	cp EFFECT_POISON_MULTI_HIT
	jr z, .alternate_anim
	cp EFFECT_THIEF
	jr z, .alternate_anim
	xor a
	ld [wKickCounter], a

.pursuit
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	call PlayFXAnimID

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .clear_sprite
	cp DIG
	ret nz
.clear_sprite
	jp AppearUserLowerSub

.alternate_anim
	ld a, [wKickCounter]
	and 1
	xor 1
	ld [wKickCounter], a
	ld a, [de]
	cp 1
	push af
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	pop af
	jp z, PlayFXAnimID
	xor a
	ld [wNumHits], a
	jp PlayFXAnimID

BattleCommand_StatUpAnim:
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	xor a
	jr BattleCommand_StatUpDownAnim

BattleCommand_StatDownAnim:
	ld a, [wAttackMissed]
	and a
	jp nz, BattleCommand_MoveDelay

	ldh a, [hBattleTurn]
	and a
	ld a, BATTLEANIM_ENEMY_STAT_DOWN
	jr z, BattleCommand_StatUpDownAnim
	ld a, BATTLEANIM_WOBBLE

	; fallthrough

BattleCommand_StatUpDownAnim:
	ld [wNumHits], a
	xor a
	ld [wKickCounter], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld e, a
	ld d, 0
	jp PlayFXAnimID

BattleCommand_SwitchTurn:
; switchturn

	ldh a, [hBattleTurn]
	xor 1
	ldh [hBattleTurn], a
	ret

BattleCommand_RaiseSub:
; raisesub

	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret z

	call _CheckBattleScene
	jp c, BattleCommand_RaiseSubNoAnim

	xor a
	ld [wNumHits], a
	ld [wFXAnimID + 1], a
	ld a, $2
	ld [wKickCounter], a
	ld a, SUBSTITUTE
	jp LoadAnim

BattleCommand_FailureText:
; failuretext
; If the move missed or failed, load the appropriate
; text, and end the effects of multi-turn or multi-
; hit moves.
	ld a, [wAttackMissed]
	and a
	ret z

	call GetFailureResultText
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr

	cp FLY
	jr z, .fly_dig
	cp DIG
	jr z, .fly_dig

; Move effect:
	inc hl
	ld a, [hl]

	cp EFFECT_MULTI_HIT
	jr z, .multihit
	cp EFFECT_DOUBLE_HIT
	jr z, .multihit
	cp EFFECT_BONEMERANG
	jr z, .multihit
	cp EFFECT_POISON_MULTI_HIT
	jp nz, EndMoveEffect

.multihit
	call BattleCommand_RaiseSub
	jp EndMoveEffect

.fly_dig
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	call AppearUserRaiseSub
	jp EndMoveEffect

BattleCommand_ApplyDamage:
; applydamage

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_BIDE, a
	jr nz, .bide
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_ENDURE, a
	jr z, .focus_sash
.bide
; A Pokemon using Bide cannot be knocked out by attacks.
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .damage
	ld b, 1
	jr .damage

.focus_sash
; Focus Sash does not activate if holder does not have max HP.
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	inc hl
	inc hl
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	cp b
	jr nz, .focus_band
	ld a, [hl]
	cp c
	jr nz, .focus_band

	call GetOpponentItem
	ld a, b
	cp HELD_FOCUS_SASH
	jp z, .activate

.focus_band
	call GetOpponentItem
	ld a, b
	cp HELD_FOCUS_BAND
	ld b, 0
	jr nz, .damage

.activate
	call BattleRandom
	cp c
	jr nc, .damage
	call BattleCommand_FalseSwipe
	ld b, 0
	jr nc, .damage
	ld b, 2

.damage
	push bc
	call .update_damage_taken
	ld c, FALSE
	ldh a, [hBattleTurn]
	and a
	jr nz, .damage_player
	call DoEnemyDamage
	jr .done_damage

.damage_player
	call DoPlayerDamage

.done_damage
	pop bc
	ld a, b
	and a
	ret z

	dec a
	jr nz, .focus_band_text
	ld hl, EnduredText
	jp StdBattleTextBox

.focus_band_text
	farcall ItemRecoveryAnim
	call GetOpponentItem
	ld a, [hl]
	ld [wNamedObjectIndexBuffer], a
	call GetItemName
	callfar ConsumeHeldItem
	ld hl, HungOnText
	jp StdBattleTextBox

.update_damage_taken
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz

	ld de, wPlayerDamageTaken + 1
	ldh a, [hBattleTurn]
	and a
	jr nz, .got_damage_taken
	ld de, wEnemyDamageTaken + 1

.got_damage_taken
	ld a, [wCurDamage + 1]
	ld b, a
	ld a, [de]
	add b
	ld [de], a
	dec de
	ld a, [wCurDamage]
	ld b, a
	ld a, [de]
	adc b
	ld [de], a
	ret nc
	ld a, $ff
	ld [de], a
	inc de
	ld [de], a
	ret	

GetFailureResultText:
	ld hl, DoesntAffectText
	ld de, DoesntAffectText
	ld a, [wTypeModifier]
	and $7f
	jr z, .got_text
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_FUTURE_SIGHT
	ld hl, ButItFailedText
	ld de, ItFailedText
	jr z, .got_text
	ld hl, AttackMissedText
	ld de, AttackMissed2Text
	ld a, [wCriticalHit]
	cp -1
	jr nz, .got_text
	ld hl, UnaffectedText
.got_text
	call FailText_CheckOpponentProtect
	xor a
	ld [wCriticalHit], a

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_JUMP_KICK
	ret nz

	ld a, [wTypeModifier]
	and $7f
	ret z

	ld hl, wCurDamage
	ld a, [hli]
	ld b, [hl]
rept 3
	srl a
	rr b
endr
	ld [hl], b
	dec hl
	ld [hli], a
	or b
	jr nz, .jump_kick_recoil
	inc a
	ld [hl], a
.jump_kick_recoil

; High Jump Kick reduces HP by 50% on a miss.
	ld hl, CrashedText
	call StdBattleTextBox

	call LoadMoveAnim
	
	callfar GetHalfMaxHP
	callfar SubtractHPFromUser
	jp UpdateUserInParty

FailText_CheckOpponentProtect:
	ld a, BATTLE_VARS_SUBSTATUS1_OPP
	call GetBattleVar
	bit SUBSTATUS_PROTECT, a
	jr z, .not_protected
	ld h, d
	ld l, e
.not_protected
	jp StdBattleTextBox

BattleCommand_BideFailText:
	ld a, [wAttackMissed]
	and a
	ret z

	call PrintButItFailed
	jp EndMoveEffect

BattleCommand_CriticalText:
; criticaltext
; Prints the message for critical hits or one-hit KOs.

; If there is no message to be printed, wait 20 frames.
	ld a, [wCriticalHit]
	and a
	ret z

	dec a
	add a
	ld hl, .texts
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call StdBattleTextBox

	xor a
	ld [wCriticalHit], a
	ret

.texts
	dw CriticalHitText
	dw OneHitKOText

BattleCommand_StartLoop:
; startloop

	ld hl, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyRolloutCount
.ok
	xor a
	ld [hl], a
	ret

BattleCommand_SuperEffectiveLoopText:
; supereffectivelooptext

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOOP, a
	ret nz

	; fallthrough

BattleCommand_SuperEffectiveText:
; supereffectivetext

	ld a, [wTypeModifier]
	and $7f
	cp 10 ; 1.0
	ret z
	ld hl, SuperEffectiveText
	jr nc, .print
	ld hl, NotVeryEffectiveText
.print
	jp StdBattleTextBox

BattleCommand_CheckFaint:
; checkfaint

; Faint the opponent if its HP reached zero
;  and faint the user along with it if it used Destiny Bond.
; Ends the move effect if the opponent faints.

	ld hl, wEnemyMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wBattleMonHP

.got_hp
	ld a, [hli]
	or [hl]
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVar
	bit SUBSTATUS_DESTINY_BOND, a
	jr z, .no_dbond

	ld hl, TookDownWithItText
	call StdBattleTextBox

	ldh a, [hBattleTurn]
	and a
	ld hl, wEnemyMonMaxHP + 1
	bccoord 2, 2 ; hp bar
	ld a, 0
	jr nz, .got_max_hp
	ld hl, wBattleMonMaxHP + 1
	bccoord 10, 9 ; hp bar
	ld a, 1

.got_max_hp
	ld [wWhichHPBar], a
	ld a, [hld]
	ld [wBuffer1], a
	ld a, [hld]
	ld [wBuffer2], a
	ld a, [hl]
	ld [wBuffer3], a
	xor a
	ld [hld], a
	ld a, [hl]
	ld [wBuffer4], a
	xor a
	ld [hl], a
	ld [wBuffer5], a
	ld [wBuffer6], a
	ld h, b
	ld l, c
	predef AnimateHPBar
	call RefreshBattleHuds

	call BattleCommand_SwitchTurn
	xor a
	ld [wNumHits], a
	ld [wFXAnimID + 1], a
	inc a
	ld [wKickCounter], a
	ld a, DESTINY_BOND
	call LoadAnim
	call BattleCommand_SwitchTurn

	jr .finish

.no_dbond
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_MULTI_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_DOUBLE_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_BONEMERANG
	jr z, .multiple_hit_raise_sub
	cp EFFECT_POISON_MULTI_HIT
	jr z, .multiple_hit_raise_sub
	cp EFFECT_HYPER_BEAM_RECHARGE
	jr nz, .finish

.multiple_hit_raise_sub
	call BattleCommand_RaiseSub

.finish
	jp EndMoveEffect

BattleCommand_BuildOpponentRage:
; buildopponentrage

	jp .start

.start
	ld a, [wAttackMissed]
	and a
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_RAGE, a
	ret z

	ld de, wEnemyRageCounter
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld de, wPlayerRageCounter
.player
	ld a, [de]
	inc a
	ret z
	ld [de], a

	call BattleCommand_SwitchTurn
	ld hl, RageBuildingText
	call StdBattleTextBox
	jp BattleCommand_SwitchTurn

BattleCommand_RageDamage:
; ragedamage

	ld a, [wCurDamage]
	ld h, a
	ld b, a
	ld a, [wCurDamage + 1]
	ld l, a
	ld c, a
	ldh a, [hBattleTurn]
	and a
	ld a, [wPlayerRageCounter]
	jr z, .rage_loop
	ld a, [wEnemyRageCounter]
.rage_loop
	and a
	jr z, .done
	dec a
	add hl, bc
	jr nc, .rage_loop
	ld hl, $ffff
.done
	ld a, h
	ld [wCurDamage], a
	ld a, l
	ld [wCurDamage + 1], a
	ret

EndMoveEffect:
	ld a, [wBattleScriptBufferAddress]
	ld l, a
	ld a, [wBattleScriptBufferAddress + 1]
	ld h, a
	ld a, $ff
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ret

DittoMetalPowder:
	ld a, MON_SPECIES
	call BattlePartyAttr
	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .Ditto
	ld a, [wTempEnemyMonSpecies]

.Ditto:
	cp DITTO
	ret nz

	push bc
	call GetOpponentItem
	ld a, [hl]
	cp METAL_POWDER
	pop bc
	ret nz

	ld a, c
	srl a
	add c
	ld c, a
	ret nc

	srl b
	ld a, b
	and a
	jr nz, .done
	inc b
.done
	scf
	rr c
	
	ld a, HIGH(MAX_STAT_VALUE)
	cp b
	jr c, .cap
	ret nz
	ld a, LOW(MAX_STAT_VALUE)
	cp c
	ret nc

.cap
	ld bc, MAX_STAT_VALUE
	ret

ParasectBigMushroom:
	ld a, MON_SPECIES
	call BattlePartyAttr
	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr nz, .Parasect
	ld a, [wTempEnemyMonSpecies]

.Parasect:
	cp PARASECT
	ret nz

	push bc
	call GetOpponentItem
	ld a, [hl]
	cp BIG_MUSHROOM
	pop bc
	ret nz

	sla a
	rl c
	ret nc

	srl b
	ld a, b
	and a
	jr nz, .done
	inc b
.done
	scf
	rr c
	ret

BattleCommand_DamageStats:
; damagestats

	ldh a, [hBattleTurn]
	and a
	jp nz, EnemyAttackDamage

	; fallthrough

PlayerAttackDamage:
; Return move power d, player level e, enemy defense c and player attack b.

	call ResetDamage

	ld hl, wPlayerMoveStructPower
	ld a, [hli]
	and a
	ld d, a
	ret z

	ld a, [hl]
	cp SPECIAL
	jr nc, .special

.physical
	call CheckBodyPress
	jr z, .skip_trick_mirror

	call CheckStatSwapItem
	jr z, .continuespecial

.skip_trick_mirror
	ld a, [wBattleMonSpecies]
	call CheckLightBuoy
	jr z, .continuespecial

.continuephysical
	ld hl, wEnemyMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wEnemyScreens]
	bit SCREENS_REFLECT, a
	jr z, .checkburn
	sla c
	rl b

.checkburn
	ld a, [wBattleMonStatus]
	and 1 << BRN
	jr z, .physicalcrit
	sla c
	rl b

.physicalcrit
	call CheckBodyPress
	jr z, .body_press

	ld hl, wBattleMonAttack
	call CheckDamageStatsCritical
	jr c, .thickclub

	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerAttack
	jr .thickclub

.body_press
	ld hl, wBattleMonDefense
	call CheckDamageStatsCritical
	jr c, .thickclub

	ld hl, wEnemyDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerDefense
	jr .thickclub

.special
	call CheckStatSwapItem
	jr z, .continuephysical

.checklightbuoy
	ld a, [wBattleMonSpecies]
	call CheckLightBuoy
	jr z, .continuephysical

.continuespecial
	ld hl, wEnemyMonSpclDef
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wEnemyScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .specialcrit
	sla c
	rl b

.specialcrit
	ld hl, wBattleMonSpclAtk
	call CheckDamageStatsCritical
	jr c, .lightball

	ld hl, wEnemySpDef
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wPlayerSpAtk

.lightball
; Note: Returns player special attack at hl in hl.
	call SpecialItemBoost
	jr .done

.thickclub
; Note: Returns player attack at hl in hl.
	call AttackItemBoost

.done
	call TruncateHL_BC

	ld a, [wBattleMonLevel]
	ld e, a
	call DittoMetalPowder
	call ParasectBigMushroom

	ld a, 1
	and a
	ret
	
CheckStatSwapItem:
	call GetUserItem
	ld a, b
	cp HELD_STAT_SWAP
	ret

CheckBodyPress:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_BODY_PRESS
	ret

CheckLightBuoy:
	cp MARILL
	jr z, .Marill
	cp AZUMARILL
	ret nz
.Marill
	call GetUserItem
	ld a, b
	cp HELD_LIGHT_BUOY
	ret

TruncateHL_BC:
.loop
; Truncate 16-bit values hl and bc to 8-bit values b and c respectively.
; b = hl, c = bc

	ld a, h
	or b
	jr z, .finish

	srl b
	rr c
	srl b
	rr c

	ld a, c
	or b
	jr nz, .done_bc
	inc c

.done_bc
	srl h
	rr l
	srl h
	rr l

	ld a, l
	or h
	jr nz, .finish
	inc l

.finish
; If we go back to the loop point,
; it's the same as doing this exact
; same check twice.
	ld a, h
	or b
	jr nz, .loop

.done
	ld b, l
	ret

CheckDamageStatsCritical:
; Return carry if boosted stats should be used in damage calculations.
; Unboosted stats should be used if the attack is a critical hit,
;  and the stage of the opponent's defense is higher than the user's attack.

	ld a, [wCriticalHit]
	and a
	scf
	ret z

	push hl
	push bc
	ldh a, [hBattleTurn]
	and a
	jr nz, .enemy
	ld a, [wPlayerMoveStructType]
	cp SPECIAL
; special
	ld a, [wPlayerSAtkLevel]
	ld b, a
	ld a, [wEnemySDefLevel]
	jr nc, .end
; physical
	ld a, [wPlayerAtkLevel]
	ld b, a
	ld a, [wEnemyDefLevel]
	jr .end

.enemy
	ld a, [wEnemyMoveStructType]
	cp SPECIAL
; special
	ld a, [wEnemySAtkLevel]
	ld b, a
	ld a, [wPlayerSDefLevel]
	jr nc, .end
; physical
	ld a, [wEnemyAtkLevel]
	ld b, a
	ld a, [wPlayerDefLevel]
.end
	cp b
	pop bc
	pop hl
	ret

AttackItemBoost:
; Return in hl the stat value at hl.

; If the attacking monster is Cubone or Marowak and
; it's holding a Thick Club, double it.
	push bc
	push de
	push hl
	ld a, MON_SPECIES
	call TrueUserPartyAttr
	pop hl
	cp PIKACHU
	lb bc, PIKACHU, PIKACHU
	ld d, LIGHT_BALL
	jr z, .ok
	cp SMEARGLE
	lb bc, SMEARGLE, SMEARGLE
	ld d, PALETTE
	jr z, .ok
	cp MARILL
	lb bc, MARILL, AZUMARILL
	ld d, LIGHT_BUOY
	jr z, .ok
	cp RAICHU
	lb bc, RAICHU, RAICHU
	ld d, LIGHT_BALL
	jr z, .light_ball
	lb bc, CUBONE, MAROWAK
	ld d, THICK_CLUB
.ok
	call SpeciesItemBoost
	pop de
	pop bc
	ret

.light_ball
	call LightBallItemBoost
	pop de
	pop bc
	ret

SpecialItemBoost:
; Return in hl the stat value at hl.

; If the attacking monster is Cubone or Marowak and
; it's holding a Thick Club, double it.
	push bc
	push de
	push hl
	ld a, MON_SPECIES
	call TrueUserPartyAttr
	pop hl
	cp SMEARGLE
	lb bc, SMEARGLE, SMEARGLE
	ld d, PALETTE
	jr z, .ok
	cp PIKACHU
	lb bc, PIKACHU, PIKACHU
	ld d, LIGHT_BALL
	jr z, .ok
	lb bc, RAICHU, RAICHU
	ld d, LIGHT_BALL
	call LightBallItemBoost
	pop de
	pop bc
	ret
.ok
	call SpeciesItemBoost
	pop de
	pop bc
	ret

SpeciesItemBoost:
; Return in hl the stat value at hl.

; If the attacking monster is species b or c and
; it's holding item d, double it.

	ld a, [hli]
	ld l, [hl]
	ld h, a

	push hl
	ld a, MON_SPECIES
	call TrueUserPartyAttr
	pop hl

	cp b
	jr z, .GetItemHeldEffect
	cp c
	ret nz

.GetItemHeldEffect:
	push hl
	call GetUserItem
	ld a, [hl]
	pop hl
	cp d
	ret nz

; Double the stat
	add hl, hl
	ret

LightBallItemBoost:
; Return in hl the stat value at hl.

; If the attacking monster is species b or c and
; it's holding item d, double it.

	ld a, [hli]
	ld l, [hl]
	ld h, a

	push hl
	ld a, MON_SPECIES
	call BattlePartyAttr

	ldh a, [hBattleTurn]
	and a
	ld a, [hl]
	jr z, .CompareSpecies
	ld a, [wTempEnemyMonSpecies]
.CompareSpecies:
	pop hl

	cp b
	jr z, .GetItemHeldEffect
	cp c
	ret nz

.GetItemHeldEffect:
	push hl
	call GetUserItem
	ld a, [hl]
	pop hl
	cp d
	ret nz

; Multiply the stat by 1.5
	ld a, l
	srl a
	add l
	ld l, a
	ret nc

	srl h
	ld a, h
	and a
	jr nz, .done
	inc h
.done
	scf
	rr l

	ld a, HIGH(MAX_STAT_VALUE)
	cp h
	jr c, .cap
	ld a, LOW(MAX_STAT_VALUE)
	cp l
	ret nc

.cap
	ld h, HIGH(MAX_STAT_VALUE)
	ld l, LOW(MAX_STAT_VALUE)
	ret

EnemyAttackDamage:
	call ResetDamage

; No damage dealt with 0 power.
	ld hl, wEnemyMoveStructPower
	ld a, [hli] ; hl = wEnemyMoveStructType
	ld d, a
	and a
	ret z

	ld a, [hl]
	cp SPECIAL
	jr nc, .Special

.physical
	call CheckBodyPress
	jr z, .skip_trick_mirror

	call CheckStatSwapItem
	jr z, .continuespecial

.skip_trick_mirror
	ld a, [wEnemyMonSpecies]
	call CheckLightBuoy
	jr z, .continuephysical

.continuephysical
	ld hl, wBattleMonDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wPlayerScreens]
	bit SCREENS_REFLECT, a
	jr z, .checkburn
	sla c
	rl b

.checkburn
	ld a, [wEnemyMonStatus]
	and 1 << BRN
	jr z, .physicalcrit
	sla c
	rl b

.physicalcrit
	call CheckBodyPress
	jr z, .body_press

	ld hl, wEnemyMonAttack
	call CheckDamageStatsCritical
	jr c, .thickclub

	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyAttack
	jr .thickclub

.body_press
	ld hl, wEnemyMonDefense
	call CheckDamageStatsCritical
	jr c, .thickclub

	ld hl, wPlayerDefense
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemyDefense
	jr .thickclub

.Special:
	call CheckStatSwapItem
	jr z, .continuephysical

	ld a, [wEnemyMonSpecies]
	call CheckLightBuoy
	jr z, .continuephysical

.continuespecial
	ld hl, wBattleMonSpclDef
	ld a, [hli]
	ld b, a
	ld c, [hl]

	ld a, [wPlayerScreens]
	bit SCREENS_LIGHT_SCREEN, a
	jr z, .specialcrit
	sla c
	rl b

.specialcrit
	ld hl, wEnemyMonSpclAtk
	call CheckDamageStatsCritical
	jr c, .lightball
	ld hl, wPlayerSpDef
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld hl, wEnemySpAtk

.lightball
	call SpecialItemBoost
	jr .done

.thickclub
	call AttackItemBoost

.done
	call TruncateHL_BC

	ld a, [wEnemyMonLevel]
	ld e, a
	call DittoMetalPowder
	call ParasectBigMushroom

	ld a, 1
	and a
	ret

BattleCommand_ClearMissDamage:
; clearmissdamage
	ld a, [wAttackMissed]
	and a
	ret z

	jp ResetDamage

HitSelfInConfusion:
	call ResetDamage
	ldh a, [hBattleTurn]
	and a
	ld hl, wBattleMonDefense
	ld de, wPlayerScreens
	ld a, [wBattleMonLevel]
	jr z, .got_it

	ld hl, wEnemyMonDefense
	ld de, wEnemyScreens
	ld a, [wEnemyMonLevel]
.got_it
	push af
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [de]
	bit SCREENS_REFLECT, a
	jr z, .mimic_screen

	sla c
	rl b
.mimic_screen
	dec hl
	dec hl
	dec hl
	ld a, [hli]
	ld l, [hl]
	ld h, a
	call TruncateHL_BC
	ld d, 40
	pop af
	ld e, a
	ld a, TRUE
	ldh [hIsConfusionDamage], a
	ret

BattleCommand_DamageCalc:
; damagecalc

; Return a damage value for move power d, player level e, enemy defense c and player attack b.

; Return 1 if successful, else 0.

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar

; Selfdestruct and Explosion halve defense.
	cp EFFECT_SELFDESTRUCT
	jr nz, .dont_selfdestruct

	srl c
	jr nz, .dont_selfdestruct
	inc c

.dont_selfdestruct

; Variable-hit moves and Conversion can have a power of 0.
	cp EFFECT_MULTI_HIT
	jr z, .skip_zero_damage_check

	cp EFFECT_CONVERSION
	jr z, .skip_zero_damage_check

; No damage if move power is 0.
	ld a, d
	and a
	ret z

.skip_zero_damage_check
	xor a ; Not confusion damage
	ldh [hIsConfusionDamage], a
	; fallthrough

ConfusionDamageCalc:
; Minimum defense value is 1.
	ld a, c
	and a
	jr nz, .not_dividing_by_zero
	ld c, 1
.not_dividing_by_zero

	xor a
	ld hl, hDividend
	ld [hli], a
	ld [hli], a
	ld [hl], a

; Level * 2
	ld a, e
	add a
	jr nc, .level_not_overflowing
	ld [hl], 1
.level_not_overflowing
	inc hl
	ld [hli], a

; / 5
	ld a, 5
	ld [hld], a
	push bc
	ld b, 4
	call Divide
	pop bc

; + 2
	inc [hl]
	inc [hl]

; * bp
	inc hl
	ld [hl], d
	call Multiply

; * Attack
	ld [hl], b
	call Multiply

; / Defense
	ld [hl], c
	ld b, 4
	call Divide

; / 50
	ld [hl], 50
	ld b, $4
	call Divide

; Item boosts

; Item boosts don't apply to confusion damage
	ldh a, [hIsConfusionDamage]
	and a
	jr nz, .DoneItem

	call GetUserItem

	ld a, b
	and a
	jr z, .DoneItem

	ld hl, TypeBoostItems

.NextItem:
	ld a, [hli]
	cp -1
	jr z, .DoneItem

; Item effect
	cp b
	ld a, [hli]
	jr nz, .NextItem

; Type
	ld b, a
	ld a, BATTLE_VARS_MOVE_TYPE
	call GetBattleVar
	cp b
	jr nz, .DoneItem

; * 100 + item effect amount
	ld a, c
	add 100
	ldh [hMultiplier], a
	call Multiply

; / 100
	ld a, 100
	ldh [hDivisor], a
	ld b, 4
	call Divide

.DoneItem:
; Critical hits
	call .CriticalMultiplier

; Update wCurDamage (capped at 997).
	ld hl, wCurDamage
	ld b, [hl]
	ldh a, [hProduct + 3]
	add b
	ldh [hProduct + 3], a
	jr nc, .dont_cap_1

	ldh a, [hProduct + 2]
	inc a
	ldh [hProduct + 2], a
	and a
	jr z, .Cap

.dont_cap_1
	ldh a, [hProduct]
	ld b, a
	ldh a, [hProduct + 1]
	or a
	jr nz, .Cap

	ldh a, [hProduct + 2]
	cp HIGH(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, .dont_cap_2

	cp HIGH(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE + 1) + 1
	jr nc, .Cap

	ldh a, [hProduct + 3]
	cp LOW(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE + 1)
	jr nc, .Cap

.dont_cap_2
	inc hl

	ldh a, [hProduct + 3]
	ld b, [hl]
	add b
	ld [hld], a

	ldh a, [hProduct + 2]
	ld b, [hl]
	adc b
	ld [hl], a
	jr c, .Cap

	ld a, [hl]
	cp HIGH(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, .dont_cap_3

	cp HIGH(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE + 1) + 1
	jr nc, .Cap

	inc hl
	ld a, [hld]
	cp LOW(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE + 1)
	jr c, .dont_cap_3

.Cap:
	ld a, HIGH(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE)
	ld [hli], a
	ld a, LOW(MAX_STAT_VALUE - MIN_NEUTRAL_DAMAGE)
	ld [hld], a

.dont_cap_3
; Minimum neutral damage is 2 (bringing the cap to 999).
	inc hl
	ld a, [hl]
	add MIN_NEUTRAL_DAMAGE
	ld [hld], a
	jr nc, .dont_floor
	inc [hl]
.dont_floor

	ld a, 1
	and a
	ret

.CriticalMultiplier:
	ld a, [wCriticalHit]
	and a
	ret z

; x2
	ldh a, [hQuotient + 3]
	add a
	ldh [hProduct + 3], a

	ldh a, [hQuotient + 2]
	rl a
	ldh [hProduct + 2], a

; Cap at $ffff.
	ret nc

	ld a, $ff
	ldh [hProduct + 2], a
	ldh [hProduct + 3], a

	ret

INCLUDE "data/types/type_boost_items.asm"

BattleCommand_ConstantDamage:
; constantdamage

	ld a, [wAttackMissed]
	and a
	ret nz
	farcall ConstantDamage
	ret
	
BattleCommand_PayDay:
; payday

	ld a, [wAttackMissed]
	and a
	ret nz
	farcall PayDayEffect
	ret

BattleCommand_FalseSwipe:
; falseswipe

	ld a, [wAttackMissed]
	and a
	ret nz
	farcall FalseSwipeEffect
	ret

BattleCommand_ClearHazards:
; clearhazards

	ld a, [wAttackMissed]
	and a
	ret nz
	farcall RapidSpinEffect
	ret

BattleCommand_HappinessPower:
; happinesspower

	ld a, [wAttackMissed]
	and a
	ret nz
	farcall ReturnEffect
	ret

BattleCommand_Safeguard:
; safeguard

	ld hl, wPlayerScreens
	ld de, wPlayerSafeguardCount
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wEnemyScreens
	ld de, wEnemySafeguardCount
.ok
	bit SCREENS_SAFEGUARD, [hl]
	jP nz, BattleEffect_ButItFailed
	set SCREENS_SAFEGUARD, [hl]
	ld a, 5
	ld [de], a
	call AnimateCurrentMove
	ld hl, CoveredByVeilText
	jp StdBattleTextBox

INCLUDE "engine/battle/move_effects/counter_mirror_coat.asm"

INCLUDE "engine/battle/move_effects/encore.asm"

INCLUDE "engine/battle/move_effects/pain_split.asm"

INCLUDE "engine/battle/move_effects/snore.asm"

INCLUDE "engine/battle/move_effects/conversion2.asm"

INCLUDE "engine/battle/move_effects/lock_on.asm"

INCLUDE "engine/battle/move_effects/sketch.asm"

INCLUDE "engine/battle/move_effects/sleep_talk.asm"

INCLUDE "engine/battle/move_effects/destiny_bond.asm"

INCLUDE "engine/battle/move_effects/spite.asm"

INCLUDE "engine/battle/move_effects/heal_bell.asm"

INCLUDE "engine/battle/move_effects/brick_break.asm"

FarPlayBattleAnimation:
; play animation de

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	ret nz

	; fallthrough

PlayFXAnimID:
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a

	ld c, 3
	call DelayFrames
	callfar PlayBattleAnim
	ret

DoEnemyDamage:
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, .did_no_damage

	ld a, c
	and a
	jr nz, .ignore_substitute
	ld a, [wEnemySubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jp nz, DoSubstituteDamage

.ignore_substitute
	; Substract wCurDamage from wEnemyMonHP.
	;  store original HP in little endian wBuffer3/4
	ld a, [hld]
	ld b, a
	ld a, [wEnemyMonHP + 1]
	ld [wBuffer3], a
	sub b
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld b, a
	ld a, [wEnemyMonHP]
	ld [wBuffer4], a
	sbc b
	ld [wEnemyMonHP], a
	jr nc, .no_underflow

	ld a, [wBuffer4]
	ld [hli], a
	ld a, [wBuffer3]
	ld [hl], a
	xor a
	ld hl, wEnemyMonHP
	ld [hli], a
	ld [hl], a

.no_underflow
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld [wBuffer2], a
	ld a, [hl]
	ld [wBuffer1], a
	ld hl, wEnemyMonHP
	ld a, [hli]
	ld [wBuffer6], a
	ld a, [hl]
	ld [wBuffer5], a

	hlcoord 2, 2
	xor a
	ld [wWhichHPBar], a
	predef AnimateHPBar
.did_no_damage
	jp RefreshBattleHuds

DoPlayerDamage:
	ld hl, wCurDamage
	ld a, [hli]
	ld b, a
	ld a, [hl]
	or b
	jr z, .did_no_damage

	ld a, c
	and a
	jr nz, .ignore_substitute
	ld a, [wPlayerSubStatus4]
	bit SUBSTATUS_SUBSTITUTE, a
	jp nz, DoSubstituteDamage

.ignore_substitute
	; Substract wCurDamage from wBattleMonHP.
	;  store original HP in little endian wBuffer3/4
	;  store new HP in little endian wBuffer5/6
	ld a, [hld]
	ld b, a
	ld a, [wBattleMonHP + 1]
	ld [wBuffer3], a
	sub b
	ld [wBattleMonHP + 1], a
	ld [wBuffer5], a
	ld b, [hl]
	ld a, [wBattleMonHP]
	ld [wBuffer4], a
	sbc b
	ld [wBattleMonHP], a
	ld [wBuffer6], a
	jr nc, .no_underflow

	ld a, [wBuffer4]
	ld [hli], a
	ld a, [wBuffer3]
	ld [hl], a
	xor a
	ld hl, wBattleMonHP
	ld [hli], a
	ld [hl], a
	ld hl, wBuffer5
	ld [hli], a
	ld [hl], a

.no_underflow
	ld hl, wBattleMonMaxHP
	ld a, [hli]
	ld [wBuffer2], a
	ld a, [hl]
	ld [wBuffer1], a

	hlcoord 10, 9
	ld a, 1
	ld [wWhichHPBar], a
	predef AnimateHPBar
.did_no_damage
	jp RefreshBattleHuds

DoSubstituteDamage:
	ld hl, SubTookDamageText
	call StdBattleTextBox

	ld de, wEnemySubstituteHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld de, wPlayerSubstituteHP
.got_hp

	ld hl, wCurDamage
	ld a, [hli]
	and a
	jr nz, .broke

	ld a, [de]
	sub [hl]
	ld [de], a
	jr z, .broke
	jr nc, .done

.broke
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_SUBSTITUTE, [hl]

	ld hl, SubFadedText
	call StdBattleTextBox

	call BattleCommand_SwitchTurn
	call BattleCommand_LowerSubNoAnim
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	call z, AppearUserLowerSub
	call BattleCommand_SwitchTurn

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	cp EFFECT_MULTI_HIT
	jr z, .ok
	cp EFFECT_DOUBLE_HIT
	jr z, .ok
	cp EFFECT_BONEMERANG
	jr z, .ok
	cp EFFECT_POISON_MULTI_HIT
	jr z, .ok
	cp EFFECT_LEECH_HIT
	jr z, .drainsub
	xor a
	ld [hl], a
.ok
	call RefreshBattleHuds
.done
	jp ResetDamage

.drainsub
	jp EndMoveEffect

UpdateMoveData:
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVarAddr
	ld d, h
	ld e, l

	ld a, BATTLE_VARS_MOVE
	call GetBattleVar
	ld [wCurSpecies], a
	ld [wNamedObjectIndexBuffer], a

	dec a
	call GetMoveData
	call GetMoveName
	jp CopyName1

BattleCommand_SleepTarget:
; sleeptarget

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	ld d, h
	ld e, l
	ld a, [de]
	and SLP
	ld hl, AlreadyAsleepText
	jr nz, .fail

	ld a, [wTypeModifier]
	and $7f
	jp z, BattleEffect_DoesntAffect

	ld a, [wAttackMissed]
	and a
	jp nz, PrintDidntAffect2

	ld hl, DidntAffect1Text

	ld a, [de]
	and a
	jr nz, .fail

	call CheckSubstituteOpp
	jr nz, .fail

	call AnimateCurrentMove
	ld b, $3

.random_loop
	call BattleRandom
	and b
	jr z, .random_loop
	cp 7
	jr z, .random_loop
	inc a
	ld [de], a
	call UpdateOpponentInParty
	call RefreshBattleHuds

	ld hl, FellAsleepText
	call StdBattleTextBox

	farcall UseHeldStatusHealingItem

	jp z, OpponentCantMove
	ret

.fail
	push hl
	call AnimateFailedMove
	pop hl
	jp StdBattleTextBox

BattleCommand_PoisonTarget:
; poisontarget

	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [wTypeModifier]
	and $7f
	ret z
	ld a, POISON
	call CheckIfTargetIsGivenType
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	farcall SafeCheckSafeguard
	ret nz

	call PoisonOpponent
	ld de, ANIM_PSN
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasPoisonedText
	call StdBattleTextBox

	farcall UseHeldStatusHealingItem
	ret

BattleCommand_Poison:
; poison

	ld hl, DoesntAffectText
	ld a, [wTypeModifier]
	and $7f
	jp z, .failed
	ld a, POISON
	call CheckIfTargetIsGivenType
	jp z, .failed
	ld a, STEEL
	call CheckIfTargetIsGivenType
	jp z, .failed

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	ld b, a
	ld hl, AlreadyPoisonedText
	and 1 << PSN | 1 << TOX
	jp nz, .failed

	ld hl, DidntAffect1Text
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and a
	jr nz, .failed

	call CheckSubstituteOpp
	jr nz, .failed
	ld a, [wAttackMissed]
	and a
	jr nz, .failed
	call .check_toxic
	jr z, .toxic

	call .apply_poison
	ld hl, WasPoisonedText
	call StdBattleTextBox
	jr .finished

.toxic
	set SUBSTATUS_TOXIC, [hl]
	xor a
	ld [de], a
	call .apply_bad_poison

	ld hl, BadlyPoisonedText
	call StdBattleTextBox

.finished
	farcall UseHeldStatusHealingItem
	ret

.failed
	push hl
	call AnimateFailedMove
	pop hl
	jp StdBattleTextBox

.apply_poison
	call AnimateCurrentMove
	call PoisonOpponent
	jp RefreshBattleHuds
	
.apply_bad_poison
	call AnimateCurrentMove
	call BadlyPoisonOpponent
	jp RefreshBattleHuds

.check_toxic
	ld a, BATTLE_VARS_SUBSTATUS5_OPP
	call GetBattleVarAddr
	ldh a, [hBattleTurn]
	and a
	ld de, wEnemyToxicCount
	jr z, .ok
	ld de, wPlayerToxicCount
.ok
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_TOXIC
	ret

BattleCore_CheckGhostType:
	ld a, GHOST
	jr CheckIfTargetIsGivenType
BattleCore_CheckPosionType:
	ld a, POISON
CheckIfTargetIsGivenType:
	ld b, a
	ld de, wEnemyMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wBattleMonType1
.ok
	ld a, [de]
	inc de
	cp b
	ret z
	ld a, [de]
	cp b
	ret

CheckIfUserIsGivenType:
	ld b, a
	ld de, wBattleMonType1
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wEnemyMonType1
.ok
	ld a, [de]
	inc de
	cp b
	ret z
	ld a, [de]
	cp b
	ret

PoisonOpponent:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PSN, [hl]
	jp UpdateOpponentInParty

BadlyPoisonOpponent:
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set TOX, [hl]
	jp UpdateOpponentInParty

BattleCommand_DrainTarget:
; draintarget
	call CheckSubstituteOpp
	jp nz, EndMoveEffect

	farcall SapHealth
	ld hl, SuckedHealthText
	jp StdBattleTextBox

BattleCommand_EatDream:
; eatdream
	call CheckSubstituteOpp
	jp nz, EndMoveEffect

	farcall SapHealth
	ld hl, DreamEatenText
	jp StdBattleTextBox

BattleCommand_BurnTarget:
; burntarget

	xor a
	ld [wNumHits], a
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jp nz, Defrost
	ld a, [wTypeModifier]
	and $7f
	ret z
	ld a, FIRE
	call CheckIfTargetIsGivenType ; Don't burn a Fire-type
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	farcall SafeCheckSafeguard
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateOpponentInParty
	ld de, ANIM_BRN
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasBurnedText
	call StdBattleTextBox

	farcall UseHeldStatusHealingItem
	ret

Defrost:
	ld a, [hl]
	and 1 << FRZ
	ret z

	xor a
	ld [hl], a

	ldh a, [hBattleTurn]
	and a
	ld a, [wCurOTMon]
	ld hl, wOTPartyMon1Status
	jr z, .ok
	ld hl, wPartyMon1Status
	ld a, [wCurBattleMon]
.ok

	call GetPartyLocation
	xor a
	ld [hl], a
	call UpdateOpponentInParty

	ld hl, DefrostedOpponentText
	jp StdBattleTextBox

BattleCommand_FreezeTarget:
; freezetarget

	xor a
	ld [wNumHits], a
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [wTypeModifier]
	and $7f
	ret z
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	ret z
	ld a, ICE
	call CheckIfTargetIsGivenType ; Don't freeze an Ice-type
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	farcall SafeCheckSafeguard
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set FRZ, [hl]
	call UpdateOpponentInParty
	ld de, ANIM_FRZ
	call PlayOpponentBattleAnim
	call RefreshBattleHuds

	ld hl, WasFrozenText
	call StdBattleTextBox

	farcall UseHeldStatusHealingItem
	ret nz

	call OpponentCantMove
	call EndRechargeOpp
	ld hl, wEnemyJustGotFrozen
	ldh a, [hBattleTurn]
	and a
	jr z, .finish
	ld hl, wPlayerJustGotFrozen
.finish
	ld [hl], $1
	ret

BattleCommand_ParalyzeTarget:
; paralyzetarget

	xor a
	ld [wNumHits], a
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	ret nz
	ld a, [wTypeModifier]
	and $7f
	ret z
	ld a, ELECTRIC
	call CheckIfTargetIsGivenType
	ret z
	ld a, [wEffectFailed]
	and a
	ret nz
	farcall SafeCheckSafeguard
	ret nz
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	ld hl, ApplyPrzEffectOnSpeed
	call CallBattleCore
	ld de, ANIM_PAR
	call PlayOpponentBattleAnim
	call RefreshBattleHuds
	call PrintParalyze
	ld hl, UseHeldStatusHealingItem
	jp CallBattleCore

BattleCommand_AttackUp:
; attackup
	ld b, ATTACK
	jr BattleCommand_StatUp

BattleCommand_DefenseUp:
; defenseup
	ld b, DEFENSE
	jr BattleCommand_StatUp

BattleCommand_SpeedUp:
; speedup
	ld b, SPEED
	jr BattleCommand_StatUp

BattleCommand_SpecialAttackUp:
; specialattackup
	ld b, SP_ATTACK
	jr BattleCommand_StatUp

BattleCommand_SpecialDefenseUp:
; specialdefenseup
	ld b, SP_DEFENSE
	jr BattleCommand_StatUp

BattleCommand_AccuracyUp:
; accuracyup
	ld b, ACCURACY
	jr BattleCommand_StatUp

BattleCommand_EvasionUp:
; evasionup
	ld b, EVASION
	jr BattleCommand_StatUp

BattleCommand_AttackUp2:
; attackup2
	ld b, $10 | ATTACK
	jr BattleCommand_StatUp

BattleCommand_DefenseUp2:
; defenseup2
	ld b, $10 | DEFENSE
	jr BattleCommand_StatUp

BattleCommand_SpeedUp2:
; speedup2
	ld b, $10 | SPEED
	jr BattleCommand_StatUp

BattleCommand_SpecialAttackUp2:
; specialattackup2
	ld b, $10 | SP_ATTACK
	jr BattleCommand_StatUp

BattleCommand_SpecialDefenseUp2:
; specialdefenseup2
	ld b, $10 | SP_DEFENSE
	jr BattleCommand_StatUp

BattleCommand_AccuracyUp2:
; accuracyup2
	ld b, $10 | ACCURACY
	jr BattleCommand_StatUp

BattleCommand_EvasionUp2:
; evasionup2
	ld b, $10 | EVASION
	jr BattleCommand_StatUp
	
BattleCommand_GrowthAttack:
; growthattack
	ld b, $10 | ATTACK
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	jr z, BattleCommand_StatUp
	ld b, ATTACK
	jr BattleCommand_StatUp

BattleCommand_GrowthSpecial:
; growthspecial
	ld b, $10 | SP_ATTACK
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	jr z, BattleCommand_StatUp
	ld b, SP_ATTACK
	; fallthrough

BattleCommand_StatUp:
; statup
	call RaiseStat
	ld a, [wFailedMessage]
	and a
	ret nz
	jp MinimizeDropSub

RaiseStat:
	ld a, b
	ld [wLoweredStat], a
	ld hl, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .got_stat_levels
	ld hl, wEnemyStatLevels
.got_stat_levels
	ld a, [wAttackMissed]
	and a
	jp nz, .stat_raise_failed
	ld a, [wEffectFailed]
	and a
	jp nz, .stat_raise_failed
	ld a, [wLoweredStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	inc b
	ld a, $d
	cp b
	jp c, .cant_raise_stat
	ld a, [wLoweredStat]
	and $f0
	jr z, .got_num_stages
	inc b
	ld a, $d
	cp b
	jr nc, .got_num_stages
	ld b, a
.got_num_stages
	ld [hl], b
	push hl
	ld a, c
	cp $5
	jr nc, .done_calcing_stats
	ld hl, wBattleMonStats + 1
	ld de, wPlayerStats
	ldh a, [hBattleTurn]
	and a
	jr z, .got_stats_pointer
	ld hl, wEnemyMonStats + 1
	ld de, wEnemyStats
.got_stats_pointer
	push bc
	sla c
	ld b, 0
	add hl, bc
	ld a, c
	add e
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	pop bc
	ld a, [hld]
	sub LOW(MAX_STAT_VALUE)
	jr nz, .not_already_max
	ld a, [hl]
	sbc HIGH(MAX_STAT_VALUE)
	jp z, .stats_already_max
.not_already_max
	ldh a, [hBattleTurn]
	and a
	jr z, .calc_player_stats
	call CalcEnemyStats
	jr .done_calcing_stats

.calc_player_stats
	call CalcPlayerStats
.done_calcing_stats
	pop hl
	xor a
	ld [wFailedMessage], a
	ret

.stats_already_max
	pop hl
	dec [hl]
	; fallthrough

.cant_raise_stat
	ld a, $2
	ld [wFailedMessage], a
	ld a, $1
	ld [wAttackMissed], a
	ret

.stat_raise_failed
	ld a, $1
	ld [wFailedMessage], a
	ret

MinimizeDropSub:
; Lower the substitute if we're minimizing

	ld bc, wPlayerMinimized
	ld hl, DropPlayerSub
	ldh a, [hBattleTurn]
	and a
	jr z, .do_player
	ld bc, wEnemyMinimized
	ld hl, DropEnemySub
.do_player
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp MINIMIZE
	ret nz

	ld a, $1
	ld [bc], a
	call _CheckBattleScene
	ret nc

	xor a
	ldh [hBGMapMode], a
	call CallBattleCore
	call WaitBGMap
	jp BattleCommand_MoveDelay

BattleCommand_AttackDown:
; attackdown
	ld a, ATTACK
	jr BattleCommand_StatDown

BattleCommand_DefenseDown:
; defensedown
	ld a, DEFENSE
	jr BattleCommand_StatDown

BattleCommand_SpeedDown:
; speeddown
	ld a, SPEED
	jr BattleCommand_StatDown

BattleCommand_SpecialAttackDown:
; specialattackdown
	ld a, SP_ATTACK
	jr BattleCommand_StatDown

BattleCommand_SpecialDefenseDown:
; specialdefensedown
	ld a, SP_DEFENSE
	jr BattleCommand_StatDown

BattleCommand_AccuracyDown:
; accuracydown
	ld a, ACCURACY
	jr BattleCommand_StatDown

BattleCommand_EvasionDown:
; evasiondown
	ld a, EVASION
	jr BattleCommand_StatDown

BattleCommand_AttackDown2:
; attackdown2
	ld a, $10 | ATTACK
	jr BattleCommand_StatDown

BattleCommand_DefenseDown2:
; defensedown2
	ld a, $10 | DEFENSE
	jr BattleCommand_StatDown

BattleCommand_SpeedDown2:
; speeddown2
	ld a, $10 | SPEED
	jr BattleCommand_StatDown

BattleCommand_SpecialAttackDown2:
; specialattackdown2
	ld a, $10 | SP_ATTACK
	jr BattleCommand_StatDown

BattleCommand_SpecialDefenseDown2:
; specialdefensedown2
	ld a, $10 | SP_DEFENSE
	jr BattleCommand_StatDown

BattleCommand_AccuracyDown2:
; accuracydown2
	ld a, $10 | ACCURACY
	jr BattleCommand_StatDown

BattleCommand_EvasionDown2:
; evasiondown2
	ld a, $10 | EVASION

BattleCommand_StatDown:
; statdown

	ld [wLoweredStat], a

	call CheckMist
	jp nz, .Mist

	ld hl, wEnemyStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .GetStatLevel
	ld hl, wPlayerStatLevels

.GetStatLevel:
; Attempt to lower the stat.
	ld a, [wLoweredStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	dec b
	jp z, .CantLower

; Sharply lower the stat if applicable.
	ld a, [wLoweredStat]
	and $f0
	jr z, .GotAmountToLower
	dec b
	jr nz, .GotAmountToLower
	inc b

.GotAmountToLower:
	call CheckSubstituteOpp
	jr nz, .Failed

	ld a, [wAttackMissed]
	and a
	jr nz, .Failed

	ld a, [wEffectFailed]
	and a
	jr nz, .Failed

	call CheckHiddenOpponent
	jr nz, .Failed

; Accuracy/Evasion reduction don't involve stats.
	ld [hl], b
	ld a, c
	cp ACCURACY
	jr nc, .Hit

	push hl
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyStats
	ldh a, [hBattleTurn]
	and a
	jr z, .do_enemy
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerStats
.do_enemy
	call TryLowerStat
	pop hl
	jr z, .CouldntLower

.Hit:
	xor a
	ld [wFailedMessage], a
	ret

.CouldntLower:
	inc [hl]
.CantLower:
	ld a, 3
	ld [wFailedMessage], a
	ld a, 1
	ld [wAttackMissed], a
	ret

.Failed:
	ld a, 1
	ld [wFailedMessage], a
	ld [wAttackMissed], a
	ret

.Mist:
	ld a, 2
	ld [wFailedMessage], a
	ld a, 1
	ld [wAttackMissed], a
	ret

CheckMist:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ATTACK_DOWN
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN + 1
	jr c, .check_mist
	cp EFFECT_ATTACK_DOWN_2
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN_2 + 1
	jr c, .check_mist
	cp EFFECT_ATTACK_DOWN_HIT
	jr c, .dont_check_mist
	cp EFFECT_EVASION_DOWN_HIT + 1
	jr c, .check_mist
.dont_check_mist
	xor a
	ret

.check_mist
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_MIST, a
	ret

BattleCommand_StatUpMessage:
	ld a, [wFailedMessage]
	and a
	ret nz

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_ALL_UP_HIT
	jr z, .allstats

	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, .stat
	jp BattleTextBox

.stat
	text_far UnknownText_0x1c0cc6
	text_asm
	ld hl, .up
	ld a, [wLoweredStat]
	and $f0
	ret z
	ld hl, .wayup
	ret

.wayup
	text_far UnknownText_0x1c0cd0
	text_end

.up
	text_far UnknownText_0x1c0ce0
	text_end

.allstats
	ld hl, BattleText_AllStatsRose
	jp StdBattleTextBox

BattleCommand_StatDownMessage:
	ld a, [wFailedMessage]
	and a
	ret nz
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, .stat
	jp BattleTextBox

.stat
	text_far UnknownText_0x1c0ceb
	text_asm
	ld hl, .fell
	ld a, [wLoweredStat]
	and $f0
	ret z
	ld hl, .sharplyfell
	ret

.sharplyfell
	text_far UnknownText_0x1c0cf5
	text_end

.fell
	text_far UnknownText_0x1c0d06
	text_end

TryLowerStat:
; Lower stat c from stat struct hl (buffer de).

	push bc
	sla c
	ld b, 0
	add hl, bc
	; add de, c
	ld a, c
	add e
	ld e, a
	jr nc, .no_carry
	inc d
.no_carry
	pop bc

; The lowest possible stat is 1.
	ld a, [hld]
	sub 1
	jr nz, .not_min
	ld a, [hl]
	and a
	ret z

.not_min
	ldh a, [hBattleTurn]
	and a
	jr z, .Player

	call BattleCommand_SwitchTurn
	call CalcPlayerStats
	call BattleCommand_SwitchTurn
	jr .end

.Player:
	call BattleCommand_SwitchTurn
	call CalcEnemyStats
	call BattleCommand_SwitchTurn
.end
	ld a, 1
	and a
	ret

BattleCommand_StatUpFailText:
; statupfailtext
	ld a, [wFailedMessage]
	and a
	ret z
	push af
	call BattleCommand_MoveDelay
	pop af
	dec a
	jp z, TryPrintButItFailed
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, WontRiseAnymoreText
	jp StdBattleTextBox

BattleCommand_StatDownFailText:
; statdownfailtext
	ld a, [wFailedMessage]
	and a
	ret z
	push af
	call BattleCommand_MoveDelay
	pop af
	dec a
	jp z, TryPrintButItFailed
	dec a
	ld hl, ProtectedByMistText
	jp z, StdBattleTextBox
	ld a, [wLoweredStat]
	and $f
	ld b, a
	inc b
	call GetStatName
	ld hl, WontDropAnymoreText
	jp StdBattleTextBox

GetStatName:
	ld hl, StatNames
	ld c, "@"
.CheckName:
	dec b
	jr z, .Copy
.GetName:
	ld a, [hli]
	cp c
	jr z, .CheckName
	jr .GetName

.Copy:
	ld de, wStringBuffer2
	ld bc, wStringBuffer3 - wStringBuffer2
	jp CopyBytes

INCLUDE "data/battle/stat_names.asm"

INCLUDE "data/battle/stat_multipliers.asm"

BattleCommand_AllStatsUp:
; allstatsup

; Attack
	call ResetMiss
	call BattleCommand_AttackUp

; Defense
	call ResetMiss
	call BattleCommand_DefenseUp

; Special Attack
	call ResetMiss
	call BattleCommand_SpecialAttackUp

; Special Defense
	call ResetMiss
	call BattleCommand_SpecialDefenseUp

; Speed
	call ResetMiss
	call BattleCommand_SpeedUp
	jp   BattleCommand_StatUpMessage
	
BattleCommand_LegendaryStatsBoost:
; allstatsup

; Attack
	call BattleCommand_AttackUp2
	call BattleCommand_AttackUp2

; Defense
	call BattleCommand_DefenseUp2
	call BattleCommand_DefenseUp2
	call BattleCommand_DefenseUp2

; Special Attack
	call BattleCommand_SpecialAttackUp2
	call BattleCommand_SpecialAttackUp2

; Special Defense
	call BattleCommand_SpecialDefenseUp2
	call BattleCommand_SpecialDefenseUp2
	call BattleCommand_SpecialDefenseUp2

; Speed
	call BattleCommand_SpeedUp2

ResetMiss:
	xor a
	ld [wAttackMissed], a
	ret

LowerStat:
	ld [wLoweredStat], a

	ld hl, wPlayerStatLevels
	ldh a, [hBattleTurn]
	and a
	jr z, .got_target
	ld hl, wEnemyStatLevels

.got_target
	ld a, [wLoweredStat]
	and $f
	ld c, a
	ld b, 0
	add hl, bc
	ld b, [hl]
	dec b
	jr z, .cant_lower_anymore

	ld a, [wLoweredStat]
	and $f0
	jr z, .got_num_stages
	dec b
	jr nz, .got_num_stages
	inc b

.got_num_stages
	ld [hl], b
	ld a, c
	cp 5
	jr nc, .accuracy_evasion

	push hl
	ld hl, wBattleMonStats + 1
	ld de, wPlayerStats
	ldh a, [hBattleTurn]
	and a
	jr z, .got_target_2
	ld hl, wEnemyMonStats + 1
	ld de, wEnemyStats

.got_target_2
	call TryLowerStat
	pop hl
	jr z, .failed

.accuracy_evasion
	ldh a, [hBattleTurn]
	and a
	jr z, .player

	call CalcEnemyStats

	jr .finish

.player
	call CalcPlayerStats

.finish
	xor a
	ld [wFailedMessage], a
	ret

.failed
	inc [hl]

.cant_lower_anymore
	ld a, 2
	ld [wFailedMessage], a
	ret

BattleCommand_TriStatusChance:
; tristatuschance

	call BattleCommand_EffectChance

.loop
	; 1/3 chance of each status
	call BattleRandom
	swap a
	and %11
	jr z, .loop
	dec a
	ld hl, .ptrs
	rst JumpTable
	ret

.ptrs
	dw BattleCommand_ParalyzeTarget ; paralyze
	dw BattleCommand_FreezeTarget ; freeze
	dw BattleCommand_BurnTarget ; burn

BattleCommand_Curl:
; curl
	ld a, BATTLE_VARS_SUBSTATUS2
	call GetBattleVarAddr
	set SUBSTATUS_CURLED, [hl]
	ret

BattleCommand_RaiseSubNoAnim:
	ld hl, GetBattleMonBackpic
	ldh a, [hBattleTurn]
	and a
	jr z, .PlayerTurn
	ld hl, GetEnemyMonFrontpic
.PlayerTurn:
	xor a
	ldh [hBGMapMode], a
	call CallBattleCore
	jp WaitBGMap

BattleCommand_LowerSubNoAnim:
	ld hl, DropPlayerSub
	ldh a, [hBattleTurn]
	and a
	jr z, .PlayerTurn
	ld hl, DropEnemySub
.PlayerTurn:
	xor a
	ldh [hBGMapMode], a
	call CallBattleCore
	jp WaitBGMap

CalcPlayerStats:
	ld hl, wPlayerAtkLevel
	ld de, wPlayerStats
	ld bc, wBattleMonAttack

	ld a, 5
	call CalcBattleStats

	call BattleCommand_SwitchTurn

	ld hl, ApplyPrzEffectOnSpeed
	call CallBattleCore

	jp BattleCommand_SwitchTurn

CalcEnemyStats:
	ld hl, wEnemyAtkLevel
	ld de, wEnemyStats
	ld bc, wEnemyMonAttack

	ld a, 5
	call CalcBattleStats

	call BattleCommand_SwitchTurn

	ld hl, ApplyPrzEffectOnSpeed
	call CallBattleCore

	jp BattleCommand_SwitchTurn

CalcBattleStats:
.loop
	push af
	ld a, [hli]
	push hl
	push bc

	ld c, a
	dec c
	ld b, 0
	ld hl, StatLevelMultipliers
	add hl, bc
	add hl, bc

	xor a
	ldh [hMultiplicand + 0], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	inc de

	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply

	ld a, [hl]
	ldh [hDivisor], a
	ld b, 4
	call Divide

	ldh a, [hQuotient + 2]
	ld b, a
	ldh a, [hQuotient + 3]
	or b
	jr nz, .check_maxed_out

	ld a, 1
	ldh [hQuotient + 3], a
	jr .not_maxed_out

.check_maxed_out
	ldh a, [hQuotient + 3]
	cp LOW(MAX_STAT_VALUE)
	ld a, b
	sbc HIGH(MAX_STAT_VALUE)
	jr c, .not_maxed_out

	ld a, LOW(MAX_STAT_VALUE)
	ldh [hQuotient + 3], a
	ld a, HIGH(MAX_STAT_VALUE)
	ldh [hQuotient + 2], a

.not_maxed_out
	pop bc
	ldh a, [hQuotient + 2]
	ld [bc], a
	inc bc
	ldh a, [hQuotient + 3]
	ld [bc], a
	inc bc
	pop hl
	pop af
	dec a
	jr nz, .loop

	ret

INCLUDE "engine/battle/move_effects/bide.asm"

BattleCommand_CheckRampage:
; checkrampage

	ld de, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld de, wEnemyRolloutCount
.player
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_RAMPAGE, [hl]
	ret z
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .continue_rampage

	res SUBSTATUS_RAMPAGE, [hl]

	set SUBSTATUS_CONFUSED, [hl]
	call BattleRandom
	and %00000001
	inc a
	inc a
	inc de ; ConfuseCount
	ld [de], a
.continue_rampage
	ld b, rampage_command
	jp SkipToBattleCommand

BattleCommand_Rampage:
; rampage

; No rampage during Sleep Talk.
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	ret nz

	ld de, wPlayerRolloutCount
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wEnemyRolloutCount
.ok
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_RAMPAGE, [hl]
; Rampage for 1 or 2 more turns
	call BattleRandom
	and %00000001
	inc a
	ld [de], a
	ld a, 1
	ld [wSomeoneIsRampaging], a
	ret

INCLUDE "engine/battle/move_effects/teleport.asm"

SetBattleDraw:
	ld a, [wBattleResult]
	and BATTLERESULT_BITMASK
	or DRAW
	ld [wBattleResult], a
	ret

BattleCommand_ForceSwitch:
; forceswitch

	ld a, [wBattleType]
	cp BATTLETYPE_SHINY
	jp z, .fail
	cp BATTLETYPE_TRAP
	jp z, .fail
	cp BATTLETYPE_BOSS
	jp z, .fail
	ldh a, [hBattleTurn]
	and a
	jp nz, .force_player_switch
	ld a, [wAttackMissed]
	and a
	jr nz, .missed
	ld a, [wBattleMode]
	dec a
	jr nz, .trainer
	ld a, [wCurPartyLevel]
	ld b, a
	ld a, [wBattleMonLevel]
	cp b
	jr nc, .wild_force_flee
	add b
	ld c, a
	inc c
.random_loop_wild
	call BattleRandom
	cp c
	jr nc, .random_loop_wild
	srl b
	srl b
	cp b
	jr nc, .wild_force_flee
.missed
	jp .fail

.wild_force_flee
	call UpdateBattleMonInParty
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	call SetBattleDraw
	ld a, [wPlayerMoveStructAnimation]
	jp .succeed

.trainer
	call FindAliveEnemyMons
	jr c, .switch_fail
	ld a, [wEnemyGoesFirst]
	and a
	jr z, .switch_fail
	call UpdateEnemyMonInParty
	ld a, $1
	ld [wKickCounter], a
	call AnimateCurrentMove
	ld c, $14
	call DelayFrames
	hlcoord 1, 0
	lb bc, 4, 10
	call ClearBox
	ld c, 20
	call DelayFrames
	ld a, [wOTPartyCount]
	ld b, a
	ld a, [wCurOTMon]
	ld c, a
; select a random enemy mon to switch to
.random_loop_trainer
	call BattleRandom
	and $7
	cp b
	jr nc, .random_loop_trainer
	cp c
	jr z, .random_loop_trainer
	push af
	push bc
	ld hl, wOTPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	pop de
	jr z, .random_loop_trainer
	ld a, d
	inc a
	ld [wEnemySwitchMonIndex], a
	callfar ForceEnemySwitch

	ld hl, DraggedOutText
	call StdBattleTextBox

	ld hl, SpikesDamage
	jp CallBattleCore

.switch_fail
	jp .fail

.force_player_switch
	ld a, [wAttackMissed]
	and a
	jr nz, .player_miss

	ld a, [wBattleMode]
	dec a
	jr nz, .vs_trainer

	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wCurPartyLevel]
	cp b
	jr nc, .wild_succeed_playeristarget

	add b
	ld c, a
	inc c
.wild_random_loop_playeristarget
	call BattleRandom
	cp c
	jr nc, .wild_random_loop_playeristarget

	srl b
	srl b
	cp b
	jr nc, .wild_succeed_playeristarget

.player_miss
	jr .fail

.wild_succeed_playeristarget
	call UpdateBattleMonInParty
	xor a
	ld [wNumHits], a
	inc a
	ld [wForcedSwitch], a
	call SetBattleDraw
	ld a, [wEnemyMoveStructAnimation]
	jr .succeed

.vs_trainer
	call CheckPlayerHasMonToSwitchTo
	jr c, .fail

	ld a, [wEnemyGoesFirst]
	cp $1
	jr z, .switch_fail

	call UpdateBattleMonInParty
	ld a, $1
	ld [wKickCounter], a
	call AnimateCurrentMove
	ld c, 20
	call DelayFrames
	hlcoord 9, 7
	lb bc, 5, 11
	call ClearBox
	ld c, 20
	call DelayFrames
	ld a, [wPartyCount]
	ld b, a
	ld a, [wCurBattleMon]
	ld c, a
.random_loop_trainer_playeristarget
	call BattleRandom
	and $7
	cp b
	jr nc, .random_loop_trainer_playeristarget

	cp c
	jr z, .random_loop_trainer_playeristarget

	push af
	push bc
	ld hl, wPartyMon1HP
	call GetPartyLocation
	ld a, [hli]
	or [hl]
	pop bc
	pop de
	jr z, .random_loop_trainer_playeristarget

	ld a, d
	ld [wCurPartyMon], a
	ld hl, SwitchPlayerMon
	call CallBattleCore

	ld hl, DraggedOutText
	call StdBattleTextBox

	ld hl, SpikesDamage
	jp CallBattleCore

.fail
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSub
	jp PrintButItFailed

.succeed
	push af
	call SetBattleDraw
	ld a, $1
	ld [wKickCounter], a
	call AnimateCurrentMove
	ld c, 20
	call DelayFrames
	pop af

	ld hl, FledInFearText
	cp ROAR
	jr z, .do_text
	ld hl, BlownAwayText
.do_text
	jp StdBattleTextBox

CheckPlayerHasMonToSwitchTo:
	ld a, [wPartyCount]
	ld d, a
	ld e, 0
	ld bc, PARTYMON_STRUCT_LENGTH
.loop
	ld a, [wCurBattleMon]
	cp e
	jr z, .next

	ld a, e
	ld hl, wPartyMon1HP
	call AddNTimes
	ld a, [hli]
	or [hl]
	jr nz, .not_fainted

.next
	inc e
	dec d
	jr nz, .loop

	scf
	ret

.not_fainted
	and a
	ret

BattleCommand_EndLoop:
; endloop

; Loop back to 'critical'.

	ld de, wPlayerRolloutCount
	ld bc, wPlayerDamageTaken
	ldh a, [hBattleTurn]
	and a
	jr z, .got_addrs
	ld de, wEnemyRolloutCount
	ld bc, wEnemyDamageTaken
.got_addrs

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_IN_LOOP, [hl]
	jp nz, .in_loop
	set SUBSTATUS_IN_LOOP, [hl]
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld a, [hl]
	cp EFFECT_POISON_MULTI_HIT
	jr z, .twineedle
	cp EFFECT_DOUBLE_HIT
	ld a, 1
	jr z, .double_hit
	ld a, [hl]
	cp EFFECT_BONEMERANG
	ld a, 1
	jr z, .double_hit
	ld a, [hl]

	push bc
	call GetUserItem
	ld a, b
	cp HELD_SKILL_BELT
	pop bc
	ld a, 4
	jr z, .double_hit

	call BattleRandom
	and $3
	cp 2
	jr c, .got_number_hits
	call BattleRandom
	and $3
.got_number_hits
	inc a
.double_hit
	ld [de], a
	inc a
	ld [bc], a
	jr .loop_back_to_critical

.twineedle
	ld a, 1
	jr .double_hit

.in_loop
	ld a, [de]
	dec a
	ld [de], a
	jr nz, .loop_back_to_critical
.done_loop
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	res SUBSTATUS_IN_LOOP, [hl]

	ld hl, PlayerHitTimesText
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hit_n_times_text
	ld hl, EnemyHitTimesText
.got_hit_n_times_text

	push bc
	call StdBattleTextBox

	pop bc
	xor a
	ld [bc], a
	ret

.loop_back_to_critical
	ld a, [wBattleScriptBufferAddress + 1]
	ld h, a
	ld a, [wBattleScriptBufferAddress]
	ld l, a
.not_critical
	ld a, [hld]
	cp critical_command
	jr nz, .not_critical
	inc hl
	ld a, h
	ld [wBattleScriptBufferAddress + 1], a
	ld a, l
	ld [wBattleScriptBufferAddress], a
	ret

BattleCommand_FlinchTarget:
	call CheckSubstituteOpp
	ret nz

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	and 1 << FRZ | SLP
	ret nz

	call CheckOpponentWentFirst
	ret nz

	ld a, [wEffectFailed]
	and a
	ret nz

	; fallthrough

FlinchTarget:
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_FLINCHED, [hl]
	jp EndRechargeOpp

CheckOpponentWentFirst:
; Returns a=0, z if user went first
; Returns a=1, nz if opponent went first
	push bc
	ld a, [wEnemyGoesFirst] ; 0 if player went first
	ld b, a
	ldh a, [hBattleTurn] ; 0 if it's the player's turn
	xor b ; 1 if opponent went first
	pop bc
	ret

BattleCommand_HeldFlinch:
; kingsrock

	ld a, [wAttackMissed]
	and a
	ret nz

	call GetUserItem
	ld a, b
	cp HELD_FLINCH
	ret nz

	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVarAddr
	ld d, h
	ld e, l
	call GetUserItem
	call BattleRandom
	cp c
	ret nc
	call EndRechargeOpp
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	set SUBSTATUS_FLINCHED, [hl]
	ret

BattleCommand_OHKO:
; ohko

	call ResetDamage
	ld a, [wTypeModifier]
	and $7f
	jr z, .no_effect
	ld hl, wEnemyMonLevel
	ld de, wBattleMonLevel
	ld bc, wPlayerMoveStruct + MOVE_ACC
	ldh a, [hBattleTurn]
	and a
	jr z, .got_move_accuracy
	push hl
	ld h, d
	ld l, e
	pop de
	ld bc, wEnemyMoveStruct + MOVE_ACC
.got_move_accuracy
	ld a, [de]
	sub [hl]
	jr c, .no_effect
	add a
	ld e, a
	ld a, [bc]
	add e
	jr nc, .finish_ohko
	ld a, $ff
.finish_ohko
	ld [bc], a
	call BattleCommand_CheckHit
	ld hl, wCurDamage
	ld a, $ff
	ld [hli], a
	ld [hl], a
	ld a, $2
	ld [wCriticalHit], a
	ret

.no_effect
	ld a, $ff
	ld [wCriticalHit], a
	ld a, $1
	ld [wAttackMissed], a
	ret

BattleCommand_CheckCharge:
; checkcharge

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	bit SUBSTATUS_CHARGED, [hl]
	ret z
	res SUBSTATUS_CHARGED, [hl]
	res SUBSTATUS_UNDERGROUND, [hl]
	res SUBSTATUS_FLYING, [hl]
	ld b, charge_command
	jp SkipToBattleCommand

BattleCommand_Charge:
; charge

	call BattleCommand_ClearText
	ld a, BATTLE_VARS_STATUS
	call GetBattleVar
	and SLP
	jr z, .awake

	call BattleCommand_MoveDelay
	call BattleCommand_RaiseSub
	call PrintButItFailed
	jp EndMoveEffect

.awake
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	set SUBSTATUS_CHARGED, [hl]

	ld hl, IgnoredOrders2Text
	ld a, [wAlreadyDisobeyed]
	and a
	call nz, StdBattleTextBox

	call BattleCommand_LowerSub
	xor a
	ld [wNumHits], a
	inc a
	ld [wKickCounter], a
	call LoadMoveAnim
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	cp FLY
	jr z, .flying
	cp DIG
	jr z, .flying
	call BattleCommand_RaiseSub
	jr .not_flying

.flying
	call DisappearUser
.not_flying
	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVarAddr
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	cp FLY
	jr z, .set_flying
	cp DIG
	jr nz, .dont_set_digging
	set SUBSTATUS_UNDERGROUND, [hl]
	jr .dont_set_digging

.set_flying
	set SUBSTATUS_FLYING, [hl]

.dont_set_digging
	call CheckUserIsCharging
	jr nz, .mimic
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	ld [hl], b
	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	ld [hl], b

.mimic
	call ResetDamage

	ld hl, .UsedText
	call BattleTextBox

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_SKULL_BASH
	ld b, endturn_command
	jp z, ._SkullBash
	jp EndMoveEffect
	
._SkullBash:
	call BattleCommand_DefenseUp
	call BattleCommand_StatUpMessage
	ld hl, wStringBuffer2
	ld [hl], "<S_BASH>"
	inc hl
	ld [hl], "@"
	jp EndMoveEffect

.UsedText:
	text_far UnknownText_0x1c0d0e ; "<USER>"
	text_asm
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar

	cp SOLARBEAM
	ld hl, .Solarbeam
	jr z, .done

	cp SKULL_BASH
	ld hl, .SkullBash
	jr z, .done

	cp FLY
	ld hl, .Fly
	jr z, .done

	cp DIG
	ld hl, .Dig

.done
	ret

.Solarbeam:
; 'took in sunlight!'
	text_far UnknownText_0x1c0d26
	text_end

.SkullBash:
; 'lowered its head!'
	text_far UnknownText_0x1c0d3a
	text_end

.Fly:
; 'flew up high!'
	text_far UnknownText_0x1c0d5c
	text_end

.Dig:
; 'dug a hole!'
	text_far UnknownText_0x1c0d6c
	text_end

BattleCommand_TrapTarget:
; traptarget

	ld a, [wAttackMissed]
	and a
	ret nz
	ld hl, wEnemyWrapCount
	ld de, wEnemyTrappingMove
	ldh a, [hBattleTurn]
	and a
	jr z, .got_trap
	ld hl, wPlayerWrapCount
	ld de, wPlayerTrappingMove

.got_trap
	ld a, [hl]
	and a
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret nz
	call BattleRandom
	; trapped for 2-5 turns
	and %11
	inc a
	inc a
	inc a
	ld [hl], a
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld [de], a
	ld b, a
	ld hl, .Traps

.find_trap_text
	ld a, [hli]
	cp b
	jr z, .found_trap_text
	inc hl
	inc hl
	jr .find_trap_text

.found_trap_text
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp StdBattleTextBox

.Traps:
	dbw BIND,      UsedBindText		; 'used BIND on'
	dbw WRAP,      WrappedByText	; 'was WRAPPED by'
	dbw FIRE_SPIN, WasTrappedText	; 'was trapped!'
	dbw WHIRLPOOL, WasTrappedText	; 'was trapped!'

INCLUDE "engine/battle/move_effects/mist.asm"

INCLUDE "engine/battle/move_effects/focus_energy.asm"

BattleCommand_Recoil:
; recoil

	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld hl, wEnemyMonMaxHP
.got_hp
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld d, a
	inc a
	jp z, .StruggleRecoil

; Crash Helmet held item reduces recoil damage.
	push hl
	call GetUserItem
	ld a, b
	cp HELD_CRASH_HELMET
	pop hl
	jr nz, .normal_recoil_damage

; get 1/4 damage or 1 HP, whichever is higher
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	call HalveBC
	call HalveBC
	jr .min_damage
	
.normal_recoil_damage
; get 1/2 damage or 1 HP, whichever is higher
	ld a, [wCurDamage]
	ld b, a
	ld a, [wCurDamage + 1]
	ld c, a
	call HalveBC

.min_damage
	call FloorBC
	ld a, [hli]
	ld [wBuffer2], a
	ld a, [hl]
	ld [wBuffer1], a
	dec hl
	dec hl
	ld a, [hl]
	ld [wBuffer3], a
	sub c
	ld [hld], a
	ld [wBuffer5], a
	ld a, [hl]
	ld [wBuffer4], a
	sbc b
	ld [hl], a
	ld [wBuffer6], a
	jr nc, .dont_ko
	xor a
	ld [hli], a
	ld [hl], a
	ld hl, wBuffer5
	ld [hli], a
	ld [hl], a
.dont_ko
	hlcoord 10, 9
	ldh a, [hBattleTurn]
	and a
	ld a, 1
	jr z, .animate_hp_bar
	hlcoord 2, 2
	xor a
.animate_hp_bar
	ld [wWhichHPBar], a
	predef AnimateHPBar
	call RefreshBattleHuds
	ld hl, RecoilText
	jp StdBattleTextBox

.StruggleRecoil
	; Struggle always deals 1/4 max HP to the user.
	callfar GetQuarterMaxHP
	callfar SubtractHPFromUser
	jr .animate_hp_bar

BattleCommand_ConfuseTarget:
; confusetarget

	ld a, [wEffectFailed]
	and a
	ret nz
	farcall SafeCheckSafeguard
	ret nz
	call CheckSubstituteOpp
	ret nz
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CONFUSED, [hl]
	ret nz
	jr BattleCommand_FinishConfusingTarget

BattleCommand_Confuse:
; confuse

	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVarAddr
	bit SUBSTATUS_CONFUSED, [hl]
	jr z, .not_already_confused
	call AnimateFailedMove
	ld hl, AlreadyConfusedText
	jp StdBattleTextBox

.not_already_confused
	call CheckSubstituteOpp
	jr nz, BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit
	ld a, [wAttackMissed]
	and a
	jr nz, BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit
BattleCommand_FinishConfusingTarget:
	ld bc, wEnemyConfuseCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_confuse_count
	ld bc, wPlayerConfuseCount

.got_confuse_count
	set SUBSTATUS_CONFUSED, [hl]
	; confused for 2-5 turns
	call BattleRandom
	and %11
	inc a
	inc a
	ld [bc], a

	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_CONFUSE_HIT
	jr z, .got_effect
	cp EFFECT_SNORE
	jr z, .got_effect
	cp EFFECT_SWAGGER
	jr z, .got_effect
	cp EFFECT_HURRICANE
	jr z, .got_effect
	call AnimateCurrentMove

.got_effect
	ld de, ANIM_CONFUSED
	call PlayOpponentBattleAnim

	ld hl, BecameConfusedText
	call StdBattleTextBox

	call GetOpponentItem
	ld a, b
	cp HELD_HEAL_STATUS
	jr z, .heal_confusion
	cp HELD_HEAL_CONFUSION
	ret nz
.heal_confusion
	ld hl, UseConfusionHealingItem
	jp CallBattleCore

BattleCommand_Confuse_CheckSnore_Swagger_ConfuseHit:
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_CONFUSE_HIT
	ret z
	cp EFFECT_SNORE
	ret z
	cp EFFECT_SWAGGER
	ret z
	jp PrintDidntAffect2

BattleCommand_Paralyze:
; paralyze

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	bit PAR, a
	jr nz, .paralyzed
	ld a, [wTypeModifier]
	and $7f
	jp z, BattleEffect_DoesntAffect
	ld a, ELECTRIC
	call CheckIfTargetIsGivenType
	jp z, BattleEffect_DoesntAffect

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jp nz, PrintDidntAffect2
	ld a, [wAttackMissed]
	and a
	jp nz, PrintDidntAffect2
	call CheckSubstituteOpp
	jp nz, PrintDidntAffect2
	ld c, 30
	call DelayFrames
	call AnimateCurrentMove
	ld a, $1
	ldh [hBGMapMode], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set PAR, [hl]
	call UpdateOpponentInParty
	ld hl, ApplyPrzEffectOnSpeed
	call CallBattleCore
	call UpdateBattleHuds
	call PrintParalyze
	ld hl, UseHeldStatusHealingItem
	jp CallBattleCore

.paralyzed
	call AnimateFailedMove
	ld hl, AlreadyParalyzedText
	jp StdBattleTextBox

.didnt_affect
	call AnimateFailedMove
	jp PrintDoesntAffect

BattleCommand_Burn:
; burn

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVar
	bit BRN, a
	jr nz, .burned
	ld a, [wTypeModifier]
	and $7f
	jp z, BattleEffect_DoesntAffect
	ld a, FIRE
	call CheckIfTargetIsGivenType
	jp z, BattleEffect_DoesntAffect

	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	and a
	jp nz, PrintDidntAffect2
	ld a, [wAttackMissed]
	and a
	jp nz, PrintDidntAffect2
	call CheckSubstituteOpp
	jp nz, PrintDidntAffect2
	ld c, 30
	call DelayFrames
	call AnimateCurrentMove
	ld a, $1
	ldh [hBGMapMode], a
	ld a, BATTLE_VARS_STATUS_OPP
	call GetBattleVarAddr
	set BRN, [hl]
	call UpdateOpponentInParty
	ld de, ANIM_BRN
	call PlayOpponentBattleAnim
	call UpdateBattleHuds
	call PrintBurn
	ld hl, UseHeldStatusHealingItem
	jp CallBattleCore

.burned
	call AnimateFailedMove
	ld hl, AlreadyBurnedText
	jp StdBattleTextBox

INCLUDE "engine/battle/move_effects/substitute.asm"

BattleCommand_RechargeNextTurn:
; rechargenextturn
	farcall BattleCommand_CheckFaint
	ret c
	ld a, BATTLE_VARS_SUBSTATUS4
	call GetBattleVarAddr
	set SUBSTATUS_RECHARGE, [hl]
	ret

EndRechargeOpp:
	push hl
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVarAddr
	res SUBSTATUS_RECHARGE, [hl]
	pop hl
	ret

INCLUDE "engine/battle/move_effects/rage.asm"

BattleCommand_DoubleFlyingDamage:
; doubleflyingdamage
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_FLYING, a
	ret z
	jr DoubleDamage

BattleCommand_DoubleUndergroundDamage:
; doubleundergrounddamage
	ld a, BATTLE_VARS_SUBSTATUS3_OPP
	call GetBattleVar
	bit SUBSTATUS_UNDERGROUND, a
	ret z

	; fallthrough

DoubleDamage:
	ld hl, wCurDamage + 1
	sla [hl]
	dec hl
	rl [hl]
	jr nc, .quit

	ld a, $ff
	ld [hli], a
	ld [hl], a
.quit
	ret

INCLUDE "engine/battle/move_effects/mimic.asm"

INCLUDE "engine/battle/move_effects/leech_seed.asm"

INCLUDE "engine/battle/move_effects/splash.asm"

INCLUDE "engine/battle/move_effects/disable.asm"

INCLUDE "engine/battle/move_effects/conversion.asm"

BattleCommand_ResetStats:
; resetstats
	ld a, 7 ; neutral
	ld hl, wPlayerStatLevels
	call .Fill
	ld hl, wEnemyStatLevels
	call .Fill
	ldh a, [hBattleTurn]
	push af
	call SetPlayerTurn
	call CalcPlayerStats
	call SetEnemyTurn
	call CalcEnemyStats
	pop af
	ldh [hBattleTurn], a
	call AnimateCurrentMove
	ld hl, EliminatedStatsText
	jp StdBattleTextBox
.Fill:
	ld b, wPlayerStatLevelsEnd - wPlayerStatLevels
.next
	ld [hli], a
	dec b
	jr nz, .next
	ret

BattleCommand_Heal:
; heal

	ld de, wBattleMonHP
	ld hl, wBattleMonMaxHP
	ldh a, [hBattleTurn]
	and a
	jr z, .got_hp
	ld de, wEnemyMonHP
	ld hl, wEnemyMonMaxHP
.got_hp
	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	ld b, a
	push hl
	push de
	push bc
	ld c, 2
	call CompareBytes
	pop bc
	pop de
	pop hl
	jp z, .hp_full
	ld a, b
	cp REST
	jr nz, .not_rest

	push hl
	push de
	push af
	call BattleCommand_MoveDelay
	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	res SUBSTATUS_TOXIC, [hl]
	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	ld a, [hl]
	and a
	ld [hl], REST_SLEEP_TURNS + 1
	ld hl, WentToSleepText
	jr z, .no_status_to_heal
	ld hl, RestedText
.no_status_to_heal
	call StdBattleTextBox
	ldh a, [hBattleTurn]
	and a
	jr nz, .calc_enemy_stats
	call CalcPlayerStats
	jr .got_stats

.calc_enemy_stats
	call CalcEnemyStats
.got_stats
	pop af
	pop de
	pop hl

.not_rest
	jr z, .restore_full_hp
	ld hl, GetHalfMaxHP
	call CallBattleCore
	jr .finish

.restore_full_hp
	ld hl, GetMaxHP
	call CallBattleCore
.finish
	call AnimateCurrentMove
	call BattleCommand_SwitchTurn
	ld hl, RestoreHP
	call CallBattleCore
	call BattleCommand_SwitchTurn
	call UpdateUserInParty
	call RefreshBattleHuds
	ld hl, RegainedHealthText
	jp StdBattleTextBox

.hp_full
	call AnimateFailedMove
	ld hl, HPIsFullText
	jp StdBattleTextBox

INCLUDE "engine/battle/move_effects/transform.asm"

BattleEffect_ButItFailed:
	call AnimateFailedMove
	jp PrintButItFailed

BattleEffect_DoesntAffect:
	call AnimateFailedMove
	jp PrintDoesntAffect

ClearLastMove:
	ld a, BATTLE_VARS_LAST_COUNTER_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a

	ld a, BATTLE_VARS_LAST_MOVE
	call GetBattleVarAddr
	xor a
	ld [hl], a
	ret

ResetActorDisable:
	ldh a, [hBattleTurn]
	and a
	jr z, .player

	xor a
	ld [wEnemyDisableCount], a
	ld [wEnemyDisabledMove], a
	ret

.player
	xor a
	ld [wPlayerDisableCount], a
	ld [wDisabledMove], a
	ret

BattleCommand_Screen:
; screen

	ld hl, wPlayerScreens
	ld bc, wPlayerLightScreenCount
	ldh a, [hBattleTurn]
	and a
	jr z, .got_screens_pointer
	ld hl, wEnemyScreens
	ld bc, wEnemyLightScreenCount

.got_screens_pointer
	ld a, BATTLE_VARS_MOVE_EFFECT
	call GetBattleVar
	cp EFFECT_LIGHT_SCREEN
	jr nz, .Reflect

	bit SCREENS_LIGHT_SCREEN, [hl]
	jp nz, .failed
	set SCREENS_LIGHT_SCREEN, [hl]

	call CheckLightClay

	ld [bc], a
	ld hl, LightScreenEffectText
	jr .good

.Reflect:
	bit SCREENS_REFLECT, [hl]
	jp nz, .failed
	set SCREENS_REFLECT, [hl]

	; LightScreenCount -> ReflectCount
	inc bc

	call CheckLightClay

	ld [bc], a
	ld hl, ReflectEffectText

.good
	call AnimateCurrentMove
	jp StdBattleTextBox

.failed
	call AnimateFailedMove
	jp PrintButItFailed

CheckLightClay:
	push bc
	call GetUserItem
	ld a, b
	cp HELD_LIGHT_CLAY
	ld a, 5
	jr nz, .no_clay
	ld a, 8
.no_clay
	pop bc
	ret

PrintDoesntAffect:
; 'it doesn't affect'
	ld hl, DoesntAffectText
	jp StdBattleTextBox

PrintNothingHappened:
; 'but nothing happened!'
	ld hl, NothingHappenedText
	jp StdBattleTextBox

TryPrintButItFailed:
	ld a, [wAlreadyFailed]
	and a
	ret nz

	; fallthrough

PrintButItFailed:
; 'but it failed!'
	ld hl, ButItFailedText
	jp StdBattleTextBox

FailMove:
	call AnimateFailedMove
	; fallthrough

FailMimic:
	ld hl, ButItFailedText ; 'but it failed!'
	ld de, ItFailedText    ; 'it failed!'
	jp FailText_CheckOpponentProtect

PrintDidntAffect:
; 'it didn't affect'
	ld hl, DidntAffect1Text
	jp StdBattleTextBox

PrintDidntAffect2:
	call AnimateFailedMove
	ld hl, DidntAffect1Text ; 'it didn't affect'
	ld de, DidntAffect2Text ; 'it didn't affect'
	jp FailText_CheckOpponentProtect

PrintParalyze:
; 'paralyzed! maybe it can't attack!'
	ld hl, ParalyzedText
	jp StdBattleTextBox
	
PrintBurn:
	ld hl, WasBurnedText
	jp StdBattleTextBox

CheckSubstituteOpp:
	ld a, BATTLE_VARS_SUBSTATUS4_OPP
	call GetBattleVar
	bit SUBSTATUS_SUBSTITUTE, a
	ret

INCLUDE "engine/battle/move_effects/selfdestruct.asm"

INCLUDE "engine/battle/move_effects/mirror_move.asm"

INCLUDE "engine/battle/move_effects/metronome.asm"

CheckUserMove:
; Return z if the user has move a.
	ld b, a
	ld de, wBattleMonMoves
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld de, wEnemyMonMoves
.ok

	ld c, NUM_MOVES
.loop
	ld a, [de]
	inc de
	cp b
	ret z

	dec c
	jr nz, .loop

	ld a, 1
	and a
	ret

CheckPowerHerb:
	call GetUserItem
	ld a, b
	cp HELD_POWER_HERB
	ret nz

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	bit SUBSTATUS_CHARGED, a
	ret z
	
	farcall ConsumeUserItem

	ld a, BATTLE_VARS_SUBSTATUS3
	call GetBattleVar
	and 1 << SUBSTATUS_FLYING | 1 << SUBSTATUS_UNDERGROUND
	jr nz, .skipanim
	ld de, RECOVER
	farcall Call_PlayBattleAnim

.skipanim
	ld hl, PowerHerbText
	call StdBattleTextBox
	call CheckUserIsCharging
	ld a, 2

ResetTurn:
	ld hl, wPlayerCharging
	ldh a, [hBattleTurn]
	and a
	jr z, .player
	ld hl, wEnemyCharging

.player
	ld [hl], 1
	xor a
	ld [wAlreadyDisobeyed], a
	call DoMove
	jp EndMoveEffect

INCLUDE "engine/battle/move_effects/thief.asm"

BattleCommand_ArenaTrap:
; arenatrap

; Doesn't work on Ghost-types.

	ld a, GHOST
	call CheckIfTargetIsGivenType
	jp z, BattleEffect_ButItFailed

; Doesn't work on an absent opponent.

	call CheckHiddenOpponent
	jp nz, BattleEffect_ButItFailed

; Don't trap if the opponent is already trapped.

	ld a, BATTLE_VARS_SUBSTATUS5
	call GetBattleVarAddr
	bit SUBSTATUS_CANT_RUN, [hl]
	jp nz, BattleEffect_ButItFailed

; Otherwise trap the opponent.

	set SUBSTATUS_CANT_RUN, [hl]
	call AnimateCurrentMove
	ld hl, CantEscapeNowText
	jp StdBattleTextBox

INCLUDE "engine/battle/move_effects/nightmare.asm"

BattleCommand_Defrost:
; defrost

; Thaw the user.

	ld a, BATTLE_VARS_STATUS
	call GetBattleVarAddr
	bit FRZ, [hl]
	ret z
	res FRZ, [hl]

; Don't update the enemy's party struct in a wild battle.

	ldh a, [hBattleTurn]
	and a
	jr z, .party

	ld a, [wBattleMode]
	dec a
	jr z, .done

.party
	ld a, MON_STATUS
	call UserPartyAttr
	res FRZ, [hl]

.done
	call RefreshBattleHuds
	ld hl, WasDefrostedText
	jp StdBattleTextBox

INCLUDE "engine/battle/move_effects/curse.asm"

INCLUDE "engine/battle/move_effects/protect.asm"

INCLUDE "engine/battle/move_effects/endure.asm"

INCLUDE "engine/battle/move_effects/spikes.asm"

INCLUDE "engine/battle/move_effects/foresight.asm"

INCLUDE "engine/battle/move_effects/perish_song.asm"

INCLUDE "engine/battle/move_effects/rollout.asm"

INCLUDE "engine/battle/move_effects/fury_cutter.asm"

INCLUDE "engine/battle/move_effects/attract.asm"

INCLUDE "engine/battle/move_effects/present.asm"


BattleCommand_CheckSafeguard:
; checksafeguard
	ld hl, wEnemyScreens
	ldh a, [hBattleTurn]
	and a
	jr z, .got_turn
	ld hl, wPlayerScreens
.got_turn
	bit SCREENS_SAFEGUARD, [hl]
	ret z
	ld a, 1
	ld [wAttackMissed], a
	call BattleCommand_MoveDelay
	ld hl, SafeguardProtectText
	call StdBattleTextBox
	jp EndMoveEffect


INCLUDE "engine/battle/move_effects/uturn.asm"

INCLUDE "engine/battle/move_effects/baton_pass.asm"

INCLUDE "engine/battle/move_effects/pursuit.asm"



BattleCommand_HealMorn:
; healmorn
	ld b, MORN_F
	jr BattleCommand_TimeBasedHealContinue

BattleCommand_HealDay:
; healday
	ld b, DAY_F
	jr BattleCommand_TimeBasedHealContinue

BattleCommand_HealNite:
; healnite
	ld b, NITE_F
	; fallthrough

BattleCommand_TimeBasedHealContinue:
; Time- and weather-sensitive heal.

	ld hl, wBattleMonMaxHP
	ld de, wBattleMonHP
	ldh a, [hBattleTurn]
	and a
	jr z, .start
	ld hl, wEnemyMonMaxHP
	ld de, wEnemyMonHP

.start
; Index for .Multipliers
; Default restores half max HP.
	ld c, 2

; Don't bother healing if HP is already full.
	push bc
	call CompareBytes
	pop bc
	jr z, .Full

; Don't factor in time of day in link battles.
	ld a, [wLinkMode]
	and a
	jr nz, .Weather
; Don't factor in time of day during the Battle Subway or Simulation either.
	ld hl, wStatusFlags2
	bit STATUSFLAGS2_BATTLE_SUBWAY_ACTIVE_F, [hl]
	jr nz, .Weather
	bit STATUSFLAGS2_BATTLE_SIMULATION_F, [hl]
	jr nz, .Weather

	ld a, [wTimeOfDay]
	cp b
	jr z, .Weather
	dec c ; double

.Weather:
	ld a, [wBattleWeather]
	and a
	jr z, .Heal

; x2 in sun
; /2 in rain/sandstorm
	inc c
	cp WEATHER_SUN
	jr z, .Heal
	dec c
	dec c

.Heal:
	ld b, 0
	ld hl, .Multipliers
	add hl, bc
	add hl, bc

	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, BANK(GetMaxHP)
	rst FarCall

	call AnimateCurrentMove
	call BattleCommand_SwitchTurn

	callfar RestoreHP

	call BattleCommand_SwitchTurn
	call UpdateUserInParty

; 'regained health!'
	ld hl, RegainedHealthText
	jp StdBattleTextBox

.Full:
	call AnimateFailedMove

; 'hp is full!'
	ld hl, HPIsFullText
	jp StdBattleTextBox

.Multipliers:
	dw GetEighthMaxHP
	dw GetQuarterMaxHP
	dw GetHalfMaxHP
	dw GetMaxHP
	
CantRaiseStats:
	ld b, ABILITY + 1
	call GetStatName
	call AnimateFailedMove
	ld hl, WontRiseAnymoreText
	jp StdBattleTextBox

INCLUDE "engine/battle/move_effects/hidden_power.asm"

INCLUDE "engine/battle/move_effects/weather_moves.asm"

INCLUDE "engine/battle/move_effects/belly_drum.asm"

INCLUDE "engine/battle/move_effects/sharpen.asm"

INCLUDE "engine/battle/move_effects/bulk_up.asm"

INCLUDE "engine/battle/move_effects/calm_mind.asm"

INCLUDE "engine/battle/move_effects/dragon_dance.asm"

INCLUDE "engine/battle/move_effects/quiver_dance.asm"

INCLUDE "engine/battle/move_effects/cosmic_power.asm"

INCLUDE "engine/battle/move_effects/coil.asm"

INCLUDE "engine/battle/move_effects/growth.asm"

INCLUDE "engine/battle/move_effects/psych_up.asm"

BattleCommand_DoubleMinimizeDamage:
; doubleminimizedamage

	ld hl, wEnemyMinimized
	ldh a, [hBattleTurn]
	and a
	jr z, .ok
	ld hl, wPlayerMinimized
.ok
	ld a, [hl]
	and a
	ret z
	ld hl, wCurDamage + 1
	sla [hl]
	dec hl
	rl [hl]
	ret nc
	ld a, $ff
	ld [hli], a
	ld [hl], a
	ret

BattleCommand_SkipSunCharge:
; mimicsuncharge
	ld a, [wBattleWeather]
	cp WEATHER_SUN
	ret nz
	ld b, charge_command
	jp SkipToBattleCommand

INCLUDE "engine/battle/move_effects/future_sight.asm"

INCLUDE "engine/battle/move_effects/thunder.asm"

BattleCommand_CheckLegendaryBattle:
; checklegendary
	ld a, [wBattleType]
	cp BATTLETYPE_LEGENDARY
	ret nz

BattleCommand_EndMoveEffect:
	call AnimateFailedMove
	call PrintButItFailed
	jp EndMoveEffect

CheckHiddenOpponent:
; BUG: This routine is completely redundant and introduces a bug, since BattleCommand_CheckHit does these checks properly.
	xor a
	ret

GetUserItem:
; Return the effect of the user's item in bc, and its id at hl.
	ld hl, wBattleMonItem
	ldh a, [hBattleTurn]
	and a
	jr z, .go
	ld hl, wEnemyMonItem
.go
	ld b, [hl]
	jp GetItemHeldEffect

GetOpponentItem:
; Return the effect of the opponent's item in bc, and its id at hl.
	ld hl, wEnemyMonItem
	ldh a, [hBattleTurn]
	and a
	jr z, .go
	ld hl, wBattleMonItem
.go
	ld b, [hl]
	jp GetItemHeldEffect

GetItemHeldEffect:
; Return the effect of item b in bc.
	ld a, b
	and a
	ret z

	push hl
	ld hl, ItemAttributes + ITEMATTR_EFFECT
	dec a
	ld c, a
	ld b, 0
	ld a, ITEMATTR_STRUCT_LENGTH
	call AddNTimes
	ld a, BANK(ItemAttributes)
	call GetFarHalfword
	ld b, l
	ld c, h
	pop hl
	ret

AnimateCurrentMoveEitherSide:
	push hl
	push de
	push bc
	ld a, [wKickCounter]
	push af
	farcall BattleCommand_LowerSub
	pop af
	ld [wKickCounter], a
	farcall PlayDamageAnim
	farcall BattleCommand_RaiseSub
	pop bc
	pop de
	pop hl
	ret

AnimateCurrentMove:
	push hl
	push de
	push bc
	ld a, [wKickCounter]
	push af
	farcall BattleCommand_LowerSub
	pop af
	ld [wKickCounter], a
	farcall LoadMoveAnim
	farcall BattleCommand_RaiseSub
	pop bc
	pop de
	pop hl
	ret

PlayDamageAnim:
	xor a
	ld [wFXAnimID + 1], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z

	ld [wFXAnimID], a

	ldh a, [hBattleTurn]
	and a
	ld a, BATTLEANIM_ENEMY_DAMAGE
	jr z, .player
	ld a, BATTLEANIM_PLAYER_DAMAGE

.player
	ld [wNumHits], a

	jp PlayUserBattleAnim

LoadMoveAnim:
	xor a
	ld [wNumHits], a
	ld [wFXAnimID + 1], a

	ld a, BATTLE_VARS_MOVE_ANIM
	call GetBattleVar
	and a
	ret z

	; fallthrough

LoadAnim:
	ld [wFXAnimID], a

	; fallthrough

PlayUserBattleAnim:
	push hl
	push de
	push bc
	callfar PlayBattleAnim
	pop bc
	pop de
	pop hl
	ret

PlayOpponentBattleAnim:
	ld a, e
	ld [wFXAnimID], a
	ld a, d
	ld [wFXAnimID + 1], a
	xor a
	ld [wNumHits], a

	push hl
	push de
	push bc
	call BattleCommand_SwitchTurn

	callfar PlayBattleAnim

	call BattleCommand_SwitchTurn
	pop bc
	pop de
	pop hl
	ret

CallBattleCore:
	ld a, BANK("Battle Core")
	rst FarCall
	ret

AnimateFailedMove:
	call BattleCommand_LowerSub
	call BattleCommand_MoveDelay
	jp BattleCommand_RaiseSub

BattleCommand_MoveDelay:
; movedelay
; Wait 10 frames.
	ld c, 10
	jp DelayFrames

BattleCommand_ClearText:
; cleartext

; Used in multi-hit moves.
	ld hl, .text
	jp BattleTextBox

.text:
	text_end

SkipToBattleCommand:
; Skip over commands until reaching command b.
	ld a, [wBattleScriptBufferAddress + 1]
	ld h, a
	ld a, [wBattleScriptBufferAddress]
	ld l, a
.loop
	ld a, [hli]
	cp b
	jr nz, .loop

	ld a, h
	ld [wBattleScriptBufferAddress + 1], a
	ld a, l
	ld [wBattleScriptBufferAddress], a
	ret

GetMoveAttr:
; Assuming hl = Moves + x, return attribute x of move a.
	push bc
	ld bc, MOVE_LENGTH
	call AddNTimes
	call GetMoveByte
	pop bc
	ret

GetMoveData:
; Copy move struct a to de.
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	jp FarCopyBytes

GetMoveByte:
	ld a, BANK(Moves)
	jp GetFarByte

DisappearUser:
	farcall _DisappearUser
	ret

AppearUserLowerSub:
	farcall _AppearUserLowerSub
	ret

AppearUserRaiseSub:
	farcall _AppearUserRaiseSub
	ret

_CheckBattleScene:
; Checks the options.  Returns carry if battle animations are disabled.
	push hl
	push de
	push bc
	farcall CheckBattleScene
	pop bc
	pop de
	pop hl
	ret
