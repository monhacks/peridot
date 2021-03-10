GiveParkBalls:
	ld a, 30
	ld [wParkBallsRemaining], a
	ld a, 500 / $100
	ld [wSafariStepsRemaining], a
	ld a, 500 % $100
	ld [wSafariStepsRemaining + 1], a
	ret

BugCatchingContestBattleScript::
	writecode VAR_BATTLETYPE, BATTLETYPE_CONTEST
	randomwildmon
	startbattle
	reloadmapafterbattle
	copybytetovar wParkBallsRemaining
	iffalse BugCatchingContestOutOfBallsScript
	end

BugCatchingContestOverScript::
	playsound SFX_ELEVATOR_END
	opentext
	writetext BugCatchingContestText_BeeepTimesUp
	waitbutton
	clearflag ENGINE_SAFARI_ZONE
	jump BugCatchingContestReturnToGateScript

BugCatchingContestOutOfBallsScript:
	playsound SFX_ELEVATOR_END
	opentext
	writetext BugCatchingContestText_ContestIsOver
	waitbutton

BugCatchingContestReturnToGateScript:
	closetext
	jumpstd bugcontestresultswarp

BugCatchingContestText_BeeepTimesUp:
	; ANNOUNCER: BEEEP! Time's up!
	text_far UnknownText_0x1bd2ca
	text_end

BugCatchingContestText_ContestIsOver:
	; ANNOUNCER: The Contest is over!
	text_far UnknownText_0x1bd2e7
	text_end
