#include <a_samp>
#include <a_mysql>

#define n(%0) pi[%0][nick]
#define gpvi GetPVarInt
#define spvi SetPVarInt

// приставка l означает - светлый; приставка d означает - тёмный;
#define hexsc "{00B8FF}" //цвет сервера
#define hexlblue "{00B8FF}"
#define hexwhite "{FFFFFF}"
#define hexgray "{AEAEAE}"
#define hexdred "{BD0000}"

#define sc 0x00B8FFFF //цвет сервера
#define white 0xFFFFFFFF
#define lblue 0x00B8FFFF
#define gray 0xAEAEAEFF
#define dred 0xBD0000FF

//
#define KEY_AIM (128)

//дефайны тд, реги для удобства
#define b_exit reg[3]
#define b_click_email reg[15]
#define b_wrong_email reg[18]
#define b_sex_man reg[27]
#define b_sex_woman reg[30]
#define b_dot_sex_man reg[28]
#define b_dot_sex_woman reg[31]
#define b_click_pass reg[41]
#define b_wrong_pass reg[40]
#define b_click_promocode reg[50]
#define b_wrong_promocode reg[49]
#define b_click_referral reg[58]
#define b_wrong_referral reg[57]
#define b_next reg[62]

#define KickEx(%0) scm(%0,-1,"!dredДля выхода из игры нажмите клавишу 'F6' и введите '/q'"),SetTimerEx("kickTimer",1000,false,"d",%0)
#define sextext(%0) (pi[%0][sex] == 0) ? ("") : ("а")

new PlayerText: reg[63];
new MySQL: connect;

//Выбор скина
new SkinPed[MAX_PLAYERS];
new SkinMan[5] = { 78,79,137,200,239 };
new SkinGirl[3] = { 12,40,55 };
//

enum dialogs
{
	d_none,
	d_off,
	d_email,
	d_pass,
	d_promocode,
	d_referral,
}

enum player_variables
{
	nick[24],
	sex,
	skin,
	fskin,
	city,
	bool: promocode,
	//не забудь добавить обнуление
}
new pi[MAX_PLAYERS][player_variables];

new promocodes[1][14] = { "testpromocode" };

main() {}

stock findtag(const oldstr[])
{
	new newmes[512]; // так много для диалогов
	strmid(newmes, oldstr, 0, sizeof(newmes));
	if(strfind(newmes, "!sc", true) != -1) // server color
	{
		strins(newmes, hexsc, strfind(newmes, "!sc", true));
		strdel(newmes, strfind(newmes, "!sc", true), strfind(newmes, "!sc", true)+3);
	}
	if(strfind(newmes, "!bl", true) != -1) // server color
	{
		strins(newmes, hexlblue, strfind(newmes, "!bl", true));
		strdel(newmes, strfind(newmes, "!bl", true), strfind(newmes, "!bl", true)+3);
	}
	if(strfind(newmes, "!dred", true) != -1) // server color
	{
		strins(newmes, hexdred, strfind(newmes, "!dred", true));
		strdel(newmes, strfind(newmes, "!dred", true), strfind(newmes, "!dred", true)+5);
	}
	if(strfind(newmes, "!wh", true) != -1) // server color
	{
		strins(newmes, hexwhite, strfind(newmes, "!wh", true));
		strdel(newmes, strfind(newmes, "!wh", true), strfind(newmes, "!wh", true)+3);
	}
	if(strfind(newmes, "!gray", true) != -1)
	{
		strins(newmes, hexgray, strfind(newmes, "!gray", true));
		strdel(newmes, strfind(newmes, "!gray", true), strfind(newmes, "!gray", true)+5);
	}
	if(strfind(newmes, "sName", true) != -1)
	{
		strins(newmes, "Digital Role Play", strfind(newmes, "sName", true));
		strdel(newmes, strfind(newmes, "sName", true), strfind(newmes, "sName", true)+5);
	}
	return newmes;
}

stock scm(playerid, color, const message[])
{
	/*
		Как добавить цвет:
		лезь в дефайны цветов
		там добавляй сразу и HEX (пример: {FF0000}) и RGBA (например: 0xFF0000FF)
		лезь в stock findtag
		ставь свой тег в if(strfind(newmes, "!твой тег", true) != -1)
		везде ниже в коде ставь тоже свой тег
		в strdel(newmes, strfind(newmes, "!твой тег", true), strfind(newmes, "!твой тег", true)+количество символов в теге учитывая ! (например в !gray - 5 символов)); 
	
		Пример использования таких тегов смотри в OnPlayerRequestClass где приветствие игрока
	*/
	return SendClientMessage(playerid, color, findtag(message));
}

stock err(playerid, const message[])
{
	//если делать в дефайне не работает format
	new newmes[144];
	strmid(newmes, message, 0, 144);
	strins(newmes, "x !gray", 0);
	return scm(playerid, dred, newmes);
}

forward kickTimer(playerid);
public kickTimer(playerid) return Kick(playerid);

forward checkPlayerAccount(playerid);
public checkPlayerAccount(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(!rows) {
		PlayerTextDrawSetString(playerid, reg[10], n(playerid));
		for(new i; i < sizeof(reg); i++) PlayerTextDrawShow(playerid, reg[i]); 
		SelectTextDraw(playerid, 0x3399FFFF); 
		PlayerTextDrawHide(playerid, b_dot_sex_woman);
		PlayerTextDrawShow(playerid, b_dot_sex_man);

		PlayerTextDrawHide(playerid, reg[16]);
		PlayerTextDrawHide(playerid, reg[17]);
		PlayerTextDrawShow(playerid, reg[18]);
		PlayerTextDrawHide(playerid, reg[38]);
		PlayerTextDrawHide(playerid, reg[39]);
		PlayerTextDrawShow(playerid, reg[40]);
		PlayerTextDrawHide(playerid, reg[47]);
		PlayerTextDrawHide(playerid, reg[48]);
		PlayerTextDrawShow(playerid, reg[49]);
		PlayerTextDrawHide(playerid, reg[55]);
		PlayerTextDrawHide(playerid, reg[56]);
		PlayerTextDrawShow(playerid, reg[57]); }
	else {}
		//тут будет авторизация
	return 1;
}

forward checkPlayerAccountReferral(playerid, inputtext[]);
public checkPlayerAccountReferral(playerid, inputtext[])
{
	new rows;
	cache_get_row_count(rows);
	if(rows) 
	{
		PlayerTextDrawSetString(playerid, reg[58], inputtext);
		SetPVarString(playerid, "reg_referral", inputtext);
		PlayerTextDrawShow(playerid, reg[55]);
		PlayerTextDrawShow(playerid, reg[56]);
		PlayerTextDrawHide(playerid, reg[57]); 
	}
	else 
	{
		PlayerTextDrawHide(playerid, reg[55]);
		PlayerTextDrawHide(playerid, reg[56]);
		PlayerTextDrawShow(playerid, reg[57]);
		SetPVarString(playerid, "reg_referral", "no");
		PlayerTextDrawSetString(playerid, reg[58], "Click...");
	}
	return 1;
}

public OnGameModeInit()
{
	SetGameModeText("DRP Alpha");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(true);
	SetNameTagDrawDistance(21.0);
	EnableStuntBonusForAll(false);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(100.0);
	ManualVehicleEngineAndLights();

	connect = 
		mysql_connect("localhost", "root", "", "new");
	if(!mysql_errno()) 
		print("~ Успешное подключение к базе данных");
	else 
		print("~ Неудачное подключение к базе данных");
	mysql_log(ALL);

	mysql_tquery(connect, "SET CHARACTER SET 'utf8'", "", "");
    mysql_tquery(connect, "SET NAMES 'utf8'", "", "");
    mysql_tquery(connect, "SET character_set_client = 'cp1251'", "", "");
    mysql_tquery(connect, "SET character_set_connection = 'cp1251'", "", "");
    mysql_tquery(connect, "SET character_set_results = 'cp1251'", "", "");
    mysql_tquery(connect, "SET SESSION collation_connection = 'utf8_general_ci'", "", "");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	TogglePlayerSpectating(playerid, true);
	if(bool:GetPVarInt(playerid, "skip?") == true)
	{
		SetPVarInt(playerid, "skip?", false);
		SetTimerEx("OnPlayerRequestClass", 100, false, "ii", playerid, classid);
	}
	else
	{
		TogglePlayerSpectating(playerid, false);
		SpawnPlayer(playerid);
	}

	if(bool: gpvi(playerid, "use_rq") == true) return 1;

	for(new i; i < 30; i++) scm(playerid, -1, "");
	
	scm(playerid, -1, "Добро пожаловать на !scsName");

	SetPVarInt(playerid, "use_rq", true);
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, n(playerid), 24);

	#include <playertextdraws>

	for(new i; i < sizeof(reg); i++) PlayerTextDrawHide(playerid, reg[i]);

	//обнуление переменных и PVARov
	SetPVarInt(playerid, "skip?", true);
	SetPVarInt(playerid, "logged", false);
	SetPVarInt(playerid, "SkinSelect", 0);
	SetPVarInt(playerid, "CitySelect", 0);
	SetPVarString(playerid, "reg_email", "no");
	SetPVarString(playerid, "reg_pass", "no");
	SetPVarString(playerid, "reg_referral", "no");
	
	pi[playerid][sex] = 0;
	pi[playerid][skin] = 0;
	pi[playerid][fskin] = 0;
	pi[playerid][city] = 0;
	pi[playerid][promocode] = false;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	for(new i; i < sizeof(reg); i++) PlayerTextDrawDestroy(playerid, reg[i]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(bool: gpvi(playerid, "logged") == false)
	{
		new mysql[39 - 2 + 24];
		mysql_format(connect, mysql, sizeof(mysql), "SELECT * FROM `accs` WHERE `nick` = '%s'", n(playerid));
		mysql_tquery(connect, mysql, "checkPlayerAccount", "i", playerid);
		SetPlayerVirtualWorld(playerid, playerid+100); //чисто свой вирт мир
		TogglePlayerControllable(playerid, false);
		return 1;
	}
	SetCameraBehindPlayer(playerid);
	pi[playerid][skin] = GetPlayerSkin(playerid),SetPlayerSkin(playerid,GetPlayerSkin(playerid));
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(playertextid == b_exit) // asd
		return spd(playerid, d_off, DIALOG_STYLE_MSGBOX, "!scПодтверждение действия", "!whВы уверены что хотите покинуть сервер?", "Назад", "Выйти");

	else if(playertextid == b_click_email)
		return spd(playerid, d_email, DIALOG_STYLE_INPUT, "!scЭлектронная почта", "!whВведите свой электронный адрес. Он потребуется для\nвосстановления пароля от аккаунта в случае его потери.\n\n!grayВы можете пропустить данный пункт оставив поле пустым.", "Далее", "");
	
	else if(playertextid == b_wrong_email)
		return spd(playerid, d_none, DIALOG_STYLE_MSGBOX, "!scНеверная электронная почта", "!whВы указали неверный электронный адрес.\nВ правильном электронном адресе присутствует знак '@',\nдомен почты (пример: gmail.com), а также размер не ниже\n6-ти и не более 40 символов.", "Далее", "");
	
	else if(playertextid == b_sex_man)
		{ PlayerTextDrawHide(playerid, b_dot_sex_woman), PlayerTextDrawShow(playerid, b_dot_sex_man); pi[playerid][sex] = 0; return 1; }
		
	else if(playertextid == b_sex_woman)
		{ PlayerTextDrawHide(playerid, b_dot_sex_man), PlayerTextDrawShow(playerid, b_dot_sex_woman); pi[playerid][sex] = 1; return 1; }

	else if(playertextid == b_click_pass)
		return spd(playerid, d_pass, DIALOG_STYLE_INPUT, "!scПароль", "!whВведите свой новый пароль, который потребуется\nпри последующем входе на сервер.\n\n!grayВ пароле требуется более 6-ти латинских букв и как\nминимум одна цифра.", "Далее", "");
	
	else if(playertextid == b_wrong_pass)
		return spd(playerid, d_none, DIALOG_STYLE_MSGBOX, "!scНеверный пароль", "!whВ правильном пароле требуется более 6-ти\nлатинских букв и как минимум одна цифра.", "Далее", "");
		
	else if(playertextid == b_click_promocode)
		return spd(playerid, d_promocode, DIALOG_STYLE_INPUT, "!scПромокод", "!whВведите промокод\n\n!grayВведя верный промокод Вы будете получать бонусы по мере игры.", "Далее", "");
	
	else if(playertextid == b_wrong_promocode)
		return spd(playerid, d_none, DIALOG_STYLE_MSGBOX, "!scНеверный промокод", "!whПромокод недействителен.", "Далее", "");

	else if(playertextid == b_click_referral)
		return spd(playerid, d_referral, DIALOG_STYLE_INPUT, "!scРеферал", "!whВведите ник игрока, пригласившего Вас на сервер\n\n!grayЗа приглашение Вас, позже этот игрок получит бонус", "Далее", "");
	
	else if(playertextid == b_wrong_referral)
		return spd(playerid, d_none, DIALOG_STYLE_MSGBOX, "!scНеверный реферал", "!whРеферал был введён неверно !gray(не найден игрок)!wh.", "Далее", "");

	else if(playertextid == b_next)
	{
		new pass[32],
			email[40],
			referral[24];
		GetPVarString(playerid, "reg_pass", pass, sizeof(pass));
		GetPVarString(playerid, "reg_email", email, sizeof(email));
		GetPVarString(playerid, "reg_referral", referral, sizeof(referral));
		if( !strcmp(pass, "no", true) ||
			!strcmp(email, "no", true) ||
			!strcmp(referral, "no", true) ) return spd(playerid, d_none, DIALOG_STYLE_MSGBOX, "!scНезаполненные поля", "!whВы не прошли регистрацию полностью.\n\n!grayВозможно, Вы не заполнили какое-то поле\nили заполнили его неверно. У каждого поля\nдолжна стоять зелёная галочка.", "Далее", "");
		TogglePlayerControllable(playerid, false);
        SetPlayerCameraPos(playerid, 2095.943115, 1295.631469, 11.299535);
		SetPlayerCameraLookAt(playerid, 2095.938476, 1290.636596, 11.072217);
		SetPlayerPos(playerid,2096.0435,1288.6414,10.8203);
		SetPlayerFacingAngle(playerid, 10.0000);
		SendClientMessage(playerid,0x3399FFFF,"[Регистрация] {FFFFFF}Используйте {FFD500}'ЛКМ' {FFFFFF}для выбора");
		SendClientMessage(playerid,0x3399FFFF,"[Регистрация] {FFFFFF}Используйте {FFD500}'ПКМ' {FFFFFF}для подтверждения выбора");
		if(pi[playerid][sex] == 0) SetPlayerSkin(playerid,SkinMan[0]);
		if(pi[playerid][sex] == 1) SetPlayerSkin(playerid,SkinGirl[0]);
		SetPlayerVirtualWorld(playerid,playerid+1000);
		for(new i; i < sizeof(reg); i++) PlayerTextDrawHide(playerid, reg[i]);
		CancelSelectTextDraw(playerid);
		SetPVarInt(playerid,"SkinSelect",1);
		SetPVarInt(playerid, "CitySelect", 0);
	}
	return 0;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_AIM)
	{
		if(GetPVarInt(playerid,"SkinSelect") == 1)
		{
			pi[playerid][skin] = GetPlayerSkin(playerid);
			SetPVarInt(playerid, "SkinSelect", 0);
			SetPVarInt(playerid, "CitySelect", 1);
			pi[playerid][city] = 1;
			InterpolateCameraPos(playerid, 2501.114501, -1190.237792, 145.654510, 1511.131347, -943.566406, 75.941421, 7000);
			InterpolateCameraLookAt(playerid, 2496.209960, -1190.189086, 144.683380, 1507.559814, -940.533813, 77.687103, 7000);
			GameTextForPlayer(playerid,"~w~LOS - SANTOS",500,1);
			return 1;
		}
		if(GetPVarInt(playerid,"CitySelect") == 1)
		{
			SpawnPlayer(playerid);
			SetPVarInt(playerid, "CitySelect", 0);
			return 1;
		}
	}
	if(newkeys == KEY_FIRE)
	{
		if(GetPVarInt(playerid,"SkinSelect") == 1)
		{
			if(pi[playerid][sex] == 0)
			{
				SkinPed[playerid]++;
				if(SkinPed[playerid] >= 5) SkinPed[playerid] = 0;
				SetPlayerSkin(playerid,SkinMan[SkinPed[playerid]]);
			}
			if(pi[playerid][sex] == 1)
			{
				SkinPed[playerid]++;
				if(SkinPed[playerid] >= 3) SkinPed[playerid] = 0;
				SetPlayerSkin(playerid,SkinGirl[SkinPed[playerid]]);
			}
			return 1;
		}
		if(GetPVarInt(playerid,"CitySelect") == 1)
		{
			pi[playerid][city] += 1;
			if(pi[playerid][city] == 4) { pi[playerid][city] = 0; return 1; }
			if(pi[playerid][city] == 1)
			{
				InterpolateCameraPos(playerid, 2501.114501, -1190.237792, 145.654510, 1511.131347, -943.566406, 75.941421, 7000);
				InterpolateCameraLookAt(playerid, 2496.209960, -1190.189086, 144.683380, 1507.559814, -940.533813, 77.687103, 7000);
				GameTextForPlayer(playerid,"~w~LOS - SANTOS",500,1);
				return 1;
			}
			if(pi[playerid][city] == 2)
			{
				InterpolateCameraPos(playerid, -1202.632934, -648.377380, 96.101669, -2904.323242, 270.076324, 66.433624, 7000);
				InterpolateCameraLookAt(playerid, -1207.240722, -646.564514, 95.407310, -2900.385009, 272.982757, 65.412475, 7000);
				GameTextForPlayer(playerid,"~w~SAN - FIERRO",500,1);
				return 1;
			}
			if(pi[playerid][city] == 3)
			{
				InterpolateCameraPos(playerid, 2387.002929, 881.351684, 126.485420, 2170.798339, 2016.477050, 84.289588, 7000);
				InterpolateCameraLookAt(playerid, 2382.450439, 883.156250, 125.476760, 2167.838623, 2012.909790, 82.414932, 7000);
				GameTextForPlayer(playerid,"~w~LAS - VENTURAS",500,1);
				return 1;
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

stock spd(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	if(bool:gpvi(playerid, "UseDialog?") != false) return err(playerid, "Закройте открытое диалоговое окно");
	SetPVarInt(playerid, "UseDialog?", true);
	ShowPlayerDialog(playerid, dialogid, style, findtag(caption), findtag(info), button1, button2);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	SetPVarInt(playerid, "UseDialog?", false);
	switch(dialogid)
	{
		case d_off: // asd`
		{
			if(!response)
				KickEx(playerid);
			else return 1;
			return 1;
		}
		case d_email:
		{
			if((strlen(inputtext) < 6 || strlen(inputtext) > 40 || strfind(inputtext, "@", true) == -1 ||  strfind(inputtext, ".", true) == -1) && strlen(inputtext) != 0)
			{
				PlayerTextDrawHide(playerid, reg[16]);
				PlayerTextDrawHide(playerid, reg[17]);
				PlayerTextDrawShow(playerid, reg[18]);
				PlayerTextDrawSetString(playerid, reg[15], "Click...");				
				SetPVarString(playerid, "reg_email", "no");
				return 1;
			}
			PlayerTextDrawSetString(playerid, reg[15], inputtext);
			SetPVarString(playerid, "reg_email", inputtext);
			if(strlen(inputtext) == 0) SetPVarString(playerid, "reg_email", "none");
			PlayerTextDrawShow(playerid, reg[16]);
			PlayerTextDrawShow(playerid, reg[17]);
			PlayerTextDrawHide(playerid, reg[18]);
		}
		case d_pass:
		{
			new agree_sym,
				numeric,
				private_text[32];
			for(new i; i != strlen(inputtext); i++)
			{
				switch(inputtext[i])
				{
					case 'A'..'Z', 'a'..'z': agree_sym++;
					case '0'..'9': numeric++;
				}
			}
			if(strlen(inputtext) < 6 || strlen(inputtext) > 40 || agree_sym < 6 || numeric < 1)
			{
				PlayerTextDrawHide(playerid, reg[38]);
				PlayerTextDrawHide(playerid, reg[39]);
				PlayerTextDrawShow(playerid, reg[40]);
				PlayerTextDrawSetString(playerid, reg[41], "Click...");
				SetPVarString(playerid, "reg_pass", "no");
				return 1;
			}
			for(new pt; pt != strlen(inputtext); pt++)
			{
				strcat(private_text, ".");
			}
			PlayerTextDrawSetString(playerid, reg[41], private_text);
			SetPVarString(playerid, "reg_pass", inputtext);
			PlayerTextDrawShow(playerid, reg[38]);
			PlayerTextDrawShow(playerid, reg[39]);
			PlayerTextDrawHide(playerid, reg[40]);
		}
		case d_promocode:
		{
			for(new i; i < sizeof(promocodes); i++) 
				if(!strcmp(inputtext, promocodes[i], true)) { pi[playerid][promocode] = true; break; }
				else { pi[playerid][promocode] = false; continue; }
			if(pi[playerid][promocode] != true)
			{
				PlayerTextDrawHide(playerid, reg[47]);
				PlayerTextDrawHide(playerid, reg[48]);
				PlayerTextDrawShow(playerid, reg[49]);
				PlayerTextDrawSetString(playerid, reg[50], "Click...");
				return 1;
			}
			PlayerTextDrawSetString(playerid, reg[50], inputtext);
			PlayerTextDrawShow(playerid, reg[47]);
			PlayerTextDrawShow(playerid, reg[48]);
			PlayerTextDrawHide(playerid, reg[49]);
		}
		case d_referral:
		{
			if(strlen(inputtext) < 3 || strlen(inputtext) > 24)
			{
				PlayerTextDrawHide(playerid, reg[55]);
				PlayerTextDrawHide(playerid, reg[56]);
				PlayerTextDrawShow(playerid, reg[57]);
				PlayerTextDrawSetString(playerid, reg[58], "Click...");
				SetPVarString(playerid, "reg_referral", "no");
				return 1;
			}
			new mysql[39 - 2 + 24];
			mysql_format(connect, mysql, sizeof(mysql), "SELECT * FROM `accs` WHERE `nick` = '%s'", inputtext);
			mysql_tquery(connect, mysql, "checkPlayerAccountReferral", "is", playerid, inputtext);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}