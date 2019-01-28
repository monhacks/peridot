PhoneScript_Random2:
	random 2
	end

PhoneScript_Random3:
	random 3
	end

PhoneScript_Random4:
	random 4
	end

PhoneScript_Random5:
	random 5
	end

PhoneScript_Random11:
	random 11
	end

PhoneScript_AnswerPhone_Male:
	checktime DAY
	iftrue PhoneScript_AnswerPhone_Male_Day
	checktime NITE
	iftrue PhoneScript_AnswerPhone_Male_Nite
	checkcode VAR_CALLERID
	; PHONE_SCHOOLBOY_JACK, .Jack
	; PHONE_SAILOR_HUEY, .Huey
	; PHONE_COOLTRAINERM_GAVEN, .Gaven
	; PHONE_BIRDKEEPER_JOSE, .Jose
	; PHONE_YOUNGSTER_JOEY, .Joey
	; PHONE_BUG_CATCHER_WADE, .Wade
	; PHONE_FISHER_RALPH, .Ralph
	; PHONE_HIKER_ANTHONY, .Anthony
	; PHONE_CAMPER_TODD, .Todd
	; PHONE_JUGGLER_IRWIN, .Irwin
	; PHONE_BUG_CATCHER_ARNIE, .Arnie
	; PHONE_SCHOOLBOY_ALAN, .Alan
	; PHONE_SCHOOLBOY_CHAD, .Chad
	; PHONE_POKEFANM_DEREK, .Derek
	; PHONE_FISHER_TULLY, .Tully
	; PHONE_POKEMANIAC_BRENT, .Brent
	; PHONE_BIRDKEEPER_VANCE, .Vance
	; PHONE_FISHER_WILTON, .Wilton
	; PHONE_BLACKBELT_KENJI, .Kenji
	; PHONE_HIKER_PARRY, .Parry

.Jack:
	farwritetext UnknownText_0x1b4dc5
	buttonsound
	end

.Huey:
	farwritetext UnknownText_0x1b5073
	buttonsound
	end

.Gaven:
	farwritetext UnknownText_0x1b5270
	buttonsound
	end

.Jose:
	farwritetext UnknownText_0x1b55ae
	buttonsound
	end

.Joey:
	farwritetext UnknownText_0x1b589a
	buttonsound
	end

.Wade:
	farwritetext UnknownText_0x1b5a3b
	buttonsound
	end

.Ralph:
	farwritetext UnknownText_0x1b5c10
	buttonsound
	end

.Anthony:
	farwritetext UnknownText_0x1b5f7a
	buttonsound
	end

.Todd:
	farwritetext UnknownText_0x1b60f5
	buttonsound
	end

.Irwin:
	farwritetext UnknownText_0x1b638c
	buttonsound
	end

.Arnie:
	farwritetext UnknownText_0x1b6454
	buttonsound
	end

.Alan:
	farwritetext UnknownText_0x1b659d
	buttonsound
	end

.Chad:
	farwritetext UnknownText_0x1b67e2
	buttonsound
	end

.Derek:
	farwritetext UnknownText_0x1b69a8
	buttonsound
	end

.Tully:
	farwritetext UnknownText_0x1b6b39
	buttonsound
	end

.Brent:
	farwritetext UnknownText_0x1b6c96
	buttonsound
	end

.Vance:
	farwritetext UnknownText_0x1b7019
	buttonsound
	end

.Wilton:
	farwritetext UnknownText_0x1b71d5
	buttonsound
	end

.Kenji:
	farwritetext UnknownText_0x1b730b
	buttonsound
	end

.Parry:
	farwritetext UnknownText_0x1b73c7
	buttonsound
	end

PhoneScript_AnswerPhone_Male_Day:
	checkcode VAR_CALLERID
	; PHONE_SCHOOLBOY_JACK, .Jack
	; PHONE_SAILOR_HUEY, .Huey
	; PHONE_COOLTRAINERM_GAVEN, .Gaven
	; PHONE_BIRDKEEPER_JOSE, .Jose
	; PHONE_YOUNGSTER_JOEY, .Joey
	; PHONE_BUG_CATCHER_WADE, .Wade
	; PHONE_FISHER_RALPH, .Ralph
	; PHONE_HIKER_ANTHONY, .Anthony
	; PHONE_CAMPER_TODD, .Todd
	; PHONE_JUGGLER_IRWIN, .Irwin
	; PHONE_BUG_CATCHER_ARNIE, .Arnie
	; PHONE_SCHOOLBOY_ALAN, .Alan
	; PHONE_SCHOOLBOY_CHAD, .Chad
	; PHONE_POKEFANM_DEREK, .Derek
	; PHONE_FISHER_TULLY, .Tully
	; PHONE_POKEMANIAC_BRENT, .Brent
	; PHONE_BIRDKEEPER_VANCE, .Vance
	; PHONE_FISHER_WILTON, .Wilton
	; PHONE_BLACKBELT_KENJI, .Kenji
	; PHONE_HIKER_PARRY, .Parry

.Jack:
	farwritetext UnknownText_0x1b4ded
	buttonsound
	end

.Huey:
	farwritetext UnknownText_0x1b509b
	buttonsound
	end

.Gaven:
	farwritetext UnknownText_0x1b52a5
	buttonsound
	end

.Jose:
	farwritetext UnknownText_0x1b55da
	buttonsound
	end

.Joey:
	farwritetext UnknownText_0x1b58c2
	buttonsound
	end

.Wade:
	farwritetext UnknownText_0x1b5a74
	buttonsound
	end

.Ralph:
	farwritetext UnknownText_0x1b5c63
	buttonsound
	end

.Anthony:
	farwritetext UnknownText_0x1b5f9e
	buttonsound
	end

.Todd:
	farwritetext UnknownText_0x1b611b
	buttonsound
	end

.Irwin:
	farwritetext UnknownText_0x1b63a8
	buttonsound
	end

.Arnie:
	farwritetext UnknownText_0x1b647e
	buttonsound
	end

.Alan:
	farwritetext UnknownText_0x1b65c7
	buttonsound
	end

.Chad:
	farwritetext UnknownText_0x1b680e
	buttonsound
	end

.Derek:
	farwritetext UnknownText_0x1b69d2
	buttonsound
	end

.Tully:
	farwritetext UnknownText_0x1b6b65
	buttonsound
	end

.Brent:
	farwritetext UnknownText_0x1b6cc6
	buttonsound
	end

.Vance:
	farwritetext UnknownText_0x1b7057
	buttonsound
	end

.Wilton:
	farwritetext UnknownText_0x1b71fc
	buttonsound
	end

.Kenji:
	farwritetext UnknownText_0x1b7331
	buttonsound
	end

.Parry:
	farwritetext UnknownText_0x1b73ef
	buttonsound
	end

PhoneScript_AnswerPhone_Male_Nite:
	checkcode VAR_CALLERID
	; PHONE_SCHOOLBOY_JACK, .Jack
	; PHONE_SAILOR_HUEY, .Huey
	; PHONE_COOLTRAINERM_GAVEN, .Gaven
	; PHONE_BIRDKEEPER_JOSE, .Jose
	; PHONE_YOUNGSTER_JOEY, .Joey
	; PHONE_BUG_CATCHER_WADE, .Wade
	; PHONE_FISHER_RALPH, .Ralph
	; PHONE_HIKER_ANTHONY, .Anthony
	; PHONE_CAMPER_TODD, .Todd
	; PHONE_JUGGLER_IRWIN, .Irwin
	; PHONE_BUG_CATCHER_ARNIE, .Arnie
	; PHONE_SCHOOLBOY_ALAN, .Alan
	; PHONE_SCHOOLBOY_CHAD, .Chad
	; PHONE_POKEFANM_DEREK, .Derek
	; PHONE_FISHER_TULLY, .Tully
	; PHONE_POKEMANIAC_BRENT, .Brent
	; PHONE_BIRDKEEPER_VANCE, .Vance
	; PHONE_FISHER_WILTON, .Wilton
	; PHONE_BLACKBELT_KENJI, .Kenji
	; PHONE_HIKER_PARRY, .Parry

.Jack:
	farwritetext UnknownText_0x1b4e16
	buttonsound
	end

.Huey:
	farwritetext UnknownText_0x1b50c2
	buttonsound
	end

.Gaven:
	farwritetext UnknownText_0x1b52cc
	buttonsound
	end

.Jose:
	farwritetext UnknownText_0x1b55fc
	buttonsound
	end

.Joey:
	farwritetext UnknownText_0x1b58ea
	buttonsound
	end

.Wade:
	farwritetext UnknownText_0x1b5a9f
	buttonsound
	end

.Ralph:
	farwritetext UnknownText_0x1b5cb6
	buttonsound
	end

.Anthony:
	farwritetext UnknownText_0x1b5fc9
	buttonsound
	end

.Todd:
	farwritetext UnknownText_0x1b6149
	buttonsound
	end

.Irwin:
	farwritetext UnknownText_0x1b63c4
	buttonsound
	end

.Arnie:
	farwritetext UnknownText_0x1b64a8
	buttonsound
	end

.Alan:
	farwritetext UnknownText_0x1b65e3
	buttonsound
	end

.Chad:
	farwritetext UnknownText_0x1b6836
	buttonsound
	end

.Derek:
	farwritetext UnknownText_0x1b69f8
	buttonsound
	end

.Tully:
	farwritetext UnknownText_0x1b6b92
	buttonsound
	end

.Brent:
	farwritetext UnknownText_0x1b6cf6
	buttonsound
	end

.Vance:
	farwritetext UnknownText_0x1b7092
	buttonsound
	end

.Wilton:
	farwritetext UnknownText_0x1b722a
	buttonsound
	end

.Kenji:
	farwritetext UnknownText_0x1b7357
	buttonsound
	end

.Parry:
	farwritetext UnknownText_0x1b7417
	buttonsound
	end

PhoneScript_AnswerPhone_Female:
	checktime DAY
	iftrue PhoneScript_AnswerPhone_Female_Day
	checktime NITE
	iftrue PhoneScript_AnswerPhone_Female_Nite

PhoneScript_AnswerPhone_Female_Day:
	end

PhoneScript_AnswerPhone_Female_Nite:
	end

PhoneScript_GreetPhone_Male:
	end

PhoneScript_GreetPhone_Male_Day:
	end

PhoneScript_GreetPhone_Male_Nite:
	end

PhoneScript_GreetPhone_Female:
	checktime DAY
	iftrue PhoneScript_GreetPhone_Female_Day
	checktime NITE
	iftrue PhoneScript_GreetPhone_Female_Nite
	checkcode VAR_CALLERID
	; PHONE_POKEFAN_BEVERLY, .Beverly
	; PHONE_COOLTRAINERF_BETH, .Beth
	; PHONE_COOLTRAINERF_REENA, .Reena
	; PHONE_PICNICKER_LIZ, .Liz
	; PHONE_PICNICKER_GINA, .Gina
	; PHONE_LASS_DANA, .Dana
	; PHONE_PICNICKER_TIFFANY, .Tiffany
	; PHONE_PICNICKER_ERIN, .Erin

.Beverly:
	farwritetext UnknownText_0x1b4fa1
	buttonsound
	end

.Beth:
	farwritetext UnknownText_0x1b5472
	buttonsound
	end

.Reena:
	farwritetext UnknownText_0x1b5786
	buttonsound
	end

.Liz:
	farwritetext UnknownText_0x1b5e25
	buttonsound
	end

.Gina:
	farwritetext UnknownText_0x1b62f1
	buttonsound
	end

.Dana:
	farwritetext UnknownText_0x1b6738
	buttonsound
	end

.Tiffany:
	farwritetext UnknownText_0x1b6ef3
	buttonsound
	end

.Erin:
	farwritetext UnknownText_0x1b758f
	buttonsound
	end

PhoneScript_GreetPhone_Female_Day:
	checkcode VAR_CALLERID
	; PHONE_POKEFAN_BEVERLY, .Beverly
	; PHONE_COOLTRAINERF_BETH, .Beth
	; PHONE_COOLTRAINERF_REENA, .Reena
	; PHONE_PICNICKER_LIZ, .Liz
	; PHONE_PICNICKER_GINA, .Gina
	; PHONE_LASS_DANA, .Dana
	; PHONE_PICNICKER_TIFFANY, .Tiffany
	; PHONE_PICNICKER_ERIN, .Erin

.Beverly:
	farwritetext UnknownText_0x1b4fda
	buttonsound
	end

.Beth:
	farwritetext UnknownText_0x1b54a6
	buttonsound
	end

.Reena:
	farwritetext UnknownText_0x1b57b7
	buttonsound
	end

.Liz:
	farwritetext UnknownText_0x1b5e59
	buttonsound
	end

.Gina:
	farwritetext UnknownText_0x1b630e
	buttonsound
	end

.Dana:
	farwritetext UnknownText_0x1b6757
	buttonsound
	end

.Tiffany:
	farwritetext UnknownText_0x1b6f1c
	buttonsound
	end

.Erin:
	farwritetext UnknownText_0x1b75ac
	buttonsound
	end

PhoneScript_GreetPhone_Female_Nite:
	checkcode VAR_CALLERID
	; PHONE_POKEFAN_BEVERLY, .Beverly
	; PHONE_COOLTRAINERF_BETH, .Beth
	; PHONE_COOLTRAINERF_REENA, .Reena
	; PHONE_PICNICKER_LIZ, .Liz
	; PHONE_PICNICKER_GINA, .Gina
	; PHONE_LASS_DANA, .Dana
	; PHONE_PICNICKER_TIFFANY, .Tiffany
	; PHONE_PICNICKER_ERIN, .Erin

.Beverly:
	farwritetext UnknownText_0x1b5004
	buttonsound
	end

.Beth:
	farwritetext UnknownText_0x1b54d4
	buttonsound
	end

.Reena:
	farwritetext UnknownText_0x1b57e8
	buttonsound
	end

.Liz:
	farwritetext UnknownText_0x1b5e8e
	buttonsound
	end

.Gina:
	farwritetext UnknownText_0x1b6331
	buttonsound
	end

.Dana:
	farwritetext UnknownText_0x1b6776
	buttonsound
	end

.Tiffany:
	farwritetext UnknownText_0x1b6f37
	buttonsound
	end

.Erin:
	farwritetext UnknownText_0x1b75c9
	buttonsound
	end

PhoneScript_Generic_Male:
	checkcode VAR_CALLERID
	; PHONE_SCHOOLBOY_JACK, .Jack
	; PHONE_COOLTRAINERM_GAVEN, .Gaven
	; PHONE_BIRDKEEPER_JOSE, .Jose
	; PHONE_YOUNGSTER_JOEY, .Joey
	; PHONE_BUG_CATCHER_WADE, .Wade
	; PHONE_FISHER_RALPH, .Ralph
	; PHONE_HIKER_ANTHONY, .Anthony
	; PHONE_CAMPER_TODD, .Todd
	; PHONE_BUG_CATCHER_ARNIE, .Arnie
	; PHONE_SCHOOLBOY_ALAN, .Alan
	; PHONE_SCHOOLBOY_CHAD, .Chad
	; PHONE_POKEFANM_DEREK, .Derek
	; PHONE_FISHER_TULLY, .Tully
	; PHONE_POKEMANIAC_BRENT, .Brent
	; PHONE_BIRDKEEPER_VANCE, .Vance
	; PHONE_FISHER_WILTON, .Wilton
	; PHONE_HIKER_PARRY, .Parry

.Jack:
	farwritetext UnknownText_0x1b4ecd
	buttonsound
	end

.Unknown:
	farwritetext UnknownText_0x1b518b
	buttonsound
	end

.Gaven:
	farwritetext UnknownText_0x1b5393
	buttonsound
	end

.Jose:
	farwritetext UnknownText_0x1b5694
	buttonsound
	end

.Joey:
	farwritetext UnknownText_0x1b59b2
	buttonsound
	end

.Wade:
	farwritetext UnknownText_0x1b5b68
	buttonsound
	end

.Ralph:
	farwritetext UnknownText_0x1b5d51
	buttonsound
	end

.Anthony:
	farwritetext UnknownText_0x1b606f
	buttonsound
	end

.Todd:
	farwritetext UnknownText_0x1b61f2
	buttonsound
	end

.Arnie:
	farwritetext UnknownText_0x1b656c
	buttonsound
	end

.Alan:
	farwritetext UnknownText_0x1b6652
	buttonsound
	end

.Chad:
	farwritetext UnknownText_0x1b68e8
	buttonsound
	end

.Derek:
	farwritetext UnknownText_0x1b6ac2
	buttonsound
	end

.Tully:
	farwritetext UnknownText_0x1b6c56
	buttonsound
	end

.Brent:
	farwritetext UnknownText_0x1b6db9
	buttonsound
	end

.Vance:
	farwritetext UnknownText_0x1b7161
	buttonsound
	end

.Wilton:
	farwritetext UnknownText_0x1b72d0
	buttonsound
	end

.Parry:
	farwritetext UnknownText_0x1b74c8
	buttonsound
	end

PhoneScript_Generic_Female:
	checkcode VAR_CALLERID
	; PHONE_POKEFAN_BEVERLY, .Beverly
	; PHONE_COOLTRAINERF_BETH, .Beth
	; PHONE_COOLTRAINERF_REENA, .Reena
	; PHONE_PICNICKER_LIZ, .Liz
	; PHONE_PICNICKER_GINA, .Gina
	; PHONE_LASS_DANA, .Dana
	; PHONE_PICNICKER_TIFFANY, .Tiffany
	; PHONE_PICNICKER_ERIN, .Erin

.Beverly:
	farwritetext UnknownText_0x1b502b
	buttonsound
	end

.Beth:
	farwritetext UnknownText_0x1b5510
	buttonsound
	end

.Reena:
	farwritetext UnknownText_0x1b5819
	buttonsound
	end

.Liz:
	farwritetext UnknownText_0x1b5ebe
	buttonsound
	end

.Gina:
	farwritetext UnknownText_0x1b6352
	buttonsound
	end

.Dana:
	farwritetext UnknownText_0x1b6795
	buttonsound
	end

.Tiffany:
	farwritetext UnknownText_0x1b6f60
	buttonsound
	end

.Erin:
	farwritetext UnknownText_0x1b75e5
	buttonsound
	end

PhoneScript_MonFlavorText:
	special RandomPhoneMon
	farscall PhoneScript_Random2
	; $0, .TooEnergetic
	farwritetext UnknownText_0x1b518b
	buttonsound
	farjump PhoneScript_HangupText_Male

.TooEnergetic:
	farjump .unnecessary

.unnecessary
	farwritetext UnknownText_0x1b522b
	buttonsound
	farjump PhoneScript_HangupText_Male

GrandmaString: db "Grandma@"
GrandpaString: db "Grandpa@"
MomString: db "Mom@"
DadString: db "Dad@"
SisterString: db "Sister@"
BrotherString: db "Brother@"
