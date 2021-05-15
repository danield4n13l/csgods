// =========================================================== //

#include <MovementHUD>

// ====================== PLUGIN INFO ======================== //

public Plugin myinfo =
{
	name = "MovementHUD-Tracking-KZTimer",
	author = "Sikari",
	description = "Provides MHud tracking accuracy for KZTimer (plugin)",
	version = "1.0.0",
	url = "https://bitbucket.org/Sikarii/movementhud-tracking"
};

// =========================================================== //

bool gB_DidPerf[MAXPLAYERS + 1];
float gF_TakeoffSpeed[MAXPLAYERS + 1];

// ======================= MAIN CODE ========================= //

public void OnPluginStart()
{
    HookEvent("player_jump", Event_Jump, EventHookMode_Pre);
}

public void OnClientPutInServer(int client)
{
    gB_DidPerf[client] = false;
    gF_TakeoffSpeed[client] = 0.0;
}

public void Event_Jump(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    gF_TakeoffSpeed[client] = GetSpeed(client);
    gB_DidPerf[client] = MHud_Movement_GetGroundTicks(client) == 1;
}

public void MHud_Movement_OnTakeoff(int client, bool didJump, bool &didPerf, float &takeoffSpeed)
{
	if (didJump)
	{
		didPerf = gB_DidPerf[client];
		takeoffSpeed = gF_TakeoffSpeed[client];
	}
	else
	{
		didPerf = false;
		takeoffSpeed = MHud_Movement_GetCurrentSpeed(client);
	}
}

// =========================================================== //