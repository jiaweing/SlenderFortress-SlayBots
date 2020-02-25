#include <sdktools>

public Plugin myinfo =
{
	name 		= 	"Slender Fortress: Bot Slay",
	author 		= 	"myst",
	description	=	"Slays all bots on the playing team if there are no humans left playing.",
	version 	= 	"1.0"
};

public void OnPluginStart() {
	HookEvent("player_death", SF2_PlayerDeath, EventHookMode_Post);
}

public void OnPluginEnd() {
	UnhookEvent("player_death", SF2_PlayerDeath, EventHookMode_Post);
}

public Action SF2_PlayerDeath(Handle hEvent, const char[] sEventName, bool bDontBroadcast)
{
	CreateTimer(1.0, Timer_UpdateBots, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_UpdateBots(Handle hTimer)
{
	if (GetPlayerTeamCount(2) == 0 && GetPlayerCount() > 0)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsValidClient(i) && IsFakeClient(i) && GetClientTeam(i) == 2)
				ForcePlayerSuicide(i);
		}
	}
}

stock int GetPlayerTeamCount(int iTeam)
{
	int iCount;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && !IsFakeClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == iTeam)
			iCount++;
	}
	
	return iCount;
}

stock int GetPlayerCount()
{
	int iCount;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && !IsFakeClient(i) && GetClientTeam(i) != 1)
			iCount++;
	}
	
	return iCount;
}

stock bool IsValidClient(int iClient, bool bReplay = true)
{
	if (iClient <= 0 || iClient > MaxClients || !IsClientInGame(iClient))
		return false;
	if (bReplay && (IsClientSourceTV(iClient) || IsClientReplay(iClient)))
		return false;
	return true;
}