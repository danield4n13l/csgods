copy .\csgo\mapcycle_hns.txt .\csgo\mapcycle.txt & REM copy .\csgo\mapcycle_hns.txt .\csgo\maplist.txt
start cmd /C "echo Starting HTTPD... && .\fastdl\bin\httpd.exe" & 
.\srcds.exe -high -usercon -console -game csgo -tickrate 128 -port 27015 -maxdownloadfilesizemb 500 +sv_pure 0 +sv_lan 1 +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage +tv_allow_camera_man_steamid1 "76561198134622425" +tv_enable 1 +tv_delay 5