#include <sdktools>
#include <cstrike>
#include <colors_csgo>
#include <logging>

bool g_bCanWhistle[MAXPLAYERS+1];

#define PLUGIN_PREFIX " {lime}{default}{lime}[HNS]{default}"		/* The prefix of the plugin's chat commands */
#define WHISTLE_FULL_SOUND_PATH "sound/danield4n13l/whistle.mp3"	/* Whistle sound path, relative to the base (csgo/) directory */
#define WHISTLE_RELATIVE_SOUND_PATH "*danield4n13l/whistle.mp3"		/* Whistle sound path, relative to the sound/ directory */
#define WHISTLE_fCOOLDOWN 10.0										/* Minimum time between two whistle uses, in seconds. */

public Plugin myinfo = 
{
	name = "Simple Whistle Reloaded", 
	author = "zwolof + d3st1ny",			// shoutout to [zwolof](https://forums.alliedmods.net/member.php?u=287342) for creating the original whistle.smx
	description = "Simple Whistle Plugin with targeting and cvars",
	version = "1.0b2",
	url = "https://steamcommunity.com/id/d3st1nyofficial"
};

public void OnPluginStart()
{
	for(int i = 1; i <= MaxClients; i++)
		if(IsValidClient(i) && !IsFakeClient(i))
			g_bCanWhistle[i] = true;
}

public OnMapStart()
{
	AddFileToDownloadsTable(WHISTLE_FULL_SOUND_PATH);
	FakePrecacheSound(WHISTLE_RELATIVE_SOUND_PATH);
}

// Issue fix?
public OnClientConnected(client)
{
	if(IsValidClient(client) && !IsFakeClient(client)) {
		g_bCanWhistle[client] = true;
	}
}

public Action OnPlayerRunCmd(client, &buttons)
{
	if(!IsPlayerAlive(client)) 
		return Plugin_Continue;
		
	if(!IsValidClient(client))
		return Plugin_Continue;
		
	if(GetClientTeam(client) == CS_TEAM_T)
	{
		if(buttons & IN_USE && g_bCanWhistle[client])
		{
			char szName[256];
			char szTarget[256];
			GetClientName(client, szName, sizeof(szName));

			int target;
			target = GetClientAimTarget(client, false);
			
			if(IsValidClient(target) && IsPlayerAlive(target)) {
				GetClientName(target, szTarget, sizeof(szTarget));

				CPrintToChatAll("%s {grey}%s{default} has whistled to {red}%s{default}!", PLUGIN_PREFIX, szName, szTarget);

				float fVec[3];
				GetClientAbsOrigin(client, fVec);
				fVec[2] += 10;	

				EmitAmbientSound(WHISTLE_RELATIVE_SOUND_PATH, fVec, client, SNDLEVEL_RAIDSIREN, _, 0.3);

				g_bCanWhistle[client] = false;
				CreateTimer(WHISTLE_fCOOLDOWN, RemoveCooldown, client);
			}
			
		}
	}
	return Plugin_Continue;
}

public Action RemoveCooldown(Handle tmr, int client)
{
	g_bCanWhistle[client] = true;
	CPrintToChat(client, "%s You can now {lime}whistle{default} again!", PLUGIN_PREFIX);
}

stock FakePrecacheSound(const char[] szPath) 
{
	AddToStringTable(FindStringTable("soundprecache"), szPath);
}

stock bool IsValidClient(int client)
{
	// GetEntProp(client, Prop_Send, "m_bIsControllingBot") != 1
    if (!(1 <= client <= MaxClients) || !IsClientInGame(client) || IsClientSourceTV(client) || IsClientReplay(client))
    {
        return false;
    }
    return true;
}