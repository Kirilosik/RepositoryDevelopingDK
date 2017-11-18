// @ Digital Role Play 2017

#include <a_samp>
#include <a_mysql> // version R41.4
#include <Pawn.CMD>
//
#define publics:%0(%1)															forward %0(%1); public %0(%1)
// - - - Подключение к базе данных - - -
#define	host			"127.0.0.1"
#define	user			"root"
#define	base			"digital"
#define	pass			""

main()
{
	print("Digital Role Play created by David and Kirill");
}

enum pInfo
{
	pID,
	pName[MAX_PLAYER_NAME],
	pSex,
	pMoney,
	pRegister,
	pLevel,
	pAdmin
};

new PI[MAX_PLAYERS][pInfo];

new PlayerLogged[MAX_PLAYERS];
new connects;

public OnGameModeInit()
{
	DisableInteriorEnterExits();
	SendRconCommand("hostname « Developing Role Play 1 | Testing server");
	SendRconCommand("gamemodetext « Developing 0.1 »");
	SendRconCommand("map « San Andreas »");
	SendRconCommand("language « Russian »");
	connects = mysql_connect(host,user,base,pass);
	if(mysql_errno()==0) printf("MySQL: Подключиться к базе данных успешно выполнено!");
	else return printf("MySQL: Подключиться к базе данных не удалось!");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}
stock PKick(playerid) return SetTimerEx("PlayerKick",1000,false,"d", playerid);
publics: PlayerKick(playerid)
{
	Kick(playerid);
	return true;
}
public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}
publics: CheckRegister(playerid)
{
	new rows, fields,str[47];
	cache_get_data(rows, fields);
	if(rows)
	{
		format(str, sizeof(str),"{FFFFFF}Тут будет текстдрав, а это авторизация");
		ShowPlayerDialog(playerid,2,DIALOG_STYLE_PASSWORD,"{66CC33}Авторизация",str,"Вход","Отмена");
	}
	else
	{
		format(str, sizeof(str),"{FFFFFF}Тут будет текстдрав, а это регистрация");
		ShowPlayerDialog(playerid,1,DIALOG_STYLE_INPUT,"{66CC33}Регистрация",str,"Далее","Отмена");
	}
	return true;
}
public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, PI[playerid][pName], 24);
	new query[75];
	format(query, 64,"SELECT `Name` FROM `accounts` WHERE `Name` = '%s'", PI[playerid][pName]);
	mysql_function_query(connects, query, true, "CheckRegister","d", playerid);
	PlayerLogged[playerid] = 1;
	return 1;
}
stock OnPlayerLogin(playerid, password[])
{
    new sendername[24],query[100];
    GetPlayerName(playerid,sendername,24);
	mysql_format(connects,query, sizeof(query),"SELECT * FROM `accounts` WHERE `Name` = '%s' AND `Pass` = '%e'", sendername, password);
	mysql_function_query(connects, query, true, "GoLogin","ds", playerid, password);
	return true;
}
stock OnPlayerRegister(playerid, password[])
{
	new bac[200],query[256];
	mysql_format(connects,query,sizeof(query),"INSERT INTO `accounts` (`Name`, `Pass`) VALUES ('%s', '%e')", PI[playerid][pName], password);
	mysql_function_query(connects, query, false, "","");
	format(bac, sizeof(bac),"{FFFFFF}");
	ShowPlayerDialog(playerid,2,DIALOG_STYLE_PASSWORD,"{66CC33}Авторизация",bac,"Вход","Отмена");
	return true;
}
publics: GoLogin(playerid, password[])
{
	new rows,fields,maximum[150],stringer[30];
	cache_get_data(rows, fields);
	if(!rows)
	{
		format(stringer, sizeof(stringer), "тут тд будет. авторизация");
		ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, "{66CC33}Авторизация", stringer, "Вход", "Отмена");
	    return true;
	}
	cache_get_field_content(0, "pAdmin", maximum),PI[playerid][pAdmin] = strval(maximum);
	cache_get_field_content(0, "pLevel", maximum),PI[playerid][pLevel] = strval(maximum);
	cache_get_field_content(0, "pSex", maximum),PI[playerid][pSex] = strval(maximum);
	PlayerLogged[playerid] = 1;
	if(PlayerLogged[playerid] == 0) PKick(playerid);
	if(PI[playerid][pRegister] == 0)
	{
	    PI[playerid][pLevel] = 1;
		PI[playerid][pAdmin] = 0;
		PI[playerid][pRegister] = 1;
		SendClientMessage(playerid,0xFFD500AA,"Вы успешно прошли все этапы регистрации!");
		SpawnPlayer(playerid);
		return true;
	}
	SpawnPlayer(playerid);
	SendClientMessage(playerid,0xFFD500AA,"Вы успешно авторизовались");
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
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
	return 1;
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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new stringer[200],query[256];
	switch(dialogid)
	{
		case 1://Регистрация
		{
			if(!strlen(inputtext))
			{
			    format(stringer, sizeof(stringer),"{FFFFFF}пфу бля, регистрация");
				ShowPlayerDialog(playerid,1,DIALOG_STYLE_INPUT,"{66CC33}Регистрация",stringer,"Далее","Отмена");
				return true;
			}
			if(strlen(inputtext) < 6 ||strlen(inputtext) > 20)
			{
			    format(stringer, sizeof(stringer),"{FFFFFF}пфу бля, регистрация");
				ShowPlayerDialog(playerid,1,DIALOG_STYLE_INPUT,"{66CC33}Регистрация",stringer,"Далее","Отмена");
				return true;
			}
			OnPlayerRegister(playerid,inputtext);
			ShowPlayerDialog(playerid,3,DIALOG_STYLE_INPUT,"{66CC33}Электронная почта","пфу бля, регистрация","Далее","Отмена");
			return true;
		}
		case 2://Авторизация
		{
			if(!strlen(inputtext))
			{
				format(stringer, sizeof(stringer),"пфу бля, регистрация");
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_PASSWORD,"{66CC33}Авторизация",stringer,"Вход","Отмена");
				return true;
			}
			OnPlayerLogin(playerid,inputtext);
			return true;
		}
		case 3:
		{
		    new sabaka;
			for(new i = strlen(inputtext); i != 0; --i)
			{
				switch(inputtext[i])
				{
					case '@': sabaka++;
				}
			}
			if(strlen(inputtext) < 1 || strlen(inputtext) > 30) return ShowPlayerDialog(playerid,3,DIALOG_STYLE_INPUT,"{66CC33}Электронная почта","suda email","Далее","Отмена");
			if(sabaka == 0) return ShowPlayerDialog(playerid,3,DIALOG_STYLE_INPUT,"Электронная почта","сюда мыло вводи бля:","Готово","Отмена");
			format(query, sizeof(query), "UPDATE `accounts` SET `Email` = '%s' WHERE `Name` = '%s'",inputtext,PI[playerid][pName]);
        	mysql_function_query(connects, query, false, "", "");
			ShowPlayerDialog(playerid,4,0,"{66CC33}Выбери пол","ну пол типо выбирай","Мужской","Женский");
		}
		case 4:
		{
			if(response)
			{
				format(query, sizeof(query), "UPDATE `accounts` SET `Sex` = '1', WHERE `Name` = '%s'",PI[playerid][pName]);
				format(stringer, sizeof(stringer),"авторизация бля");
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_PASSWORD,"{66CC33}Авторизация",stringer,"Вход","Отмена");
			}
			else
			{
				format(query, sizeof(query), "UPDATE `accounts` SET `pSex` = '2', WHERE `Name` = '%s'",PI[playerid][pName]);
				format(stringer, sizeof(stringer),"авторизация бля");
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_PASSWORD,"{66CC33}Авторизация",stringer,"Вход","Отмена");
			}
			mysql_function_query(connects, query, false, "", "");
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
CMD:first(playerid) 
{ 
    SendClientMessage(playerid,0x66CC33FF,"Всё успешно работает!");
    return true; 
} 