#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Global HNS"
#define PLUGIN_VERSION "1.00"
#define PLUGIN_PREFIX " {orange}{default}{orange}[Damage]{default}"

#include <sourcemod>
#include <sdkhooks>
#include <colors_csgo>

public Plugin myinfo = 
{
    name = "Print Fall Damage",
    author = PLUGIN_AUTHOR,
    description = "Prints how many fall damage players have received.",
    version = PLUGIN_VERSION,
    url = "https://discord.gg/unt5ffP"
};

public void OnPluginStart()
{
    for(int i=1;i<=MaxClients;++i)
        if(IsClientInGame(i))
            SDKHook(i, SDKHook_OnTakeDamage, Event_OnTakeDamage);
    
}

public void OnClientPutInServer(int client)
{
    SDKHook(client, SDKHook_OnTakeDamage, Event_OnTakeDamage);
}

public Action Event_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{
    
    if( (damagetype & DMG_FALL || damagetype & DMG_VEHICLE) && RoundToFloor(damage) > 0.0)
    {
        CPrintToChatAll("%s {grey}%N{default} just took {red}%d{default} fall damage.", PLUGIN_PREFIX, victim, RoundToFloor(damage));
    }
    
    return Plugin_Continue;
}