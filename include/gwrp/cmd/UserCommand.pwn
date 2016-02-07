/***
	The MIT License (MIT)

	Copyright (c) 2014 MacMailler

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
***/

#if defined __UserCommand__
	#endinput
#endif
#define __UserCommand__


CMD:mycar(playerid, params[]) {
	return ShowExtraVehiclesMenu(playerid);
}

CMD:editgarint(playerid, params[]) {
	new house = Pl::Info[playerid][pHouseKey];
	if(!IsPlayerHouseOwner(playerid, house)) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	if(!HouseInfo[house][hgGarage]) return Send(playerid, COLOR_GREY, "* � ��� ��� �����!");
	if(!IsPlayerInHouse(playerid, 50.0, house)) return Send(playerid, COLOR_GREY, "* �� ������ ��������� � ����� ����!");
	GetPlayerPos(playerid, HouseInfo[house][hgIntPos][0], HouseInfo[house][hgIntPos][1], HouseInfo[house][hgIntPos][2]);
	GetPlayerFacingAngle(playerid, HouseInfo[house][hgIntPos][3]);
	DestroyDynamicPickup(HouseInfo[house][hgPickupInt]);
	HouseInfo[house][hgPickupInt] = CreateDynamicPickup(1318, 23, HouseInfo[house][hgIntPos][0], HouseInfo[house][hgIntPos][1], HouseInfo[house][hgIntPos][2], HouseInfo[house][hID], -1, -1, 30.0);
	UpdateHouseGarage(house);
	Send(playerid, COLOR_YELLOW, "* ����� ����������!");
	return 1;
}

CMD:editgarstreet(playerid, params[]) {
	new house = Pl::Info[playerid][pHouseKey];
	if(!IsPlayerHouseOwner(playerid, house)) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	if(!HouseInfo[house][hgGarage]) return Send(playerid, COLOR_GREY, "* � ��� ��� �����!");
	if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[house][hEnter][0], HouseInfo[house][hEnter][1], HouseInfo[house][hEnter][2])) {
		GetPlayerPos(playerid, HouseInfo[house][hgStreetPos][0], HouseInfo[house][hgStreetPos][1], HouseInfo[house][hgStreetPos][2]);
		GetPlayerFacingAngle(playerid, HouseInfo[house][hgStreetPos][3]);
		DestroyDynamicPickup(HouseInfo[house][hgPickupStreet]);
		HouseInfo[house][hgPickupStreet] = CreateDynamicPickup(1318, 23, HouseInfo[house][hgStreetPos][0], HouseInfo[house][hgStreetPos][1], HouseInfo[house][hgStreetPos][2], 0, -1, -1, 8.0);
		UpdateHouseGarage(house);
		Send(playerid, COLOR_YELLOW, "* ����� ����������!");
	} else {
		Send(playerid, COLOR_GREY, "* �� ������� ������ �� ����!");
	}
	return 1;
}

CMD:cambehind(playerid, params[]) {
	return SetCameraBehindPlayer(playerid);
}

CMD:park(playerid, params[]) {
	new hid = Pl::Info[playerid][pHouseKey];
	if(!IsPlayerHouseOwner(playerid, hid)) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	if(!(400 <= HouseInfo[hid][hvModel] <= 611)) return Send(playerid, COLOR_GREY, "* � ��� ��� �������� ������!");
	if(IsPlayerInRangeOfPoint(playerid, 50.0, HouseInfo[hid][hEnter][0], HouseInfo[hid][hEnter][1], HouseInfo[hid][hEnter][2])) {
		GetPlayerPosEx(playerid, HouseInfo[hid][hvSpawn][0], HouseInfo[hid][hvSpawn][1], HouseInfo[hid][hvSpawn][2], HouseInfo[hid][hvSpawn][3]);
		if(IsValidVehicle(HouseInfo[hid][hAuto])) {
			AutoInfo[0][aMileage] = AutoInfo[HouseInfo[hid][hAuto]][aMileage];
			Veh::Destroy(HouseInfo[hid][hAuto]);
		}
		HouseInfo[hid][hvPark] = NONE_VEHICLE;
		HouseInfo[hid][hAuto] = Veh::Create(
			HouseInfo[hid][hvModel],
			HouseInfo[hid][hvSpawn][0],
			HouseInfo[hid][hvSpawn][1],
			HouseInfo[hid][hvSpawn][2],
			HouseInfo[hid][hvSpawn][3],
			HouseInfo[hid][hvColor][0],
			HouseInfo[hid][hvColor][1],
			180000
		);
		AutoInfo[HouseInfo[hid][hAuto]][aOwner] = INVALID_PLAYER_ID * hid;
		AutoInfo[HouseInfo[hid][hAuto]][aMileage] = AutoInfo[0][aMileage];
		SetVehicleNumber(HouseInfo[hid][hAuto]);
		AddTuning(HouseInfo[hid][hAuto]);
		Rac::PutPlayerInVehicle(playerid, HouseInfo[hid][hAuto], 0);
		Send(playerid, COLOR_YELLOW, "* ������ ���� ������������ � ���� �����!");
	} else if(IsPlayerInHouseGarage(playerid)) {
		HouseInfo[hid][hvPark] = HOME_VEHICLE;
		GetPlayerPosEx(playerid, HouseInfo[hid][hvSpawn][0], HouseInfo[hid][hvSpawn][1], HouseInfo[hid][hvSpawn][2], HouseInfo[hid][hvSpawn][3]);
		if(IsValidVehicle(HouseInfo[hid][hAuto])) {
			AutoInfo[0][aMileage] = AutoInfo[HouseInfo[hid][hAuto]][aMileage];
			Veh::Destroy(HouseInfo[hid][hAuto]);
		}
		HouseInfo[hid][hAuto] = Veh::Create(
			HouseInfo[hid][hvModel],
			HouseInfo[hid][hvSpawn][0],
			HouseInfo[hid][hvSpawn][1],
			HouseInfo[hid][hvSpawn][2],
			HouseInfo[hid][hvSpawn][3],
			HouseInfo[hid][hvColor][0],
			HouseInfo[hid][hvColor][1],
			180000
		);
		AutoInfo[HouseInfo[hid][hAuto]][aOwner] = INVALID_PLAYER_ID * hid;
		AutoInfo[HouseInfo[hid][hAuto]][aMileage] = AutoInfo[0][aMileage];
		LinkVehicleToInterior(HouseInfo[hid][hAuto], 3);
		SetVehicleVirtualWorld(HouseInfo[hid][hAuto], HouseInfo[hid][hVirtual]);
		SetVehicleNumber(HouseInfo[hid][hAuto]);
		AddTuning(HouseInfo[hid][hAuto]);
		Rac::PutPlayerInVehicle(playerid, HouseInfo[hid][hAuto], 0);
		Send(playerid, COLOR_YELLOW, "* ������ ���� ������������ � ������!");
	} else {
		Send(playerid, COLOR_GREY, "* �� ������� ������ �� ����!");
	}
	return 1;
}

CMD:bl(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsAGang(playerid) && !IsAMafia(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ���� �����/�����");
	new fracid = Pl::FracID(playerid);
	if(sscanf(params, "uS(none)[36]", params[0], params[1])) {
		format(query, sizeof query, "SELECT (SELECT `Name` FROM `"#__TableUsers__"` WHERE `ID`=`accused`),`mink`,FROM_UNIXTIME(`date`),\
		(SELECT `Name` FROM `"#__TableUsers__"` WHERE `ID`=`accuser`),`reason` FROM `"#__TableBlacklist__"` WHERE `f_id`='%i'", fracid);
		Db::tquery(connDb, query, ""#Bl::"Show", "ii", playerid, fracid);
		return 1;
	}
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if((GetBRank(fracid) > Pl::Info[playerid][pRank]) && (Pl::Info[playerid][pLeader] < 1)) {
		format(string, sizeof string, "* ��� ����� ��� ������� %d-� ����!", GetBRank(fracid));
		Send(playerid, COLOR_GREY, string);
	} else {
		getname(playerid -> sendername, params[0] -> playername);
		if(strcmp(params[1], "none", false) == 0) {
			if(!Bl::Info[params[0]][Bl::onFrac][fracid]) return Send(playerid, COLOR_GREY, "* ����� ������ ��� � ����� ��!");
			Bl::Remove(params[0], fracid);
			format(string, sizeof string, "[BLACK LIST] %s %s ��������� ��� �� ������� ������ %s", RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, FracInfo[fracid][fName]);
			Send(params[0], COLOR_AZTECAS, string);
			format(string, sizeof string, "[BLACK LIST] %s %s ��������� %s �� ������� ������ %s", RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, playername, FracInfo[fracid][fName]);
			sendToFamily(fracid, COLOR_AZTECAS, string);
		} else {
			if(fracid == Pl::FracID(params[0])) return Send(playerid, COLOR_GREY, "* ��� ����������!");
			if(Bl::Info[params[0]][Bl::onFrac][fracid]) return Send(playerid, COLOR_GREY, "* ���� ����� ��� ���� � ����� ��!");
			if(strlen(params[1]) > 30) return Send(playerid, COLOR_GREY, "* ������� ������� �������!");
			Bl::Add(params[0], playerid, params[1]);
			format(string, sizeof string, "[BLACK LIST] %s %s ���� ��� � ������ ������ %s, �������: %s", RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, FracInfo[fracid][fName],params[1]);
			Send(params[0], COLOR_AZTECAS, string);
			format(string, sizeof string, "[BLACK LIST] %s %s ���� %s � ������ ������ %s, �������: %s", RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, playername, FracInfo[fracid][fName], params[1]);
			sendToFamily(fracid, COLOR_AZTECAS, string);
		}
	}
	return 1;
}
	
CMD:bmenu(playerid, params[]) {
	new bidx = GetIndexFromBizID(Pl::Info[playerid][pBizKey]);
	if(!IsPlayerBizOwner(playerid, bidx) && !IsPlayerBizExtortion(playerid, bidx)) return Send(playerid, COLOR_GREY, "* ��� �� ����������� ������!");
	return ShowDialog(playerid, D_BMENU, DIALOG_STYLE_LIST, "[Biz Menu] �������� �����", "dialog/bmenu.txt", "ENTER", "CANCLE");
}

CMD:hmenu(playerid, params[]) {
	if(!IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	return ShowDialog(playerid, D_HMENU, DIALOG_STYLE_LIST, "[House Menu]", "dialog/hmenu.txt", "ENTER", "CANCLE");
}

CMD:lmenu(playerid, params[]) {
	if(!Pl::Info[playerid][pLeader]) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	ShowLMenu(playerid);
	return 1;
}

CMD:saveme(playerid, params[]) {
	Pl::Update(playerid);
	return Send(playerid, COLOR_GREY, "* ���� ����������");
}

CMD:online(playerid, params[]) {
	ShowDialog(playerid, D_ONLINE, 2, ""#__SERVER_PREFIX""#__SERVER_NAME_LC" ������", "dialog/online.txt", "�����","������");
	return 1;
}

CMD:offline(playerid, params[]) {
	if(!Pl::isAdmin(playerid, 1) && !Pl::Info[playerid][pVip]) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	ShowDialog(playerid, D_OFFLINE, 2, ""#__SERVER_PREFIX""#__SERVER_NAME_LC": OFFLINE", "dialog/offline.txt", "�����","������");
	return 1;
}

CMD:leaders(playerid, params[]) {
	return ShowOnline(playerid,0);
}

CMD:licenzers(playerid, params[]) {
	return ShowOnline(playerid,1);
}

CMD:members(playerid, params[]) {
	return ShowOnline(playerid,2);
}

CMD:advokats(playerid, params[]) {
	return ShowOnline(playerid,3);
}

CMD:admins(playerid, params[]) {
	return ShowOnline(playerid,4);
}

CMD:helpers(playerid, params[]) {
	return ShowOnline(playerid,5);
}

CMD:lodgers(playerid, params[]) {
	return ShowOnline(playerid, 6);
}

CMD:iznas(playerid, params[]) {
	if(Pl::Info[playerid][pJailed]) return Send(playerid, COLOR_RED, "* ����� ������ ������ � ����������!");
	if(ReduceTime[playerid] == 3) return Send(playerid, COLOR_LIGHTRED, "���� ���� ���������.");
	if(sscanf(params, "u", params[0])) Send(playerid, COLOR_GREY, "�������: /iznas [id/Name]");
	if(playerid == params[0]) return Send(playerid, COLOR_RED, "* ������ ������������ ������ ����.");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(Pl::Info[params[0]][pVip] > 0) return Send(playerid, COLOR_RED, "* ��� �������� ����!");
	if(!IsPlayerInRangeOfPlayer(playerid, 2.0, params[0])) return Send(playerid, COLOR_GREY, "* ����� ������� ������!");
	
	ReduceTime[playerid] += 1;
	if(ReduceTime[playerid] >= 3) {
		SetTimerEx("ReduceTimer", 8000, false, "i", playerid);
		if(Pl::Info[playerid][pWantedL] < 3) {
			SetPlayerCriminal(playerid, params[0], "�������������");
		}
	}
	ApplyAnimation(params[0],"SNM","SPANKINGW",4.1,0,1,1,1,1);
	ApplyAnimation(playerid,"SNM","SPANKEDW",4.1,0,1,1,1,1);
	ApplyAnimation(params[0],"SNM","SPANKINGW",4.1,0,1,1,1,1,1);
	
	Send(playerid,COLOR_RED,"* �� ������������ ������!");
	Send(params[0],COLOR_RED,"* ��� ������������!");
	return 1;
}

CMD:local(playerid, params[]) { new string[144];
	format(string, sizeof string, "�� ���������� � ������� - %d", Pl::Info[playerid][pLocal]);
	return Send(playerid, 0xFF0000AA, string);
}

CMD:switchkey(playerid, params[]) {
	if(!SwitchKey[playerid]) {
		if(HireCar[playerid] == INVALID_VEHICLE_ID) return GameTextForPlayer(playerid, "~w~You do not hire a car", 5000, 6);
		SwitchKey[playerid] = true;
		GameTextForPlayer(playerid, "~w~You control now your house car", 5000, 6);
	} else {
		SwitchKey[playerid] = false;
		GameTextForPlayer(playerid, "~w~You control now your hire car", 5000, 6);
	}
	return 1;
}

CMD:givekey(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /givekey [id/Name]");
	if(HireCar[playerid] == INVALID_VEHICLE_ID && !IsValidHouse(Pl::Info[playerid][pHouseKey])) Send(playerid, COLOR_GREY, "* �� �� ������ ���� ���� � ��� ��� ���!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ����� ������� ������!");
	
	new vehicleid;
	if(HireCar[playerid] != INVALID_VEHICLE_ID && !SwitchKey[playerid]) {
		vehicleid = HireCar[playerid];
		ToggleVehicleDoor(vehicleid, true);
		HireCar[playerid] = INVALID_VEHICLE_ID;
	}
	else vehicleid = HouseInfo[Pl::Info[playerid][pHouseKey]][hAuto];

	if(HireCar[params[0]] != INVALID_VEHICLE_ID) {
		ToggleVehicleDoor(HireCar[params[0]], true);
	}
	HireCar[params[0]] = vehicleid;
	getname(playerid -> sendername, params[0] -> playername);
	format(string, sizeof string, "* �� ���� %s ���� ����� �� ������.", playername);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	Send(playerid, COLOR_GRAD1, string);
	format(string, sizeof string, "* �� �������� ����� ��� ������ �� %s", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s �������� ����� ������ � �������� �� %s.", sendername, playername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:handsup(playerid, params[]) {
	if(Pl::CuffedTime[playerid] <= 0) SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:color(playerid, params[]) { new string[144];
	new fracid = Pl::FracID(playerid);
	if(GangOnBattle[fracid] != INVALID_BIZ_ID) {
		if(IsPlayerInDynamicArea(playerid, BizzInfo[GangOnBattle[fracid]][bZahvatArea])) {
			return Send(playerid, COLOR_GREY, "* ������ ������������ ��� ������� �� ����� �������!");
		}
	}
	dialog[0]='\0';
	scf(dialog, string, "{888888}� {%06h}���� �������\n"#_GREY_ARROW"������ ����\n----------------\n", rgb<GetFracColor(fracid)>);
	for(new i; i < sizeof Colors; i++) {
		scf(dialog, string, "{888888}� {%06h}%s\n", rgb<Colors[i][e_color]>, Colors[i][e_name]);
	}
	SPD(playerid, D_COLORS, DIALOG_STYLE_LIST, ""#__SERVER_PREFIX""#__SERVER_NAME_LC": �����", dialog, "SELECT", "CANCLE");
	return 1;
}

CMD:mheal(playerid, params[]) {
	if(!IsPlayerInRangeOfPoint(playerid,4.0,366.3,158.9,1008.3)) return 1;
	if(Pl::FracID(playerid) == 7) Rac::SetPlayerHealth(playerid,100.0);
	return 1;
}

CMD:sit(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY,"* ������������ ����!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY,"�������: /sit [playerid]");
	if(Pl::CuffedTime[params[0]] <= 0) return Send(playerid, COLOR_GREY,"* ����� �� � ����������!");
	if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(params[0])) return Send(playerid, COLOR_GREY,"* �� ��� ��� ����� ���������� ��� � �����!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY,"* �� ������� ������ �� ������!");
	new vehid = ClosestVeh(playerid, 4.0);
	if(vehid != INVALID_VEHICLE_ID) {
		new seatid = GetVehicleFreeSeat(vehid);
		if(seatid) {
			Rac::PutPlayerInVehicle(params[0], vehid, seatid);
			getname(playerid -> sendername, params[0] -> playername);
			format(string, sizeof string, "* %s ������� ���� %s, � ������� � ������.", sendername, playername);
			ProxDetector(20.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		}
		else Send(playerid, COLOR_GREY,"* � ����� ��� ��������� ����!");
	}
	else Send(playerid, COLOR_GREY, "* �� �� ����� � �����������!");
	
	return 1;
}

CMD:gotome(playerid, params[]) {
	if(!IsACop(playerid)) return Send(playerid,COLOR_GREY,"* ������������ ����!");
	if(sscanf(params, "u", params[0])) return Send(playerid,COLOR_GREY,"�������: /gotome [playerid]");
	if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(params[0])) return Send(playerid,COLOR_GREY, "* �� ��� ��� ����� ���������� � �����!");
	if(Pl::CuffedTime[params[0]] <= 0) return Send(playerid,COLOR_GREY,"* ����� �� � ����������!");
	if(IsPlayerInRangeOfPlayer(playerid, 8.0, params[0])) return Send(playerid,COLOR_GREY,"* �� ������� ������ �� ������!");
	GetPlayerPos(playerid, posx, posy, posz);
	Rac::SetPlayerPos(params[0],posx+0.5, posy+0.5, posz);
	return Send(params[0],COLOR_LIGHTRED,"* ��� �������� �������� �� �����!");
}

CMD:dance(playerid, params[]) {
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
		if(sscanf(params, "d", params[0])) return Send(playerid,COLOR_GREY ,"�������: /dance [1-3]");
		if(params[0] < 1 || params[0] > 3) return Send(playerid,COLOR_GREY ,"�������: /dance [1-3]");
		switch(params[0]) {
			case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
			case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
			case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
		}
	}
	return 1;
}

CMD:pdd(playerid, params[]) {
	return ShowDialog(playerid, D_NONE, 0, "������� ��������� ��������", "dialog/help/pdd.txt", "ENTER", "");
}

CMD:pay(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(sscanf(params, "ud", params[0], params[1])) return Send(playerid, COLOR_GRAD1, "�������: /pay [playerid] [amount]");
	if(params[1] > 1000 && Pl::Info[playerid][pLevel] < 2) return Send(playerid, COLOR_GRAD1, "* �� ������ ���� 2 �������, ����� ������ ������ $1000");
	if(params[1] < 1 || params[1] > 100000) return Send(playerid, COLOR_GRAD1, "* �� ���� 1, � �� ���� 100000 �����.");
	if(params[1] > Rac::GetPlayerMoney(playerid)) return  Send(playerid,COLOR_GREY,"* � ��� ��� ������� �����!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 4.0, params[0])) return Send(playerid, COLOR_GREY, "* �� ������� ������!");
	if(params[1] > 0 && Rac::GetPlayerMoney(playerid) >= params[1]) {
		getname(playerid -> sendername, params[0] -> playername);
		Rac::GivePlayerMoney(playerid, -params[1]);
		Rac::GivePlayerMoney(params[0], params[1]);
		format(string, sizeof string, "* �� �������� $%i %s (ID: %i)", params[1], playername, params[0]);
		Send(playerid, COLOR_GRAD1, string);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);
		format(string, sizeof string, "* �� �������� $%d �� %s (������: %d).", params[1], sendername, playerid);
		Send(params[0], COLOR_GRAD1, string);
		format(string, sizeof string, "%s �������� $%d %s", sendername, params[1], playername);
		SendLog(LOG_PAY, string);
	}
	else Send(playerid, COLOR_GRAD1, "* ���������������� ������������ ����������.");
	
	return 1;
}

CMD:charity(playerid, params[]) { new string[144], sendername[24];
	if(sscanf(params, "d", params[0])) Send(playerid, COLOR_GRAD1, "* �������: /charity [amount]");
	if(params[0] < 0) return Send(playerid, COLOR_GRAD1, "* � ��� ��� �����!");
	if(Rac::GetPlayerMoney(playerid) < params[0]) return Send(playerid, COLOR_GRAD1, "* � ��� ��� ������ �������� ���������� �����.");
	Rac::GivePlayerMoney(playerid, -params[0]); GetPlayerName(playerid, sendername, 24);
	format(string, sizeof string, "* %s ������� ��� �� �������������, $%d.", sendername, params[0]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	Send(playerid, COLOR_GRAD1, string), SendLog(LOG_PAY,string);
	return 1;
}

CMD:stats(playerid, params[]) {
	return ShowStats(playerid, playerid, 0);
}

CMD:delivery(playerid, params[]) {
	if(Pl::Info[playerid][pJob] != 10) return Send(playerid,COLOR_GREY,"�� �� ������������!");
	if(GetPlayerState(playerid) != 2) return Send(playerid,COLOR_GREY,"* �� �� � ����������!");
	new veh = GetPlayerVehicleID(playerid);
	if(!IsATruckCar(veh)) return Send(playerid,COLOR_GREY,"�� �� � ����� �������������!");
	if(!IsAnyTrailerAttachedToVehicle(veh)) return Send(playerid,COLOR_GREY,"* � ��� �� ��������� ������!");
	if(acceptgruz{playerid} > 0) return Send(playerid,COLOR_GREY,"* �� ��� ����� ����");
	new rnd; do { rnd = random(sizeof(CargoInfo)); } while(!rnd);
	DestroyDynamicPickup(pickupd[playerid][0]); DestroyDynamicMapIcon(pickupd[playerid][1]); acceptgruz{playerid} = rnd;
	pickupd[playerid][0] = CreateDynamicPickup(1239, 14, CargoInfo[rnd][0], CargoInfo[rnd][1], CargoInfo[rnd][2], 0, 0, playerid, 50.0);
	pickupd[playerid][1] = CreateDynamicMapIcon(CargoInfo[rnd][0], CargoInfo[rnd][1], CargoInfo[rnd][2], 51, 0, 0, 0, playerid, 99999.9);
	Streamer::SetIntData(4, pickupd[playerid][1], E_STREAMER_STYLE, MAPICON_GLOBAL_CHECKPOINT);
	Send(playerid,COLOR_LIGHTBLUE,"���� ��������! �������� ���� �� ������!");
	return 1;
}


CMD:number(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pPhoneBook] != 1) return Send(playerid, COLOR_GREY, "* � ��� ��� ���������� �����!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GRAD1, "�������: /number [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GRAD2, "* ���� ����� �� ���������!");
	format(string, sizeof string, "Name: %s, Ph: %d", GetName(params[0]), Pl::Info[params[0]][pNumber]);
	Send(playerid, COLOR_GRAD1, string);
	return 1;
}

CMD:buylevel(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pLevel]) {
		if(Rac::GetPlayerMoney(playerid) < costlvl(playerid)) {
			format(string, sizeof string, "* � ��� ��� ������������ ���������� �������� ����� ($%d) !", costlvl(playerid));
			Send(playerid, COLOR_GRAD1, string);
		} else if (Pl::Info[playerid][pExp] < EXP(playerid)) {
			format(string, sizeof string, "* ����� %d ���������, � ��� ����� [%d] !", EXP(playerid), Pl::Info[playerid][pExp]);
			Send(playerid, COLOR_GRAD1, string);
		} else {
			Pl::Info[playerid][pAge] ++; GameTextForPlayer(playerid, string, 5000, 1);
			format(string, sizeof string, "* �� ������ ������� %d �� ($%d)", (Pl::Info[playerid][pLevel]+1), costlvl(playerid));
			Send(playerid, COLOR_LIGHTBLUE, string);
			
			format(string, sizeof string, "~g~LEVEL UP~n~~w~You Are Now Level %d", (Pl::Info[playerid][pLevel] + 1));
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); PlayerPlayMusic(playerid);
			Rac::GivePlayerMoney(playerid, -costlvl(playerid)); GiveFracMoney(7, costlvl(playerid));
			Pl::Info[playerid][pLevel]++;

			if(Pl::Info[playerid][pVip] > 0) {
				Pl::Info[playerid][pExp] -= EXP(playerid);
				if(Pl::Info[playerid][pExp] <= 0) Pl::Info[playerid][pExp] = 0;
			}
			else Pl::Info[playerid][pExp] = 0;
		}
	}
	return 1;
}


CMD:setpass(playerid, params[]) {
	SPD(playerid, D_CHANGE_PASS, DIALOG_STYLE_PASSWORD, ""#__SERVER_PREFIX""#__SERVER_NAME_LC": ATTENTION PLEASE",
	"��������! ��� ��������� ������ �� ������\n\
	�������� ���������� ������ ������� ������!\n\
	�� ������ ��������, ���� ������� �������� ������!", "��", "������");
	return 1;
}

CMD:setsex(playerid, params[]) {
	SPD(playerid, 65, DIALOG_STYLE_MSGBOX, "����� ����", "�������� ��� ���.", "�������", "������");
	return 1;
}

CMD:ad(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ��������!");
	if(Pl::Info[playerid][pJailed] != 0) return Send(playerid, COLOR_GREY, "* �� �� ������ ������������ ��� ������� � ������!");
	if(Pl::Info[playerid][pLevel] < 2) return Send(playerid, COLOR_GREY, "* ����� ������ ������� ��� ��������� 2 level!");
	if(Pl::Info[playerid][pTime] < 2) return Send(playerid, COLOR_GREY, "* �� ������ �������� 2 ���� �� �������, ����� ������������ ��� �������!");
	if(Pl::Info[playerid][pNumber] == 0) return Send(playerid, COLOR_GREY, "* � ��� ��� ��������! ������ ��� ����� � 24/7.");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /ad [�����]");
	else if(!adds && !Pl::isAdmin(playerid, 3)) {
		format(string, sizeof string, "���������� ���������� ��� ��� ����� %i ������� ����� ���������� ������������!",  (addtimer/1000));
		Send(playerid, COLOR_GRAD2, string);
	} else {
		new len = strlen(params);
		new payout = len * 25;
		if(Rac::GetPlayerMoney(playerid) < payout) {
			format(string, sizeof string, "* �� �������� %d ��������, ���������� $%d. � ��� ��� ������� �����.", len, payout);
			Send(playerid, COLOR_LIGHTBLUE, string);
		} else {
			new bidx = GetIndexFromBizID(Bizz_TelephoneCompany);
			GetPlayerName(playerid, sendername, 24);
			Rac::GivePlayerMoney(playerid, -payout);
			GiveBizzProfit(bidx, payout);
			regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
			if(Pl::FracID(playerid) == 8 && Pl::Info[playerid][pMaskOn]) {
				format(string, sizeof string, "����������: %s. �����: ����������, �������: ����������.", replacecmdtext);
			} else {
				format(string, sizeof string, "����������: %s. �����: %s, �������: %i.", replacecmdtext, sendername, Pl::Info[playerid][pNumber]);
			}
			OOCNews(COLOR_GROVE,string);
			SendLog(LOG_AD_CHAT,string);
			format(string, sizeof string, "~r~Paid $%d~n~~w~Message contained: %d Characters", payout, len);
			GameTextForPlayer(playerid, string, 7000, 5);
		}
		if(!Pl::isAdmin(playerid, MODER3LVL)) {
			adds = false;
			SetTimer("AddsOn", addtimer, false);
		}
	}
	return 1;
}

CMD:gov(playerid, params[]) { new string[144], sendername[24];
	if(IsPMuted(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /gov [�����]");
	if(Pl::Info[playerid][pLevel] < 2) return Send(playerid, COLOR_GREY, "* �� ������ ����� 3 ���!");
	new fracid = Pl::FracID(playerid);
	GetPlayerName(playerid, sendername, 24);
	switch(fracid) {
		case 1..4, 7, 10, 11 : {
			if(Pl::Info[playerid][pRank] >= GetGRank(fracid)) {
				SendToAll(COLOR_WHITE, "______________| ��������� ������� |______________");
				format(string, sizeof string, "*%s %s: %s", RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, params);
				SendToAll(COLOR_DBLUE, string);
				SendLog(LOG_GOV_CHAT, string);
			} else {
				format(string, sizeof string, "* �������� ������ � %i �����", GetGRank(fracid));
				Send(playerid, COLOR_GREY, string);
			}
		}
	}
	return 1;
}

CMD:togooc(playerid, params[]) { new string[144];
	gOoc[playerid] = !gOoc[playerid];
	format(string, sizeof string, "* ��� OOC %s!", (gOoc[playerid])?("�������"):("��������"));
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:tognews(playerid, params[]) { new string[144];
	gNews[playerid] = !gNews[playerid];
	format(string, sizeof string, "* ������� %s!", (gNews[playerid])?("��������"):("���������"));
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:togfam(playerid, params[]) { new string[144];
	gFam[playerid] = !gFam[playerid];
	format(string, sizeof string, "* ��� ����� %s!", (gFam[playerid])?("�������"):("��������"));
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:togphone(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pVip] != 1 && !Pl::isAdmin(playerid, 1)) return Send(playerid, COLOR_LIGHTRED2, "* ������������ ����!");
	PhoneOnline[playerid] = !PhoneOnline[playerid];
	format(string, sizeof string, "* ��� ������� %s!", (PhoneOnline[playerid])?("�������"):("��������"));
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:toglogins(playerid, params[]) {
	if(!Iter::Contains(ToglogPlayers, playerid)){
		Iter::Add(ToglogPlayers, playerid);
		Send(playerid, COLOR_GREY, "* ��������� � �����������/���������� ������� ��������!");
	} else {
		Iter::Remove(ToglogPlayers, playerid);
		Send(playerid, COLOR_GREY, "* ��������� � �����������/���������� ������� ���������!");
	}
	return 1;
}

CMD:me(playerid, params[]) { new string[144];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(sscanf(params, "s[90]", params[0])) return Send(playerid, COLOR_GREY, "�������: /me [�����]");
	format(string, sizeof string, "* %s %s", GetName(playerid), params[0]);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:knockdown(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(useknock[playerid] > 0) return Send(playerid, COLOR_GREY, "* ��� ������� ����� ������������ ������ ��� � 30 ���");
	if(Fell[playerid] > 0) return  Send(playerid, COLOR_GREY, "* ��� �����, � �� �� ������ ����� � ���");
	if(IsPlayerInAnyVehicle(playerid)) return Send(playerid, COLOR_GREY, "* � ���������� ������ ������������ ��� �������");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /knockdown [id/Name]");
	if(playerid == params[0]) return Send(playerid, COLOR_GREY, "* ������ ����� � ��� ������ ����!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "�� ������� ������!");
	if(IsPlayerInAnyVehicle(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� � ����������");
	new rannn = random(100);
	getname(playerid -> sendername, params[0] -> playername);
	if(rannn < 30) {
		format(string, sizeof string, "* %s ���������(���) ����� � ��� %s (��������)", Pl::Info[playerid][pMaskOn]?("����������"):(sendername), playername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	} else if(rannn >= 30) {
		format(string, sizeof string, "* %s ���������(���) ����� � ��� %s (������)", Pl::Info[playerid][pMaskOn]?("����������"):(sendername), playername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		Rac::TogglePlayerControllable(params[0], 0);
		ApplyAnimation(params[0],"PED","BIKE_fall_off",4.1,0,1,1,1,1);
		ApplyAnimation(playerid,"PED","GUN_BUTT_crouch",4.1,0,1,1,1,1);
		TurnPlayerFaceToPlayer(params[0], playerid);
		TurnPlayerFaceToPlayer(playerid, params[0]);
		Rac::GivePlayerHealth(params[0], -5.0);
		Fell[params[0]] = 5;
	}
	useknock[playerid] = 30;
	return 1;
}

CMD:do(playerid, params[]) { new string[144];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(sscanf(params, "s[90]", params[0])) return Send(playerid, COLOR_GREY, "�������: /do [�����]");
	format(string, sizeof string, "* %s (( %s ))", params[0], GetName(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:try(playerid, params[]) { new string[144], sendername[24];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /try [�����]");
	new rannn = random(100);
	GetPlayerName(playerid, sendername, 24);
	if(rannn < 25) {
		format(string, sizeof string, "* %s ��������� %s (��������)", sendername, params);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else if(rannn >= 25)
	{
		format(string, sizeof string, "* %s ��������� %s (������)", sendername, params);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	return 1;
}

CMD:b(playerid, params[]) { new string[144], sendername[24];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /b [�����]");
	if(Pl::Info[playerid][pMaskOn]) {
		format(string, sizeof string, "���������� ������: (( %s ))", params);
		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	} else {
		GetPlayerName(playerid, sendername, 24);
		format(string, sizeof string, "%s ������: (( %s ))", sendername, params);
		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	}
	return 1;
}

CMD:close(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];                                                   
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /c [�����]");
	GetPlayerName(playerid, sendername, 24);
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	format(string, sizeof string, "%s ������: %s", sendername, replacecmdtext);
	if(!IsPlayerInAnyVehicle(playerid)) {
		AnimClear[playerid] = 4;
		ApplyAnimation(playerid,"PED","IDLE_chat",4.1,0,1,1,1,1);
	}
	ProxDetector(3.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}

CMD:shout(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /s [�����]");
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	if(!Pl::Info[playerid][pMaskOn]) {
		GetPlayerName(playerid, sendername, 24);
		format(string, sizeof string, "%s �������: %s!", sendername, replacecmdtext);
		ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2);
		SetPlayerChatBubble(playerid, replacecmdtext, COLOR_GREEN, 50.0, 10000);
		if(!IsPlayerInAnyVehicle(playerid)) {
			AnimClear[playerid] = 4;
			ApplyAnimation(playerid,"ON_LOOKERS", "shout_01", 4.1, 1, 1, 1, 1, 1, 1);
		}
	} else {
		format(string, sizeof string, "����������� �������: %s!", replacecmdtext);
		ProxDetector(30.0, playerid, string,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2);
		SetPlayerChatBubble(playerid, replacecmdtext, COLOR_GREEN, 50.0, 10000);
		if(!IsPlayerInAnyVehicle(playerid)) {
			AnimClear[playerid] = 4;
			ApplyAnimation(playerid,"ON_LOOKERS", "shout_01", 4.1, 1, 1, 1, 1, 1, 1);
		}
	}
	return 1;
}

CMD:o(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ��������!");
	if(Pl::Info[playerid][pTime] < 2) return Send(playerid, COLOR_GREY, "* �� ������ �������� 2 ���� �� �������, ����� ������������ ��� �������!");
	if((noooc) && !Pl::isAdmin(playerid, 1)) return Send(playerid, COLOR_GRAD2, " OOC ��� ��������.");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GRAD2, "�����������: (/o)oc [ooc chat]");
	GetPlayerName(playerid, sendername, 24);
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	format(string, sizeof string, "(( %s[ID: %d]: %s ))", sendername, playerid, replacecmdtext);
	OOCOff(COLOR_OOC,string);
	printf("%s", string);
	return 1;
}

CMD:m(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(Pl::Info[playerid][pTime] < 2) return Send(playerid, COLOR_GREY, "* �� ������ �������� 2 ���� �� �������, ����� ������������ ��� �������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /m [�����]");
	if(!IsPlayerInAnyVehicle(playerid)) return Send(playerid, COLOR_GREY, " �� ������ ��������� � ������������ ��������");
	new fracid = Pl::FracID(playerid);
	if(!IsACop(playerid) && fracid != 4) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(!Fc::GetInfo(GetPlayerVehicleID(playerid))) return Send(playerid, COLOR_GREY, "* �� �� � ��������� ������!");
	GetPlayerName(playerid, sendername, 24);
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	format(string, sizeof string, "[%s %s %s:o< %s]", FracInfo[fracid][fTag], RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, replacecmdtext);
	ProxDetector(60.0, playerid, string,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW,COLOR_YELLOW);
	return 1;
}

CMD:r(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /r [�����]");
	if(!IsATeam(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ���� �������!");
	new fracid = Pl::FracID(playerid);
	GetPlayerName(playerid, sendername, 24);
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	format(string, sizeof string, "[R] %s %s: %s. **", RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, replacecmdtext);
	sendToFamily(fracid, COLOR_RADIO, string);
	return 1;
}

CMD:duty(playerid, params[]) { new string[144];
	if(Pl::FracID(playerid) == TEAM_COP) {
		if(IsPlayerInRangeOfPoint(playerid,3,255.3,77.4,1003.6) || IsPlayerInRangeOfPoint(playerid,3,-1616.1294,681.1594,7.1875) || Pl::Info[playerid][pLocal] != 0) {
			if(!OnDuty[playerid]) {
				OnDuty[playerid] = true;
				Rac::GivePlayerWeapon(playerid, 3, 200);
				Rac::GivePlayerWeapon(playerid, 24, 70);
				format(string, sizeof string, "* ������ %s ���� ������ � ������ �� ������ ��������.", GetName(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			} else {
				OnDuty[playerid] = false;
				Rac::ResetPlayerWeapons(playerid);
				format(string, sizeof string, "* ������ %s ����� ���� ������ � ������ � ���� �������.", GetName(playerid));
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			}
		}
		else return Send(playerid, COLOR_LIGHTRED2, "* �� �� � ����������!");
	
	} else if(Pl::FracID(playerid) == TEAM_MEDIC) {
		switch(OnDuty[playerid]) {
			case 0: {
				Medics ++;
				OnDuty[playerid] = true;
				Send(playerid, COLOR_LIGHTBLUE, "* �� ��������� �� ������!");
			}
			case 1: {
				Medics --;
				OnDuty[playerid] = false;
				Send(playerid, COLOR_LIGHTBLUE, "* �� ������ �� �� ���������!");
			}
		}
	}
	
	if(Pl::Info[playerid][pJob] == JOB_MECHANIC) {
		switch(OnDuty[playerid]) {
			case 0: {
				Mechanics ++;
				OnDuty[playerid] = true;
				Send(playerid, COLOR_LIGHTBLUE, "* �� ��������� �� ���������!");
			}
			case 1: {
				Mechanics --;
				OnDuty[playerid] = false;
				Send(playerid, COLOR_LIGHTBLUE, "* �� ������ �� �� ���������!");
			}
		}
	}
	return 1;
}


CMD:d(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /d [�����]");
	if(Pl::Info[playerid][pTime] < 1) return Send(playerid, COLOR_GREY, "* �� ������ �������� 3 ���� �� �������, ����� ������������ ��� �������!!");
	if(!IsATeam(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ���� �������!");
	new fracid = Pl::FracID(playerid);
	GetPlayerName(playerid, sendername, 24);
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	format(string, sizeof string, "[%s] %s %s: %s. **", FracInfo[fracid][fTag], RankInfo[fracid][Pl::Info[playerid][pRank]], sendername, replacecmdtext);
	sendToTeam(COLOR_ALLDEPT, string, Teams);
	return 1;
}

CMD:su(playerid, params[]) { new string[144];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������.");
	if(sscanf(params, "uis[64]", params[0], params[1], params[2])) return Send(playerid, COLOR_GRAD2, "�������: /su [id/Name] [���-�� �����] [������������]");
	if(!OnDuty[playerid] && Pl::FracID(playerid) == 1) return Send(playerid, COLOR_GREY, "* �� �� ��� ���������� ��������� ������������!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(IsACop(params[0])) return Send(playerid, COLOR_GREY, "* �� �� ������ ����������� ������������!");
	if(params[1] > 6) return Send(playerid,COLOR_GREY,"* ������ 6 ����� ������ ������!");
	if(Pl::Info[params[0]][pWantedL] == 0) {
		WantedTime[params[0]] = 180;
		SetPlayerCriminal(params[0], playerid, params[2], params[1]);
		format(string,sizeof string,"* ������ � ����� ������ %i ������� �������.", Pl::Info[params[0]][pWantedL]);
		Send(playerid, COLOR_LIGHTRED, string);
	}
	return 1;
}
CMD:mdc(playerid, params[]) { new string[144], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������.");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GRAD2, "�������: /mdc [id/Name]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!OnDuty[playerid] && Pl::FracID(playerid) == 1) return Send(playerid, COLOR_GREY, "* �� �� ��� ���������� ��������� ������������!");
	if(Pl::Info[params[0]][pWantedL] == 0) return Send(playerid, COLOR_GREY, "* ����� ��� � ���� ������!");
	new veh = GetPlayerVehicleID(playerid);
	if(IsACopCar(veh) || IsPlayerInRangeOfPoint(playerid, 5.0, 253.9280,69.6094,1003.6406)) {
		GetPlayerName(params[0], playername, 24);
		Send(playerid, COLOR_BLUE, "-=��������� ��������� ������=-");
		format(string, sizeof string, "* ���: %s", playername);
		Send(playerid, COLOR_WHITE, string);
		format(string, sizeof string, "* ������������: %s", Pl::Crime[params[0]][pAccusing]);
		Send(playerid, COLOR_GRAD2, string);
		format(string, sizeof string, "* �����������: %s", Pl::Crime[params[0]][pVictim]);
		Send(playerid, COLOR_GRAD3, string);
		format(string, sizeof string, "* ����������: %s", Pl::Crime[params[0]][pAccused]);
		Send(playerid, COLOR_GRAD4, string);
		Send(playerid, COLOR_BLUE, "");
	} else {
		Send(playerid, COLOR_GREY, "* �� �� ���������� � ����������� ������������ �������� ��� � ����������� ����������.");
	}
	return 1;
}

CMD:open(playerid, params[]) {
	if(Pl::Info[playerid][pBizKey] != INVALID_BIZ_ID || Pl::isAdmin(playerid, 4))  {
		foreach(new i : Biznes) {
			if(IsPlayerInRangeOfPoint(playerid, 3.0, BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], BizzInfo[i][bEnter][2]) || IsPlayerInBiz(playerid, 5.0, BizzInfo[i][bID])) {
				if(Pl::Info[playerid][pBizKey] == BizzInfo[i][bID] || Pl::isAdmin(playerid, 4)) {
					switch(BizzInfo[i][bLocked]) {
						case 0: {
							BizzInfo[i][bLocked] = 1;
							GameTextForPlayer(playerid, "~w~Bussiness ~r~Closed", 5000, 4);
							PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
						}
						case 1: {
							BizzInfo[i][bLocked] = 0;
							GameTextForPlayer(playerid, "~w~Bussiness ~g~Open", 5000, 4);
							PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
						}
					}
				}
				else {
					GameTextForPlayer(playerid, "~r~You Dont Have A Key", 5000, 4);
				}
				return 1;
			}
		}
	}
	
	if(Pl::Info[playerid][pHouseKey] != INVALID_HOUSE_ID || Pl::isAdmin(playerid, 4)) {
		foreach(new i : Houses) {
			if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2]) || IsPlayerInHouse(playerid, 2.0, i)) {
				if(Pl::Info[playerid][pHouseKey] == i || Pl::isAdmin(playerid, 4)) {
					switch(HouseInfo[i][hLock]) {
						case 0: {
							HouseInfo[i][hLock] = 1;
							GameTextForPlayer(playerid, "~w~Door ~r~Locked", 5000, 4);
							PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
						}
						
						case 1: {
							HouseInfo[i][hLock] = 0;
							GameTextForPlayer(playerid, "~w~Door ~g~Unlocked", 5000, 4);
							PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
						}
					}
				}
				else {
					GameTextForPlayer(playerid, "~r~You Dont Have A Key", 5000, 4);
				}
				return 1;
			}
		}
	}
	return 1;
}

CMD:pm(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(IsPMuted(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ���������!");
	if(Pl::Info[playerid][pLevel] < 2) return Send(playerid, COLOR_GREY, "* ����� ������ �� ��� ��������� 2 level!");
	if(sscanf(params, "us[90]", params[0], params[1])) return Send(playerid, COLOR_GRAD2, "�������: /w [id/Name] [�����]");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* ������ ��������� ��������� ����!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(HidePM[params[0]]) return Send(playerid, COLOR_RED, "* ������� ��������!");
	getname(playerid->sendername,params[0]->playername);
	format(string, sizeof string, "PM �� %s(ID:%i): %s", sendername, playerid, params[1]);
	Send(params[0], COLOR_YELLOW, string);
	format(string, sizeof string, "PM � %s(ID:%i): %s", playername, params[0], params[1]);
	Send(playerid, COLOR_YELLOW, string);
	PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);
	PlayerPlaySound(params[0], 1084, 0.0, 0.0, 0.0);
	printf("[PM] �� %s � %s: %s", sendername, playername, params[1]);
	return 1;
}

CMD:bar(playerid, params[]) {
	if(!IsAtBar(playerid)) return Send(playerid, COLOR_GREY, "* �� �� � ����!");
	if(Pl::Drunk[playerid] > 10) return Send(playerid, COLOR_GREY, "* ������ ������������ ��� ��������!");
	Rac::TogglePlayerControllable(playerid,0); ShowMenuForPlayer(BarMenu, playerid);
	return 1;
}

CMD:rentroom(playerid, params[]) {
	if(!Pl::Info[playerid][pPasport][0]) return Send(playerid, COLOR_GREY, "* � ��� ��� ��������!");
	if(IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) {
		Send(playerid, COLOR_WHITE, "* � ��� ��� ���� ���. ������� �������� ���: /sellhouse - ������� ��� �������!");
	} else {
		foreach(new i : Houses) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2])) {
				if(HouseInfo[i][hOwned] == 1 && HouseInfo[i][hRent][0] == 1) {
					if(Rac::GetPlayerMoney(playerid) < HouseInfo[i][hRent][1]) return SendClientMessage(playerid, COLOR_WHITE, "* � ��� �� ������� �����!");
					Pl::Info[playerid][pHouseKey] = i;
					Rac::GivePlayerMoney(playerid,-HouseInfo[i][hRent][1]);
					HouseInfo[i][hSafe][0] += HouseInfo[i][hRent][0];
					EnterHouse(playerid, i);
					GameTextForPlayer(playerid, "~g~] ~w~Welcome Home ~g~] ~w~~n~You can exit at any time by moving to this door and typing ~g~/exit", 10000, 3);
					Send(playerid, COLOR_WHITE, "* ������ /help ��� ��������� ����� �������!");
					PlayerPlayMusic(playerid);
					Pl::Update(playerid);
					Pl::SetSpawnInfo(playerid);
					
					return 1;
				}
			}
		}
	}
	return 1;
}

CMD:unrent(playerid, params[]) {
	new hidx = Pl::Info[playerid][pHouseKey];
	if(!IsValidHouse(hidx)) return Send(playerid, COLOR_GREY, "* �� �� ��������� ���!");
	if(IsPlayerHouseOwner(playerid, hidx)) return Send(playerid, COLOR_WHITE, " ��� ����������� ���� ���!");
	Pl::Info[playerid][pLocal] = 0;
	Pl::Info[playerid][pHouseKey] = INVALID_HOUSE_ID;
	if(Pl::Info[playerid][pLocal] == (OFFSET_HOUSE + hidx)) {
		ExitHouse(playerid, hidx);
	}
	Pl::SetSpawnInfo(playerid);
	Send(playerid, COLOR_WHITE, "* ������ �� ����!");
	return 1;
}

CMD:buyhouse(playerid, params[]) { new string[144], sendername[24];
	if(!Pl::Info[playerid][pPasport][0]) return Send(playerid, COLOR_GREY, "* � ��� ��� ��������!");
	if(IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) {
		Send(playerid, COLOR_GREY, "* � ��� ��� ���� ���. ������� �������� ���: /sellhouse - ������� ��� �������!");
	} else {
		for(new h = 1; h < sizeof(HouseInfo); h++) {
			if(!HouseInfo[h][hOwned] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hEnter][0], HouseInfo[h][hEnter][1], HouseInfo[h][hEnter][2])) {
				if(HouseInfo[h][hPrice] > Rac::GetPlayerMoney(playerid)) {
					Send(playerid, COLOR_LIGHTRED, "* � ��� ��� ������� �����!");
				} else {
					if(Pl::Info[playerid][pLevel] < HouseInfo[h][hLevel]) {
						format(string, sizeof string, "* ��� ����� ��������� {0080FF}%d {ffffff}��� � ����� ���-�� ������ ���� ���!", HouseInfo[h][hLevel]);
						Send(playerid, COLOR_WHITE, string);
					} else {
						new bidx = GetIndexFromBizID(Bizz_EstateAgency);
						HouseInfo[h][hOwned] = 1;
						Pl::Info[playerid][pHouseKey] = h;
						GetPlayerName(playerid, sendername, 24);
						strmid(HouseInfo[h][hOwner], sendername, 0, 24, 24);
						UpdateHousePickups(h);
						Rac::GivePlayerMoney(playerid,-HouseInfo[h][hPrice]);
						EnterHouse(playerid, h);
						GameTextForPlayer(playerid, "~g~] ~w~Welcome Home ~g~]~w~~n~You can exit at any time by moving to this door and typing ~g~/exit", 10000, 3);
						Send(playerid, COLOR_LIGHTBLUE, "* ����������� ������������� ����� ���������� � /help!");
						DateProp(playerid, 0);
						Pl::Update(playerid);
						Pl::SetSpawnInfo(playerid);
						PlayerPlayMusic(playerid);
						GiveBizzProfit(bidx, PERCENT(HouseInfo[h][hPrice], 10));
					}
				}
				
				return 1;
			}
		}
	}
	return 1;
}

CMD:changehouse(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	if(sscanf(params, "uI(0)", params[0], params[1])) return Send(playerid, COLOR_GREY, "�������: /changehouse [��/���] [������� ���]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if(GetPVarInt(playerid, "HouseBuyer") != INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* �� ��� ���������� ����� ������!");
	if(!IsPlayerInBiz(playerid, 60.0, Bizz_EstateAgency)) return Send(playerid, COLOR_GREY, "* �� ������ ��������� � �������� ������������!");
	if(!(0 <= params[1] <= (2000000 * 100))) return Send(playerid, COLOR_GREY, "* ����� ������ ���� �� $0 �� $200kk");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ����� ���!");
	SetPVarInt(playerid, "HouseBuyer", params[0]);
	SetPVarInt(params[0], "HouseSeller", playerid);
	SetPVarInt(params[0], "HouseType", 1);
	SetPVarInt(params[0], "HousePrice", params[1]);
	getname(playerid -> sendername, params[0] -> playername);
	format(string, sizeof string, "* %s ���������� ��� ��������� ������, � �������� $%i (������ /accept house ����� ����������)", sendername, params[1]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ���������� ��������� ������ %s, � �������� $%i (������ /cancel house ����� ��������)", playername, params[1]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}
	
CMD:sellhouse(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	if(sscanf(params, "ui", params[0], params[1])) return Send(playerid, COLOR_GREY, "�������: /sellhouse [��/���] [�����]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if(!IsPlayerInBiz(playerid, 60.0, Bizz_EstateAgency)) return Send(playerid, COLOR_GREY, "* �� ������ ��������� � �������� ������������!");
	if(!(1 <= params[1] <= (2000000 * 100))) return Send(playerid, COLOR_GREY, "* ����� ������ ���� �� $1 �� $200kk");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ����� ���!");
	if(GetPVarInt(playerid, "HouseBuyer") != INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* �� ��� ���������� ������� ����!");
	SetPVarInt(playerid, "HouseBuyer", params[0]);
	SetPVarInt(params[0], "HouseSeller", playerid);
	SetPVarInt(params[0], "HouseType", 0);
	SetPVarInt(params[0], "HousePrice", params[1]);
	getname(playerid -> sendername, params[0] -> playername);
	format(string, sizeof string, "* %s ���������� ��� ������ ���, �� $%i (������ /accept house ����� ����������)", sendername, params[1]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ���������� ������ ��� %s, �� $%i (������ /cancel house ����� ��������)", playername, params[1]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:buybiz(playerid, params[]) { new string[144], sendername[24];
	if(!Pl::Info[playerid][pPasport][0]) return Send(playerid, COLOR_GREY, "* � ��� ��� ��������!");
	new pbiz = GetIndexFromBizID(Pl::Info[playerid][pBizKey]);
	GetPlayerName(playerid, sendername, 24);
	if(IsPlayerBizOwner(playerid, pbiz) || IsPlayerBizExtortion(playerid, pbiz)) {
		Send(playerid, COLOR_GREY, "* � ��� ��� ���� ������. ������� �������� ���: /sellbiz - ������� ��� �������!");
	} else {
		foreach(new i : Biznes) {
			if(!BizzInfo[i][bOwned] && IsPlayerInRangeOfPoint(playerid, 2.0, BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], BizzInfo[i][bEnter][2])) {
				if(Pl::Info[playerid][pLevel] < BizzInfo[i][bLevel]) {
					format(string, sizeof string, "* �� ������ ���� ������� %d, ����� ������ ���!",BizzInfo[i][bLevel]);
					Send(playerid, COLOR_GRAD5, string);
				} else {
					if(Rac::GetPlayerMoney(playerid) >= BizzInfo[i][bPrice]) {
						BizzInfo[i][bOwned] = 1;
						Pl::Info[playerid][pBizKey] = BizzInfo[i][bID];
						strmid(BizzInfo[i][bOwner], sendername, 0, 24, 24);
						Rac::GivePlayerMoney(playerid,-BizzInfo[i][bPrice]);
						PlayerPlayMusic(playerid);
						if(BizzInfo[i][bInterior] == -1) {
							Send(playerid, COLOR_LIGHTBLUE, "* ���������� ��� � ��������");
							Send(playerid, COLOR_LIGHTBLUE, "* ������ /help ����� ����������� ����� ������� ������ ������.");
						} else {
							EnterBiz(playerid, i);
							GameTextForPlayer(playerid, "~w~Welcome~n~You can exit at any time by moving to this door and typing /exit", 5000, 3);
							Send(playerid, COLOR_LIGHTBLUE, "* ���������� ��� � ��������");
							Send(playerid, COLOR_LIGHTBLUE, "* ������ /help ����� ����������� ����� ������� ������ ������.");
						}
						UpdateBizzPickups(i);
						Pl::Update(playerid);
						Gz::ShowForAll(BizzInfo[i][bZone], GetFracColor(BizzInfo[i][bFrac]));
					} else {
						Send(playerid, COLOR_WHITE, "* � ��� ��� �������� ����� ��� �����!");
					}
				}
				return 1;
			}
		}
	}
	return 1;
}

CMD:sellbiz(playerid, params[]) { new string[144];
	new bidx = GetIndexFromBizID(Pl::Info[playerid][pBizKey]);
	if(!IsPlayerBizOwner(playerid, bidx)) return Send(playerid, COLOR_GREY, "* ��� �� ����������� ������!");
	ClearBiz(bidx);
	Pl::Info[playerid][pBizKey] = INVALID_BIZ_ID;
	new sellprice = BizzInfo[bidx][bPrice] - PERCENT(BizzInfo[bidx][bPrice], 5);
	if(sellprice > 0) Rac::GivePlayerMoney(playerid, sellprice);
	format(string, sizeof string, "~w~Congratulations~n~ You have sold your property for ~n~~g~$%d", sellprice);
	GameTextForPlayer(playerid, string, 10000, 3);
	format(string, sizeof string, "[������� ������������] ������ %s ��� ��������� �� �������! ����: $%i", BizzInfo[bidx][bDescription], BizzInfo[bidx][bPrice]);
	SendToAll(COLOR_NEWS, string);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	Pl::Update(playerid);

	return 1;
}

CMD:call(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(sscanf(params, "d", params[0])) return Send(playerid, COLOR_GRAD2, "�������: /call [����� ��������]");
	if(Pl::Info[playerid][pNumber] == 0) return Send(playerid, COLOR_GRAD2, "* � ��� ��� ��������!");
	if(params[0] == Pl::Info[playerid][pNumber]) return Send(playerid, COLOR_GRAD2, "* �� �� ������ ��������� ����");
	if(Mobile[playerid] != INVALID_PLAYER_ID) return Send(playerid, COLOR_GRAD2, "  �� ������ ���������...");
	foreach(new i: Player) {
		if(Pl::isLogged(i)) {
			if(Pl::Info[i][pNumber] == params[0]) {
				if(!PhoneOnline[i]) return Send(playerid, COLOR_GREY, "* ������� ��������!");
				if(Mobile[i] != INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ����� ������!");
				
				Mobile[playerid] = i;
				CellTime[playerid] = 1;
				
				getname(playerid -> sendername, i -> playername);
				format(string, sizeof string, "* %s ������ �� ��������", sendername);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
				format(string, sizeof string, " ��� ��������� ������ ������� (/p) ������ %s", sendername);
				Send(i, COLOR_YELLOW, string);
				format(string, sizeof string, "* %s's ������� �������� �������.", playername);
				ProxDetector(30.0, i, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				Send(playerid, COLOR_WHITE, "���������: ����������� � ��� ���� ����� ��������, ������� /h ����� �������� ������");
				
				return 1;
			}
		}
	}
	return 1;
}

CMD:anim(playerid, params[]) {
	Send(playerid, COLOR_GRAD2, "/piss /sitdown /sitdown2 /stay /upplay /droch /konch");
	return 1;
}

CMD:droch(playerid, params[]) {
	ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 10000.0, 9999, 9999, 9999, 9999, 9999);
	return 1;
}

CMD:konch(playerid, params[]) {
	ApplyAnimation(playerid, "PAULNMAC", "wank_out", 10000.0, 9999, 9999, 9999, 9999, 9999);
	return 1;
}

CMD:piss(playerid, params[]) {
	if (Pl::Info[playerid][pJailed]) return Send(playerid, COLOR_RED, "����� ������ ����� � ����������!");
	SetPlayerSpecialAction(playerid,68);
	return 1;
}

CMD:sitdown(playerid, params[]) {
	//ApplyAnimation(playerid,"FOOD","FF_Dam_Bkw",4.1,0,1,1,1,1);
	ApplyAnimation(playerid,"PED","SEAT_down",4.1,0,0,0,1,1);
	return 1;
}

CMD:sitdown2(playerid, params[]) {
	ApplyAnimation(playerid,"INT_HOUSE","LOU_In",4.1,0,0,0,1,1);
	return 1;
}

CMD:upplay(playerid, params[]) {
	ApplyAnimation(playerid,"INT_HOUSE","LOU_Out",4.1,0,1,1,1,1);
	return 1;
}

CMD:stay(playerid, params[]) {
	ApplyAnimation(playerid,"DEALER","DEALER_IDLE",4.1,0,1,1,1,1);
	return 1;
}

CMD:sms(playerid, params[]) { new string[144], sendername[24];
	if(IsPMuted(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ��������!");
	if(PlayerTied[playerid]) return Send(playerid,COLOR_GREY,"�� �������");
	if(Pl::Info[playerid][pNumber] == 0) return Send(playerid, COLOR_GRAD2, "* � ��� ��� ��������...");
	if(Pl::Info[playerid][pTime] < 1) return Send(playerid, COLOR_GREY, "* �� ������ �������� 1 ��� �� �������, ����� ������������ ��� �������!");
	if(sscanf(params, "ds[90]", params[0], params[1])) return Send(playerid, COLOR_GRAD2, "�������: /sms [phonenumber] [text]");
	if(params[0] == 0) return Send(playerid, COLOR_GREY, "* �������� �����!");
	foreach(new i: Player) {
		if(Pl::isLogged(i)) {
			if(Pl::Info[i][pNumber] == params[0]) {
				if(!PhoneOnline[i]) return Send(playerid, COLOR_GREY, "* ������� ������ ��������!");
				new bidx = GetIndexFromBizID(Bizz_TelephoneCompany);
				BizzInfo[bidx][bProds]--;
				GiveBizzProfit(bidx, BizzInfo[bidx][bEnterCost]);
				Rac::GivePlayerMoney(playerid, -BizzInfo[bidx][bEnterCost]);
				format(string, sizeof string, "~r~$-%i", BizzInfo[bidx][bEnterCost]);
				GameTextForPlayer(playerid, string, 5000, 1);
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				
				GetPlayerName(playerid, sendername, 24);
				format(string, sizeof string, "* %s �������� ������.", sendername);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				format(string, sizeof string, "*SMS: %s. �����������: %s (%d)", params[1], sendername, Pl::Info[playerid][pNumber]);
				Send(i, COLOR_YELLOW, string);
				Send(playerid, COLOR_YELLOW, "* ����� �����������");
				return 1;
			}
		}
	}
	return 1;
}

CMD:p(playerid, params[]) { new string[144], sendername[24];
	if(Mobile[playerid] != INVALID_ID) return Send(playerid, COLOR_GREY, "  �� ��� �������������� �� ��������!");
	foreach(new i: Player)
	{
		if(Pl::isLogged(i))
		{
			if(Mobile[i] == playerid)
			{
				Mobile[playerid] = i;
				Send(i, COLOR_GREY, "* �� ������ ������.");
				GetPlayerName(playerid, sendername, 24);
				format(string, sizeof string, "* %s �������� �� ������.", sendername);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
				return 1;
			}
		}
	}
	return 1;
}

CMD:h(playerid, params[]) {
	new caller = Mobile[playerid];
	if(caller != INVALID_PLAYER_ID)
	{
		if( Pl::isLogged(caller) )
		{
			CellTime[caller] = 0;
			CellTime[playerid] = 0;
			Mobile[caller] = INVALID_PLAYER_ID;
			Mobile[playerid] = INVALID_PLAYER_ID;
			Send(caller, COLOR_GRAD2, "������� ������� ������.");
			SetPlayerSpecialAction(caller,SPECIAL_ACTION_STOPUSECELLPHONE);
			Send(playerid, COLOR_GRAD2, "�� �������� ������.");
			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
			return 1;
		}
	}
	Send(playerid, COLOR_GRAD2, "��� ������� � �������.");
	
	return 1;
}

CMD:time(playerid, params[]) { new string[144];
	new h, m, s; gettime(h, m, s);
	if(Pl::Info[playerid][pJailTime] > 0) {
		format(string, sizeof string, "~w~time: ~g~%02i:%02i~n~~w~Jail Time Left: ~g~%i sec", h, m, Pl::Info[playerid][pJailTime]);
	} else {
		format(string, sizeof string, "~w~Time: ~g~%02i:%02i", h, m);
	}
	GameTextForPlayer(playerid, string, 3500, 1);
	ApplyAnimation(playerid,"COP_AMBIENT","coplook_watch",4.1,0,0,0,0,0);
	return 1;
}

CMD:heal(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::FracID(playerid) != 4) return Send(playerid, COLOR_GREY, "* �� �� �����!");
	if(sscanf(params, "ui", params[0], params[1])) return Send(playerid, COLOR_GREY, "�������: /heal [playerid] [price]");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ �������� ����!");
	if(params[1] < 1 || params[1] > 1000) return Send(playerid, COLOR_GREY, "* ��������� ���� �� ���� $1 � �� ���� $1000!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	new veh = GetPlayerVehicleID(playerid);
	if(IsPlayerInVehicle(params[0], veh) && IsAnAmbulance(veh)) {
		if(Rac::GetPlayerHealth(params[0]) >= 100.0) return Send(playerid, COLOR_GREY,"* ��� ������� ��������� �������!");
		if(Rac::GetPlayerMoney(params[0]) < params[1]) return Send(playerid, COLOR_GREY,"* ��� ������� �� ������ �������� �������!");
		Rac::SetPlayerHealth(params[0], 100.0);
		Rac::GivePlayerMoney(playerid, params[1]);
		Rac::GivePlayerMoney(params[0], -params[1]);
		getname(playerid->sendername,params[0]->playername);
		format(string, sizeof string, "* �� �������� %s �� %i$", playername, params[1]);
		Send(playerid, COLOR_LIGHTGREEN,string);
		format(string, sizeof string, "* ����� %s ������� ��� �� %i$", sendername, params[1]);
		Send(params[0], COLOR_LIGHTGREEN,string);
		PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
		PlayerPlaySound(params[0], 1150, 0.0, 0.0, 0.0);
		if(STDPlayer[params[0]] > 0) {
			STDPlayer[params[0]] = 0;
		}
	}
	else Send(playerid, COLOR_GRAD1, "* ���� �� ��� �� ��������� � ���������� ������ / �������� !");
	
	return 1;
}

CMD:gangtop(playerid, params[]) { new string[144];
	if(!IsAGang(playerid) && !Pl::isAdmin(playerid, 1)) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	Send(playerid, COLOR_WHITE, "_____________________|GANG TOP|_____________________");
	for(new i; i < sizeof(GangInfo); i++) {
		format(string, sizeof string,
			"%i. %s  [��������: %i; �������: %i; �����: $%i; ������: %i]",
			i+1,
			GetGangName(GangInfo[i][fID]),
			GangInfo[i][gRespect],
			GangBiznes{GangInfo[i][fID]},
			GetFracMoney(GangInfo[i][fID]),
			Iter::Count(TeamPlayers[GangInfo[i][fID]])
		);
		Send(playerid, GetFracColor(GangInfo[i][fID]), string);
	}
	return 1;
}

CMD:help(playerid, params[]) {
	ShowDialog(playerid, D_HELP,DIALOG_STYLE_LIST,""#__SERVER_PREFIX""#__SERVER_NAME_LC": ������", "dialog/help.txt", "�������", "�������");
	return 1;
}

CMD:skill(playerid, params[]) {
	ShowDialog(playerid, D_SKILL, DIALOG_STYLE_LIST, ""#__SERVER_PREFIX""#__SERVER_NAME_LC": SKILL", "dialog/skill.txt", "�����","������");
	return 1;
}

CMD:gl(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::FracID(playerid) != 11) return Send(playerid, COLOR_GREY, " �� �� ��������.");
	if(Pl::Info[playerid][pRank] < 2) return Send(playerid, COLOR_GREY, "* ������� �������� ����� ������ � 2-�� �����!");
	if(sscanf(params, "s[15]u", params[1], params[0])) {
		Send(playerid, COLOR_WHITE, "�������: /givelicense [license] [id/Name]");
		Send(playerid, COLOR_WHITE, "��������� ��������: Driving, Flying, Sailing, Weapon.");
		return 1;
	}
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GRAD2, "* ���� ����� �� ���������!");
	if(!Pl::Info[params[0]][pPasport][0]) return Send(playerid, COLOR_GREY, "* � ����� �������� ��� ��������!");
	getname(playerid -> sendername,params[0] -> playername);
	
	if(strcmp(params[1], "driving", true) == 0) {
		AshQueue(playerid, 1);
		Pl::Info[params[0]][pTest] = 0;
		Pl::Info[params[0]][pLic][0] = 1;
		format(string, sizeof string, "* �� ���� ������������ ����� %s.", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* �������� %s ��� ��� ������������ �����", sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
	} else {
		if(Pl::Info[playerid][pRank] > 2) {
			if(strcmp(params[1], "flying", true) == 0) {
				Pl::Info[params[0]][pLic][1] = 1;
				format(string, sizeof string, "* �� ���� �������� �� ������ %s.", playername);
				Send(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof string, "* �������� %s ��� ��� �������� �� ������.", sendername);
				Send(params[0], COLOR_LIGHTBLUE, string);
			}
			else if(strcmp(params[1], "sailing", true) == 0) {
				Pl::Info[params[0]][pLic][2] = 1;
				format(string, sizeof string, "* �� ���� �������� �� ����� %s.", playername);
				Send(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof string, "* �������� %s ��� �������� �� �����.", sendername);
				Send(params[0], COLOR_LIGHTBLUE, string);
			}
			else if(strcmp(params[1], "weapon", true) == 0) {
				format(string, sizeof string, "* �� ���� ��� �������� �� ������ %s.", playername);
				Send(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof string, "* �������� %s ��� ��� �������� �� ������.", sendername);
				Send(params[0], COLOR_LIGHTBLUE, string);
				Pl::Info[params[0]][pLic][3] = 1;
			}
		} else {
			Send(playerid, COLOR_GREY, "* �� ������ �������� ������ �����!");
		}
	}
	return 1;
}

CMD:startlesson(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::FracID(playerid) != 11) return Send(playerid, COLOR_GREY, "�� �� ��������!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /startlesson [id/Name]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if(TakingLesson[params[0]]) return Send(playerid, COLOR_GREY, "* ���� ��� �����!");
	TakingLesson[params[0]] = true;
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ������ ���� � %s's", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �������� %s ����� ��� ���� �� ��������", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:stoplesson(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::FracID(playerid) != 11) return Send(playerid, COLOR_GREY, "�� �� ��������!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /startlesson [id/Name]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if(!TakingLesson[params[0]]) return Send(playerid, COLOR_GREY, "* ���� �� ��� �����!");
	TakingLesson[params[0]] = false;
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ��������� ���� � %s's", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �������� %s �������� ��� ���� �� ��������", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:ram(playerid, params[]) {
	if(!IsACop(playerid) && !Pl::isAdmin(playerid, 4)) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	foreach(new i : Houses) {
		if(IsPlayerInRangeOfPoint(playerid,3.0,HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2])) {
			EnterHouse(playerid, i);
			GameTextForPlayer(playerid, "~r~Breached the door", 5000, 1);
		}
	}
	return 1;
}

CMD:checktax(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pLeader] != 7) return Send(playerid, COLOR_GREY, "* �� �� ���!");
	format(string, sizeof string, "* ��������������� ������ ����������: %i$", GetFracMoney(7));
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:givetax(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pLeader] != 7) return Send(playerid, COLOR_GREY, "* �� �� ���!");
	if(sscanf(params, "ii", params[0], params[1])) {
		Send(playerid, COLOR_GREY, "�������: /givetax [ID �������] [�����]");
		Send(playerid, COLOR_GREEN, ">>> ID ������� �� �������: <<");
		for(new i; i < sizeof Teams; i++) {
			format(string, sizeof string, "%i) %s", Teams[i], FracInfo[Teams[i]][fName]);
			Send(playerid, COLOR_YELLOW, string);
		}
	} else {
		if(!IsATeamF(params[0])) return Send(playerid, COLOR_GREY, "* ������� �� ���� ������������!");
		if(!(10000 <= params[1] <= 10000000)) return Send(playerid, COLOR_GREY, "* ����� ������ ���� �� $10000 �� $10000000");
		if(params[1] > GetFracMoney(TEAM_GOV)) return Send(playerid, COLOR_GREY, "* � ����� ��� ������� �����!");
		GiveFracMoney(TEAM_GOV, -params[1]);
		GiveFracMoney(params[0], params[1]);
		format(string, sizeof string, "* ���������� ������� $%i �� ���� %s", params[1], FracInfo[params[0]][fName]);
		sendToTeam(COLOR_ALLDEPT, string, Teams);
	}
	return 1;
}

CMD:settax(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pLeader] != 7) return Send(playerid, COLOR_GREY, "* �� �� ���!");
	if(sscanf(params, "i", params[0])) return Send(playerid, COLOR_GREY, "�������: /settax [ammount]");
	if(params[0] < 1 || params[0] > 20) return Send(playerid, COLOR_GREY, "* �����, ��������, �� 1 � �� 20 ���������!");
	Gm::Info[Gm::TaxValue] = params[0];
	SaveStuff();
	format(string, sizeof string, "* ������� ����� - %i ��������� �� ��������, �� ������� ������ �����.", Gm::Info[Gm::TaxValue]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:spawnchange(playerid, params[]) { new string[144];
	if(!IsValidHouse(Pl::Info[playerid][pHouseKey])) return Send(playerid, COLOR_GREY, "� ��� ��� ���� ��� �� �� ���������");
	SpawnChange[playerid] = !SpawnChange[playerid];
	Pl::SetSpawnInfo(playerid);
	format(string, sizeof string, "* �� ������ ������ ��������� %s", (SpawnChange[playerid])?("�� �������� ����� �������!"):("� ����� ��� ������������ ����!"));
	Send(playerid, COLOR_GREY, string);
	return 1;
}

CMD:report(playerid, params[]) { new string[144], sendername[24];
	if(IsPMuted(playerid)) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(sscanf(params, "s[90]", params[0])) return Send(playerid, COLOR_GREY, "�������: /report [�����]");
	if(Pl::Info[playerid][pReport] > 0) return Send(playerid, COLOR_LIGHTRED, "* �� �����!");
	Pl::Info[playerid][pReport] = 280;
	GetPlayerName(playerid, sendername, 24);
	format(string, sizeof string, "*������ �� %s[%d]: %s", sendername, playerid, params[0]);
	SendToAdmin(COLOR_LIGHTRED, string , 1, 2);
	Send(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:take(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid) && Pl::FracID(playerid) != 11) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	if(sscanf(params, "s[16]u", temp, params[0])) {
		Send(playerid, COLOR_WHITE, "|_______________ {0080ff}TAKE{ffffff} _______________|");
		Send(playerid, COLOR_WHITE, "* �����������: /take [id] [name]");
		Send(playerid, COLOR_GREY, "*  ��������: drivinglic, flyinglic, sailinglic, weaponlic");
		if(Pl::FracID(playerid) != 11) {
			Send(playerid, COLOR_GREY, "*  ������: drugs, maps, weapons.");
		}
		Send(playerid, COLOR_WHITE, "|_______________________________|");
		return 1;
	}
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GRAD2, "* ���� ����� �� ���������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* �� ������� ������ ���� �� �����!");
	getname(playerid -> sendername,params[0] -> playername);
	
	new xx[16];
	format(xx, 16, "%s", (IsACop(playerid))?("������"):("����������"));
	if(strcmp(temp,"drivinglic",true) == 0) {
		if(Pl::Info[params[0]][pLic][0] <= 0) return Send(playerid, COLOR_GREY, "* � ������ ��� ����!");
		Pl::Info[params[0]][pLic][0] = 0;
		format(string, sizeof string, "* �� ������ %s ������������ ���� **", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* %s %s �����(�) ��� ������������ ���� **", xx, sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
	}
	else if(strcmp(temp,"flyinglic",true) == 0) {
		if(Pl::Info[params[0]][pLic][1] <= 0) return Send(playerid, COLOR_GREY, "* � ������ ��� �������� ������!");
		Pl::Info[params[0]][pLic][1] = 0;
		format(string, sizeof string, "* �� ������ %s �������� �� ����� **", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* %s %s �����(�) ��� �������� �� ����� **", xx, sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
	}
	else if(strcmp(temp,"sailinglic",true) == 0) {
		if(Pl::Info[params[0]][pLic][2] <= 0) return Send(playerid, COLOR_GREY, "* � ������ ��� �������� �� ���������� ������ �����������!");
		Pl::Info[params[0]][pLic][2] = 0;
		format(string, sizeof string, "* �� ������ %s �������� �� ������ ��������� **", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* %s %s �����(�) ��� �������� �� ������ ��������� **", xx, sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
	}
	else if(strcmp(temp,"gunlic",true) == 0) {
		if(Pl::Info[params[0]][pLic][3] <= 0) return Send(playerid, COLOR_GREY, "* � ������ ��� �������� �� ������!");
		Pl::Info[params[0]][pLic][3] = 0;
		format(string, sizeof string, "* �� ������ %s �������� �� ������� ������ **", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* %s %s �����(�) ��� �������� �� ������� ������ **", xx, sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
	} else if(Pl::FracID(playerid) != 11) {
		if(strcmp(temp,"drugs",true) == 0) {
			if(Pl::Info[params[0]][pDrugs] <= 0) return Send(playerid, COLOR_GREY, "* � ������ ��� ����������!");
			Pl::Info[params[0]][pDrugs] = 0;
			format(string, sizeof string, "* �� ������������ � %s ������������� �������� **", playername);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* %s %s �����������(�) ���� ��������� **", xx, sendername);
			Send(params[0], COLOR_LIGHTBLUE, string);
		}
		else if(strcmp(temp,"mats",true) == 0) {
			if(Pl::Info[params[0]][pMats] <= 0) return Send(playerid, COLOR_GREY, "* � ������ ��� ����������!");
			Pl::Info[params[0]][pMats] = 0;
			format(string, sizeof string, "* �� ������������ � %s ��� ��������� **", playername);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* %s %s �����������(�) ���� ��������� **", xx, sendername);
			Send(params[0], COLOR_LIGHTBLUE, string);
		}
		else if(strcmp(temp,"weapons",true) == 0) {
			Rac::ResetPlayerWeapons(params[0]);
			format(string, sizeof string, "* �� ������������ � %s ��� ������ **", playername);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* %s %s �����������(�) ���� ������ **", xx, sendername);
			Send(params[0], COLOR_LIGHTBLUE, string);
		} else {
			Send(playerid, COLOR_WHITE, "|_______________ {0080ff}TAKE{ffffff} _______________|");
			Send(playerid, COLOR_WHITE, "* �����������: /take [id] [name]");
			Send(playerid, COLOR_GREY, "*  ��������: drivinglic, flyinglic, sailinglic, gunlic");
			Send(playerid, COLOR_GREY, "*  ������: drugs, maps, weapons.");
			Send(playerid, COLOR_WHITE, "|______________________________|");
		}
	} else {
		Send(playerid, COLOR_WHITE, "| {0080ff}TAKE{ffffff} |");
		Send(playerid, COLOR_WHITE, "* �����������: /take [id] [name]");
		Send(playerid, COLOR_GREY, "*  ��������: drivinglic, flyinglic, sailinglic, weaponlic");
		Send(playerid, COLOR_WHITE, "|______________________________|");
	}
	return 1;
}

CMD:music(playerid, params[]) {
	if(Pl::Info[playerid][pCDPlayer] <= 0) return Send(playerid, COLOR_GREY, "* � ��� ��� CD-�������!");
	dialog[0] = '\0';
	for(new i; i < sizeof(RadioInfo); i++) {
		scf(dialog, temp, "� %s\n", RadioInfo[i][rName]);
	}
	return SPD(playerid, D_RADIO+1, DIALOG_STYLE_LIST, "FM Player", dialog, "SELECT", "CANCEL");
}

CMD:service(playerid, params[]) {
	SPD(playerid, D_SERVICE, DIALOG_STYLE_LIST, ""#__SERVER_PREFIX""#__SERVER_NAME_LC": SERVICE", "�����\n�����\n�������", "SELECT", "CANCEL");
	return true;
}

CMD:tie(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsAMafia(playerid) && !IsAGang(playerid) && Pl::FracID(playerid) != 8) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	if(Pl::Info[playerid][pRank] < 3) return Send(playerid, COLOR_GREY, "* ��� ���� ������ ���� �� ������ 3-��!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /tie [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ ������� ����!");
	if(!IsPlayerInVehiclePlayer(playerid, params[0])) return Send(playerid, COLOR_GREY, "* �� ������ ���� � ����� ������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 4.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���!");
	if(PlayerTied[params[0]]) return Send(playerid, COLOR_GREY, "* ���� ����� ��� ������!");

	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ���� ������� %s.", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ������� %s.", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s ��������� %s.", sendername, playername);
	ProxDetector(15.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	Rac::TogglePlayerControllable(params[0], 0); PlayerTied[params[0]] = true;
	GameTextForPlayer(params[0], "~r~Tied", 3000, 3);
	
	return 1;
}

CMD:untie(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsAMafia(playerid) && !IsAGang(playerid) && Pl::FracID(playerid) != 8) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	if(Pl::Info[playerid][pRank] < 3) return Send(playerid, COLOR_GREY, "* ��� ���� ������ ���� �� ������ 3-��!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /untie [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ ��������� ����!");
	if(!PlayerTied[params[0]]) return Send(playerid, COLOR_GREY, "* ���� ����� �� ������!");
	if(!IsPlayerInVehiclePlayer(playerid, params[0])) return Send(playerid, COLOR_GREY, "* �� ������ ���� � ����� ������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���!");
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ���� ��������� %s.", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ���������� %s.", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s �������� %s", sendername, playername);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	Rac::TogglePlayerControllable(params[0], 1); PlayerTied[params[0]] = false;
	GameTextForPlayer(params[0], "~g~Untied", 3000, 3);
	
	return 1;
}

CMD:muted(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsAMafia(playerid) && IsAGang(playerid) && Pl::FracID(playerid) != 8) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	if(Pl::Info[playerid][pRank] < 3) return Send(playerid, COLOR_GREY, "* ��� ���� ������ ���� �� ������ 3-��!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /muted [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* ������ ��������??? �� ����� ����� ���������� � ��������� ������...!");
	if(!PlayerTied[params[0]]) return Send(playerid, COLOR_GREY, "* ����� �� ������!");
	if(Gag[params[0]]) return Send(playerid, COLOR_GREY, "* � ����� ������ ��� ���� ���� �� ���!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���!");
	if(!IsPlayerInVehiclePlayer(playerid, params[0])) return Send(playerid, COLOR_GREY, "* �� ������ ���� � ����� ������!");
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* %s �������� ��� ���� � ���", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ��������� ���� � ��� %s.", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s ���������� ���� � ��� %s", sendername, playername);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	Gag[params[0]]=true; GameTextForPlayer(params[0], "~r~Muted", 30000, 3);
	
	return 1;
}

CMD:unmuted(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsAMafia(playerid) && IsAGang(playerid) && Pl::FracID(playerid) != 8) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	if(Pl::Info[playerid][pRank] < 3) return Send(playerid, COLOR_GREY, "* ��� ���� ������ ���� �� ������ 3-��!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /muted [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* ������ ��������??? �� ����� ����� ���������� � ��������� ������...!");
	if(!PlayerTied[params[0]]) return Send(playerid, COLOR_GREY, "* ����� �� ������!");
	if(!Gag[params[0]]) return Send(playerid, COLOR_GREY, "* � ����� ������ ��� ����� �� ���!");
	if(!IsPlayerInVehiclePlayer(playerid, params[0])) return Send(playerid, COLOR_GREY, "* �� ������ ���� � ����� ������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���!");
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* %s ������� �� ������ ��� ����", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� �������� ���� ��� ��� %s.", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s ����������� ���� ��� ��� %s ", sendername, playername);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	Gag[params[0]]=false; GameTextForPlayer(params[0], "~g~Unmuted", 3000, 3);

	return 1;
}

CMD:towcar(playerid, params[]) { new string[144];
	new house = Pl::Info[playerid][pHouseKey];
	if(!IsPlayerHouseOwner(playerid, house)) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
	new bidx = GetIndexFromBizID(Bizz_HouseService);
	if(BizzInfo[bidx][bProds] == 0) return GameTextForPlayer(playerid, "~r~Out Of Stock", 5000, 1);
	if(Rac::GetPlayerMoney(playerid) < BizzInfo[bidx][bEnterCost]) return Send(playerid, COLOR_GREY, "* � ��� ��� ������� �����!");
	if(GetVehiclePassengers(HouseInfo[house][hAuto])) return GameTextForPlayer(playerid, "~w~Car is~n~in ~r~use", 5000, 1);
	
	SetVehicleToRespawn(HouseInfo[house][hAuto]);
	Rac::GivePlayerMoney(playerid,-BizzInfo[bidx][bEnterCost]);
	GiveBizzProfit(bidx, BizzInfo[bidx][bEnterCost]);
	BizzInfo[bidx][bProds]--;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	format(string, sizeof string, "~w~Car~n~~g~Towed Home~n~~r~-$%d", BizzInfo[bidx][bEnterCost]);
	GameTextForPlayer(playerid, string, 5000, 1);
	
	return 1;
}

CMD:fare(playerid, params[]) { new string[144];
	if(Pl::FracID(playerid) != 10 && Pl::Info[playerid][pJob] != 9) return Send(playerid,COLOR_GREY,"* �� �� ������� / �������� ��������!");
	new Veh = GetPlayerVehicleID(playerid);
	if(TransportDuty[playerid] > 0) {
		TaxiDrivers --;
		TransportDuty[playerid] = 0;
		DestroyDynamic3DTextLabel(AttachText[Veh]);
		DestroyDynamicRaceCP(checkpointb[playerid]);
		Rac::GivePlayerMoney(playerid, TransportMoney[playerid]);
		format(string, sizeof string, "* �� ���������� $%d", TransportMoney[playerid]);
		Send(playerid, COLOR_LIGHTBLUE, string);
		TransportValue[playerid] = 0;
		TransportMoney[playerid] = 0;
	}
	else if(IsATaxiCar(Veh)) {
		if(GetPlayerState(playerid) != 2) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
		if(sscanf(params, "i", params[0])) return Send(playerid, COLOR_WHITE, "�������: /fare [price]");
		if(params[0] < 1 || params[0] > 1000) return Send(playerid, COLOR_GREY, " * ����� �� ������ ���� ������ $1 � �� ������ ��������� $1000!");
		TaxiDrivers ++;
		TransportDuty[playerid] = 1;
		TransportValue[playerid] = params[0];
		GetPlayerName(playerid, plname, 24);
		DestroyDynamic3DTextLabel(AttachText[Veh]);
		format(string, sizeof string, "�� S.A.T.C.C ��\n�� �����: %s\n�����: $%d", plname, TransportValue[playerid]);
		AttachText[Veh] = Add3DText(string, COLOR_TAXI_PRICE, 0.0, 0.0, 1.3, 20.0, INVALID_PLAYER_ID, Veh, 0, 0, 0, -1);
	}
	else if(IsABusCar(Veh)) {
		if(GetPlayerState(playerid) != 2) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
		if(sscanf(params, "i", params[0])) return Send(playerid, COLOR_WHITE, "�������: /fare [price]");
		if(params[0] < 1 || params[0] > 1000) return Send(playerid, COLOR_GREY, " * ����� �� ������ ���� ������ $1 � �� ������ ��������� $1000!");
		
		BusDrivers ++;
		TransportDuty[playerid] = 2;
		TransportValue[playerid] = params[0];

		DestroyDynamicRaceCP(checkpointb[playerid]);
		DestroyDynamic3DTextLabel(AttachText[Veh]);
		
		dialog[0]='\0';
		for(new i; i < sizeof BusRoute; i++) {
			scf(dialog, string, "%s "#_GREY_ARROW" %s\n", BusRoute[i][0][stopName], BusRoute[i][BusRouteCount[i]-1][stopName]);
		}
		SPD(playerid, D_FARE, DIALOG_STYLE_LIST, "�������� �������", dialog, "SELECT", "CANCEL");
	}
	return 1;
}

CMD:licenses(playerid, params[]) { new string[144];
	static const lic[][] = { "�����������", "�������" };
	Send(playerid, COLOR_WHITE, "____________| Licenses |____________");
	sendf(playerid, string, COLOR_GREY, "** ������������ �����: *%s.", lic[Pl::Info[playerid][pLic][0]]);
	sendf(playerid, string, COLOR_GREY, "** �������� �� ������ � �����: *%s.", lic[Pl::Info[playerid][pLic][1]]);
	sendf(playerid, string, COLOR_GREY, "** �������� �� ������� ���������: *%s.", lic[Pl::Info[playerid][pLic][2]]);
	sendf(playerid, string, COLOR_GREY, "** �������� �� ������: *%s.", lic[Pl::Info[playerid][pLic][3]]);
	Send(playerid, COLOR_WHITE, "||");
	return 1;
}

CMD:sl(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_WHITE, "�������: /sl [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ �������� �������� ����. �����������: /licenses!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ����� �� ����� ���!");
	getname(playerid -> sendername, params[0] -> playername);
	
	static const lic[][] = { "�����������", "�������" };
	sendf(params[0], string, COLOR_WHITE, "____________| �������� %s |____________", sendername);
	sendf(params[0], string, COLOR_GREY, "** ������������ �����: *%s.", lic[Pl::Info[playerid][pLic][0]]);
	sendf(params[0], string, COLOR_GREY, "** �������� �� ������ � �����: *%s.", lic[Pl::Info[playerid][pLic][1]]);
	sendf(params[0], string, COLOR_GREY, "** �������� �� ������� ���������: *%s.", lic[Pl::Info[playerid][pLic][2]]);
	sendf(params[0], string, COLOR_GREY, "** �������� �� ������: *%s.", lic[Pl::Info[playerid][pLic][3]]);
	sendf(params[0], string, COLOR_LIGHTBLUE, "* %s �������(�) ��� ���� ��������.", sendername);
	sendf(playerid,  string, COLOR_LIGHTBLUE, "* �� �������� ���� �������� %s.", playername);
	return 1;
}

CMD:pas(playerid, params[]) { new string[144];
	if(!Pl::Info[playerid][pPasport][0]) return Send(playerid, COLOR_GREY, "* � ��� ��� ��������!");
	if(sscanf(params, "u", params[0])) return ShowPass(playerid, playerid, D_NONE);
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ����� � ����!");
	ShowPass(playerid, params[0], D_NONE);
	if(playerid != params[0]) {
		format(string, sizeof string, "* %s ������� ���� ������� ���.", GetName(playerid));
		Send(params[0], COLOR_LIGHTBLUE, string);
	}
	return 1;
}

CMD:frisk(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_WHITE, "�������: /frisk [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "�� �� ������ �������� ����!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ����� ���!");
	
	dialog[0]='\0';
	strcat(dialog, Pl::Info[params[0]][pDrugs] 	 > 0 ? (""#_GREY_ARROW" ���������\n") : (""#_GREY_ARROW" �����\n"));
	strcat(dialog, Pl::Info[params[0]][pMats]      > 0 ? (""#_GREY_ARROW" ���������\n") : (""#_GREY_ARROW" �����\n"));
	strcat(dialog, Pl::Info[params[0]][pCDPlayer]  > 0 ? (""#_GREY_ARROW" CD-������\n") : (""#_GREY_ARROW" �����\n"));
	strcat(dialog, Pl::Info[params[0]][pPhoneBook] > 0 ? (""#_GREY_ARROW" ���������� �����\n") : (""#_GREY_ARROW" �����\n"));
	scf(dialog, string, ""#_GREY_ARROW" ��������: %d$\n", Rac::GetPlayerMoney(params[0]));
	strcat(dialog, "{888888}�\n{888888}�������������[{FFFFFF}������{888888}]������������\n");

	new weapon, ammo, WeapName[40];
	for(new i = 0; i < 12; i++) {
		GetPlayerWeaponData(params[0], i, weapon, ammo);
		if(weapon != 0) {
			GetWeaponName(weapon, WeapName, sizeof WeapName);
			scf(dialog, string,""#_GREY_ARROW" %s | �������: %i\n",WeapName, ammo);
		}
	}
	getname(playerid -> sendername, params[0] -> playername);
	format(string, sizeof string, "������� %s", playername);
	SPD(playerid, D_NONE, DIALOG_STYLE_LIST, string, dialog, "CANCEL", "");
	
	format(string, sizeof string, "* %s ������� %s", sendername, playername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	return 1;
}

CMD:sellcar(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pJob] != 8) return Send(playerid,COLOR_GREY,"* �� �� ����� �� ������� �������� �����������!");
	if(!IsPlayerInAnyVehicle(playerid)) return Send(playerid,COLOR_GREY,"* �� �� ���������� � ���������!");
	if(sscanf(params, "ui", params[0], params[1])) return Send(playerid, COLOR_GREY, "�������: /sellvcar [playerid] [price]");
	if(params[1] < 1 || params[1] > 99999) return Send(playerid, COLOR_GREY, "* ���� �� ���� 1$ � �� ���� 99999$ !");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ ������� ���� ����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���!");
	if(CarCalls[params[0]] > 0) return Send(playerid, COLOR_GREY, "* ���� ����� ��� ����� ����������, �� ������ ������������ /callcar ������� !");
	format(string, sizeof string, "* �� ����������� ��������� %s ������ ������ �� $%d .", GetName(params[0]), params[1]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ����� �� ������� �������� ����������� %s ����� ������� ��� ���� ���������� �� $%d, (��� /accept car) �������.", GetName(playerid), params[1]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	CarOffer[params[0]] = playerid;
	CarPrice[params[0]] = params[1];
	CarID[params[0]] = GetPlayerVehicleID(playerid);
	return 1;
}

CMD:mats(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pJob] != 7) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(sscanf(params, "s[10]I(0)", temp, params[0])) {
		Send(playerid, COLOR_WHITE, "�������: /mats [name]");
		Send(playerid, COLOR_WHITE, "* ��������� ��������: Get, Deliver.");
	} else {
		if(strcmp(temp, "get", false) == 0) {
			if(params[0] < 1 || params[0] > 10) return Send(playerid, COLOR_GREY, "* ����� ������ �� ����� ���� ���� 1 ��� ���� 10!");
			if(!IsPlayerInRangeOfPoint(playerid,3.0,597.3430,-1248.6998,18.2804)) return Send(playerid, COLOR_GREY, "* �� �� � ������ ������� ���������� � ��� �������!");
			if(MatsHolding[playerid] >= 10) return Send(playerid, COLOR_GREY, "* �������� ����� ����� 10 �������!");
			new price = (params[0] * 100);
			if(Rac::GetPlayerMoney(playerid) < price) return Send(playerid, COLOR_GREY, "* � ��� �� ������� ������!");
			new bidx = GetIndexFromBizID(Bizz_RifaSklad);
			Rac::GivePlayerMoney(playerid, -price);
			MatsHolding[playerid] = params[0];
			GiveBizzProfit(bidx, price+1000);
			format(string, sizeof string, "* �� ������ %d ������� ���������� �� $%d.", params[0], price);
			Send(playerid, COLOR_LIGHTBLUE, string);
		
		} else if(strcmp(temp, "deliver", false) == 0) {
			if(!IsPlayerInRangeOfPoint(playerid,3.0,-2115.7246,-78.0859,35.3203)) return Send(playerid, COLOR_GREY, "* �� �� �� ������� ���������� � ��� �����!");
			if(MatsHolding[playerid] <= 0) return Send(playerid, COLOR_GREY, "* � ��� ��� �����!");
			new bidx = GetIndexFromBizID(Bizz_RifaSklad);
			new payout = (50 * MatsHolding[playerid]);
			if(BizzInfo[bidx][bProds] < payout) return Send(playerid, COLOR_GREY, "* �� ������� � ������ ������ ��� ����������!");
			format(string, sizeof string, "* ������� ���� ��� %d ���������� ��� ����� %d ������� ����������.", payout, MatsHolding[playerid]);
			BizzInfo[bidx][bProds] -= payout;
			Pl::Info[playerid][pMats] += payout;
			MatsHolding[playerid] = 0;
			Send(playerid, COLOR_LIGHTBLUE, string);
		
		} else {
			Send(playerid, COLOR_WHITE, "* ��������� ��������: Get, Deliver.");
		}
	}
	return 1;
}

CMD:buymats(playerid, params[]) { new string[144];
	if(Pl::FracID(playerid) != 17) return Send(playerid, COLOR_GREY, "* �� �� ������ �������� ���������!");
	new tmpcar = GetPlayerVehicleID(playerid);
	if(GetVehicleModel(tmpcar) != 482) return Send(playerid, COLOR_GREY, "* ���� ��������� �� ������������ ��� ��������� ����������!");
	if(sscanf(params, "d", params[0])) return Send(playerid, COLOR_GREY, "�������: /buymats [���-�� �����]");
	if(!IsPlayerInRangeOfPoint(playerid,25.0, 2801.3, -2356.3, 13.3)) return Send(playerid, COLOR_GREY, "* �� �� � ����� ��� �������!");
	if(!IsATruckrifa(tmpcar)) return Send(playerid, COLOR_GREY, "* ��� ������ �� ������������� ��� ��������� ����������!");
	if(AutoInfo[tmpcar][aMats] >= AutoInfo[tmpcar][aMaxMats]) return Send(playerid, COLOR_GREY, "* ��� ������ �����������!");
	if(GetPlayerState(playerid) != 2) {
		format(string, sizeof string, "* ���������: %d/%d.", AutoInfo[tmpcar][aMats], AutoInfo[tmpcar][aMaxMats]);
		return Send(playerid, COLOR_LIGHTGREEN, string);
	}
	if(params[0] > 2000) return Send(playerid,COLOR_GREY,"* ������ 2000 ���������� ������ ������!");
	params[2] = params[0]*10;
	if(Rac::GetPlayerMoney(playerid) < params[2]) return Send(playerid,COLOR_GREY,"* � ��� ��������� �����!");
	if(AutoInfo[tmpcar][aMats]+params[0] > AutoInfo[tmpcar][aMaxMats]) return Send(playerid,COLOR_GREY,"* �� ���� ��� ����� ����� 2000 ����������!");
	AutoInfo[tmpcar][aMats] += params[0];
	format(string, sizeof string, "* ���������: %d/%d.", AutoInfo[tmpcar][aMats], AutoInfo[tmpcar][aMaxMats]);
	Send(playerid, COLOR_GREEN, string);
	format(string, sizeof string, "* �� ����� %d ���������� �� $%d.", AutoInfo[tmpcar][aMats], params[2]);
	Send(playerid, COLOR_GREEN, string);
	Rac::GivePlayerMoney(playerid,-params[2]);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	return 1;
}

CMD:sellmats(playerid, params[]) { new string[144];
	if(Pl::FracID(playerid) != 17) return Send(playerid, COLOR_GREY, "* �� �� ������ ��������� ���������!");
	if(!IsPlayerInRangeOfPoint(playerid,25.0,-2115.4,-175.8,35.3)) return Send(playerid, COLOR_GREY, "* ��  �� � ����� ������� ����������!");
	new tmpcar = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != 2) return Send(playerid,COLOR_LIGHTRED2,"* �� �� ��������!");
	if(AutoInfo[tmpcar][aMats] <= 0) return Send(playerid,COLOR_LIGHTRED2,"* � ����� ������ ���� ����������!");
	new bidx = GetIndexFromBizID(Bizz_RifaSklad);
	if(BizzInfo[bidx][bProds] >= BizzInfo[bidx][bMaxProds]) return Send(playerid, COLOR_GREY, "* ������� �����������!");
	new cash = AutoInfo[tmpcar][aMats]*17;
	BizzInfo[bidx][bProds] += AutoInfo[tmpcar][aMats];
	format(string, sizeof string, "* �� ������� %d ���������� ������� �� $%d", AutoInfo[tmpcar][aMats], cash);
	Send(playerid, COLOR_GREEN, string);
	Rac::GivePlayerMoney(playerid, cash);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	AutoInfo[tmpcar][aMats] = 0;
	return 1;
}

CMD:buyprods(playerid, params[]) { new string[144];
	if(sscanf(params, "i", params[0])) {
		Send(playerid, COLOR_GREY, "�������: /buyprods [amount]");
	} else {
		if(params[0] < 1 || params[0] > 150) {
			Send(playerid, COLOR_GREY, "* ������ ������ ������ 1-�� �������� ��� ����� 150-��");
		} else {
			new vehid = GetPlayerVehicleID(playerid);
			if(vehid && GetPlayerState(playerid) == 2) {
				if(IsACompTruck(vehid)) {
					if(PlayerHaul[vehid-comptruck[0]][pLoad] < PlayerHaul[vehid-comptruck[0]][pCapasity]) {
						foreach(new i : Biznes) {
							if(IsPlayerInSquare2D(playerid, 50.0, BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], 0)) {
								if(BizzInfo[i][bID] == Bizz_ProdSkladLS || BizzInfo[i][bID] == Bizz_ProdSkladSF) {
									new check = PlayerHaul[vehid-comptruck[0]][pLoad] + params[0];
									if(check > PlayerHaul[vehid-comptruck[0]][pCapasity]) {
										Send(playerid, COLOR_GREY, "* ������� �� ������ � ��������!");
									} else {
										new cost = params[0]*50;
										if(Rac::GetPlayerMoney(playerid) >= cost) {
											PlayerHaul[vehid-comptruck[0]][pLoad] += params[0];
											format(string, sizeof string, "* �� ������ %d ��������� �� $%d.", params[0], cost);
											Send(playerid, COLOR_GREEN, string);
											Rac::GivePlayerMoney(playerid,-cost);
											PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
										} else {
											format(string, sizeof string, "�� �� ������ ��������� ���� %d ��������� �� $%d!", params[0], cost);
											Send(playerid, COLOR_GREEN, string);
										}
									}
									return 1;
								}
							}
						}
					} else {
						Send(playerid,COLOR_GREY,"* �������� �����!");
					}
				} else {
					Send(playerid,COLOR_GREY,"* �� ������ ���� � ��������� ��� ������� ���������");
				}
			} else {
				Send(playerid,COLOR_GREY,"* �� ������ ���� � ��������� ��� ������� ���������");
			}
		}
	}
	return 1;
}

CMD:sellprods(playerid, params[]) { new string[144];
	new vehid = GetPlayerVehicleID(playerid);
	if(vehid && GetPlayerState(playerid) == 2) {
		if(IsACompTruck(vehid)) {
			if(PlayerHaul[vehid-comptruck[0]][pLoad] <= 0) {
				GameTextForPlayer(playerid, "~r~Truck is empty, return to the stock house", 5000, 1);
			} else {
				foreach(new i : Biznes) {
					if(IsPlayerInRangeOfPoint(playerid, 10.0, BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], BizzInfo[i][bEnter][2])) {
						if(BizzInfo[i][bID] != 56 && BizzInfo[i][bID] != 74 && BizzInfo[i][bID] != 47) {
							new cashmade;
							for(new l = PlayerHaul[vehid-comptruck[0]][pLoad]; l > 0; l--) {
								if(BizzInfo[i][bProds] == BizzInfo[i][bMaxProds]) {
									GameTextForPlayer(playerid, "~r~Our stores are full", 5000, 1);
									format(string, sizeof string, "����������: $%d.", cashmade);
									Send(playerid, COLOR_GREEN, string);
									PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
									return 1;
								}
								if(BizzInfo[i][bPriceProd] > BizzInfo[i][bSafe]) {
									GameTextForPlayer(playerid, "~r~We Cant Afford The Deal", 5000, 1);
									format(string, sizeof string, "����������: $%d.", cashmade);
									Send(playerid, COLOR_GREEN, string);
									PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
									return 1;
								}
								BizzInfo[i][bProds]++;
								PlayerHaul[vehid-comptruck[0]][pLoad]--;
								cashmade = cashmade+BizzInfo[i][bPriceProd];
								Rac::GivePlayerMoney(playerid,BizzInfo[i][bPriceProd]);
								BizzInfo[i][bSafe] -= BizzInfo[i][bPriceProd];
								if(PlayerHaul[vehid-comptruck[0]][pLoad] == 0) {
									GameTextForPlayer(playerid, "~r~Truck is empty, return to the stock house", 5000, 1);
									format(string, sizeof string, "����������: $%d.", cashmade);
									Send(playerid, COLOR_GREEN, string);
									PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
									return 1;
								}
							}
						}
						return 1;
					}
				}
			}
		} else {
			Send(playerid,COLOR_GREY,"* �� ������ ���� � ��������� ��� ������� ���������");
		}
	} else {
		Send(playerid,COLOR_GREY,"* �� ������ ���� � ��������� ��� ������� ���������");
	}
	return 1;
}

CMD:loadmats(playerid, params[]) { new string[144];
	new bidx = GetIndexFromBizID(Bizz_RifaSklad);
	format(string, sizeof string, "* �� ������� %i/%i ����������.",
	BizzInfo[bidx][bProds], BizzInfo[bidx][bMaxProds]);
	Send(playerid, COLOR_GREEN, string);
	return 1;
}

CMD:loadmac(playerid, params[]) { new string[144];
	if(!isPlayerInPickup(playerid,barn[0])) return Send(playerid,COLOR_LIGHTRED2,"* �� �� � ������!");
	format(string, sizeof string, "* � ������ %d �����", Gm::Info[Gm::AmbarDrugs]);
	Send(playerid,COLOR_LIGHTBLUE,string);
	format(string, sizeof string, "* � ������� %d �����", Gm::Info[Gm::PritonDrugs]);
	Send(playerid,COLOR_LIGHTBLUE,string);
	
	return 1;
}

CMD:sellgun(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::Info[playerid][pJob] != 7) return Send(playerid,COLOR_GREY,"* �� �� ��������!");
	if(sscanf(params, "s[15]u", temp, params[0])) {
		return ShowDialog(playerid, D_NONE, 0, "� SellGun � Info", "dialog/sellgun.txt", "OK", "");
	}
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* �� ������ �� ����� ������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ ������� ������ ����!");
	new weapon, ammo, price;
	getname(playerid->sendername,params[0]->playername);
	if(!GetGunInfo(temp, weapon, ammo, price)) return Send(playerid,COLOR_GREY,"* ���������������� �������� ������!");
	if(price > Pl::Info[playerid][pMats]) return Send(playerid,COLOR_GREY,"* ������������ ���������� ��� ����� ������!");
	Rac::GivePlayerWeapon(params[0], weapon, ammo);
	Pl::Info[playerid][pMats] -= price;
	
	format(string, sizeof string, "* �� ���� %s, %s � %i ������������, ��� %i ����������.", playername, temp, ammo, price);
	Send(playerid, COLOR_GREY, string);
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	format(string, sizeof string, "* �� �������� %s � %i ������������ �� %s.", temp, ammo, sendername);
	Send(params[0], COLOR_GREY, string);
	PlayerPlaySound(params[0], 1052, 0.0, 0.0, 0.0);
	format(string, sizeof string, "* %s ���� ������ �� ����������, � ������� � ���� %s.", sendername, playername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	
	return 1;
}

CMD:get(playerid, params[]) { new string[144];
	if(sscanf(params, "s[16]I(0)", params[1], params[0])) {
		Send(playerid, COLOR_WHITE, " {0080ff}��������{ffffff} ");
		Send(playerid, COLOR_GREY, "�������: /get [name]");
		Send(playerid, COLOR_GREY, " ��������� ��������: Drugs, Fuel");
	} else {
		if(strcmp(params[1], "drugs", false) == 0) {
			if(Pl::Info[playerid][pJob] != 4) return Send(playerid, COLOR_GREY, "* �� �� ����������!");
			if(Pl::Info[playerid][pDrugs] > 15) return Send(playerid, COLOR_GREY, "* � ��� ��� ���� ���������, �������� �� �������!");
			if(!IsPlayerInRangeOfPoint(playerid, 2.0, 323.0342,1118.5804,1083.8828)) return Send(playerid, COLOR_GREY, "* �� �� � �������!");
			if((Gm::Info[Gm::PritonDrugs] - params[0]) < 0) return Send(playerid, COLOR_GREY,"* � ������� ��������� ����������.");
			new tel, price;
			switch(Pl::Info[playerid][pSkill][7]) {
				case 0..50 : {
					tel = 200;
					if(params[0] < 1 || params[0] > 6) return Send(playerid, COLOR_GREY, "* �� ������ � ����� ������ �� 1 �� 6 ������� ����������");
				}
				case 51..100 : {
					tel = 150;
					if(params[0] < 1 || params[0] > 12) return Send(playerid, COLOR_GREY, "* �� ������ � ����� ������ �� 1 �� 12 ������� ����������!");
				}
				case 101..200 : {
					tel = 100;
					if(params[0] < 1 || params[0] > 20) return Send(playerid, COLOR_GREY, "* �� ������ � ����� ������ �� 1 �� 20 ������� ����������");
				}
				case 201..400 : {
					tel = 50;
					if(params[0] < 1 || params[0] > 30) return Send(playerid, COLOR_GREY, "* �� ������ � ����� ������ �� 1 �� 30 ������� ����������");
				}
				case 401 : {
					tel = 10;
					if(params[0] < 1 || params[0] > 99) return Send(playerid, COLOR_GREY, "* �� ������ � ����� ������ �� 1 �� 99 ������� ����������");
				
				}
			}
			price = ( params[0] * tel );
			if(Rac::GetPlayerMoney(playerid) < price) return Send(playerid, COLOR_GREY, "* � ��� ��������� �����");
			format(string, sizeof string, "* �� ������ %d ����� �� $%d.", params[0], price);
			Send(playerid, COLOR_LIGHTBLUE, string);
			Rac::GivePlayerMoney(playerid, -price);
			Pl::Info[playerid][pDrugs] = Pl::Info[playerid][pDrugs] + params[0];
			Gm::Info[Gm::PritonDrugs] -= params[0];
			
		} else if(strcmp(params[1], "fuel", false) == 0) {
			new gas;
			if((gas = GetClosestGas(playerid)) == -1) return Send(playerid,COLOR_GREY,"* �� �� �� ������������!");
			if(Rac::GetPlayerMoney(playerid) < 40) return Send(playerid,COLOR_GREY,"* � ��� �� ������� �����!");
			new bidx = GetIndexFromBizID(RefillInfo[gas][brBizID]);
			if(BizzInfo[bidx][bProds] <= 0) return GameTextForPlayer(playerid, "~r~Out of stock", 5000, 1);
			BizzInfo[bidx][bProds]--;
			GiveBizzProfit(bidx, 40);
			Pl::Info[playerid][pFuel] = 20;
			Rac::GivePlayerMoney(playerid, -40);
			Send(playerid, COLOR_LIGHTBLUE, "* �� ����� 20 �������� �������� ������� �� $40");
		} else {
			Send(playerid, COLOR_WHITE, " {0080ff}��������{ffffff} ");
			Send(playerid, COLOR_GREY, "�������: /get [name]");
			Send(playerid, COLOR_GREY, " ��������� ��������: Drugs, Fuel");
		}
	}
	return 1;
}

CMD:fillcar(playerid, params[]) {
	if(Pl::Info[playerid][pFuel] <= 0) return Send(playerid, COLOR_GREY, "* � ��� ��� �������� � ��������!");
	if(AutoInfo[gLastCar[playerid]][aFuel] > 81.0) return Send(playerid, COLOR_GREY, "* ��� ���������� ���������, �������� ����!");
	Send(playerid, COLOR_LIGHTBLUE, "�� ��������� ��� ���������� �� 20 ���������");
	AutoInfo[gLastCar[playerid]][aFuel] += 20.0;
	Pl::Info[playerid][pFuel] = 0;
	return 1;
}

CMD:zahvat(playerid, params[]) { new string[144], sendername[24];
	if(IsAGang(playerid) && GetPlayerState(playerid) == 1) {
		new frac = Pl::FracID(playerid);
		if(Pl::Info[playerid][pRank] < GetZRank(frac) && !IsPlayerLeader(playerid)) {
			format(string, sizeof string, "* ��� ������� ������� ��� ����� %i-� ����!", GetZRank(frac));
			Send(playerid, COLOR_LIGHTRED, string);
		} else if(IsValidBiz(GangOnBattle[frac])) {
			Send(playerid, COLOR_GREY, "* ���� ����� ��� ���������� � �������!");
		} else {
			new i = GetClosestBiz(playerid, 3.0);
			if(!IsValidBiz(i)) return Send(playerid, COLOR_GREY, "* ��� �������� ����������!");
			if(BizzInfo[i][bOnBattle] == 1) return Send(playerid, COLOR_GREY, "* ������ ��� ��������!");
			if(BizzInfo[i][bFrac] == frac) return Send(playerid, COLOR_GREY, "* �� �� ������ ����������� ���� ������!");
			if(GangOnBattle[BizzInfo[i][bFrac]] != INVALID_BIZ_ID) {
				format(string, sizeof string, "* ����� %s ��� ��������� �� ������ ������!", GetGangName(BizzInfo[i][bFrac]));
				Send(playerid, COLOR_GREY, string);
			} else {
				GangOnBattle[frac] = i;
				ZahvatKills{frac} = 0;
				ZahvatScore[frac] = 0;
				BizzInfo[i][bAttack] = frac;
				BizzInfo[i][bDefend] = BizzInfo[i][bFrac];
				BizzInfo[i][bOnBattle] = 1;
				BizzInfo[i][bZahvatTime] = 240;
				GangOnBattle[BizzInfo[i][bFrac]] = i;
				ZahvatKills{BizzInfo[i][bFrac]} = 0;
				ZahvatScore[BizzInfo[i][bFrac]] = 0;
				CreateZahvatTD(BizzInfo[i][bZahvatTD]);
				SetZahvatMapIcon(i, frac, BizzInfo[i][bFrac]);
				Gz::FlashForAll(BizzInfo[i][bZone], GetFracColor(frac));
				BizzInfo[i][bZahvatTimer] = SetTimerEx("onZahvatBizz", 900*2, true, "iii", i, frac, BizzInfo[i][bFrac]);
				new Float:minx, Float:miny, Float:minz, Float:maxx, Float:maxy, Float:maxz;
				GetSquare3DPos(BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], BizzInfo[i][bEnter][2], MAX_ZONE_SIZE, minx, miny, minz, maxx, maxy, maxz);
				BizzInfo[i][bZahvatArea] = CreateDynamicCube(minx, miny, minz, maxx, maxy, maxz, 0);
				
				foreach(new j : inStreamPlayers[playerid]) {
					Streamer::UpdateEx(j, BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], BizzInfo[i][bEnter][2], 0, 0);
				}
				Streamer::UpdateEx(playerid, BizzInfo[i][bEnter][0], BizzInfo[i][bEnter][1], BizzInfo[i][bEnter][2], 0, 0);
				
				GetPlayerName(playerid, sendername, 24);
				sendToFamily(frac, COLOR_LIGHTRED, "[GANG NEWS] ��������� � ���, ����� ����������� ������!");
				format(string, sizeof string, "[GANG NEWS] ����� ��� ������ �� ���� ���������� [%s], �������� �� ��� ��� ������!", BizzInfo[i][bDescription]);
				sendToFamily(BizzInfo[i][bFrac], GetFracColor(BizzInfo[i][bFrac]), string);
			}
		}
	}
	return 1;
}

CMD:togpm(playerid, params[]) { new string[144];
	if(!Pl::isAdmin(playerid, 2) && Pl::Info[playerid][pVip] < 1 && IsPlayerLeader(playerid) <= 0) return Send(playerid, COLOR_GREY, "* ������������ ����!");
	HidePM[playerid] = !HidePM[playerid];
	format(string, sizeof string, "* ������ ��������� %s!", (HidePM[playerid])?("���������"):("��������"));
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:vopros(playerid, params[]) { new string[144], sendername[24];
	if(IsPMuted(playerid) || Pl::Info[playerid][pMuted] == 2) return Send(playerid,COLOR_GREY,"* � ��� ��������!");
	if(sscanf(params, "s[90]", params[0])) return Send(playerid, COLOR_GREY, "�������: /������ [�����]");
	if(gettime() < VoprosTime[playerid]) return Send(playerid, COLOR_GREY, "* �� �����!");
	VoprosTime[playerid] = gettime()+30;
	SetPVarInt(playerid, "AnsweredHelper", -1);
	GetPlayerName(playerid, sendername, 24);
	format(string, sizeof string, "*������ �� %s[%d]: %s", sendername, playerid, params[0]);
	SendToHelper(0x10F441AA, string);
	Send(playerid, COLOR_LIGHTRED, string);
	Send(playerid, COLOR_YELLOW, "* ��� ������ ��������� ��������!");
	return 1;
}

CMD:origin(playerid, params[]) {
	SPD(playerid, D_SPAWN, DIALOG_STYLE_LIST, ""#__SERVER_PREFIX""#__SERVER_NAME_LC": ORIGIN", "Jefferson Motel\nRock Hotel", "SELECT", "CANCEL");
	return 1;
}

CMD:jack(playerid, params[]) {
	if(Pl::Info[playerid][pJob] == 5)
	{
		if(JobWaitTime[playerid] != 0) return Send(playerid, COLOR_GREY, "* ������ ����� ���������� ��� � 3 ������!");
		if(GetPlayerState(playerid) == 1 && GetPlayerInterior(playerid) == 0)
		{
			new c = ClosestVeh(playerid, 3.0);
			if(c != INVALID_VEHICLE_ID) {
				if(!gCarLock{c}) return Send(playerid, COLOR_GREY, "* ��� ������ ��� �������!");
				ToggleVehicleDoor(c, true);
				JobWaitTime[playerid] = 180;
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				GameTextForPlayer(playerid, "~w~Vehicle ~r~Hacked", 5000, 4);
				
				params[0] = GetClosestPlayer(playerid, 20.0);
				if(Pl::isLogged(params[0])) {
					WantedTime[playerid] = 180;
					SetPlayerCriminal(playerid, 255, "���� ��", 2);
				}
			}
		}
	}
	return 1;
}

CMD:lock(playerid, params[]) {
	new carid = GetPlayerVehicleID(playerid);
	new houseid = Pl::Info[playerid][pHouseKey];
	if(carid == 0) carid = ClosestVeh(playerid, 3.0);
	if(carid != INVALID_VEHICLE_ID) {
		if(HireCar[playerid] == carid) {
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			SetPlayerChatBubble(playerid, !gCarLock{carid} ? ("������ ���������") : ("������ ���������"), COLOR_YELLOW, 50.0, 5000);
			GameTextForPlayer(playerid, !gCarLock{carid} ? ("~w~Vehicle ~r~Locked") : ("~w~Vehicle ~g~Unlocked"), 5000, 6);
			ToggleVehicleDoor(carid, gCarLock{carid});
		} else if(IsValidHouse(houseid) && HouseInfo[houseid][hAuto] == carid) {
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			SetPlayerChatBubble(playerid, !gCarLock{carid} ? ("������ ���������") : ("������ ���������"), COLOR_YELLOW, 50.0, 5000);
			GameTextForPlayer(playerid, !gCarLock{carid} ? ("~w~Vehicle ~r~Locked") : ("~w~Vehicle ~g~Unlocked"), 5000, 6);
			ToggleVehicleDoor(carid, gCarLock{carid});
		} else {
			new slot = GetIdxExtraVehicleFromVehicleID(playerid, carid);
			if(slot != -1 && ExtraVehicles[playerid][slot][evOwner] == Pl::Info[playerid][pID]) {
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				SetPlayerChatBubble(playerid, !gCarLock{carid} ? ("������ ���������") : ("������ ���������"), COLOR_YELLOW, 50.0, 5000);
				GameTextForPlayer(playerid,  !gCarLock{carid} ? ("~w~Vehicle ~r~Locked") : ("~w~Vehicle ~g~Unlocked"), 5000, 6);
				ToggleVehicleDoor(carid, gCarLock{carid});
			} else {
				Send(playerid, COLOR_GREY, "* � ��� ��� ����� �� ����� ����������");
			}
		}
	}
	else Send(playerid, COLOR_GREY, "��� ����� ����������");
	
	return 1;
}

CMD:tazer(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(IsPlayerInAnyVehicle(playerid)) return Send(playerid, COLOR_GREY, "* ������ ������������ ��� � ����������!");
	if(PlayerUseTazed[playerid]) return Send(playerid, COLOR_GREY,"* ����������� ������� ����� ��� � 8 ������");
	params[0] = GetClosestPlayer(playerid, 4.0);
	if(params[0] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ����� ��� ��� ������!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(IsACop(params[0])) return Send(playerid, COLOR_GREY, "������ ��������������� �����!!");
	if(IsPlayerInAnyVehicle(params[0])) return Send(playerid, COLOR_GREY, "* ������������� ��������� � ����������, �������� ��� �������!");
	
	getname(playerid -> sendername,params[0] -> playername);
	if(Pl::Info[params[0]][pMaskOn])
	{
		format(string, sizeof string, "* �� ������� ������������ �� ����������� �� ����������� �� 8 ������.");
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* �� ������� ������������ � ������������ %s �� 8 ������.", sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* %s ��������� ������������ � ����������� � �� ��� �����������,.", sendername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	else
	{
		format(string, sizeof string, "* �� ������� ������������ �� %s �� ����������� �� 8 ������.", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* �� ������� ������������ � ������������ %s �� 8 ������.", sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* %s ��������� ������������ � %s � �� ��� �����������,.", sendername, playername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	}
	PlayerUseTazed[playerid] = true;
	GameTextForPlayer(params[0], "~r~Tazed", 3000, 3);
	Rac::TogglePlayerControllable(params[0], 0);
	SetTimerEx("TazerTime", 1000*8, false, "i", playerid);
	SetTimerEx(""#Rac::"TogglePlayerControllable", 1000 * 8 , false, "ii", params[0], 1);
	return 1;
}

CMD:unmask(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	params[0] = GetClosestPlayer(playerid, 3.0);
	if(params[0] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ����� ��� ��� ������!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!Pl::Info[params[0]][pMaskOn]) return Send(playerid, COLOR_GREY, "����� ��� ��� ������ � �����!");
	
	HideNameTag( params[0], false );
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* %s ���� � ��� �����", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ����� ����� � %s", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s ������� ����� � %s", sendername, playername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	
	return 1;
}

CMD:jailed(playerid, params[]) { new string[144];
	switch(Pl::FracID(playerid)) {
		case 1..3 : {
			Send(playerid, COLOR_WHITE, " {0080ff}����������� � ������ {ffffff}_");
			foreach(new i: Player) {
				if(Pl::Info[i][pJailed] == 1) {
					format(string, sizeof string, "* �����������: %s | �������� �������: %d", GetName(i), Pl::Info[i][pJailTime]);
					Send(playerid, COLOR_LIGHTBLUE, string);
				}
			}
		}
	}
	return 1;
}

CMD:cuff(playerid, params[]) { new string[144];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ���!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /cuff [id/Name]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "*�� �������� ������ ��������� �� ������ ����!");
	if(IsACop(params[0])) return Send(playerid, COLOR_GREY, "*�� �������� �������� ��������� �� ����������!");
	if(Pl::CuffedTime[params[0]] > 0) return Send(playerid, COLOR_GREY, "* �� ������ ��� ������ ��������� !");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ����� ������� ������!");
	SetPlayerAttachedObject(params[0], 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
	SetPlayerSpecialAction(params[0], SPECIAL_ACTION_CUFFED);
	format(string, sizeof string, "* ������ %s ����� �� ��� ���������", GetName(playerid));
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ������ ��������� �� %s.", GetName(params[0]));
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ������ %s �������� ��������� �� %s", GetName(playerid), GetName(params[0]));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	GameTextForPlayer(params[0], "~r~Cuffed", 3000, 3);
	Pl::CuffedTime[params[0]] = 240;
	return 1;
}

CMD:uncuff(playerid, params[]) { new string[144];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ���!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /uncuff [id/Name]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �������� ����� ��������� �� ������ ����!");
	if(IsACop(params[0])) return Send(playerid, COLOR_GREY, "* �� �������� �������� ��������� �� ����������!");
	if(Pl::CuffedTime[params[0]] <= 0) return Send(playerid, COLOR_GREY, "* �� ������ �� ������ ���������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ����� ������� ������!");
	RemovePlayerAttachedObject(params[0], 0);
	SetPlayerSpecialAction(params[0], SPECIAL_ACTION_NONE);
	format(string, sizeof string, "* ������ %s ���� � ��� ���������", GetName(playerid));
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ����� ��������� � %s", GetName(params[0]));
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ������ %s ������� ��������� � %s", GetName(playerid), GetName(params[0]));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	GameTextForPlayer(params[0], "~g~Uncuffed", 2500, 3);
	Pl::CuffedTime[params[0]] = 0;
	return 1;
}

CMD:find(playerid, params[]) {
	if(Pl::Info[playerid][pJob] != 1) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(UsedFind[playerid] != 0) return Send(playerid, COLOR_GREY, "* �� ��� ������ ����-��, ���������!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /find [id]");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ �������� ������ ����!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ������������ ���/ID!");
	
	FindTime[playerid] = 10;
	UsedFind[playerid] = (60-(Pl::Info[playerid][pSkill][0]/10));
	GetPlayerPos(params[0], posx, posy, posz);
	SetPlayerCheckpointEx(playerid, FIND_ICON, posx, posy, posz, 60, 0, -1, -1, true);
	
	if(Pl::Info[playerid][pSkill][0] < 500) {
		switch(++Pl::Info[playerid][pSkill][0]) {
			case 50 : Send(playerid, COLOR_YELLOW, "* ��� ����� ��������� ������ 2 ������, ����� �� ������� �������� ������ �������.");
			case 100 : Send(playerid, COLOR_YELLOW, "* ��� ����� ��������� ������ 3 ������, ����� �� ������� �������� ������ �������.");
			case 200 : Send(playerid, COLOR_YELLOW, "* ��� ����� ��������� ������ 4 ������, ������ �� ������� �������� ������ �������.");
			case 400 : Send(playerid, COLOR_YELLOW, "* ��� ����� ��������� ������ 5 ������, ������ �� ������� �������� ������ �������.");
		}
	}
	
	return 1;
}

CMD:giveorder(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid,COLOR_GREY,"* �� �� ��������!");
	if(Pl::Info[playerid][pRank] < 8) return Send(playerid,COLOR_GREY,"* ������ � 8 �����!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GRAD2, "�������: /giveoder [playerid]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsALawyer(params[0])) return Send(playerid, COLOR_GREY,"* ���� ������� �� �������!");
	if(ApprovedLawyer[params[0]]) return Send(playerid, COLOR_GREY,"* � ���� ��� ���� �����!");
	ApprovedLawyer[params[0]] = 1;
	getname(playerid->sendername,params[0]->playername);
	format(string, sizeof string, "* �� ������ ����� �� ������������ �� ������ %s ������", playername);
	Send(playerid, COLOR_LIGHTBLUE,string);
	format(string, sizeof string, "* ������ %s ����� ��� ����� �� ������������ ������(����������� /free)", sendername);
	Send(params[0], COLOR_LIGHTBLUE,string);
	
	return 1;
}

CMD:free(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsALawyer(playerid)) return Send(playerid, COLOR_GREY,"* �� �� �������!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GRAD2, "�������: /free [playerid]");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "�� �� ������ ���������� ����!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(Pl::Info[params[0]][pJailed] != 1) return Send(playerid, COLOR_GREY, "* ����� �� � ������!");
	if(ApprovedLawyer[playerid] != 1) return Send(playerid, COLOR_GREY, "* � ��� ��� ������ �� ������������!");
	
	Pl::Info[playerid][pSkill][2] ++;
	if(Pl::Info[playerid][pSkill][2] == 50)
	{ Send(playerid, COLOR_YELLOW, "* ��� ������� ����� - ������ ������� 2, �� ����������� ������ �����, � ����� ������� ������������ �����."); }
	else if(Pl::Info[playerid][pSkill][2] == 100)
	{ Send(playerid, COLOR_YELLOW, "* ��� ������� ����� - ������ ������� 3, �� ����������� ������ �����, � ����� ������� ������������ �����."); }
	else if(Pl::Info[playerid][pSkill][2] == 200)
	{ Send(playerid, COLOR_YELLOW, "* ��� ������� ����� - ������ ������� 4, �� ����������� ������ �����, � ����� ������� ������������ �����."); }
	else if(Pl::Info[playerid][pSkill][2] == 400)
	{ Send(playerid, COLOR_YELLOW, "* ��� ������� ����� - ������ ������� 5, �� ����������� ������ �����, � ����� ������� ������������ �����."); }
	
	ApprovedLawyer[playerid] = 0;
	WantLawyer[params[0]] = 0;
	CallLawyer[params[0]] = 0;
	JailPrice[params[0]] = 0;
	
	UnJail(params[0], 1);
	Pl::Info[params[0]][pJailTime] = 0;
	getname(playerid->sendername,params[0]->playername);
	format(string, sizeof string, "* �� ���������� %s �� ������.", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ���� ����������� �� ������, ��������� %s.", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:cancel(playerid, params[]) { new string[144], sendername[24];
	if(sscanf(params, "s[15]U(65535)", temp, params[0]))
	{
		Send(playerid, COLOR_WHITE, "_________| ������������ |_________");
		Send(playerid, COLOR_WHITE, "{ffffff}�������: /cancel [name]");
		Send(playerid, COLOR_GREY, "��������� ��������: Sex, Drugs, Repair, Live, Refill, Car, Taxi, Bus");
		Send(playerid, COLOR_GREY, "��������� ��������: Medic, Mechanic, Ticket");
		Send(playerid, COLOR_WHITE, "||");
		return 1;
	}
	GetPlayerName(playerid, sendername, 24);
	if(strcmp(temp, "house", true) == 0) {
		SetPVarInt(playerid, "HouseSeller", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "HouseBuyer", INVALID_PLAYER_ID);
		SetPVarInt(playerid, "HousePrice", 0);
	
	} else if(strcmp(temp,"sex",true) == 0) {
		SexOffer[playerid] = INVALID_PLAYER_ID;
		SexPrice[playerid] = 0;
	
	} else if(strcmp(temp,"drugs",true) == 0) {
		DrugOffer[playerid] = INVALID_PLAYER_ID;
		DrugPrice[playerid] = 0;
		DrugGram[playerid] = 0;
	
	} else if(strcmp(temp,"repair",true) == 0) {
		RepairOffer[playerid] = INVALID_PLAYER_ID;
		RepairPrice[playerid] = 0;
		RepairCar[playerid] = 0;

	} else if(strcmp(temp,"live",true) == 0) {
		LiveOffer[playerid] = INVALID_PLAYER_ID;
	
	} else if(strcmp(temp,"refill",true) == 0) {
		RefillOffer[playerid] = INVALID_PLAYER_ID;
		RefillPrice[playerid] = 0;
	
	} else if(strcmp(temp,"car",true) == 0) {
		CarOffer[playerid] = INVALID_PLAYER_ID;
		CarPrice[playerid] = 0;
		CarID[playerid] = 0;
	
	} else if(strcmp(temp,"ticket",true) == 0) {
		TicketOffer[playerid] = INVALID_PLAYER_ID;
		TicketMoney[playerid] = 0;

	} else if(strcmp(temp,"medic",true) == 0) {
		if(Iter::Count(MedicCalls)) {
			if(Iter::Contains(MedicCalls, playerid)) {
				Iter::Remove(MedicCalls, playerid);
				format(string, sizeof string, "* ������ %s, ������� �����.", GetName(playerid));
				sendToFamily(4, COLOR_AZTECAS, string);
				Send(playerid, COLOR_GREY, "* �� �������� �����!");
			}
		} else if(Iter::Count(TeamPlayers[4])) {
			foreach(new med : TeamPlayers[4]) {
				if(MedicCallTime[med][0] == playerid) {
					MedicCallTime[med][1] = 300;
					format(string, sizeof string, "* ������ %s, ������� �����.", GetName(playerid));
					Send(med, COLOR_AZTECAS, string), Send(playerid, COLOR_GREY, "* �� �������� �����!");
					break;
				}
			}
		} else {
			Send(playerid, COLOR_GREY, "* �� �� �������� ������!");
		}
	
	} else if(strcmp(temp,"mechanic",true) == 0) {
		if(Iter::Count(MechanicCalls)) {
			if(Iter::Contains(MechanicCalls, playerid)) {
				Iter::Remove(MechanicCalls, playerid);
				format(string, sizeof string, "* ������ %s, ������� �����.", GetName(playerid));
				SendJobMessage(6, COLOR_AZTECAS, string);
				Send(playerid, COLOR_GREY, "* �� �������� �����!");
			}
		} else if(Iter::Count(JobPlayers[6]) > 0) {
			foreach(new meh : JobPlayers[6]) {
				if(MechanicCallTime[meh][0] == playerid) {
					MechanicCallTime[meh][1] = 300;
					format(string, sizeof string, "* ������ %s, ������� �����.", GetName(playerid));
					Send(meh, COLOR_AZTECAS, string), Send(playerid, COLOR_GREY, "* �� �������� �����!");
					break;
				}
			}
		} else {
			Send(playerid, COLOR_GREY, "* �� �� �������� ��������!");
		}
	
	} else if(strcmp(temp,"taxi",true) == 0) {
		if(TaxiCall != INVALID_PLAYER_ID) {
			if(TransportDuty[playerid] == 1 && TaxiCallTime[playerid] > 0) {
				TaxiAccepted[playerid] = INVALID_PLAYER_ID;
				GameTextForPlayer(playerid, "~w~You have~n~~r~Canceled the call", 5000, 1);
				TaxiCallTime[playerid] = 0;
				DestroyDynamicCP(checkpoints[playerid]);
				TaxiCall = INVALID_PLAYER_ID;
			} else {
				if(IsPlayerConnected(TaxiCall)) if(TaxiCall == playerid) TaxiCall = INVALID_PLAYER_ID;
				foreach(new i: Player) {
					if(Pl::isLogged(i)) {
						if(TaxiAccepted[i] != INVALID_PLAYER_ID) {
							if(TaxiAccepted[i] == playerid) {
								TaxiAccepted[i] = INVALID_PLAYER_ID;
								GameTextForPlayer(i, "~w~Taxi Caller~n~~r~Canceled the call", 5000, 1);
								TaxiCallTime[i] = 0;
								DestroyDynamicCP(checkpoints[playerid]);
							}
						}
					}
				}
			}
		}
	
	} else if(strcmp(temp,"bus",true) == 0) {
		if(BusCall != INVALID_PLAYER_ID) {
			if(TransportDuty[playerid] == 2 && BusCallTime[playerid] > 0) {
				BusAccepted[playerid] = INVALID_PLAYER_ID;
				GameTextForPlayer(playerid, "~w~You have~n~~r~Canceled the call", 5000, 1);
				BusCallTime[playerid] = 0;
				DestroyDynamicCP(checkpoints[playerid]);
				BusCall = INVALID_PLAYER_ID;
			} else {
				if(IsPlayerConnected(BusCall)) if(BusCall == playerid) BusCall = INVALID_PLAYER_ID;
				foreach(new i: Player) {
					if(Pl::isLogged(i)) {
						if(BusAccepted[i] != INVALID_PLAYER_ID) {
							if(BusAccepted[i] == playerid) {
								BusAccepted[i] = INVALID_PLAYER_ID;
								GameTextForPlayer(i, "~w~Bus Caller~n~~r~Canceled the call", 5000, 1);
								BusCallTime[i] = 0;
								DestroyDynamicCP(checkpoints[playerid]);
							}
						}
					}
				}
			}
		}
	} else {
		return 1;
	}
	format(string, sizeof string, "* �� ��������: %s.", temp);
	Send(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:accept(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::isLogged(playerid)) {
		if(sscanf(params, "s[32]U(65535)", temp, params[0])) {
			Send(playerid, COLOR_WHITE, "_________| ��������� |_________");
			Send(playerid, COLOR_WHITE, "* �������: accept [name]");
			Send(playerid, COLOR_GREY, "��������� ��������: Sex, Drugs, Repair, Live, Refill, House");
			Send(playerid, COLOR_GREY, "��������� ��������: Car, Taxi, Bus, Medic, Mechanic, Ticket");
			Send(playerid, COLOR_WHITE, "||");
			return 1;
		}
		
		if(strcmp(temp, "house", true) == 0) {
			if(!IsPlayerInBiz(playerid, 60.0, Bizz_EstateAgency)) return Send(playerid, COLOR_GREY, "* �� ������ ��������� � �������� ������������!");
			switch(GetPVarInt(playerid, "HouseType")) {
				case 0 : {
					if(IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) return Send(playerid, COLOR_GREY, "* � ��� ��� ���� ���!");
					new seller = GetPVarInt(playerid, "HouseSeller");
					if(!Pl::isLogged(seller)) return Send(playerid, COLOR_GREY, "* ��� �� ���������� ������ ���!");
					if(!IsPlayerInBiz(seller, 60.0, Bizz_EstateAgency)) return Send(playerid, COLOR_GREY, "* ��� ��������� ������ ������ ��������� � ��������� ������������!");
					new price = GetPVarInt(playerid, "HousePrice");
					if(price > Rac::GetPlayerMoney(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ������������ �������!");
					new biz   = GetIndexFromBizID(Bizz_EstateAgency);
					GiveBizzProfit(biz, PERCENT(price, 10));
					
					Rac::GivePlayerMoney(playerid, -price);
					Rac::GivePlayerMoney(seller, price);
					printf("p_house:%i", Pl::Info[playerid][pHouseKey]);
					printf("s_house:%i", Pl::Info[seller][pHouseKey]);
					new house = Pl::Info[seller][pHouseKey];
					ClearHouse(house);
					HouseInfo[house][hOwned] = 1;
					getname(playerid -> sendername, seller -> playername);
					strmid(HouseInfo[house][hOwner], sendername, 0, 24, 24);
					UpdateHousePickups(house);
					UpdateHouse(house);
					Pl::Info[seller][pHouseKey] = INVALID_HOUSE_ID;
					Pl::Info[playerid][pHouseKey] = house;
					PlayerPlaySound(seller, 1052, 0.0, 0.0, 0.0);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					Send(playerid, COLOR_YELLOW, "* ������ ���� ������� ���������!");
					Send(seller, COLOR_YELLOW, "* ������ ���� ������� ���������!");
					
					getname(playerid -> sendername, seller -> playername);
					format(string, sizeof string, "[Debug] %s ������ ��� %s. Price: $%i; SellPrice: $%i; Safe: $%i",
					playername, sendername, HouseInfo[house][hPrice], price, HouseInfo[house][hSafe][0]);
					SendLog(LOG_HOUSE, string);
				}
				
				case 1 : {
					if(!IsPlayerHouseOwner(playerid, Pl::Info[playerid][pHouseKey])) return Send(playerid, COLOR_GREY, "* � ��� ��� ����!");
					new seller = GetPVarInt(playerid, "HouseSeller");
					if(!Pl::isLogged(seller)) return Send(playerid, COLOR_GREY, "* ��� �� ���������� ����� ������!");
					if(!IsPlayerInBiz(seller, 60.0, Bizz_EstateAgency)) return Send(playerid, COLOR_GREY, "* ��� ��������� ������ ������ ��������� � ��������� ������������!");
					new price = GetPVarInt(playerid, "HousePrice");
					if(price > Rac::GetPlayerMoney(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ������������ ������� ��� �������!");
					
					new biz   = GetIndexFromBizID(Bizz_EstateAgency);
					GiveBizzProfit(biz, PERCENT(price, 10));
					
					Rac::GivePlayerMoney(playerid, -price);
					Rac::GivePlayerMoney(seller, price);

					new h1 = Pl::Info[seller][pHouseKey];
					new h2 = Pl::Info[playerid][pHouseKey];
					ClearHouse(h1), ClearHouse(h2);
					HouseInfo[h1][hOwned] = HouseInfo[h2][hOwned] = 1;
					getname(playerid -> sendername, seller -> playername);
					strmid(HouseInfo[h1][hOwner], sendername, 0, 24, 24);
					strmid(HouseInfo[h2][hOwner], playername, 0, 24, 24);
					UpdateHousePickups(h1), UpdateHousePickups(h2);
					UpdateHouse(h1), UpdateHouse(h2);
					Pl::Info[seller][pHouseKey] = h2;
					Pl::Info[playerid][pHouseKey] = h1;
					PlayerPlaySound(seller, 1052, 0.0, 0.0, 0.0);
					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					Send(playerid, COLOR_YELLOW, "* ������ ���� ������� ���������!");
					Send(seller, COLOR_YELLOW, "* ������ ���� ������� ���������!");
					
					getname(playerid -> sendername, seller -> playername);
					format(string, sizeof string, "[Debug] %s ��������� ����� � %s. Price: $%i|%i; Surcharge: $%i; Safe: $%i|%i",
					playername, sendername, HouseInfo[h1][hPrice], HouseInfo[h2][hPrice], price, HouseInfo[h1][hSafe][0], HouseInfo[h2][hSafe][0]);
					SendLog(LOG_HOUSE, string);
				}
			}
		}
		else if(strcmp(temp, "invite",true) == 0) {
			new frac = GetPVarInt(playerid, "InvateFrac");
			if(!IsValidFrac(frac)) return Send(playerid, COLOR_GREY, "* ��� �� ���������� �� �������!");
			Pl::Info[playerid][pMember] = frac;
			Pl::Info[playerid][pRank] = 1;
			Rac::SetPlayerInterior(playerid, 3);
			Rac::SetPlayerVirtualWorld(playerid, Bizz_ProLaps);
			Pl::Info[playerid][pLocal] = OFFSET_BIZZ + GetIndexFromBizID(Bizz_ProLaps);
			Rac::SetPlayerPos(playerid, 207.4872,-129.2266,1003.5078);
			SelectCharPlace[playerid] = 0;
			Pl::SetFracColor(playerid);
			SetPVarInt(playerid, "InvateFrac", 0);
			Iter::Add(TeamPlayers[frac], playerid);
			Container::At(Pl::FracID(playerid), Container::First, SelectCharPlace[playerid], ChosenSkin[playerid]);
			SetPlayerSkin(playerid, ChosenSkin[playerid]);
			Pl::Info[playerid][pChar] = ChosenSkin[playerid];
			format(string, sizeof string, "* �� ���� ������� � %s", FracInfo[frac][fName]);
			Send(playerid, COLOR_LIGHTBLUE, string);
		}
		
		else if(strcmp(temp,"car",true) == 0) {
			if(CarOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ����� �� ��������� �������� ����������!");
			if(!Pl::isLogged(CarOffer[playerid])) return 1;
			if(Rac::GetPlayerMoney(playerid) < CarPrice[playerid]) return Send(playerid, COLOR_GREY, "* � ��� �� ������� �����!");
			if(!IsPlayerInVehicle(CarOffer[playerid], CarID[playerid])) return Send(playerid, COLOR_GREY, "* ����� �� ������� �������� ����������� �� ��������� � ����������� ����������!");
			new points;
			new level = Pl::Info[CarOffer[playerid]][pSkill][5];
			if(level == 50)
			{ Send(CarOffer[playerid], COLOR_YELLOW, "* ��� ����� ������ �� ������� �������� ����������� - ������ ������� 2, ������, ������� �������� ���������� �� ���, ����� ������� ��� ����."); }
			else if(level == 100)
			{ Send(CarOffer[playerid], COLOR_YELLOW, "* ��� ����� ������ �� ������� �������� ����������� - ������ ������� 3, ������, ������� �������� ���������� �� ���, ����� ������� ��� ����."); }
			else if(level == 200)
			{ Send(CarOffer[playerid], COLOR_YELLOW, "* ��� ����� ������ �� ������� �������� ����������� - ������ ������� 4, ������, ������� �������� ���������� �� ���, ����� ������� ��� ����."); }
			else if(level == 400)
			{ Send(CarOffer[playerid], COLOR_YELLOW, "* ��� ����� ������ �� ������� �������� ����������� - ������ ������� 5, ������, ������� �������� ���������� �� ���, ����� ������� ��� ����."); }
			if(level >= 0 && level <= 50) { points = 1; }
			else if(level >= 51 && level <= 100) { points = 2; }
			else if(level >= 101 && level <= 200) { points = 3; }
			else if(level >= 201 && level <= 400) { points = 4; }
			else if(level >= 401) { points = 4; }
			format(string, sizeof string, "* �� ������ ���������� �� $%d, �� ������ �� ������� �������� ����������� %s. (�� ������ ������������ /callcar %d �����)",CarPrice[playerid], GetName(CarOffer[playerid]), points);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* �� ������� ���� ���������� %s ��� $%d, ����� ����� ������������ /callcar %d �����.", GetName(playerid), CarPrice[playerid], points);
			Send(CarOffer[playerid], COLOR_LIGHTBLUE, string);
			Pl::Info[CarOffer[playerid]][pPayCheck] += CarPrice[playerid];
			Rac::GivePlayerMoney(playerid, -CarPrice[playerid]);
			Rac::RemovePlayerFromVehicle(CarOffer[playerid]);
			Rac::TogglePlayerControllable(CarOffer[playerid], 1);
			CarCalls[playerid] = points;
			CarOffer[playerid] = INVALID_PLAYER_ID;
			CarPrice[playerid] = 0;
		
		} else if(strcmp(temp,"ticket",true) == 0) {
			if(!Pl::isLogged(TicketOffer[playerid])) return 1;
			if(TicketOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ��� �� ���������� �����!");
			if(!IsPlayerInRangeOfPlayer(playerid, 5.0, TicketOffer[playerid])) return Send(playerid, COLOR_GREY, "* ������ �� ����� ���!");
			if(TicketMoney[playerid] > Rac::GetPlayerMoney(TicketOffer[playerid])) return Send(playerid, COLOR_GREY, "* � ��� �� ������� ����� �� ������ ������.");
			format(string, sizeof string, "* �� ��������� ���� $%d ������� %s.", TicketMoney[playerid], GetName(TicketOffer[playerid]));
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* %s �������� ����� $%d.", GetName(playerid), TicketMoney[playerid]);
			Send(TicketOffer[playerid], COLOR_LIGHTBLUE, string);
			Rac::GivePlayerMoney(playerid, -TicketMoney[playerid]);
			Rac::GivePlayerMoney(TicketOffer[playerid], TicketMoney[playerid]);
			TicketOffer[playerid] = INVALID_PLAYER_ID;
			TicketMoney[playerid] = 0;

		} else if(strcmp(temp,"taxi",true) == 0) {
			if(TransportDuty[playerid] != 1) return Send(playerid, COLOR_GREY, "* �� �� �������!");
			if(TaxiCallTime[playerid] > 0) return Send(playerid, COLOR_GREY, "* �� ��� ������� �����!");
			if(TaxiCall == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ����� ��� �� ������� �����!");
			if(!Pl::isLogged(TaxiCall)) return 1;
			format(string, sizeof string, "* �� ������� ����� �� %s, �� ������ ������ ������, ���� �� ���������� ���.", GetName(TaxiCall));
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* ������� %s ������ ��� �����, ���������� ����� �� ����� ��������� ���������.", GetName(playerid));
			Send(TaxiCall, COLOR_LIGHTBLUE, string);
			GameTextForPlayer(playerid, "~w~Taxi Caller~n~~r~Goto redmarker", 5000, 1);
			TaxiCallTime[playerid] = 1;
			TaxiAccepted[playerid] = TaxiCall;
			TaxiCall = INVALID_PLAYER_ID;
		
		} else if(strcmp(temp,"bus",true) == 0) {
			if(TransportDuty[playerid] != 2) return Send(playerid, COLOR_GREY, "�� �� �������� ��������!");
			if(BusCallTime[playerid] > 0) return Send(playerid, COLOR_GREY, "* �� ��� ������� �����!");
			if(BusCall == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ����� ��� �� ������� �������!");
			if(!Pl::isLogged(BusCall)) return 1;
			format(string, sizeof string, "* �� ������� ����� �� %s, �� ������ ������ ������, ���� �� ���������� ���.", GetName(BusCall));
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* �������� �������� %s ������ ��� �����, ���������� ����� � ����� ��������� ���������.", GetName(playerid));
			Send(BusCall, COLOR_LIGHTBLUE, string);
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(BusCall, X, Y, Z);
			DestroyDynamicCP(checkpoints[playerid]);
			checkpoints[playerid] = CreateDynamicCP(X, Y, Z,8.0,-1,-1,playerid,99999.9);
			GameTextForPlayer(playerid, "~w~Bus Caller~n~~r~Goto redmarker", 5000, 1);
			BusCallTime[playerid] = 1;
			BusAccepted[playerid] = BusCall;
			BusCall = INVALID_PLAYER_ID;
		
		} else if(strcmp(temp,"medic",true) == 0) {
			if(Pl::FracID(playerid) != 4) return Send(playerid, COLOR_GREY, "* �� �� �����!");
			if(MedicCallTime[playerid][0] != INVALID_ID) return Send(playerid, COLOR_GREY, "* �� ��� ������� �����!");
			if(!Iter::Count(MedicCalls)) return Send(playerid, COLOR_GREY, "* ����� ��� �� ������� ������!");
			foreach(new caller : MedicCalls) {
				MedicCallTime[playerid][0] = caller;
				MedicCallTime[playerid][1] = 1;
				Iter::Remove(MedicCalls, caller);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(caller, X, Y, Z);
				pickupd[playerid][1] = CreateDynamicMapIcon(X, Y, Z, 20, 0, 0, 0, playerid, 99999.9);
				Streamer::SetIntData(4, pickupd[playerid][1], E_STREAMER_STYLE, MAPICON_GLOBAL_CHECKPOINT);
				GameTextForPlayer(playerid, "~w~Medic Caller~n~~r~Goto redmarker", 5000, 1);
				getname(playerid->sendername,caller->playername);
				format(string, sizeof string, "* �� ������� ����� �� %s, � ��� ���� 300 ������, ����� ��������� �� ����.", playername);
				Send(playerid, COLOR_LIGHTBLUE, string);
				Send(playerid, COLOR_LIGHTBLUE, "* ����� ���� 300 ������ ������� ������ ����� ������.");
				format(string, sizeof string, "* %s %s ������ ��� �����. �� ����� � ������� 300 ������", RankInfo[Pl::FracID(playerid)][Pl::Info[playerid][pRank]], sendername);
				Send(caller, COLOR_LIGHTBLUE, string);
				return 1;
			}
		
		} else if(strcmp(temp,"mechanic",true) == 0) {
			if(Pl::Info[playerid][pJob] != 6) return Send(playerid, COLOR_GREY, "* �� �� �����������!");
			if(MechanicCallTime[playerid][0] != INVALID_ID) return Send(playerid, COLOR_GREY, "* �� ��� ������� ������ �����!");
			if(!Iter::Count(MechanicCalls)) return Send(playerid, COLOR_GREY, "* � ��������� ����� ��� �������!");
			foreach(new caller : MechanicCalls) {
				MechanicCallTime[playerid][0] = caller;
				MechanicCallTime[playerid][1] = 1;
				Iter::Remove(MechanicCalls, caller);
				new Float:X,Float:Y,Float:Z;
				GetPlayerPos(caller, X, Y, Z);
				pickupd[playerid][1] = CreateDynamicMapIcon(X, Y, Z, 20, 0, 0, 0, playerid, 99999.9);
				Streamer::SetIntData(4, pickupd[playerid][1], E_STREAMER_STYLE, MAPICON_GLOBAL_CHECKPOINT);
				GameTextForPlayer(playerid, "~w~Mechanic Caller~n~~r~Goto redmarker", 5000, 1);
				getname(playerid -> sendername, caller -> playername);
				format(string, sizeof string, "* �� ������� ����� �� %s, � ��� ���� 300 ������, ����� ��������� ����.", playername);
				Send(playerid, COLOR_LIGHTBLUE, string);
				Send(playerid, COLOR_LIGHTBLUE, "* ����� ���� 300 ������ ������� ������ ����� ������.");
				format(string, sizeof string, "* ����������� %s ������ ��� �����, ���������� ����� � ����� ��������� ���������.", sendername);
				Send(caller, COLOR_LIGHTBLUE, string);
				format(string, sizeof string, "** %s ������ ����� � ������� � %s.", sendername, playername);
				SendJobMessage(6, COLOR_AZTECAS, string);
				break ;
			}
		
		} else if(strcmp(temp,"refill",true) == 0) {
			if(RefillOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ��� �� ���������� ��������� ���������!");
			if(!Pl::isLogged(RefillOffer[playerid])) return 1;
			if(RefillPrice[playerid] > Rac::GetPlayerMoney(playerid)) return Send(playerid, COLOR_GREY, "* � ��� �� ������� �����!");
			
			new Float:fuel, car = gLastCar[playerid];
			switch(++Pl::Info[RefillOffer[playerid]][pSkill][3]) {
				case 50 : Send(RefillOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 2, �� ������ �������� ������ ������� � ����� ����������� �������.");
				case 100 : Send(RefillOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 3, �� ������ �������� ������ ������� � ����� ����������� �������.");
				case 200 : Send(RefillOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 4, �� ������ �������� ������ ������� � ����� ����������� �������.");
				case 400 : Send(RefillOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 5, �� ������ �������� ������ ������� � ����� ����������� �������.");
			}
			switch(Pl::Info[RefillOffer[playerid]][pSkill][3]) {
				case 0..50		: fuel = 15.0;
				case 51..100	: fuel = 25.0;
				case 101..200	: fuel = 35.0;
				case 201..300 	: fuel = 45.0;
				case 301..400 	: fuel = 55.0;
				case 401..501 	: fuel = 65.0;
			}

			format(string, sizeof string, "* �� ����� ��������� ���� ���������� � %d%, �� $%d �� ������ ������������ %s.", fuel, RefillPrice[playerid], GetName(RefillOffer[playerid]));
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* �� ����� ��������� %s's ���������� � %d%, $%d ��� �������� � ����� ��������.", GetName(playerid), fuel, RefillPrice[playerid]);
			Send(RefillOffer[playerid], COLOR_LIGHTBLUE, string);
			Pl::Info[RefillOffer[playerid]][pPayCheck] += RefillPrice[playerid];
			Rac::GivePlayerMoney(playerid, -RefillPrice[playerid]);
			if(AutoInfo[car][aFuel] < 110) {
				AutoInfo[car][aFuel] += fuel;
			}
			RefillOffer[playerid] = INVALID_PLAYER_ID;
			RefillPrice[playerid] = 0;
		
		} else if(strcmp(temp,"live",true) == 0) {
			if(LiveOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ��� �� ���������� ���� ��������!");
			if(!Pl::isLogged(LiveOffer[playerid])) return 1;
			if(!IsPlayerInRangeOfPlayer(playerid, 3.0, LiveOffer[playerid])) return Send(playerid, COLOR_GREY, "* �� ������� ������ �� ���������!");
			Send(playerid, COLOR_LIGHTBLUE, "* �� ���������� �� ��������� ��������");
			Send(LiveOffer[playerid], COLOR_LIGHTBLUE, "* �� ���������� �� ��������� �������� (����������� /live again).");
			Rac::TogglePlayerControllable(playerid, 0); Rac::TogglePlayerControllable(LiveOffer[playerid], 0);
			TalkingLive[playerid] = LiveOffer[playerid];
			TalkingLive[LiveOffer[playerid]] = playerid;
			LiveOffer[playerid] = INVALID_PLAYER_ID;
		
		} else if(strcmp(temp,"drugs",true) == 0) {
			if(DrugOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ��� �� ���������� ���������!");
			if(DrugPrice[playerid] > Rac::GetPlayerMoney(playerid)) return Send(playerid, COLOR_GREY, "* � ��� �� ������� �����!");
			if(Pl::Info[playerid][pDrugs] > 9) return Send(playerid, COLOR_GREY, "* � ��� ��� ������� ����� ����������!");
			if(!Pl::isLogged(DrugOffer[playerid])) return 1;
			format(string, sizeof string, "* �� ������ %d ����� �� $%d �� �������� ����������� %s.", DrugGram[playerid], DrugPrice[playerid], GetName(DrugOffer[playerid]));
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* %s ����� ��� %d �����, $%d ��� �������� � ����� ��������.", GetName(playerid), DrugGram[playerid], DrugPrice[playerid]);
			Send(DrugOffer[playerid], COLOR_LIGHTBLUE, string);
			Pl::Info[DrugOffer[playerid]][pPayCheck] += DrugPrice[playerid];
			Pl::Info[DrugOffer[playerid]][pSkill][7] ++;
			Rac::GivePlayerMoney(playerid, -DrugPrice[playerid]);
			Pl::Info[playerid][pDrugs] += DrugGram[playerid];
			Pl::Info[DrugOffer[playerid]][pDrugs] -= DrugGram[playerid];
			if(Pl::Info[DrugOffer[playerid]][pSkill][7] == 50)
			{ Send(DrugOffer[playerid], COLOR_YELLOW, "* ��� ����� �������� ����������� - ������ ������� 2, �� ������ ������ ������ ������� � ����� �������."); }
			else if(Pl::Info[DrugOffer[playerid]][pSkill][7] == 100)
			{ Send(DrugOffer[playerid], COLOR_YELLOW, "* ��� ����� �������� ����������� - ������ ������� 3, �� ������ ������ ������ ������� � ����� �������."); }
			else if(Pl::Info[DrugOffer[playerid]][pSkill][7] == 200)
			{ Send(DrugOffer[playerid], COLOR_YELLOW, "* ��� ����� �������� ����������� - ������ ������� 4, �� ������ ������ ������ ������� � ����� �������."); }
			else if(Pl::Info[DrugOffer[playerid]][pSkill][7] == 400)
			{ Send(DrugOffer[playerid], COLOR_YELLOW, "* ��� ����� �������� ����������� - ������ ������� 5, �� ������ ������ ������ ������� � ����� �������."); }
			DrugOffer[playerid] = INVALID_PLAYER_ID; DrugPrice[playerid] = 0; DrugGram[playerid] = 0;
		
		} else if(strcmp(temp,"sex",true) == 0) {
			if(SexOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ��� �� ���������� ����!");
			if(Rac::GetPlayerMoney(playerid) > SexPrice[playerid]) return Send(playerid, COLOR_GREY, "* �� �� ������� ��������� �����!");
			if(!Pl::isLogged(SexOffer[playerid])) return 1;
			new Car = GetPlayerVehicleID(playerid);
			if(!IsPlayerInAnyVehicle(playerid) && !IsPlayerInVehicle(SexOffer[playerid], Car)) return Send(playerid, COLOR_GREY, "* �� ���� ����� �� ���������� � ������!");
			format(string, sizeof string, "* � ��� ��� ���� �� ������ %s, ��� $%d.", GetName(SexOffer[playerid]), SexPrice[playerid]);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* %s ���� ���� � ����, $%d ��� �������� � ����� ��������.", GetName(playerid), SexPrice[playerid]);
			Send(SexOffer[playerid], COLOR_LIGHTBLUE, string);
			Pl::Info[SexOffer[playerid]][pPayCheck] += SexPrice[playerid];
			Rac::GivePlayerMoney(playerid, -SexPrice[playerid]);
			Pl::Info[SexOffer[playerid]][pSkill][1] ++;
			if(Pl::Info[SexOffer[playerid]][pSkill][1] == 50)
			{ Send(SexOffer[playerid], COLOR_YELLOW, "* ��� ����������� ����� - ������ ������� 2, �� ����������� ������ ��� (��������), � ������ �������� ���������� �� �����."); }
			else if(Pl::Info[SexOffer[playerid]][pSkill][1] == 100)
			{ Send(SexOffer[playerid], COLOR_YELLOW, "* ��� ����������� ����� - ������ ������� 3, �� ����������� ������ ��� (��������), � ������ �������� ���������� �� �����."); }
			else if(Pl::Info[SexOffer[playerid]][pSkill][1] == 200)
			{ Send(SexOffer[playerid], COLOR_YELLOW, "* ��� ����������� ����� - ������ ������� 4, �� ����������� ������ ��� (��������), � ������ �������� ���������� �� �����."); }
			else if(Pl::Info[SexOffer[playerid]][pSkill][1] == 400)
			{ Send(SexOffer[playerid], COLOR_YELLOW, "* ��� ����������� ����� - ������ ������� 5, �� ����������� ������ ��� (��������), � ������ �������� ���������� �� �����."); }
			if(Condom[playerid] < 1) {
				new rand, level = Pl::Info[SexOffer[playerid]][pSkill][1];
				if(level >= 0 && level <= 50) {
					if(Rac::GetPlayerHealth(playerid) < 150) Rac::GivePlayerHealth(playerid, 30.0);
					rand = random(sizeof(STD1));
					STDPlayer[playerid] = STD1[rand];
					STDPlayer[SexOffer[playerid]] = STD1[rand];
					switch(STDPlayer[SexOffer[playerid]]) {
						case 0: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 30 �������� ���� ����.");
						case 1: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 30 �������� + �������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������.");
						case 2: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 30 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ��������.");
						case 3: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 30 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������");
					}
				} else if(level >= 51 && level <= 100) {
					if(Rac::GetPlayerHealth(playerid) < 150) Rac::GivePlayerHealth(playerid, 60.0);
					rand = random(sizeof(STD2)); STDPlayer[playerid] = STD2[rand];
					STDPlayer[SexOffer[playerid]] = STD2[rand];
					switch(STDPlayer[SexOffer[playerid]]) {
						case 0: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� ���� ����.");
						case 1: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + �������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������.");
						case 2: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ��������.");
						case 3: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������");
					}
				} else if(level >= 101 && level <= 200) {
					if(Rac::GetPlayerHealth(playerid) < 150) Rac::GivePlayerHealth(playerid, 90.0);
					rand = random(sizeof(STD3)); STDPlayer[playerid] = STD3[rand];
					STDPlayer[SexOffer[playerid]] = STD3[rand];
					switch(STDPlayer[SexOffer[playerid]]) {
						case 0: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� ���� ����.");
						case 1: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + �������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������.");
						case 2: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ��������.");
						case 3: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������");
					}
				} else if(level >= 201 && level <= 400) {
					if(Rac::GetPlayerHealth(playerid) < 150) Rac::GivePlayerHealth(playerid, 120.0);
					rand = random(sizeof(STD4)); STDPlayer[playerid] = STD4[rand];
					STDPlayer[SexOffer[playerid]] = STD4[rand];
					switch(STDPlayer[SexOffer[playerid]])
					{
						case 0: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� ���� ����.");
						case 1: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + �������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������.");
						case 2: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ��������.");
						case 3: Send(playerid, COLOR_LIGHTBLUE, "* �� �������� 60 �������� + ������� ��-�� �����."), Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* �� �������� ������ ������� ���������");
					}
				} else if(level >= 401) {
					if(Rac::GetPlayerHealth(playerid) < 150) Rac::GivePlayerHealth(playerid, 150.0);
					Send(playerid, COLOR_LIGHTBLUE, "* ��� ������� ������������ ����� ����� �����, ��� �� ���� ������ ������� ����� ������� ��������.");
					Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* ������� ������������ ����� ����� �����, �� �������� ������� �������� � ������� �������");
				}
			} else {
				Send(SexOffer[playerid], COLOR_LIGHTBLUE, "* ����� ����������� �����������.");
				Send(playerid, COLOR_LIGHTBLUE, "* �� ������������ �����������.");
				Condom[playerid] --;
			}
			SexOffer[playerid] = INVALID_PLAYER_ID;
		
		} else if(strcmp(temp,"repair",true) == 0) {
			if(RepairOffer[playerid] == INVALID_PLAYER_ID) return Send(playerid, COLOR_GREY, "* ��� �� ���������� �������� ����������!");
			if(RepairPrice[playerid] > Rac::GetPlayerMoney(playerid)) return Send(playerid, COLOR_GREY, "* � ��� �� ������ ����� �� �������!");
			if(!IsPlayerInAnyVehicle(playerid)) return 1;
			if(!Pl::isLogged(RepairOffer[playerid])) return 1;
			RepairCar[playerid] = GetPlayerVehicleID(playerid);
			Rac::RepairVehicle(GetPlayerVehicleID(RepairCar[playerid]));
			format(string, sizeof string, "* �� ������������ ���� ���������� �� $%d �� ������ ������� %s.", RepairPrice[playerid], GetName(RepairOffer[playerid]));
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* �� ���������� %s's ����������, $%d ��� �������� � ����� ��������.", GetName(playerid), RepairPrice[playerid]);
			Send(RepairOffer[playerid], COLOR_LIGHTBLUE, string);
			Pl::Info[RepairOffer[playerid]][pSkill][3] ++;
			if(Pl::Info[RepairOffer[playerid]][pSkill][3] == 50)
			{ Send(RepairOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 2, �� ������ �������� ������ ������� � ����� ����������� �������."); }
			else if(Pl::Info[RepairOffer[playerid]][pSkill][3] == 100)
			{ Send(RepairOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 3, �� ������ �������� ������ ������� � ����� ����������� �������."); }
			else if(Pl::Info[RepairOffer[playerid]][pSkill][3] == 200)
			{ Send(RepairOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 4, �� ������ �������� ������ ������� � ����� ����������� �������."); }
			else if(Pl::Info[RepairOffer[playerid]][pSkill][3] == 400)
			{ Send(RepairOffer[playerid], COLOR_YELLOW, "* ��� ������������� ����� �������� - ������ ������� 5, �� ������ �������� ������ ������� � ����� ����������� �������."); }
			Pl::Info[RepairOffer[playerid]][pPayCheck] += RepairPrice[playerid];
			Rac::GivePlayerMoney(playerid, -RepairPrice[playerid]);
			RepairOffer[playerid] = INVALID_PLAYER_ID;
			RepairPrice[playerid] = 0;
		}
	}
	return 1;
}

CMD:refill(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::Info[playerid][pJob] != 6) return Send(playerid, COLOR_GREY, "�� �� ��������� ���������!");
	if(sscanf(params, "ui", params[0], params[1])) return Send(playerid, COLOR_GREY, "�������: /refill [playerid] [price]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsAMehCar(GetPlayerVehicleID(playerid))) return Send(playerid,COLOR_GREY,"�� �� � ����� ��������");
	if(params[1] < 1 || params[1] > 5000) return Send(playerid, COLOR_GREY, "���� �� ������ ���� ������ 1, ��� ���� 5000!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[1]) && !IsPlayerInAnyVehicle(params[1])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���");
	RefillOffer[params[0]] = playerid;
	RefillPrice[params[0]] = params[1];
	getname(playerid -> sendername, params[0] -> playername);
	format(string, sizeof string, "* �� ���������� %s ��������� ��� ���������� �� $%d .", sendername, params[1]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ������� %s ���������� ��������� ��� ���������� �� $%d (������ /accept refill ����� �����������)", playername, params[1]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:at(playerid, params[]) {
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525) return Send(playerid, COLOR_GREY, "* �� �� � ������ ��������!");
	new veh = GetPlayerVehicleID(playerid);
	if(IsTrailerAttachedToVehicle(veh)) return Send(playerid, COLOR_GREY, "* ������ ����������!");
	new trailer = GetPlayerBootVehicle(playerid, veh);
	if(trailer == INVALID_VEHICLE_ID) return Send(playerid, COLOR_GREY,"* ��� ����� ����������!");
	if(IsTrailerAttachedToVehicle(trailer)) return Send(playerid, COLOR_GREY, "* ������ ��� ����������!");
	AttachTrailerToVehicle(trailer, veh);
	Send(playerid, COLOR_YELLOW, "* ������ ����������!");
	return 1;
}

CMD:dt(playerid, params[]) {
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 525) return Send(playerid, COLOR_GREY, "* �� �� � ������ ��������!");
	new veh = GetPlayerVehicleID(playerid);
	if(!IsTrailerAttachedToVehicle(veh)) return Send(playerid, COLOR_GREY, "* ������ �� ����������!");
	DetachTrailerFromVehicle(veh); Send(playerid, COLOR_YELLOW, "* ������ ���������!");
	return 1;
}

CMD:repair(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::Info[playerid][pJob] != 6) return Send(playerid, COLOR_GREY, "�� �� ������������� �������!");
	if(sscanf(params, "ud", params[0], params[1])) return Send(playerid, COLOR_GRAD2, "* �������: /repair [playerid] [price]");
	if(params[1] < 1 || params[1] > 1000) return Send(playerid, COLOR_GREY, "���� �� ������ ���� ������ 1, ��� ���� 1000!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[0]) && !IsPlayerInAnyVehicle(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���!");
	if(IsAMehCar(GetPlayerVehicleID(playerid))) {
		getname(playerid->sendername,params[0]->playername);
		format(string, sizeof string, "* �� ���������� %s �������� ��� ���������� �� $%d .", playername, params[1]);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* ������� %s ���������� �������� ��� ���������� �� $%d, (������ /accept repair ����� �����������)", sendername, params[1]);
		Send(params[0], COLOR_LIGHTBLUE, string);
		RepairOffer[params[0]] = playerid;
		RepairPrice[params[0]] = params[1];
	}
	return 1;
}

CMD:callcar(playerid, params[]) { new string[144];
	if(!CarCalls[playerid]) Send(playerid, COLOR_GREY, "���������������� �������� !");
	GetPlayerPos(playerid, posx, posy, posz);
	SetVehiclePos(CarID[playerid],posx, posy+4, posz);
	Send(playerid, COLOR_LIGHTBLUE, "* ��������� ���������� ������.");
	format(string, sizeof string, "* �� ������ ������� ���� ��������� ���������� � ������� %d ������ ������.", CarCalls[playerid]);
	Send(playerid, COLOR_LIGHTBLUE, string); CarCalls[playerid] -= 1;
	return 1;
}

CMD:f(playerid, params[]) { new string[144], sendername[24], replacecmdtext[255];
	if(IsPMuted(playerid)) return Send(playerid, COLOR_CYAN, "�� �� ������ ��������!");
	if(isnull(params) || params[0] == ' ') return Send(playerid, COLOR_GREY, "�������: /f [�����]");
	if(!IsAFamily(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ���� �����!");
	GetPlayerName(playerid, sendername, 24);
	regex_replace_exid(params, ADBlock, REPLACE_TEXT, replacecmdtext, sizeof replacecmdtext);
	format(string, sizeof string, "[F] %s %s: %s.**", RankInfo[Pl::FracID(playerid)][Pl::Info[playerid][pRank]], sendername, replacecmdtext);
	sendToFamily(Pl::FracID(playerid), COLOR_AZTECAS, string);
	return 1;
}

CMD:news(playerid, params[]) {
	if(IsPMuted(playerid)) return Send(playerid, COLOR_GREY, "* � ��� ��������!");
	if(Pl::FracID(playerid) != 9) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(!OnAir[playerid]) {
		if(OnAirMax >= 2) return Send(playerid, COLOR_GREY, "* � ����� ��� ����� ������ ����!");
		new veh = GetPlayerVehicleID(playerid);
		if((!veh &&IsANews(veh)) || IsPlayerInRangeOfPoint(playerid,5.0,353.4343,272.8408,1008.6656)) {
			Send(playerid, COLOR_GREY, "�� �� ���������� � ������� ��������, ��������� ��� � ������!");
		} else {
			OnAirMax++;
			OnAir[playerid] = true;
			Send(playerid,COLOR_LIGHTBLUE,"* �� ������ ����! �������� ������ � ���, � ���� ��������� ����� ���������");
		}
	} else {
		OnAirMax--;
		OnAir[playerid] = false;
		Send(playerid,COLOR_LIGHTBLUE,"* �� ��������� ����!");
	}
	return 1;
}

CMD:live(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::FracID(playerid) != 9) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(TalkingLive[playerid] != INVALID_PLAYER_ID) {
		Send(playerid, COLOR_LIGHTBLUE, "* �������� ��������");
		Send(TalkingLive[playerid], COLOR_LIGHTBLUE, "* �������� ��������");
		Rac::TogglePlayerControllable(playerid, 1);
		Rac::TogglePlayerControllable(TalkingLive[playerid], 1);
		TalkingLive[TalkingLive[playerid]] = INVALID_PLAYER_ID;
		TalkingLive[playerid] = INVALID_PLAYER_ID;
	} else {
		if(Pl::Info[playerid][pRank] <= 4) return Send(playerid, COLOR_GREY, "��� ���� ��������� �����, ����� ����� ��������!");
		if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /live [id/Name]");
		if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ ����� � ������ ���� ��������");
		if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) Send(playerid, COLOR_GREY, "* �� ������ �� ����� ������!");
		Rac::TogglePlayerControllable(playerid, 0);
		Rac::TogglePlayerControllable(params[0], 0);
		getname(playerid -> sendername,params[0] -> playername);
		format(string, sizeof string, "* �� ���������� �������� %s.", playername);
		Send(playerid, COLOR_LIGHTBLUE, string);
		format(string, sizeof string, "* �������� %s ���������� ��� ���� �������� (/accept live) �������.", sendername);
		Send(params[0], COLOR_LIGHTBLUE, string);
		LiveOffer[params[0]] = playerid;
	}
	return 1;
}

CMD:selldrugs(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::Info[playerid][pJob] != 4) Send(playerid, COLOR_GREY, "�� �� ����������!");
	if(sscanf(params, "uii", params[0], params[1], params[2])) return Send(playerid, COLOR_GREY, "�������: /selldrugs [playerid] [ammount] [price]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* ����� ��� �������� ����� � ������ ����?");
	if(params[1] < 1 || params[1] > 99) return Send(playerid, COLOR_GREY, "* ������ �� ������ ���� ������ 1, ��� ���� 99!");
	if(params[2] < 1 || params[2] > 99999) return Send(playerid, COLOR_GREY, "* ���� �� ������ ���� �� ������ 1, ��� ���� 99999!");
	if(params[1] > Pl::Info[playerid][pDrugs]) return Send(playerid, COLOR_GREY, "* �� �� ������ ������� ����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ����� � ����!");
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ���������� %s ������ %d ����� �� $%d", playername, params[1], params[2]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ������������� %s ���������� ��� ������ %d ����� �� $%d (������ /accept drugs ����� �����������)", sendername, params[1], params[2]);
	Send(params[0], COLOR_LIGHTBLUE, string); DrugOffer[params[0]] = playerid;
	DrugPrice[params[0]] = params[2]; DrugGram[params[0]] = params[1];
	
	return 1;
}

CMD:usedrugs(playerid, params[]) {
	if(Pl::Info[playerid][pDrugs] > 0) {
		Pl::Stoned[playerid] += 1;
		DrugIntoxic[playerid] = DrugIntoxic[playerid] + 60;
		SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+2000);
		Pl::Info[playerid][pDrugs] -= 2;
		if(Pl::Info[playerid][pDrugs] < 0) {
			Pl::Info[playerid][pDrugs] = 0;
		}
		Rac::GivePlayerHealth(playerid, 20.0);
		SetPlayerChatBubble(playerid, "������ ��������", COLOR_PURPLE, 40.0, 4000);
		Send(playerid, COLOR_PURPLE, "* �� ������������ 2 ������ ���������!");
		if(Pl::Stoned[playerid] >= 2) {
			GameTextForPlayer(playerid, "~w~You are~n~~p~Stoned", 4000, 1);
		}
		if(STDPlayer[playerid]) {
			STDPlayer[playerid] = 0;
			Send(playerid, COLOR_LIGHTBLUE, "* �� ������ �� ������� ��������� ��-�� ����������!");
		}
	} else {
		Send(playerid, COLOR_GREY, "* � ��� ��� �����!");
	}
	return 1;
}


CMD:givedrugs(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(sscanf(params, "ud", params[0], params[1])) return Send(playerid, COLOR_GRAD2, "�������: /givedrugs [playerid] [ammount]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "������ ���� ������ �����!");
	if(params[1] < 1 || params[1] > 99) return Send(playerid, COLOR_GREY, "* ������ �� ������ ���� ������ 1, ��� ���� 99!");
	if(Pl::Info[playerid][pDrugs] < params[1]) return Send(playerid,COLOR_GREY,"* � ��� ��� ������� �����!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[0])) return Send(playerid, COLOR_GREY, "* ��� ����� �� ����� ���!");
	Pl::Info[playerid][pDrugs] -= params[1];
	Pl::Info[params[0]][pDrugs] += params[1];
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ������ %s %d ����� �����", playername, params[1]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s ����� ��� %d ����� �����", sendername, params[1]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* %s �������� %s ���������", sendername, playername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	
	return 1;
}

CMD:outdrugs(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pDrugs] <= 0) return Send(playerid, COLOR_GREY, "� ��� ��� �����!");
	format(string, sizeof string, "* %s ���������� ��� ���������.", GetName(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	Pl::Info[playerid][pDrugs] = 0;
	return 1;
}

CMD:outmats(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pMats] <= 0) return Send(playerid, COLOR_GREY, "* � ��� ��� ����������!");
	format(string, sizeof string, "* %s ���������� ��� ���������.", GetName(playerid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	Pl::Info[playerid][pMats] = 0;
	return 1;
}

CMD:healme(playerid, params[]) {
	if(Pl::Info[playerid][pLocal] != 0) {
		new house = Pl::Info[playerid][pLocal] - OFFSET_HOUSE;
		if(IsValidHouse(house)) {
			if(IsPlayerInRangeOfPoint(playerid, 9.0, HouseInfo[house][hExit][0], HouseInfo[house][hExit][1], HouseInfo[house][hExit][2])
				&& HouseInfo[house][hVirtual] == GetPlayerVirtualWorld(playerid)) {
				SPD(playerid, D_HEALME, 0, "��� ������������?", "�������\n�����", "SELECT", "CANCEL");
			}
		}
	} else {
		if(IsPlayerInRangeOfPoint(playerid,3,1173.2563,-1323.3102,15.3943)||
		IsPlayerInRangeOfPoint(playerid,3,2029.5945,-1404.6426,17.2512)) return Send(playerid, COLOR_GREY, "�� �� � �������� !");
		if(STDPlayer[playerid] <= 0) return Send(playerid, COLOR_GREY, "�� �� ������!");
		switch(STDPlayer[playerid]) {
			case 1: Send(playerid, COLOR_LIGHTBLUE, "* �� ���� �������� �� ��������.");
			case 2: Send(playerid, COLOR_LIGHTBLUE, "* �� ���� �������� �� �������.");
			case 3: Send(playerid, COLOR_LIGHTBLUE, "* �� ���� �������� �� ��������.");
		}
		STDPlayer[playerid] = 0; Rac::GivePlayerMoney(playerid, -1000);
		Send(playerid, COLOR_CYAN, "������: ��� ����������� ���� �������� 1000$. ����� ��������!");
	}
	return 1;
}

CMD:eject(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(GetPlayerState(playerid) != 2) return Send(playerid,COLOR_GREY,"* �� �� �� �����!");
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /eject [playerid]");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "�� �� ������ ������� ����!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInVehiclePlayer(playerid, params[0])) return Send(playerid, COLOR_GREY, "* ��� ����� �� ��������� � ����� ����������!");
	
	new Float:x, Float:y, Float:z;
	GetCoordVehicleParams(GetPlayerVehicleID(playerid), 1, x, y, z);
	SetPlayerPos(params[0], x, y, z);
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� �������� %s �� ����������!", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* �� ���� �������� �� ���������� %s!", sendername);
	Send(params[0], COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:sex(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(Pl::Info[playerid][pJob] == 3) return Send(playerid, COLOR_GREY, "�� �� �����!");
	if(!IsPlayerInAnyVehicle(playerid)) return Send(playerid, COLOR_GREY, "* �� �� � ����������!");
	if(sscanf(params, "ud", params[0], params[1])) return Send(playerid, COLOR_GREY, "�������: /sex [playerid] [price]");
	if(params[1] < 1 || params[1] > 99999) return Send(playerid, COLOR_GREY, "* ���� �� ������ ���� ������ 1, ��� ���� 99999!");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ �������� ���� ����!");
	if(!IsPlayerInRangeOfPlayer(playerid, 8.0, params[0])) return Send(playerid, COLOR_GREY, "* ��� ����� �� ����� ���!");
	if(!IsPlayerInAnyVehicle(playerid) && !IsPlayerInVehicle(params[0], GetPlayerVehicleID(playerid))) return Send(playerid, COLOR_GREY, "* �� ��� ������ ����� ������ ���� � ����������!");
	SexOffer[params[0]] = playerid; SexPrice[params[0]] = params[1];
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ���������� ������� %s ������� ������ �� $%d.", playername, params[1]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ����� %s ��� ���� �� $%d (����� ������� /accept sex)", sendername, params[1]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:wanted(playerid, params[]) { new string[144], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	Send(playerid, COLOR_GREEN, "* � �������:");
	foreach(new i: WantedPlayers) {
		static count;
		if(count >= 5) {
			count = 0;
			string[strlen(string)-2] = '\0';
			Send(playerid, COLOR_YELLOW, string);
			string[0] = '\0';
		} else {
			count ++;
			GetPlayerName(i, playername, 24);
			scf(string, temp, "%s[%i]: %i. ", playername, i, Pl::Info[i][pWantedL]);
		}
	}
	if(strlen(string)) Send(playerid, COLOR_YELLOW, string);
	return 1;
}

CMD:dropcar(playerid, params[]) {
	if(Pl::Info[playerid][pJob] != 5) return Send(playerid, COLOR_GREY, "�� �� ����������� !");
	if(Pl::Info[playerid][pCarTime] != 0) return Send(playerid, COLOR_GREY, "�� ��� ������� ����������, ����� ���� ���������� �����!");
	GameTextForPlayer(playerid, "~w~Car Selling ~n~~r~Drop the car at the Crane", 5000, 1);
	CP[playerid] = 1;
	DestroyDynamicCP(checkpoints[playerid]);
	checkpoints[playerid] = CreateDynamicCP(-1548.3618,123.6438,3.2966,8.0,-1,-1,playerid,99999.9);
	return 1;
}

CMD:quitjob(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pJob] <= 0) return Send(playerid, COLOR_GREY, "* �� �� �������� �� ������!");
	if(Pl::Info[playerid][pVip] > 0) {
		if(Pl::Info[playerid][pContractTime] <= 4) {
			Iter::Remove(JobPlayers[Pl::Info[playerid][pJob]], playerid);
			Pl::Info[playerid][pJob] = 0;
			Pl::Info[playerid][pContractTime] = 0;
			Send(playerid, COLOR_LIGHTBLUE, "* �� ��������� � ������!");
		} else {
			format(string, sizeof string, "* ��� ����� ���������� %d �����, ����� ��������� � ������!", Pl::Info[playerid][pContractTime]);
			Send(playerid, COLOR_LIGHTBLUE, string);
		}
	} else {
		if(!Pl::Info[playerid][pContractTime]) {
			Iter::Remove(JobPlayers[Pl::Info[playerid][pJob]], playerid);
			Pl::Info[playerid][pJob] = 0;
			Pl::Info[playerid][pContractTime] = 0;
			Send(playerid, COLOR_LIGHTBLUE, "* �� ���������� 5 ����� �� ��������� � ��������� � ������.");
		} else {
			format(string, sizeof string, "* ��� ����� ���������� %d �����, ����� ��������� � ������!", Pl::Info[playerid][pContractTime]);
			Send(playerid, COLOR_LIGHTBLUE, string);
		}
	}
	return 1;
}

CMD:bail(playerid, params[]) { new string[144];
	if(Pl::Info[playerid][pJailed] != 1) return Send(playerid, COLOR_GREY, "* �� �� ���������� � ������!");
	if(JailPrice[playerid] <= 0) Send(playerid, COLOR_GREY, "* �� �� ������ ����� ��� �����!");
	if(Rac::GetPlayerMoney(playerid) > JailPrice[playerid]) return Send(playerid, COLOR_GREY, "* � ��� �� ������� �����!");
	JailPrice[playerid] = 0; WantLawyer[playerid] = 0; CallLawyer[playerid] = 0;
	Pl::Info[playerid][pJailTime] = 1; Rac::GivePlayerMoney(playerid, -JailPrice[playerid]);
	format(string, sizeof string, "* �� ��������� ���� ��: $%d", JailPrice[playerid]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	return 1;
}

CMD:clear(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(sscanf(params, "u", params[0])) return Send(playerid, COLOR_GREY, "�������: /clear [id/Name]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if(params[0] == playerid) return Send(playerid, COLOR_GREY, "* �� �� ������ �����������!");
	if(IsPlayerInRangeOfPoint(playerid,3.0, 253.9280,69.6094,1003.6406) || IsPlayerInRangeOfPoint(playerid,3.0, 256.7318,188.2524,1008.1719)) {
		if(IsACop(playerid)) {
			// ������� ������
			Pl::SetWantedLevel(params[0], 0);
			ClearCrime(params[0]);

			// ������� ���������
			getname(playerid -> sendername,params[0] -> playername);
			format(string, sizeof string, "* �� �������� ������� ������� �������������� %s.", playername);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* ������ %s ������� ��� ������� �������.", sendername);
			Send(params[0], COLOR_LIGHTBLUE, string);
		
		} else if(IsAMafia(playerid)) {
			if(Pl::FracID(params[0]) != Pl::FracID(playerid)) return Send(playerid, COLOR_GREY, "* ��� ����� �� ��������� � ����� �����!");
			if(Pl::Info[params[0]][pRank] < 4) return Send(playerid, COLOR_GREY, "�� ���������� � 4 �����, ����� �������� ������ �������!");
			if(Rac::GetPlayerMoney(playerid) < 5000) return Send(playerid, COLOR_GREY, "�� ���������� � 5000$, ����� �������� ������ ������ ����� �����!");

			// ������� ������
			Pl::SetWantedLevel(params[0], 0);
			ClearCrime(params[0]);
			Rac::GivePlayerMoney(playerid, -5000);

			// ������� ���������
			getname(playerid -> sendername,params[0] -> playername);
			format(string, sizeof string, "* �� �������� ������ �������������� %s �� 5000$.", playername);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* ���� ����� %s %s, ������� ��� ������.", RankInfo[Pl::FracID(playerid)][Pl::Info[playerid][pRank]], sendername);
			Send(params[0], COLOR_LIGHTBLUE, string);
		
		} else if(IsAGang(playerid)) {
			if(Pl::FracID(params[0]) != Pl::FracID(playerid)) return Send(playerid, COLOR_GREY, "* ��� ����� �� ��������� � ����� �����!");
			if(Pl::Info[params[0]][pRank] < 4) return Send(playerid, COLOR_GREY, "�� ���������� � 4 �����, ����� �������� ������ �������!");
			if(Rac::GetPlayerMoney(playerid) < 5000) return Send(playerid, COLOR_GREY, "�� ���������� � 5000$, ����� �������� ������ ������ ����� �����!");

			// ������� ������
			Pl::SetWantedLevel(params[0], 0);
			ClearCrime(params[0]);
			Rac::GivePlayerMoney(playerid, - 5000);

			// ������� ���������
			getname(playerid -> sendername,params[0] -> playername);
			format(string, sizeof string, "* �� �������� ������ �������������� %s �� 5000$.", playername);
			Send(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof string, "* ���� ����� %s %s, ������� ��� ������.", RankInfo[Pl::FracID(playerid)][Pl::Info[playerid][pRank]], sendername);
			Send(params[0], COLOR_LIGHTBLUE, string);
		}
	}
	else Send(playerid, COLOR_GRAD2, "�� �� � ��������� �������!");

	return 1;
}

CMD:ticket(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(!OnDuty[playerid] && Pl::FracID(playerid) == 1) return Send(playerid, COLOR_GREY, "�� �� ��� ���������� ��������� ������������!");
	if(sscanf(params, "uds[24]", params[0], params[1], params[2])) return Send(playerid, COLOR_GREY, "�������: /ticket [playerid] [price] [reason]");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ���������!");
	if(params[1] < 1 || params[1] > 99999) return Send(playerid, COLOR_GREY, "* ����� �� ����� ���� ���� $1 ��� ���� $99999!");
	if(!IsPlayerInRangeOfPlayer(playerid, 5.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� ����� ���!");
	
	TicketOffer[params[0]] = playerid;
	TicketMoney[params[0]] = params[1];
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� �������� %s ���� �� ����� $%d | �������: %s", playername, params[1], params[2]);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "* ������ %s ������� ��� ����� �� ����� $%d, �������: %s", sendername, params[1], params[2]);
	Send(params[0], COLOR_LIGHTBLUE, string);
	Send(params[0], COLOR_LIGHTBLUE, "* �������� /accept ticket, ����� ������� �����.");
	return 1;
}

CMD:arrest(playerid, params[]) { new string[144], sendername[24], playername[24];
	if(!IsACop(playerid)) return Send(playerid, COLOR_GREY, "* �� �� ��������!");
	if(!OnDuty[playerid] && Pl::FracID(playerid) == 1) return Send(playerid, COLOR_GREY, "* �� �� ��� ���������� ��������� ������������!");
	if(!IsPlayerInRangeOfPoint(playerid, 10.0, 268.3327,77.8972,1001.0391)) return Send(playerid, COLOR_GREY, "* �� �� ����� ������, �� ����� ����������!");
	if(sscanf(params, "uiiI(0)I(1)", params[0], params[1], params[2], params[3], params[4])) return Send(playerid, COLOR_GREY, "�������: /arrest [id/Name] [price] [time] [bail] [bailprice]");
	if(params[1] < 1 || params[1] > 99999) return Send(playerid, COLOR_GREY, "* ���� �� ����� �� ����� ���� ���� 1$ ��� ���� 99999$ !");
	if(params[2] < 1 || params[2] > 6000) return Send(playerid, COLOR_GREY, "* ������� ��������� ���������� �� ����� ���� ���� 1, ��� ���� 6000!");
	if(params[3] < 0 || params[3] > 1) return Send(playerid, COLOR_GREY, "* ������ ������ �� ����� ���� ���� 0 ��� ���� 1!");
	if(params[4] < 0 || params[4] > 3000000) return Send(playerid, COLOR_GREY, "* ����� �� ����� ���� ���� 0$ ��� ���� 3000000$ !");
	if(!Pl::isLogged(params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� �� �����������!");
	if(!IsPlayerInRangeOfPlayer(playerid, 3.0, params[0])) return Send(playerid, COLOR_GREY, "* ���� ����� ������� ������ �� ���");
	if(Pl::Info[params[0]][pWantedL] < 1) return Send(playerid, COLOR_GREY, "* ����� ������ �� ������� ���� ���� � �������!");
	if(IsACop(params[0])) return Send(playerid,COLOR_GREY,"* ������ ������ �����");
	
	Rac::GivePlayerMoney(params[0], -params[1]);
	Jailed(params[0], params[2], 1);
	SetPlayerFree(params[0], playerid, "Got Arrested");
	if(params[3] == 1) {
		JailPrice[params[0]] = params[4];
		format(string, sizeof string, "�� ��������� � ������ � ������� %i ������. �����: $%d", Pl::Info[params[0]][pJailTime], JailPrice[params[0]]);
		Send(params[0], COLOR_LIGHTBLUE, string);
	} else {
		JailPrice[params[0]] = 0;
		format(string, sizeof string, "�� ��������� � ������ � ������� %i ������. �����: ��� ������", Pl::Info[params[0]][pJailTime]);
		Send(params[0], COLOR_LIGHTBLUE, string);
	}
	
	getname(playerid -> sendername,params[0] -> playername);
	format(string, sizeof string, "* �� ���������� %s!", playername);
	Send(playerid, COLOR_LIGHTBLUE, string);
	format(string, sizeof string, "arrested by %s ~n~    for $%d", sendername, params[1]);
	GameTextForPlayer(params[0], string, 5000, 5);
	
	switch(Pl::FracID(playerid)) {
		case 1 : strunpack(temp, !"������" );
		case 2 : strunpack(temp, !"����� ���" );
		case 3 : strunpack(temp, !"������" );
	}
	format(string, sizeof string, "<< %s %s ��������� �������������� %s >>", temp, sendername, playername);
	OOCNews(COLOR_LIGHTRED, string);

	return 1;
}


CMD:dice(playerid, params[]) { new string[144];
	if(!gDice[playerid]) return Send(playerid, COLOR_GRAD2, "* � ��� ��� ������!");
	new dice = random(6)+1;
	format(string, sizeof string, "* %s ������� �����. ������ ����� %d", GetName(playerid), dice);
	ProxDetector(5.0, playerid, string, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN, COLOR_GREEN);
	return 1;
}