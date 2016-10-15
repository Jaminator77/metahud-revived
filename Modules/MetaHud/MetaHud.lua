--- Init Vars --
METAHUD_NAME = "MetaHud - Revived Branch"
METAHUD_TOC = 50400;
METAHUD_VERSION = "v"..METAHUD_TOC.."-9.1";
METAHUD_ICON = "Interface\\AddOns\\MetaHud\\Layout\\Icon";
METAHUD_LAYOUTPATH = "Interface\\AddOns\\MetaHud\\Layout\\";
BINDING_HEADER_METAHUD = "|cff00FF80"..METAHUD_NAME.."|r";
local _G = _G

-- Constants
METAHUD_RUNE_SIZE_X = 32;
METAHUD_RUNE_SIZE_Y = 16;
METAHUD_BUFF_SIZE = 18;
METAHUD_RUNE_FRAME_X = METAHUD_RUNE_SIZE_X * 6;
METAHUD_RUNE_FRAME_Y = METAHUD_RUNE_SIZE_Y;

METAHUD_TEXT_EMPTY = "";
METAHUD_TEXT_HP2   = "<color_hp><hp_value></color>";
METAHUD_TEXT_HP3   = "<color_hp><hp_value></color>/<hp_max>";
METAHUD_TEXT_HP4   = "<color_hp><hp_percent></color>";
METAHUD_TEXT_HP5   = "<color_hp><hp_value></color> <color>999999(</color><hp_percent><color>999999)</color>";
METAHUD_TEXT_HP6   = "<color_hp><hp_value>/<hp_max></color> <color>999999(</color><hp_percent><color>999999)</color>";
METAHUD_TEXT_MP2   = "<color_mp><mp_value></color>";
METAHUD_TEXT_MP3   = "<color_mp><mp_value></color>/<mp_max>";
METAHUD_TEXT_MP4   = "<color_mp><mp_percent></color>";
METAHUD_TEXT_MP5   = "<color_mp><mp_value></color> <color>999999(</color><mp_percent><color>999999)</color>";
METAHUD_TEXT_MP6   = "<color_mp><mp_value>/<mp_max></color> <color>999999(</color><mp_percent><color>999999)</color>";
METAHUD_TEXT_MP7   = "<color_mp><mp_value_druid></color>";
METAHUD_TEXT_TA1   = "[<color_level><level><elite></color>] <color_reaction><pvp_rank> <name></color> [<color_class><class><type><pet><npc></color>] <raidgroup>";
METAHUD_TEXT_TA2   = "[<color_level><level><elite></color>] <color_reaction><name></color> [<color_class><class><type><pet><npc></color>]";
METAHUD_TEXT_TA3   = "[<color_level><level><elite></color>] <color_reaction><name></color>";

MetaHud = {
     debug             = nil,
     vars_loaded       = nil,
     enter             = nil,
     issetup           = nil,
     isinit            = nil,
     userID            = nil,
     inCombat          = nil,
     Attacking         = nil,
     TimerSet          = nil,
     inParty           = nil,
     Regen             = nil,
     Target            = nil,
     needMana          = nil,
     needHealth        = nil,
     playerDead        = nil,
     PetneedHealth     = nil,
     PetneedMana       = nil,
     has_target_health = nil,
     has_target_mana   = nil,
     has_pet_health    = nil, 
     has_pet_mana      = nil, 
     player_class      = nil,
     update_elapsed    = 0,
     step              = 0.005,
     stepfast          = 0.02,
     defaultfont       = "Fonts/FRIZQT__.TTF",  
     defaultfont_num   = METAHUD_LAYOUTPATH.."Number.TTF",  

     C_textures    = nil,
     C_frames      = nil,
     C_curLayout   = nil,
     C_tClips      = nil,
     C_names       = nil,

     timer         = 0,
     frame_level   = nil,

     ---  current mana / health values
     bar_values    = {
          MetaHud_PlayerHealth_Bar  = 1,
          MetaHud_PlayerMana_Bar    = 1,
          MetaHud_TargetHealth_Bar  = 0,
          MetaHud_TargetMana_Bar    = 0,
          MetaHud_PetHealth_Bar     = 0,
          MetaHud_PetMana_Bar       = 0,    
     },

     ---  animated mana / health values
     bar_anim      = {
          MetaHud_PlayerHealth_Bar  = 1,
          MetaHud_PlayerMana_Bar    = 1,
          MetaHud_TargetHealth_Bar  = 1,
          MetaHud_TargetMana_Bar    = 1,
          MetaHud_PetHealth_Bar     = 1,
          MetaHud_PetMana_Bar       = 1,       
     },

     ---  flag for animation             
     bar_change    = {
          MetaHud_PlayerHealth_Bar  = 0,
          MetaHud_PlayerMana_Bar    = 0,
          MetaHud_TargetHealth_Bar  = 0,
          MetaHud_TargetMana_Bar    = 0,
          MetaHud_PetHealth_Bar     = 0,
          MetaHud_PetMana_Bar       = 0,        
     },

     ---  powertypes
     powertypes = {"mana", "rage", "focus", "energy", "Runes", "Runic Power"},
     -- original code: powertypes = {"mana", "rage", "focus", "energy", "happiness", "Runes", "Runic Power"},

     ---  font outlines
     Outline       = { "", "OUTLINE", "THICKOUTLINE" },

     name2unit     = {
          MetaHud_PlayerHealth_Bar  = "player",
          MetaHud_PlayerMana_Bar    = "player",
          MetaHud_TargetHealth_Bar  = "target",
          MetaHud_TargetMana_Bar    = "target",
          MetaHud_PetHealth_Bar     = "pet",
          MetaHud_PetMana_Bar       = "pet",
          MetaHud_Target_Text       = "target",
          MetaHud_ToTarget_Text     = "targettarget",
          MetaHud_Range_Text        = "target",
          MetaHud_Guild_Text        = "target",
     },

     name2typ      = {
          MetaHud_PlayerHealth_Bar  = "health",
          MetaHud_PlayerMana_Bar    = "mana",
          MetaHud_TargetHealth_Bar  = "health",
          MetaHud_TargetMana_Bar    = "mana",
          MetaHud_PetHealth_Bar     = "health",
          MetaHud_PetMana_Bar       = "mana",
     },

     text2bar    = {
          MetaHud_PlayerHealth_Text = "MetaHud_PlayerHealth_Bar",
          MetaHud_PlayerMana_Text   = "MetaHud_PlayerMana_Bar",
          MetaHud_TargetHealth_Text = "MetaHud_TargetHealth_Bar",
          MetaHud_TargetMana_Text   = "MetaHud_TargetMana_Bar",
          MetaHud_PetHealth_Text    = "MetaHud_PetHealth_Bar",
          MetaHud_PetMana_Text      = "MetaHud_PetMana_Bar",
          MetaHud_Target_Text       = "MetaHud_Target_Text",
          MetaHud_ToTarget_Text     = "MetaHud_ToTarget_Text",
          MetaHud_Range_Text        = "MetaHud_Range_Text",
          MetaHud_Threat            = "MetaHud_Threat",
          MetaHud_Guild_Text        = "MetaHud_Guild_Text",
     },

     ---  alphamode textures
     alpha_textures = {
          "MetaHud_LeftFrame_Texture",
          "MetaHud_RightFrame_Texture",
          "MetaHud_PlayerHealth_Bar_Texture",
          "MetaHud_PlayerMana_Bar_Texture",
          "MetaHud_TargetHealth_Bar_Texture",
          "MetaHud_TargetMana_Bar_Texture",
          "MetaHud_PetHealth_Bar_Texture",
          "MetaHud_PetMana_Bar_Texture",
          "MetaHud_PlayerResting",
          "MetaHud_TargetIcon",
          "MetaHud_PlayerAttacking",
          "MetaHud_PlayerLeader",
          "MetaHud_PlayerLooter",
          "MetaHud_PlayerPvP",
          "MetaHud_TargetElite",
          ---     "MetaHud_PetHappy",
          "MetaHud_RuneFrame",
     },

     ---  alphamode text
     alpha2_textures = {
          "MetaHud_PlayerHealth_Text",
          "MetaHud_PlayerMana_Text",
          "MetaHud_TargetHealth_Text",
          "MetaHud_TargetMana_Text",
          "MetaHud_PetHealth_Text",
          "MetaHud_PetMana_Text",
          "MetaHud_Target_Text",
          "MetaHud_Threat",
          "MetaHud_ToTarget_Text",
          "MetaHud_ToT_SubFrame",
          "MetaHud_Range_Text",
          "MetaHud_Guild_Text",
     },

     ---  reaction Colors
     ReacColors    = { "ff0000","ffff00","55ff55","8888ff","008800","cccccc" }, 

     ---  prepared Colors
     BarColorTab   = {},

     -- Main Events
     -- WotLK PLAYER_COMBO_POINTS changed to UNIT_COMBO_POINTS, PLAYER_AURAS_CHANGED removed
     -- UNIT_ENERGYMAX, UNIT_MANAMAX, UNIT_FOCUSMAX, UNIT_HEALTHMAX, UNIT_RAGEMAX removed
     -- Cata removed UNIT_MANA, UNIT_ENERGY, UNIT_RAGE, UNIT_RUNIC_POWER, UNIT_FOCUS and UNIT_HAPPINESS
     -- instead "UNIT_POWER",
     mainEvents    = { "UNIT_AURA","UNIT_PET","UNIT_HEALTH",
          "UNIT_POWER",
          "UNIT_DISPLAYPOWER","UNIT_RUNE","UNIT_TARGET",
          "PLAYER_ENTER_COMBAT","PLAYER_LEAVE_COMBAT","PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED",
          "PLAYER_TARGET_CHANGED","UNIT_COMBO_POINTS","PLAYER_ALIVE","PLAYER_DEAD", "RAID_TARGET_UPDATE",
          "UNIT_SPELLCAST_CHANNEL_START","UNIT_SPELLCAST_CHANNEL_UPDATE","UNIT_SPELLCAST_DELAYED","UNIT_SPELLCAST_FAILED",
          "UNIT_SPELLCAST_INTERRUPTED","UNIT_SPELLCAST_START","UNIT_SPELLCAST_STOP","UNIT_SPELLCAST_CHANNEL_STOP",
          "PLAYER_UPDATE_RESTING","UNIT_PVP_UPDATE","PLAYER_PET_CHANGED","UNIT_PVP_STATUS","PLAYER_UNGHOST",
          "UNIT_ENTERED_VEHICLE", "UNIT_EXITED_VEHICLE", "VEHICLE_PASSENGERS_CHANGED", "UPDATE_SHAPESHIFT_FORM" --"UPDATE_SHAPESHIFT_FORMS"--, "COMPANION_UPDATE" , "UNIT_ENTERING_VEHICLE"
     },

     ---  movable frame
     moveFrame     = {
          MetaHud_Main              = { "xoffset"         , "yoffset"               },
          MetaHud_LeftFrame         = { "hudspacing"      , ""               , "-"  },
          MetaHud_RightFrame        = { "hudspacing"      , ""                      },
          MetaHud_Target_Text       = { "targettextx"     , "targettexty"           },
          MetaHud_ToTarget_Text     = { "totargettextx"   , "totargettexty"         },
          MetaHud_Range_Text        = { "rangetextx"      , "rangetexty"            },
          MetaHud_Guild_Text        = { "guildtextx"      , "guildtexty"            },
          MetaHud_PlayerHealth_Text = { "playerhptextx"   , "playerhptexty"         },
          MetaHud_PlayerMana_Text   = { "playermanatextx" , "playermanatexty"       },
          MetaHud_TargetHealth_Text = { "targethptextx"   , "targethptexty"         },
          MetaHud_TargetMana_Text   = { "targetmanatextx" , "targetmanatexty"       },
          MetaHud_PetHealth_Text    = { "pethptextx"      , "pethptexty"            },
          MetaHud_PetMana_Text      = { "petmanatextx"    , "petmanatexty"          }, 
     },

     ---  default settings                
     Config_default = {
          ["version"]            = METAHUD_VERSION,
          ["layouttyp"]          = 1,
          ["profile"]            = "Default",
          ["combatalpha"]        = 0.8,
          ["oocalpha"]           = 0.8,
          ["selectalpha"]        = 0.8,
          ["regenalpha"]         = 0.8,
          ["textalpha"]          = 1,
          ["scale"]              = 1.0,
          ["targetbuffsize"]     = 15,
          ["targetdebuffsize"]   = 15,
          ["buffheight"]         = 260,
          ["buffx"]              = 53,
          ["buffy"]              = 0,
          ["debuffx"]            = -53,
          ["debuffy"]            = 0,
          ["showallcd"]          = 0,
          ["showmycd"]           = 1,
          ["runeVerticle"]        = 0,
          ["runeorient"]         = 0,
          ["runeframex"]         = 0,
          ["runeframey"]         = -100,
          ["ttscale"]            = 0.8,
          ["showresticon"]       = 1, 
          ["showplayer"]         = 1,
          ["showplayerleadericon"]  = 1,   
          ["showplayerlootericon"]  = 1,   
          ["showplayerpvpicon"]  = 1,   
          ["showtargetpvpicon"]  = 0,  
          ["showtargeticon"]     = 1,  
          ["showpeticon"]        = 1, 
          ["showeliteicon"]      = 1, 
          ["showcombopoints"]    = 1,
          ["showrunes"]          = 1,
          ["showholypower"]      = 1,
          ["showsoulshards"]     = 1,
          ["animatebars"]        = 1,
          ["barborders"]         = 1,
          ["showauras"]          = 1,
          ["showauratips"]       = 1,
          ["doublemine"]         = 1,
          ["showtarget"]         = 1,
          ["showtotarget"]       = 1,
          ["playsound"]          = 1,
          ["texturefile"]        = 1,
          ["soundfile"]          = 1,
          ["fontfile"]           = 1,
          ["showrange"]          = 1,
          ["showguild"]          = 1,
          ["showthreat"]         = 1,
          ["activename"]         = 0,
          ["showflighttimer"]    = 1,
          ["showelitetext"]      = 0,
          ["showpet"]            = 1,
          ["btarget"]            = 0,
          ["bplayer"]            = 0,                
          ["swaptargetauras"]    = 0,
          ["ewcontrol"]          = 0,

          ["MetaHud_PlayerHealth_Text"] = "<color_hp><hp_value></color> <color>999999(</color><hp_percent><color>999999)</color>",
          ["MetaHud_PlayerMana_Text"]   = "<color_mp><mp_value></color> <color>999999(</color><mp_percent><color>999999)</color>",
          ["MetaHud_TargetHealth_Text"] = "<color_hp><hp_value></color> <color>999999(</color><hp_percent><color>999999)</color>",
          ["MetaHud_TargetMana_Text"]   = "<color_mp><mp_value></color> <color>999999(</color><mp_percent><color>999999)</color>",                                  
          ["MetaHud_PetHealth_Text"]    = "<color_hp><hp_value></color>",
          ["MetaHud_PetMana_Text"]      = "<color_mp><mp_value></color>",
          ["MetaHud_Target_Text"]       = "<color_reaction><name></color> [<color_level><level><elite></color><color_class><class><type><pet><npc></color>] <raidgroup>",
          ["MetaHud_ToTarget_Text"]     = "<color_reaction><totarget></color>",
          ["MetaHud_Range_Text"]        = "<range>",
          ["MetaHud_Threat"]            = "<threat>",
          ["MetaHud_Guild_Text"]        = "<guild>",

          ["playerhpoutline"]     = 1,
          ["playermanaoutline"]   = 1,
          ["targethpoutline"]     = 1,
          ["targetmanaoutline"]   = 1,
          ["pethpoutline"]        = 1,
          ["petmanaoutline"]      = 1,
          ["targetoutline"]       = 1,
          ["totargetoutline"]       = 1,
          ["rangeoutline"]       = 1,
          ["guildoutline"]       = 1,

          ["fontsizepet"]        = 9,
          ["fontsizeplayer"]     = 12,
          ["fontsizetarget"]     = 12,     
          ["fontsizetotarget"]   = 11,     
          ["fontsizerange"]      = 12,     
          ["fontsizeguild"]      = 12,     
          ["fontsizetargetname"] = 14,

          ["xoffset"]            = 0,
          ["yoffset"]            = 0,
          ["hudspacing"]         = 35,
          ["targettexty"]        = 0,
          ["totargettexty"]      = -121,
          ["totargettextx"]        = 0,
          ["rangetexty"]         = -303,
          ["rangetextx"]             = 0,
          ["guildtexty"]         = -4,
          ["guildtextx"]             = 0,
          ["playerhptextx"]      = 0,
          ["playerhptexty"]      = 0,
          ["playermanatextx"]    = 0,
          ["playermanatexty"]    = 0,
          ["targethptextx"]      = 0,
          ["targethptexty"]      = 0,
          ["targetmanatextx"]    = 0,
          ["targetmanatexty"]    = 0,
          ["pethptextx"]         = 0,
          ["pethptexty"]         = 0,
          ["petmanatextx"]       = 0,
          ["petmanatexty"]       = 0,

          ["colors"] = {
               health_player = { "00FF00", "FFFF00", "FF0000" }, --
               health_target = { "00aa00", "aaaa00", "aa0000" }, --
               health_pet    = { "00FF00", "FFFF00", "FF0000" }, --
               mana_player   = { "00FFFF", "0000FF", "FF00FF" }, --
               mana_target   = { "00aaaa", "0000aa", "aa00aa" }, --
               mana_pet      = { "00FFFF", "0000FF", "FF00FF" }, --
               rage_player   = { "FF0000", "FF0000", "FF0000" }, --
               rage_target   = { "aa0000", "aa0000", "aa0000" }, --
               energy_player = { "FFFF00", "FFFF00", "FFFF00" }, --
               energy_target = { "aaaa00", "aaaa00", "aaaa00" }, --
               focus_target  = { "aa4400", "aa4400", "aa4400" }, --
               focus_pet     = { "aa4400", "aa4400", "aa4400" }, --
               tapped        = { "cccccc", "bbbbbb", "aaaaaa" }, --
          },
     },

     FontFile = {
          "default",
          "Fonts\\MORPHEUS.TTF",
          "Fonts\\SKURRI.TTF",
          "Fonts\\ARIALN.TTF",
          METAHUD_LAYOUTPATH.."font.ttf",
     },
}

--- OnLoad --
function MetaHud:OnLoad()
     --- Event
     MetaHud_EventFrame:RegisterEvent("VARIABLES_LOADED");
     MetaHud_EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
     MetaHud_EventFrame:RegisterEvent("PLAYER_LEAVING_WORLD");
     --- slash handler
     SLASH_MetaHud1 = "/MetaHud";
     SlashCmdList["MetaHud"] = function(msg)
          MetaHud:SCommandHandler(msg);
     end

     --- addon loaded 
     MetaHud:print("Loaded "..METAHUD_VERSION);

end

--- firstload
function MetaHud:firstload()
     MetaHud:printd("MetaHud.vars_loaded: "..(MetaHud.vars_loaded or "0") );
     MetaHud:printd("MetaHud.enter: "..(MetaHud.enter or "0") );
     if MetaHud.vars_loaded == 1 and MetaHud.enter == 1 and MetaHud.isinit == nil and MetaHud.issetup == nil then
          MetaHud:setup();
          MetaHud:init();
          if(MetaHudOptions.layouttyp == "MetaHud_Standard_Layout") then
               MetaHud:SetConfig("layouttyp", 1);
          elseif(MetaHudOptions.layouttyp == "MetaHud_PlayerLeft_Layout") then
               MetaHud:SetConfig("layouttyp", 2);
          end
          return true;
     end
     return false;
end

--- OnEvent --
function MetaHud:OnEvent(self, event, ...)
     local arg1 = ...;
     --- init HUD
     if event == "VARIABLES_LOADED" then    
          MetaHud.vars_loaded = 1;
          MetaHud:firstload();
          --- zoning  
     elseif event == "PLAYER_ENTERING_WORLD" then
          MetaHud.enter = 1;
          if MetaHud:firstload() then return; end       
          if MetaHud.issetup ~= 2 then return; end
          if MetaHud.isinit  ~= 2 then return; end
          MetaHud:init();
          MetaHud:UpdateCombos();
          --MetaHud:UpdateRunes();
          --MetaHud_HolyPower1:Hide();
          --MetaHud_HolyPower2:Hide();
          --MetaHud_HolyPower3:Hide();
          --- update HEALTH Bars    or event == "UNIT_HEALTHMAX" removed
     elseif(event == "UNIT_HEALTH" ) then
          if arg1 == "player" then
               MetaHud:UpdateValues("MetaHud_PlayerHealth_Text");
          elseif arg1 == "target" then
               MetaHud:UpdateValues("MetaHud_TargetHealth_Text");
          elseif arg1 == "pet" then
               MetaHud:UpdateValues("MetaHud_PetHealth_Text");
          end
          MetaHud:updateAlpha();
          --- Fix to update Sunder 
          MetaHud:UpdateCombos(); 
          -- update MANA Bars, UNIT_ENERGYMAX, UNIT_MANAMAX, UNIT_FOCUSMAX, UNIT_RAGEMAX   removed 
     elseif(event == "UNIT_POWER" or event == "UNIT_DISPLAYPOWER") then
          if arg1 == "player" then
               MetaHud:UpdateValues("MetaHud_PlayerMana_Text");
               MetaHud:UpdateCombos();
               --MetaHud:UpdateRunes();
               --MetaHud:UpdateHolyPower();
          elseif arg1 == "target" then
               MetaHud:UpdateValues("MetaHud_TargetMana_Text");
          elseif arg1 == "pet" then
               MetaHud:UpdateValues("MetaHud_PetMana_Text");
          end
          --- Druidbar support
          if DruidBarKey and MetaHud.player_class == "DRUID" then
               MetaHud:UpdateValues("MetaHud_PetMana_Text");
               MetaHud:doText("MetaHud_PlayerMana_Text");
               MetaHud:doText("MetaHud_PetMana_Text");
          end
          MetaHud:updateAlpha();
     elseif event == "PLAYER_AURAS_CHANGED" then
          MetaHud:doText("MetaHud_PlayerMana_Text");
          MetaHud:doText("MetaHud_PetMana_Text");
          MetaHud:UpdateValues("MetaHud_PlayerMana_Text");
          MetaHud:UpdateValues("MetaHud_PlayerHealth_Text");
          MetaHud:UpdateValues("MetaHud_PetMana_Text");
          MetaHud:ChangeBackgroundTexture();
          MetaHud:updateAlpha();
          --- target changed
     elseif event == "PLAYER_TARGET_CHANGED" then  
          MetaHud:TargetChanged();
          --- update Combopoints
     elseif event == "UNIT_COMBO_POINTS" then
          MetaHud:UpdateCombos();
     elseif event == "UNIT_POWER" then
          MetaHud:UpdateCombos();
     elseif event == "RUNE_TYPE_UPDATE" then
          MetaHud:UpdateRunes();
          ---  Combat / Regen / Attack check
     elseif event == "PLAYER_ENTER_COMBAT" then
          MetaHud.Attacking = true;
          MetaHud.inCombat  = true;
          MetaHud:updateStatus();
          MetaHud:updateAlpha();
     elseif event == "PLAYER_LEAVE_COMBAT" then
          MetaHud.Attacking = nil;
          if (MetaHud.Regen) then MetaHud.inCombat = nil; end
          MetaHud:updateStatus();
          MetaHud:updateAlpha();
     elseif event == "PLAYER_REGEN_ENABLED" then
          MetaHud.Regen = true;
          if (not MetaHud.Attacking) then MetaHud.inCombat = nil; end
          MetaHud:updateStatus();
          MetaHud:updateAlpha();
     elseif event == "PLAYER_REGEN_DISABLED" then
          MetaHud.Regen    = nil;
          MetaHud.inCombat = true;
          MetaHud:updateStatus();
          MetaHud:updateAlpha();
     elseif (event == "PLAYER_ALIVE" or event =="PLAYER_DEAD" or event =="PLAYER_UNGHOST") then
          MetaHud:UpdateValues("MetaHud_PlayerHealth_Text" , 1 );
          MetaHud:UpdateValues("MetaHud_PlayerMana_Text", 1 );
          MetaHud:ChangeBackgroundTexture();
          MetaHud:updateAlpha();
     elseif event == "PLAYER_UPDATE_RESTING" then
          MetaHud:updateStatus();
     elseif(event == "RAID_ROSTER_UPDATE" or event == "PARTY_LEADER_CHANGED" or event == "PARTY_LOOT_METHOD_CHANGED") then
          MetaHud:updateParty();
     elseif event == "RAID_TARGET_UPDATE" then
          MetaHud:updateTargetIcon();
     elseif event == "UNIT_PVP_STATUS" or event == "UNIT_PVP_UPDATE" then
          MetaHud:updatePlayerPvP();
          MetaHud:updateTargetPvP();
     elseif(event == "UNIT_PET" or event == "PLAYER_PET_CHANGED") then
          MetaHud:UpdateValues("MetaHud_PetHealth_Text", 1 );
          MetaHud:UpdateValues("MetaHud_PetMana_Text", 1 );
          MetaHud:ChangeBackgroundTexture();
          --MetaHud:updatePetIcon();
          MetaHud:updateAlpha();
          ---     elseif(event == "UNIT_HAPPINESS" and arg1 == "pet") then
          ---          MetaHud:updatePetIcon();
     elseif (event == "UNIT_AURA" and arg1 == "target") then
          MetaHud:Auras();
          if(MetaHud.player_class == "WARRIOR" and MetaHudOptions.showcombopoints == 1) then
               MetaHud:UpdateCombos();
          end
     elseif((event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" or event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") and (MetaHud.player_class == "WARRIOR" and MetaHudOptions.showcombopoints == 1)) then
          local found, mobName
          for i = 1,3 do
               found = string.find(arg1, MetaHud.SunderCombo_Filter[i].pattern)
               if(found) then
                    for mobName in string.gmatch(arg1, MetaHud.SunderCombo_Filter[i].pattern) do
                         MetaHud:UpdateCombos()
                    end
                    break;
               end
          end
     end

     if MetaHud.issetup ~= 2 then return; end
     if MetaHud.isinit  ~= 2 then return; end
end

--- init textfield
function MetaHud:initTextfield(ref,name)
     if MetaHudOptions[name] ~= nil then
          local bar = MetaHud.text2bar[name];
          ref.vars = {};
          ref:UnregisterAllEvents();
          ref.text = MetaHudOptions[name] or "";
          ref.unit = MetaHud.name2unit[bar];
          if ref.unit == nil then
               ref.unit = "player";
          end
          for var, value in pairs(MetaHud_variables) do
               if (string.find(ref.text, var)) then
                    ref.vars[var] = true;
                    for _,event in pairs(value.events) do
                         ref:RegisterEvent(event);          
                    end               
               end
          end
          ref:RegisterEvent("PLAYER_ENTERING_WORLD");
          if ref.unit == "target" then
               ref:RegisterEvent("PLAYER_TARGET_CHANGED");
          elseif ref.unit == "pet" then
               ref:RegisterEvent("UNIT_PET");
               ref:RegisterEvent("PLAYER_PET_CHANGED");
          end
          ref:SetScript("OnEvent", function() MetaHud:TextOnEvent(ref); end );
          ref:SetScript("OnUpdate", function() MetaHud:TextOnUpdate(ref); end );
     end
end

function MetaHud:TextOnUpdate(ref)
     MetaHud:doText(ref:GetName());
end

--- events for vars
function MetaHud:TextOnEvent(ref, ...)
     local arg1 = ...;
     if ref.unit == arg1 or
          event == "PLAYER_ENTERING_WORLD" or
          ( event == "PLAYER_TARGET_CHANGED" and ref.unit == "target" ) or
          ( (event == "UNIT_PET" or event == "PLAYER_PET_CHANGED") and ref.unit == "pet" ) then
          MetaHud:doText( ref:GetName());
     end
end

--- set Textbox
function MetaHud:doText(name)
     local font = _G[name.."_Text"];
     local this = _G[name];

     if this.unit == "target" and MetaHudOptions["showtarget"] == 0 then 
          font:SetText(" ");
          return; 
     end

     if this.unit == "player" and MetaHudOptions["showplayer"] == 0 then
          font:SetText(" ");
          return;
     end

     if this.unit == "pet" and MetaHudOptions["showpet"] == 0 then 
          font:SetText(" ");
          return; 
     end
     if(this.unit == "targettarget" and MetaHudOptions["showtotarget"] == 0) then
          font:SetText(" ");
          return; 
     end
     if not UnitExists(this.unit) then
          font:SetText(" ");
          return; 
     end

     local text  = this.text;
     local htext = this.text;
     for var, bol in pairs(this.vars) do
          text  = MetaHud_variables[var].func(text,this.unit);
          htext = MetaHud:gsub(htext, var, MetaHud_variables[var].hideval);
     end
     if text == htext then
          font:SetText(" ");
     else
          text = string.gsub(text, "  "," ");
          text = string.gsub(text,"(^%s+)","");
          text = string.gsub(text,"(%s+$)","");
          font:SetText(text);
     end

     font:SetWidth(1000);
     local w = font:GetStringWidth() + 10;
     font:SetWidth(w);
     if(not MetaHud.inCombat) then
          this:SetWidth(w);
     end
end

--- trigger all textevents
function MetaHud:triggerAllTextEvents()
     MetaHud:doText("MetaHud_Target_Text");
     MetaHud:doText("MetaHud_ToTarget_Text");
     MetaHud:doText("MetaHud_Range_Text");
     MetaHud:doText("MetaHud_Guild_Text");
     MetaHud:doText("MetaHud_PlayerHealth_Text");
     MetaHud:doText("MetaHud_PlayerMana_Text");
     MetaHud:doText("MetaHud_TargetHealth_Text");
     MetaHud:doText("MetaHud_Threat");
     MetaHud:doText("MetaHud_TargetMana_Text");
     MetaHud:doText("MetaHud_PetHealth_Text");
     MetaHud:doText("MetaHud_PetMana_Text");
end

--- Chat Alert --
function MetaHud:ChatAlert()
     if(MetaHud_Range_Text:GetAlpha() == 0) then
          local x,y = GetPlayerMapPosition("player");
          local coords = ("%d%s%d"):format(x*100, ",", y*100)
          if(not ChatFrameEditBox:IsVisible()) then ChatFrameEditBox:Show(); end
          ChatFrameEditBox:Insert("My current location is "..coords.." in "..GetZoneText());
     elseif(MetaHud_Target_Text:GetAlpha() > 0) then
          if(not ChatFrameEditBox:IsVisible()) then ChatFrameEditBox:Show(); end
          ChatFrameEditBox:Insert("Current target: "..UnitName("target"));
     end
end

--- OnUpdate --
function MetaHud:OnUpdate(self, elapsed)

     if MetaHud.issetup ~= 2 then return; end
     if MetaHud.isinit  ~= 2 then return; end

     MetaHud:doText("MetaHud_Range_Text");
     MetaHud:doText("MetaHud_ToTarget_Text");
     MetaHud:UpdateValues("MetaHud_PlayerMana_Text");

     if(MetaHud.player_class == "DEATHKNIGHT") then
          MetaHud:UpdateRunes();
     else
          MetaHud_RuneFrame:Hide();
     end

     if MetaHudOptions["showplayer"] ~= 1 then
          MetaHud_PlayerHealth_Bar:Hide();
          MetaHud_PlayerMana_Bar:Hide();
     else
          if MetaHud_PlayerHealth_Bar:IsVisible() ~= true then
               MetaHud_PlayerHealth_Bar:Show();
               MetaHud_PlayerMana_Bar:Show();
          end
     end

     MetaHud:updateAlpha();

     if UnitExists("target") then
          MetaHud:doText("MetaHud_Threat");
     end

     ---  animate bars
     if MetaHudOptions["animatebars"] == 1 and MetaHudOptions["showplayer"] == 1 then
          MetaHud:Animate("MetaHud_PlayerHealth_Bar");
          MetaHud:Animate("MetaHud_PlayerMana_Bar");
     end
     if  MetaHudOptions["animatebars"] == 1 and MetaHudOptions["showtarget"] == 1 then
          MetaHud:Animate("MetaHud_TargetHealth_Bar");
          MetaHud:Animate("MetaHud_TargetMana_Bar");
     end
     if MetaHudOptions["animatebars"] == 1 and MetaHudOptions["showpet"] == 1 then
          MetaHud:Animate("MetaHud_PetHealth_Bar");
          MetaHud:Animate("MetaHud_PetMana_Bar");
     end
     if DruidBarKey and MetaHud.player_class == "DRUID" and UnitPowerType("player") ~= 0 then
          MetaHud:Animate("MetaHud_PetMana_Bar");
     end

     if not UnitExists("targettarget") or MetaHudOptions["showtotarget"] == 0 then
          _G["MetaHud_ToT_Frame"]:Hide();
          _G["MetaHud_ToT_SubFrame"]:Hide();
     end
end

--- register Events
function MetaHud:registerEvents()
     local f = MetaHud_EventFrame;   
     for e, v in pairs(MetaHud.mainEvents) do
          f:RegisterEvent(MetaHud.mainEvents[e]); 
     end
end

--- unregister events (on zoning)
function MetaHud:unregisterEvents()
     local f = MetaHud_EventFrame;   
     for e, v in pairs(MetaHud.mainEvents) do
          f:UnregisterEvent(MetaHud.mainEvents[e]); 
     end
end

--- set layout
function MetaHud:setLayout()
     MetaHud.C_baseLayout = "MetaHud_Base_Layout";
     MetaHud.C_curLayout  = MetaHudOptions["layouttyp"] or 1;
     MetaHud:UpdateLayout(MetaHud.C_curLayout);
     MetaHud.C_textures   = MetaHud_Layouts[MetaHud.C_baseLayout]["MetaHud_textures"];
     MetaHud.C_frames     = MetaHud_Layouts[MetaHud.C_baseLayout]["MetaHud_frames"];
     MetaHud.C_tClips     = MetaHud_Layouts[MetaHud.C_baseLayout]["MetaHud_textures_clip"];
     MetaHud.C_names      = MetaHud_Layouts[MetaHud.C_baseLayout]["MetaHud_names"];
end

--- Setup MetaHud --
function MetaHud:setup(...)
     local arg1 = ...;
     MetaHud:printd("setup START");
     MetaHud.issetup = 1;
     ---  Get Humanoid Creature Type
     MetaHud.humanoid = UnitCreatureType("player");
     ---  set userid 
     MetaHud.userID = GetRealmName()..":"..UnitName("player");
     _, MetaHud.player_class = UnitClass("player");
     ---  set default Values
     if( not MetaHudOptions ) then
          MetaHudOptions = { };
     end
     for k, v in pairs(MetaHud.Config_default) do
          MetaHud:SetDefaultConfig(k);
     end
     ---  init Layout (ref settings to hud)
     MetaHud:SetLayoutElements();
     MetaHud:setLayout();
     ---  create all Frames
     MetaHud:createFrames();
     MetaHud_Target_Text:RegisterForClicks('LeftButtonUp', 'RightButtonUp');
     MetaHud_Target_Text:SetScript("OnClick", function(self, button, down) 
               if(button == "LeftButton") then     
                    ToggleDropDownMenu(1, nil, MetaHud_Target_DropDown, "MetaHud_Target_Text", 25, 10); 
               else     
                    ToggleDropDownMenu(1, nil, MetaHud_Player_DropDown, "MetaHud_Target_Text" , 25, 10); 
               end 
          end ); 
     MetaHud_ToT_Frame:SetPoint("TOP", "MetaHud_ToTarget_Text", "TOP", 0, 0);
     MetaHud_ToT_SubFrame:SetPoint("TOP", "MetaHud_ToTarget_Text", "BOTTOM", 0, -10);
     MetaHud:myAddons();
     MetaHud:registerEvents();
     MetaHud:printd("setup END");
     MetaHud.issetup = 2;
end

--- prepare colors
function MetaHud:prepareColors()
     ---  for k, v in MetaHud.BarColor do
     for k, v in pairs(MetaHudOptions["colors"]) do
          local color0 = {};
          local color1 = {};
          local color2 = {};
          local h0, h1, h2;  
          h0, h1, h2 = unpack(MetaHudOptions["colors"][k]);
          color0.r , color0.g , color0.b = unpack(MetaHud_hextodec(h0));
          color1.r , color1.g , color1.b = unpack(MetaHud_hextodec(h1));
          color2.r , color2.g , color2.b = unpack(MetaHud_hextodec(h2));
          MetaHud.BarColorTab[k] = { color0, color1, color2 };
     end
end

function MetaHud:SetFont()
     local font = MetaHud.FontFile[MetaHudOptions.fontfile];
     if(font == nil or font == "default") then
          MetaHud.defaultfont = "Fonts/FRIZQT__.TTF";
          MetaHud.defaultfont_num = METAHUD_LAYOUTPATH.."Number.TTF";
     else
          MetaHud.defaultfont = font;
          MetaHud.defaultfont_num = font;
     end
end

--- init HUD
function MetaHud:init()
     MetaHud:printd("init START");
     MetaHud.isinit = 1;
     MetaHud:prepareColors();
     MetaHud:SetFont();
     ---  set Hud Scale
     MetaHud_Main:SetScale(MetaHudOptions["scale"] or 1);
     ---  set ToT Scale
     MetaHud_ToT_SubFrame:SetScale(MetaHudOptions["ttscale"] or 1);
     ---  set Bars
     if(MetaHudOptions["showtotarget"] == 0) then 
          MetaHud_ToT_Frame:EnableMouse(false);
     else
          MetaHud_ToT_Frame:EnableMouse(true);
     end
     if(MetaHud.onTaxi == nil) then
          MetaHud:UpdateValues("MetaHud_PlayerHealth_Text", 1 );
          MetaHud:UpdateValues("MetaHud_PlayerMana_Text", 1 );
          MetaHud:UpdateValues("MetaHud_TargetHealth_Text", 1);
          MetaHud:UpdateValues("MetaHud_TargetMana_Text", 1);
          MetaHud:UpdateValues("MetaHud_PetHealth_Text", 1);
          MetaHud:UpdateValues("MetaHud_PetMana_Text",  1);
     end
     MetaHud:UpdateCombos();
     --MetaHud:UpdateHolyPower();
     MetaHud:Auras();
     MetaHud:ChangeBackgroundTexture();
     MetaHud:updateStatus();
     MetaHud:updateParty();
     MetaHud:updatePlayerPvP();
     MetaHud:updateTargetPvP();
     -- MetaHud:updatePetIcon();
     ---  set font
     MetaHud_PlayerHealth_Text_Text:SetFont(MetaHud.defaultfont_num, MetaHudOptions["fontsizeplayer"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["playerhpoutline"] ]);
     MetaHud_PlayerMana_Text_Text:SetFont(MetaHud.defaultfont_num, MetaHudOptions["fontsizeplayer"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["playermanaoutline"] ]);
     MetaHud_TargetHealth_Text_Text:SetFont(MetaHud.defaultfont_num, MetaHudOptions["fontsizetarget"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["targethpoutline"] ]);
     MetaHud_TargetMana_Text_Text:SetFont(MetaHud.defaultfont_num, MetaHudOptions["fontsizetarget"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["targetmanaoutline"] ]);
     MetaHud_PetHealth_Text_Text:SetFont(MetaHud.defaultfont_num, MetaHudOptions["fontsizepet"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["pethpoutline"] ]);
     MetaHud_PetMana_Text_Text:SetFont(MetaHud.defaultfont_num, MetaHudOptions["fontsizepet"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["petmanaoutline"] ]);
     MetaHud_Threat_Text:SetFont(MetaHud.defaultfont, MetaHudOptions["fontsizetargetname"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["targetoutline"] ]);
     MetaHud_Target_Text_Text:SetFont(MetaHud.defaultfont, MetaHudOptions["fontsizetargetname"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["targetoutline"] ]);
     MetaHud_ToTarget_Text_Text:SetFont(MetaHud.defaultfont, MetaHudOptions["fontsizetotarget"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["totargetoutline"] ]);
     MetaHud_Range_Text_Text:SetFont(MetaHud.defaultfont, MetaHudOptions["fontsizerange"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["rangeoutline"] ]);
     MetaHud_Guild_Text_Text:SetFont(MetaHud.defaultfont, MetaHudOptions["fontsizeguild"] / MetaHudOptions["scale"], MetaHud.Outline[ MetaHudOptions["guildoutline"] ]);
     ---  Hide Blizz Target Frame
     if MetaHudOptions["btarget"] == 0 then
          TargetFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
          TargetFrame:UnregisterEvent("UNIT_HEALTH")
          TargetFrame:UnregisterEvent("UNIT_LEVEL")
          TargetFrame:UnregisterEvent("UNIT_FACTION")
          TargetFrame:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED")
          TargetFrame:UnregisterEvent("UNIT_AURA")
          TargetFrame:UnregisterEvent("PLAYER_FLAGS_CHANGED")
          TargetFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED")
          TargetFrame:Hide()
          ComboFrame:UnregisterEvent("PLAYER_TARGET_CHANGED")
          ComboFrame:UnregisterEvent("UNIT_COMBO_POINTS")
     else
          TargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
          TargetFrame:RegisterEvent("UNIT_HEALTH")
          TargetFrame:RegisterEvent("UNIT_LEVEL")
          TargetFrame:RegisterEvent("UNIT_FACTION")
          TargetFrame:RegisterEvent("UNIT_CLASSIFICATION_CHANGED")
          TargetFrame:RegisterEvent("UNIT_AURA")
          TargetFrame:RegisterEvent("PLAYER_FLAGS_CHANGED")
          TargetFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
          if UnitExists("target") then TargetFrame:Show() end
          ComboFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
          ComboFrame:RegisterEvent("UNIT_COMBO_POINTS")
     end
     ---  Hide Blizz Player Frame
     if MetaHudOptions["bplayer"] == 0 then
          PlayerFrame:UnregisterEvent("UNIT_LEVEL")
          PlayerFrame:UnregisterEvent("UNIT_COMBAT")
          PlayerFrame:UnregisterEvent("UNIT_SPELLMISS")
          PlayerFrame:UnregisterEvent("UNIT_PVP_UPDATE")
          PlayerFrame:UnregisterEvent("UNIT_MAXMANA")
          PlayerFrame:UnregisterEvent("PLAYER_ENTER_COMBAT")
          PlayerFrame:UnregisterEvent("PLAYER_LEAVE_COMBAT")
          PlayerFrame:UnregisterEvent("PLAYER_UPDATE_RESTING")
          PlayerFrame:UnregisterEvent("PARTY_MEMBERS_CHANGED")
          PlayerFrame:UnregisterEvent("PARTY_LEADER_CHANGED")
          PlayerFrame:UnregisterEvent("PARTY_LOOT_METHOD_CHANGED")
          PlayerFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
          PlayerFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
          PlayerFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
          PlayerFrameHealthBar:UnregisterEvent("UNIT_HEALTH")
          PlayerFrameHealthBar:UnregisterEvent("UNIT_MAXHEALTH")
          PlayerFrameManaBar:UnregisterEvent("UNIT_MANA")
          PlayerFrameManaBar:UnregisterEvent("UNIT_RAGE")
          PlayerFrameManaBar:UnregisterEvent("UNIT_FOCUS")
          PlayerFrameManaBar:UnregisterEvent("UNIT_ENERGY")
          --PlayerFrameManaBar:UnregisterEvent("UNIT_HAPPINESS")
          PlayerFrameManaBar:UnregisterEvent("UNIT_MAXMANA")
          PlayerFrameManaBar:UnregisterEvent("UNIT_MAXRAGE")
          PlayerFrameManaBar:UnregisterEvent("UNIT_MAXFOCUS")
          PlayerFrameManaBar:UnregisterEvent("UNIT_MAXENERGY")
          --PlayerFrameManaBar:UnregisterEvent("UNIT_MAXHAPPINESS")
          PlayerFrameManaBar:UnregisterEvent("UNIT_DISPLAYPOWER")
          PlayerFrame:UnregisterEvent("UNIT_NAME_UPDATE")
          PlayerFrame:UnregisterEvent("UNIT_PORTRAIT_UPDATE")
          PlayerFrame:UnregisterEvent("UNIT_DISPLAYPOWER")
          PlayerFrame:Hide()
          RuneFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
          RuneFrame:UnregisterEvent("RUNE_TYPE_UPDATE")
          RuneFrame:UnregisterEvent("RUNIC_POWER_UPDATE")
          RuneFrame:Hide()
     else
          PlayerFrame:RegisterEvent("UNIT_LEVEL")
          PlayerFrame:RegisterEvent("UNIT_COMBAT")
          PlayerFrame:RegisterEvent("UNIT_SPELLMISS")
          PlayerFrame:RegisterEvent("UNIT_PVP_UPDATE")
          PlayerFrame:RegisterEvent("UNIT_MAXMANA")
          PlayerFrame:RegisterEvent("PLAYER_ENTER_COMBAT")
          PlayerFrame:RegisterEvent("PLAYER_LEAVE_COMBAT")
          PlayerFrame:RegisterEvent("PLAYER_UPDATE_RESTING")
          PlayerFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
          PlayerFrame:RegisterEvent("PARTY_LEADER_CHANGED")
          PlayerFrame:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
          PlayerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
          PlayerFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
          PlayerFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
          PlayerFrameHealthBar:RegisterEvent("UNIT_HEALTH")
          PlayerFrameHealthBar:RegisterEvent("UNIT_MAXHEALTH")
          PlayerFrameManaBar:RegisterEvent("UNIT_MANA")
          PlayerFrameManaBar:RegisterEvent("UNIT_RAGE")
          PlayerFrameManaBar:RegisterEvent("UNIT_FOCUS")
          PlayerFrameManaBar:RegisterEvent("UNIT_ENERGY")
          --PlayerFrameManaBar:RegisterEvent("UNIT_HAPPINESS")
          PlayerFrameManaBar:RegisterEvent("UNIT_MAXMANA")
          PlayerFrameManaBar:RegisterEvent("UNIT_MAXRAGE")
          PlayerFrameManaBar:RegisterEvent("UNIT_MAXFOCUS")
          PlayerFrameManaBar:RegisterEvent("UNIT_MAXENERGY")
          --PlayerFrameManaBar:RegisterEvent("UNIT_MAXHAPPINESS")
          PlayerFrameManaBar:RegisterEvent("UNIT_DISPLAYPOWER")
          PlayerFrame:RegisterEvent("UNIT_NAME_UPDATE")
          PlayerFrame:RegisterEvent("UNIT_PORTRAIT_UPDATE")
          PlayerFrame:RegisterEvent("UNIT_DISPLAYPOWER")
          PlayerFrame:Show()
          if(MetaHud.player_class == "DEATHKNIGHT") then
               RuneFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
               RuneFrame:RegisterEvent("RUNE_TYPE_UPDATE")
               RuneFrame:RegisterEvent("RUNIC_POWER_UPDATE")
               RuneFrame:Show()
          end
     end 
     ---  update Alpha
     MetaHud.inCombat = nil;

     ---  pos frames
     MetaHud:PositionFrame("MetaHud_Main");
     MetaHud:PositionFrame("MetaHud_LeftFrame");
     MetaHud:PositionFrame("MetaHud_RightFrame");
     MetaHud:PositionFrame("MetaHud_Target_Text");
     MetaHud:PositionFrame("MetaHud_ToTarget_Text");
     MetaHud:PositionFrame("MetaHud_Range_Text");
     MetaHud:PositionFrame("MetaHud_Guild_Text");
     MetaHud:PositionFrame("MetaHud_PlayerHealth_Text");
     MetaHud:PositionFrame("MetaHud_PlayerMana_Text");
     MetaHud:PositionFrame("MetaHud_TargetHealth_Text");
     MetaHud:PositionFrame("MetaHud_TargetMana_Text");
     MetaHud:PositionFrame("MetaHud_PetHealth_Text");
     MetaHud:PositionFrame("MetaHud_PetMana_Text");    
     ---  top frames
     MetaHud_TargetElite:SetFrameLevel(MetaHud_RightFrame:GetFrameLevel() + 1);
     ---  alter pet manatext when class = DRUID
     if DruidBarKey and MetaHud.player_class == "DRUID" and MetaHudOptions["MetaHud_PetMana_Text"] == METAHUD_TEXT_MP2 then
          MetaHudOptions["MetaHud_PetMana_Text"] = METAHUD_TEXT_MP7;
     end
     ---  trigger all texts
     MetaHud:triggerAllTextEvents();

     ---  init end   
     MetaHud.isinit = 2;
     MetaHud:printd("init END");
end

--- Change Frame Pos
function MetaHud:PositionFrame(name)
     local xn , yn, mx, my = unpack ( MetaHud.moveFrame[name] );
     local x2 = tonumber(MetaHudOptions[xn] or 0);
     local y2 = tonumber(MetaHudOptions[yn] or 0);
     if mx == "-" then
          x2 = 0 - x2;
     end
     if my == "-" then
          y2 = 0 - y2;
     end
     local typ, point, frame, relative, x, y, width, height = unpack( MetaHud.C_frames[name] );
     local ref = _G[name];
     MetaHud:printd(name.." "..(x + x2).." "..(y + y2) );
     ref:SetPoint(point, frame , relative, x + x2, y + y2);
end

function MetaHud:TargetChanged()   
     if UnitExists("target") then
          MetaHud.Target = 1;
     else
          MetaHud.Target = nil;
     end
     if MetaHudOptions["showplayer"] == 0 then
          MetaHud:SetBarHeight("MetaHud_PlayerHealth_Bar",0);
          MetaHud:SetBarHeight("MetaHud_PlayerMana_Bar",0);
     else
          MetaHud:UpdateValues("MetaHud_PlayerHealth_Text", 1);
          MetaHud:UpdateValues("MetaHud_PlayerMana_Text", 1);  
     end
     if MetaHudOptions["showtarget"] == 0 then
          MetaHud:SetBarHeight("MetaHud_TargetHealth_Bar",0);
          MetaHud:SetBarHeight("MetaHud_TargetMana_Bar",0);
          MetaHud.Target = nil;
     else
          MetaHud:UpdateValues("MetaHud_TargetHealth_Text", 1);
          MetaHud:UpdateValues("MetaHud_TargetMana_Text", 1); 
     end
     MetaHud:doText("MetaHud_Threat");
     MetaHud:UpdateCombos();  
     MetaHud:updateParty();
     MetaHud:updateTargetPvP();
     MetaHud:ChangeBackgroundTexture();     
     MetaHud:updateAlpha();
     MetaHud:Auras();
     if(UnitExists("target")) then
          MetaHud:Set_TargetMode(true);
     else
          MetaHud:Set_TargetMode(false);
     end
     MetaHud:doText("MetaHud_Target_Text");
     MetaHud:doText("MetaHud_Guild_Text");

     local icon = _G["MetaHud_TargetIcon"];
     icon:ClearAllPoints();
     icon:SetPoint("TOPRIGHT", _G["MetaHud_Target_Text"], "TOPLEFT");
end

function MetaHud:Set_TargetMode(mode)
     if(MetaHudOptions["activename"] == 0) then
          _G["MetaHud_Target_Text"]:EnableMouse(false);
          return;
     end
     if(not mode) then
          MetaHud_Target_Text:SetScript("OnEnter", nil);
          MetaHud_Target_Text:SetScript("OnLeave", nil);
     else
          MetaHud_Target_Text:SetScript("OnEnter", function() MetaHud:GameTP("Enter", "target"); end);
          MetaHud_Target_Text:SetScript("OnLeave", function() MetaHud:GameTP("Leave", "target"); end);
     end
end

function MetaHud:GameTP(mode, unit)
     if mode == "Enter" then
          GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
          GameTooltip:SetUnit(unit);
          GameTooltip:Show();
     elseif mode == "Leave" then
          GameTooltip:FadeOut();
     end
end

--- Create all Frames --
function MetaHud:createFrames()
     for i = 1, getn(MetaHud.C_names) do
          MetaHud:createFrame(MetaHud.C_names[i]);
     end
end

--- Transform Frames
function MetaHud:transformFrames(layout)
     if layout == 1 or layout == 2 then
          MetaHud:SetConfig( "layouttyp", layout );
          MetaHud:setLayout();
          MetaHud.frame_level = 0;
          for i = 1, getn(MetaHud.C_names) do
               MetaHud:transform(MetaHud.C_names[i]);
          end
          MetaHud:init();
     end
end

--- Frame transformer
function MetaHud:transform(name)
     ---  does frame exist in list?
     if not MetaHud.C_frames[name] then
          return;
     end
     ---  get frame settings
     local typ, point, frame, relative, x, y, width, height = unpack( MetaHud.C_frames[name] );  
     MetaHud.frame_level = MetaHud.frame_level + 1;

     if typ == "Frame" then
          local ref = _G[name];
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width); 

          --ref:SetFrameLevel(MetaHud.frame_level);
          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();       
     elseif typ == "Texture" then    
          local texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures[name] );
          local ref = _G[name];
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          strata = "BACKGROUND";

          local bgt = _G[name.."_Texture"];
          bgt:SetTexture(texture);
          bgt:ClearAllPoints();
          bgt:SetPoint("TOPLEFT", ref , "TOPLEFT", 0, 0);
          bgt:SetPoint("BOTTOMRIGHT", ref , "BOTTOMRIGHT", 0, 0);
          bgt:SetTexCoord(x0,x1,y0,y1);

          ref:SetFrameStrata(strata);
          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();

     elseif typ == "Bar" then    
          local texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures[name] );
          local ref = _G[name];
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          local bgt = _G[name.."_Texture"];
          bgt:SetTexture(texture);
          bgt:SetPoint(point, ref, relative, 0, 0);
          bgt:SetHeight(height);
          bgt:SetWidth(width);
          bgt:SetTexCoord(x0,x1,y0,y1);

          ref:SetFrameStrata("BACKGROUND");
          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();    

     elseif typ == "Text" then
          local ref = _G[name];
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);

          local font = _G[name.."_Text"];
          font:SetFontObject(GameFontHighlightSmall);
          if MetaHud.debug then
               font:SetText(name);
          else
               font:SetText(" ");
          end
          font:SetJustifyH("CENTER");
          font:SetWidth(font:GetStringWidth());
          font:SetHeight(height);
          font:Show();
          font:ClearAllPoints();
          font:SetPoint(point, ref, relative,0, 0);

          ref:SetHeight(height);
          ref:SetWidth(font:GetStringWidth());
          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();
          MetaHud:initTextfield(ref, name); 

     elseif typ == "Buff" then

          local ref = _G[name];
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          local font = _G[name.."_Text"];
          font:SetFontObject(GameFontHighlightSmall);
          font:SetText("");
          font:SetJustifyH("RIGHT");
          font:SetJustifyV("BOTTOM");
          font:SetWidth(width+1);
          font:SetHeight(height-5);
          font:SetFont( MetaHud.defaultfont, width / 2.2, "OUTLINE");
          font:Show();
          font:ClearAllPoints();
          font:SetPoint(point, frame, relative,x, y);

          ref:SetNormalTexture(METAHUD_ICON);
          ref:SetParent(frame);

          local button = _G[name];
          ref:SetScript("OnEnter", function() 
                    if (not button:IsVisible()) then return; end
                    if MetaHudOptions["showauratips"] == 0 then return; end
                    GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT");
                    if button.hasdebuff == 1 then
                         GameTooltip:SetUnitDebuff(button.unit, button.id);
                    else
                         GameTooltip:SetUnitBuff(button.unit, button.id);
                    end
               end );

          ref:SetScript("OnLeave", function() 
                    GameTooltip:Hide();
               end );

          ref:EnableMouse(true);
          ref:Show();

     end
end    

--- Frame Creator
function MetaHud:createFrame(name)
     ---  does frame exist in list?
     if not MetaHud.C_frames[name] then
          return;
     end
     ---  get frame settings
     local typ, point, frame, relative, x, y, width, height = unpack( MetaHud.C_frames[name] );
     ---  set framelevel
     if not MetaHud.frame_level then 
          MetaHud.frame_level = 0;
     end
     MetaHud.frame_level = MetaHud.frame_level + 1;
     ---  debug
     MetaHud:printd("MetaHud: createFrame "..name.." parent:"..frame.." typ:"..typ .." level:"..MetaHud.frame_level);    
     ---  set frame        
     if typ == "Frame" then
          ref = CreateFrame ("Frame", name, _G[frame] );
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();

          ---  set bar
     elseif typ == "Texture" then    
          local texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures[name] );
          ref = CreateFrame ("Frame", name, _G[frame] );
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          strata = "BACKGROUND";

          local bgt = ref:CreateTexture(name.."_Texture",strata);
          bgt:SetTexture(texture);
          bgt:ClearAllPoints();
          bgt:SetPoint("TOPLEFT", ref , "TOPLEFT", 0, 0);
          bgt:SetPoint("BOTTOMRIGHT", ref , "BOTTOMRIGHT", 0, 0);
          bgt:SetTexCoord(x0,x1,y0,y1);

          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();
          ---  set bar
     elseif typ == "Bar" then    
          local texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures[name] );
          ref = CreateFrame ("Frame", name, _G[frame]);
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          local bgt = ref:CreateTexture(name.."_Texture","BACKGROUND");
          bgt:SetTexture(texture);
          bgt:SetPoint(point, ref, relative, 0, 0);
          bgt:SetHeight(height);
          bgt:SetWidth(width);
          bgt:SetTexCoord(x0,x1,y0,y1);
          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();            
          ---  set text
     elseif typ == "Text" then
          ref = CreateFrame ("Button", name, _G[frame]);
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);


          local font = ref:CreateFontString(name.."_Text", "ARTWORK");
          font:SetFontObject(GameFontHighlightSmall);
          if MetaHud.debug then
               font:SetText(name);
          else
               font:SetText(" ");
          end
          font:SetJustifyH("CENTER");
          font:SetWidth(font:GetStringWidth());
          font:SetHeight(height);
          font:Show();
          font:ClearAllPoints();
          font:SetPoint(point, ref, relative,0, 0);

          ref:SetHeight(height);
          ref:SetWidth(font:GetStringWidth());
          ref:SetParent(frame);
          ref:EnableMouse(false);
          ref:Show();
          MetaHud:initTextfield(ref, name);        

          ---  set buffs    
     elseif typ == "Buff" then
          ref = CreateFrame ("Button", name, _G[frame], "TargetDebuffFrameTemplate");
          _G[name.."Border"]:Hide();
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          local font = ref:CreateFontString(name.."_Text", "ARTWORK");
          font:SetFontObject(GameFontHighlightSmall);
          font:SetText("");
          font:SetJustifyH("RIGHT");
          font:SetJustifyV("BOTTOM");
          font:SetWidth(width+1);
          font:SetHeight(height-5);
          font:SetFont( MetaHud.defaultfont, width / 2.2, "OUTLINE");
          font:Show();
          font:ClearAllPoints();
          font:SetPoint(point, frame, relative,x, y);

          ref:SetNormalTexture(METAHUD_ICON);
          ref:SetParent(frame);

          local button = _G[name];
          ref:SetScript("OnEnter", function() 
                    if (not button:IsVisible()) then return; end
                    if MetaHudOptions["showauratips"] == 0 then return; end
                    GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT");
                    if button.hasdebuff == 1 then
                         GameTooltip:SetUnitDebuff(button.unit, button.id);
                    else
                         GameTooltip:SetUnitBuff(button.unit, button.id);
                    end
               end );

          ref:SetScript("OnLeave", function() 
                    GameTooltip:Hide();
               end );

          ref:EnableMouse(true);
          ref:Show();
          ---  set runes    
     elseif typ == "Rune" then
          ref = CreateFrame("Button", name, _G[frame]);
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);

          --Orb texture
          local tex = ref:CreateTexture(name.."_Texture", "ARTWORK");
          tex:SetPoint("BOTTOM", ref, "BOTTOM", 0, 0);
          tex:SetHeight(height);
          tex:SetWidth(width);

          --Rune cooldown frame
          local fcd = CreateFrame("Cooldown", name.."_Cooldown", ref, "RuneTemplate");
          fcd:SetPoint("CENTER", ref, "CENTER", 0, 0);
          fcd:SetHeight(height);
          fcd:SetWidth(width);
          ref:SetParent(frame);

          ref:EnableMouse(false);
          ref:Show();
     elseif typ == "Orb" then
          ref = CreateFrame("Button", name, _G[frame]);
          ref:ClearAllPoints();
          ref:SetPoint(point, frame , relative, x, y);
          ref:SetHeight(height);
          ref:SetWidth(width);
          print("hai");

          local tex = ref:CreateTexture(name.."_Texture", "ARTWORK");
          tex:SetPoint("BOTTOM", ref, "BOTTOM", 0, 0);
          tex:SetHeight(height);
          tex:SetWidth(width);
          tex:SetTexture(METAHUD_LAYOUTPATH.."orb")
          tex:SetVertexColor(0, 0.9, 0)

          ref:SetScript("OnClick", function()
                    if(name == "MetaHud_TargetOrb") then
                         ToggleDropDownMenu(1, nil, MetaHud_Target_DropDown, name, 25, 10);
                    else
                         ToggleDropDownMenu(1, nil, MetaHud_Player_DropDown, name , 25, 10); 
                    end
               end );

          ref:EnableMouse(true)
          ref:Show();
     end
end

--- colorize bar
function MetaHud:SetBarColor(bar,percent)
     local unit = MetaHud.name2unit[bar];
     local typ  = MetaHud.name2typ[bar];
     typunit = MetaHud:getTypUnit(unit,typ);
     local texture = _G[bar.."_Texture"];
     texture:SetVertexColor(MetaHud:Colorize(typunit,percent));
end

--- gettypeunit
function MetaHud:getTypUnit(unit,typ)
     ---  what power type?
     if typ == "mana" then
          if UnitPowerType(unit) then
               typ = MetaHud.powertypes[ UnitPowerType(unit)+1 ];
          end
     end

     if typ == nil then
          typ = "";
     end

     local typunit = typ.."_"..unit;
     ---  default 

     if typunit =="focus_player" then
          typunit = "focus_pet";
     end

     if not MetaHud.BarColorTab[typunit] then
          typunit = "mana_pet";
     end
     ---  only tap target bars
     if unit == "target" then
          if (UnitIsTapped("target") and (not UnitIsTappedByPlayer("target"))) then
               typunit = "tapped";
          end
     end
     return typunit;
end

--- Colorize
function MetaHud:Colorize(typunit,percent)
     if not MetaHud.BarColorTab[typunit] then return 0,0,0; end
     local r, g, b, diff;
     local threshold1 = 0.6;    
     local threshold2 = 0.3;
     local color0 = MetaHud.BarColorTab[typunit][1];
     local color1 = MetaHud.BarColorTab[typunit][2];
     local color2 = MetaHud.BarColorTab[typunit][3];

     if ( percent <= threshold2 ) then
          r = color2.r;        
          g = color2.g;        
          b = color2.b;    
     elseif ( percent <= threshold1) then        
          diff = 1 - (percent - threshold2) / (threshold1 - threshold2);
          r = color1.r - (color1.r - color2.r) * diff;        
          g = color1.g - (color1.g - color2.g) * diff;        
          b = color1.b - (color1.b - color2.b) * diff;    
     elseif ( percent < 1) then        
          diff = 1 - (percent - threshold1) / (1 - threshold1);        
          r = color0.r - (color0.r - color1.r) * diff;        
          g = color0.g - (color0.g - color1.g) * diff;        
          b = color0.b - (color0.b - color1.b) * diff;    
     else       
          r = color0.r;
          g = color0.g;
          b = color0.b;    
     end 

     if (r < 0) then r = 0; end    
     if (r > 1) then r = 1; end    
     if (g < 0) then g = 0; end    
     if (g > 1) then g = 1; end    
     if (b < 0) then b = 0; end    
     if (b > 1) then b = 1; end     
     return r,g,b;
end

--- set bar height
function MetaHud:SetBarHeight(bar,p)
     local texture = _G[bar.."_Texture"];
     ---  Hide when Bar empty 
     if(math.floor(p * 100) == 0) then
          texture:Hide();
          return;
     end
     ---  Texture Settings
     local typ, point, frame, relative, x, y, width, height = unpack( MetaHud.C_frames[bar] );
     local texname,x0,x1,y0,y1 = unpack(MetaHud.C_textures[bar]);        
     local tex_height, tex_gap_top, tex_gap_bottom = unpack(MetaHud.C_tClips[texname]);
     ---  offsets
     local tex_gap_top_p    = tex_gap_top / tex_height;    
     local tex_gap_bottom_p = tex_gap_bottom / tex_height;
     local h = (tex_height - tex_gap_top - tex_gap_bottom) * p;
     local top    = 1-(p-(tex_gap_top_p));
     local bottom = 1-tex_gap_bottom_p;
     top = top  - ((tex_gap_top_p+tex_gap_bottom_p)*(1-p));
     texture:SetHeight(h);
     texture:SetTexCoord(x0, x1, top, bottom );
     texture:SetPoint(point, _G[frame], relative, x, tex_gap_bottom);
     texture:Show();
end;

--- show / hide combopoints
function MetaHud:UpdateCombos()
     for i = 1, 5 do
          _G["MetaHud_Combo"..i]:Hide()
     end

     for i = 1, 5 do
          _G["MetaHud_HolyPower"..i]:Hide();
     end

     for i = 1, 4 do
          _G["MetaHud_SoulShard"..i]:Hide();
     end

     if MetaHudOptions["showcombopoints"] == 1 then
          local points = 0
          if not (self["player_class"] == "DRUID" or self["player_class"] == "ROGUE") and not UnitHasVehicleUI("player") then
               if self["player_class"] == "WARRIOR" then
                    local _, _, _, count = UnitDebuff("target", "Weakened Armor")
                    points = count or 0
               elseif self["player_class"] == "DEATHKNIGHT" then
                    MetaHud:UpdateRunes()
               elseif self["player_class"] == "PALADIN" then
                    --points = UnitPower("player", SPELL_POWER_HOLY_POWER) or 0
                    MetaHud:UpdateHolyPower()
               elseif self["player_class"] == "WARLOCK" then
                    --points = UnitPower("player", SPELL_POWER_SOUL_SHARDS) or 0
                    MetaHud:UpdateSoulShards()
               end
          else
               points = GetComboPoints(UnitHasVehicleUI("player") and "vehicle" or "player", "target")
          end

          for i = 1, points do
               _G["MetaHud_Combo"..i]:Show()
          end

          for i = points + 1, 5 do
               _G["MetaHud_Combo"..i]:Hide()
          end
     else          
          for i = 1, 5 do
               _G["MetaHud_Combo"..i]:Hide()
          end

          for i = 1,5 do
               _G["MetaHud_HolyPower"..i]:Hide();
          end

          for i = 1,4 do
               _G["MetaHud_SoulShard"..i]:Hide();
          end
     end          
end

function MetaHud:UpdateRunes()
     if MetaHudOptions["showrunes"] == 1 and MetaHud.player_class == "DEATHKNIGHT" then
          if MetaHud_RuneFrame:IsVisible() ~= true then
               MetaHud_RuneFrame:Show();
          end

          --set the textures
          for i = 1, 6 do
               local runeType = GetRuneType(i);
               local r = 0;
               local g = 0;
               local b = 0;

               if runeType == 1 then
                    r = 1;
               elseif runeType == 2 then
                    g = 1;
               elseif runeType == 3 then
                    b = 1;
               elseif runeType == 4 then
                    b = 1;
                    r = 1;
               end

               _G["MetaHud_Rune"..i.."_Texture"]:SetVertexColor(r, g, b);

               local start, duration, runeReady = GetRuneCooldown(i);

               local displayCooldown = (runeReady and 0) or 1;
               local cooldown = _G["MetaHud_Rune"..i.."_Cooldown"];
               CooldownFrame_SetTimer(cooldown, start, duration, displayCooldown);
          end
     else
          MetaHud_RuneFrame:Hide();
     end
end

function MetaHud:UpdateHolyPower()
     if(MetaHudOptions.showholypower == 1 and MetaHud.player_class == "PALADIN" and not UnitHasVehicleUI("player")) then
          local points = UnitPower("player", SPELL_POWER_HOLY_POWER) or 0;

          --print(points);

          for i = 1, points do
               _G["MetaHud_HolyPower"..i]:Show();
          end

          for i = points + 1, 5 do
               _G["MetaHud_HolyPower"..i]:Hide();
          end
     else
          for i = 1, 5 do
               _G["MetaHud_HolyPower"..i]:Hide();
          end
     end
end

function MetaHud:UpdateSoulShards()
     if(MetaHudOptions.showsoulshards == 1 and MetaHud.player_class == "WARLOCK" and not UnitHasVehicleUI("player")) then
          local points = UnitPower("player", SPELL_POWER_SOUL_SHARDS) or 0;

          --print(points);

          for i = 1, points do
               _G["MetaHud_SoulShard"..i]:Show();
          end

          for i = points + 1, 4 do
               _G["MetaHud_SoulShard"..i]:Hide();
          end
     else
          for i = 1, 4 do
               _G["MetaHud_SoulShard"..i]:Hide();
          end
     end     
end

--- update target Auras

function MetaHud:Auras()
     MetaHud:AuraSetup();
     MetaHud:AuraPosition();
end

function MetaHud:AuraSetup()
     --constants
     local MAX_AURA = 40;

     -- 1 - 40 are BUFFS
     -- 41 - 80 are DEBUFFS
     for i = 1, 80 do
          if i <= MAX_AURA then --BUFFS
               index = i;
               if MetaHudOptions["swaptargetauras"] == 1 then
                    ROOT = "MetaHud_DeBuff";
               else
                    ROOT = "MetaHud_Buff";
               end
          else -- DEBUFFS
               index = i - MAX_AURA;
               if MetaHudOptions["swaptargetauras"] == 1 then
                    ROOT = "MetaHud_Buff";
               else
                    ROOT = "MetaHud_DeBuff";
               end
          end

          --Call the function data
          local filter = "HELPFUL";
          if i > MAX_AURA then
               filter = "HARMFUL";
          end

          local button = _G[ROOT..index];
          local _, _, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable = UnitAura("target", index, filter);

          if icon and MetaHudOptions["showauras"] == 1 and MetaHudOptions["showtarget"] == 1 then
               --Set Mine Flag
               if unitCaster == "player" or unitCaster == "pet" then
                    button.mine = true;
               else
                    button.mine = nil;
               end

               --Set ID
               button.id = index;
               button.unit = "target";
               if i > 40 then
                    button.hasdebuff = 1;
               else
                    button.hasdebuff = 0;
               end

               --Set Icon
               local iconFrame = _G[ROOT..index];
               iconFrame:SetNormalTexture(icon);

               --Cooldown Frame
               local cooldown = _G[ROOT..index.."Cooldown"];
               if ((button.mine and MetaHudOptions["showmycd"] == 1) or (not button.mine and MetaHudOptions["showallcd"] == 1)) and duration > 0 then
                    CooldownFrame_SetTimer(cooldown, expirationTime - duration, duration, 1);
                    cooldown:Show();
               else
                    cooldown:Hide();
               end

               --Count Frame
               buttonCount = _G[ROOT..index.."Count"];
               if count > 1 then
                    buttonCount:SetText(count);
                    buttonCount:Show();
               else
                    buttonCount:Hide();
               end

               --Border Color
               border = _G[ROOT..index.."Border"];
               if isStealable and not button.mine then
                    border:SetVertexColor(1, 1, 0);
                    border:Show();
               elseif debuffType and i > 40 then
                    local color = DebuffTypeColor[debuffType];
                    border:SetVertexColor(color.r, color.g, color.b);
                    border:Show();
               elseif i > 40 then
                    local color = DebuffTypeColor["none"];
                    border:SetVertexColor(color.r, color.g, color.b);
                    border:Show();
               else
                    border:Hide();
               end

               button:Show();
          else
               button:Hide();
          end
     end
end

function MetaHud:AuraPosition()
     --constants
     local MAX_AURA = 40;
     local FRAME_HEIGHT = MetaHudOptions["buffheight"];

     --vars
     local head = 1;
     local endMine, countHeight, hasSecondRow;

     for i = 1, 80 do
          local ROOT, index, size;
          if i <= MAX_AURA then
               ROOT = "MetaHud_Buff";
               index = i;
               size = MetaHudOptions["targetbuffsize"];
          else
               ROOT = "MetaHud_DeBuff";
               index = i - MAX_AURA;
               size = MetaHudOptions["targetdebuffsize"];
          end

          local button = _G[ROOT..index];
          local prev = _G[ROOT..(index-1)];
          local header = _G[ROOT..head];

          if (button.mine and MetaHudOptions["doublemine"] == 1) then
               size = size * 2;
          end
          button:SetWidth(size);
          button:SetHeight(size);

          if button.mine then
               endMine = index;
          end

          button:ClearAllPoints();
          if index == 1 then
               head = 1;
               countHeight = size;
               hasSecondRow = nil;
               if i == 1 then
                    button:SetPoint("TOPRIGHT", MetaHud_LeftFrame, "TOPLEFT", MetaHudOptions["buffx"], MetaHudOptions["buffy"]);
               else
                    button:SetPoint("TOPLEFT", MetaHud_RightFrame, "TOPRIGHT", MetaHudOptions["debuffx"], MetaHudOptions["debuffy"]);
               end
          elseif countHeight + size <= FRAME_HEIGHT then
               --attach me on
               if i <= MAX_AURA then
                    button:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT");
               else
                    button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT");
               end
               countHeight = countHeight + size;
          elseif countHeight + size > FRAME_HEIGHT then
               if not header.mine or prev.mine or hasSecondRow then
                    --create fresh column
                    if i <= MAX_AURA then
                         button:SetPoint("TOPRIGHT", header, "TOPLEFT");
                    else
                         button:SetPoint("TOPLEFT", header, "TOPRIGHT");
                    end
                    countHeight = size;
                    head = index;
               elseif header.mine and not hasSecondRow and endMine > 0 and not button.mine then
                    --create the second column
                    local lastMine = _G[ROOT..endMine];
                    if i <= MAX_AURA then
                         button:SetPoint("TOPLEFT", lastMine, "BOTTOMLEFT");
                    else
                         button:SetPoint("TOPRIGHT", lastMine, "BOTTOMRIGHT");
                    end
                    countHeight = (size * 2) * (endMine) + size;
                    hasSecondRow = true;
               end
          end
     end
end

--- is unit npc?
function MetaHud:TargetIsNPC()
     if UnitExists("target") and not UnitIsPlayer("target") and not UnitCanAttack("player", "target") and not UnitPlayerControlled("target") then
          return true;
     else
          return false;
     end
end

--- is unit pet?
function MetaHud:TargetIsPet()
     if not UnitIsPlayer("target") and not UnitCanAttack("player", "target") and UnitPlayerControlled("target") then
          return true;
     else
          return false;
     end
end

--- Update Values
function MetaHud:UpdateValues(frame,set)
     local value;
     local bar  = MetaHud.text2bar[frame];
     local unit = MetaHud.name2unit[bar];
     local typ  = MetaHud.name2typ[bar];
     local ref  = _G[frame.. "_Text"];    
     MetaHud.PetneedMana   = nil;
     MetaHud.PetneedHealth = nil;

     if typ == "health" then
          if UnitHealthMax(unit) == 0 then
               value = 0;
          else
               value = UnitHealth(unit)/UnitHealthMax(unit);
          end
     else
          if UnitPowerMax(unit) == 0 then
               value = 0;
          else
               value = UnitPower(unit)/UnitPowerMax(unit);
          end
     end  
     if unit == "pet" and MetaHudOptions["showpet"] == 0 then
          value = 0;
     end
     if unit == "target" and MetaHudOptions["showtarget"] == 0 then
          value = 0;
     end
     if unit == "targettarget" and not UnitExists("targettarget") then
          value = 0;
     end

     ---  Druidbar support
     if unit == "pet" and typ == "mana" and DruidBarKey and MetaHud.player_class == "DRUID" then
          if UnitPowerType("player") ~= 0 then
               value = tonumber( DruidBarKey.keepthemana / DruidBarKey.maxmana );
               if math.floor(value * 100) == 100 then
                    MetaHud.PetneedMana = nil;
               else
                    MetaHud.PetneedMana = 1;
               end
          else
               value = 0;
               set   = 1;
          end
     end
     MetaHud.bar_values[bar] = value;

     if typ == "health" and unit == "player" then
          if math.floor(value * 100) == 100 then
               MetaHud.needHealth = nil;
          else
               MetaHud.needHealth = true;
          end
     elseif typ == "mana" and unit == "player" then
          local type = MetaHud.powertypes[ UnitPowerType(unit)+1 ];
          if type == "rage" or type == "Runic Power" then
               if math.floor(value * 100) == 100 then
                    MetaHud.needMana = true;
               else
                    MetaHud.needMana = nil;
               end
          else
               if math.floor(value * 100) == 100 then
                    MetaHud.needMana = nil;
               else
                    MetaHud.needMana = true;
               end
          end
     elseif typ == "mana" and unit == "pet" and MetaHud.player_class ~= "DRUID" and MetaHudOptions["showpet"] == 1 and UnitExists(unit) then    
          if math.floor(value * 100) == 100 then
               MetaHud.PetneedMana = nil;
          else
               MetaHud.PetneedMana = true;
          end
     elseif typ == "health" and unit == "pet" and MetaHudOptions["showpet"] == 1 and UnitExists(unit) then
          if math.floor(value * 100) == 100 then
               MetaHud.PetneedHealth = nil;
          else
               MetaHud.PetneedHealth = true;
          end 
     end

     if MetaHudOptions["animatebars"] == 0 or set then
          MetaHud.bar_anim[bar] = value;
          MetaHud:SetBarHeight(bar,value); 
          MetaHud:SetBarColor(bar,value);
     end
end

--- animate bars
function MetaHud:Animate(bar)
     local ph  = math.floor(MetaHud.bar_values[bar] * 100);
     local pha = math.floor(MetaHud.bar_anim[bar] * 100);
     if ph < pha then
          MetaHud.bar_change[bar] = 1;
          if pha - ph > 10 then
               MetaHud.bar_anim[bar] = MetaHud.bar_anim[bar] - MetaHud.stepfast;
          else
               MetaHud.bar_anim[bar] = MetaHud.bar_anim[bar] - MetaHud.step;
          end   
     elseif ph > pha then
          MetaHud.bar_change[bar] = 1;
          if ph - pha > 10 then
               MetaHud.bar_anim[bar] = MetaHud.bar_anim[bar] + MetaHud.stepfast;
          else
               MetaHud.bar_anim[bar] = MetaHud.bar_anim[bar] + MetaHud.step;
          end
     end
     ---  Anim 
     if MetaHud.bar_change[bar] then
          MetaHud:SetBarHeight(bar, MetaHud.bar_anim[bar] );
          MetaHud:SetBarColor(bar, MetaHud.bar_anim[bar] );
          MetaHud.bar_change[bar] = nil;
     end
end

--[[
This function is called on each click in the options plus re-targetting
]]--
--- update Background Texture
function MetaHud:ChangeBackgroundTexture()
     if(MetaHudOptions["barborders"] == 1) then
          if(UnitExists("target") and MetaHudOptions["showtarget"] == 1) then 
               if(UnitHealthMax("target")) then 
                    MetaHud.has_target_health = 1;
               else
                    MetaHud.has_target_health = nil;
               end
               if(UnitPowerMax("target") > 0) then 
                    MetaHud.has_target_mana = 1;
               else
                    MetaHud.has_target_mana = nil;
               end
          else
               MetaHud.has_target_health = nil;
               MetaHud.has_target_mana   = nil;
          end
          ---  check pet
          MetaHud.has_pet_health = nil;
          MetaHud.has_pet_mana   = nil;
          if(MetaHudOptions["showpet"] == 1 and UnitExists("pet")) then
               if(UnitName("pet")) then 
                    if(UnitHealthMax("pet")) then 
                         MetaHud.has_pet_health = 1;
                    end
                    if(UnitPowerMax("pet") > 0) then 
                         MetaHud.has_pet_mana = 1;
                    end              
               end
          end
          ---  check druidbar
          if(DruidBarKey and MetaHud.player_class == "DRUID") then
               if(UnitPowerType("player") ~= 0) then
                    MetaHud.has_pet_mana = 1;
               else
                    MetaHud.has_pet_mana = nil;
               end
          end
     end

     local what = "ph_pm";
     if(MetaHud.has_pet_health)    then what = what.."_eh"; end
     if(MetaHud.has_pet_mana)      then what = what.."_em"; end
     if(MetaHud.has_target_health) then what = what.."_th"; end
     if(MetaHud.has_target_mana)   then what = what.."_tm"; end

     if MetaHudOptions["barborders"] == 0 then
          what = "none";
     end
     local texture,x0,x1,y0,y1;
     if(type(MetaHud.C_textures["l_"..what]) == "table") then
          texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["l_"..what] );
          _G["MetaHud_LeftFrame_Texture"]:SetTexture(texture);
          _G["MetaHud_LeftFrame_Texture"]:SetTexCoord(x0,x1,y0,y1);
     end
     if(type(MetaHud.C_textures["l_"..what]) == "table") then
          texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["r_"..what] );
          _G["MetaHud_RightFrame_Texture"]:SetTexture(texture);
          _G["MetaHud_RightFrame_Texture"]:SetTexCoord(x0,x1,y0,y1);
     end


     local width = MetaHud_Rune1:GetWidth();
     local height = MetaHud_Rune1:GetHeight();
     if MetaHudOptions["runeorient"] == 1 and width > height then
          for i = 1, 6 do
               f1 = _G["MetaHud_Rune"..i];
               f2 = _G["MetaHud_Rune"..i.."_Texture"];
               f3 = _G["MetaHud_Rune"..i.."_Cooldown"];

               for j = 1, 3 do
                    _G["f"..j]:SetWidth(height);
                    _G["f"..j]:SetHeight(width);
               end
               --             ULx, ULy, LLx, LLy, URx, URy, LRx, LRy
               --               0,   0,   0,   1,   1,   0,   1,   1
               f2:SetTexCoord(  0,   1,   1,   1,   0,   0,   1,   0);
          end
     elseif height > width and MetaHudOptions["runeorient"] == 0 then
          for i = 1, 6 do
               f1 = _G["MetaHud_Rune"..i];
               f2 = _G["MetaHud_Rune"..i.."_Texture"];
               f3 = _G["MetaHud_Rune"..i.."_Cooldown"];

               for j = 1, 3 do
                    _G["f"..j]:SetWidth(height);
                    _G["f"..j]:SetHeight(width);
               end
               --             ULx, ULy, LLx, LLy, URx, URy, LRx, LRy
               --               0,   0,   0,   1,   1,   0,   1,   1
               f2:SetTexCoord(  0,   0,   0,   1,   1,   0,   1,   1);
          end
     end

     if MetaHudOptions["runeVerticle"] == 1 then
          MetaHud_RuneFrame:SetHeight(METAHUD_RUNE_SIZE_Y * 6);
          MetaHud_RuneFrame:SetWidth(METAHUD_RUNE_SIZE_X);
          MetaHud_RuneFrame:SetPoint("CENTER", MetaHud_Main, "CENTER", MetaHudOptions["runeframex"], MetaHudOptions["runeframey"]);
          for i=1, 6 do
               _G["MetaHud_Rune"..i]:ClearAllPoints();
          end
          MetaHud_Rune1:SetPoint("TOPLEFT", MetaHud_RuneFrame, "TOPLEFT");
          MetaHud_Rune2:SetPoint("TOPRIGHT", MetaHud_Rune1, "BOTTOMRIGHT");
          MetaHud_Rune3:SetPoint("TOPRIGHT", MetaHud_Rune2, "BOTTOMRIGHT");
          MetaHud_Rune4:SetPoint("TOPRIGHT", MetaHud_Rune3, "BOTTOMRIGHT");
          MetaHud_Rune5:SetPoint("TOPRIGHT", MetaHud_Rune4, "BOTTOMRIGHT");
          MetaHud_Rune6:SetPoint("TOPRIGHT", MetaHud_Rune5, "BOTTOMRIGHT");
     else
          MetaHud_RuneFrame:SetHeight(METAHUD_RUNE_SIZE_Y);
          MetaHud_RuneFrame:SetWidth(METAHUD_RUNE_SIZE_X * 6);
          MetaHud_RuneFrame:SetPoint("CENTER", MetaHud_Main, "CENTER", MetaHudOptions["runeframex"], MetaHudOptions["runeframey"]);
          for i=1, 6 do
               _G["MetaHud_Rune"..i]:ClearAllPoints();
          end
          MetaHud_Rune1:SetPoint("TOPLEFT", MetaHud_RuneFrame, "TOPLEFT");
          MetaHud_Rune2:SetPoint("TOPLEFT", MetaHud_Rune1, "TOPRIGHT");
          MetaHud_Rune3:SetPoint("TOPLEFT", MetaHud_Rune2, "TOPRIGHT");
          MetaHud_Rune4:SetPoint("TOPLEFT", MetaHud_Rune3, "TOPRIGHT");
          MetaHud_Rune5:SetPoint("TOPLEFT", MetaHud_Rune4, "TOPRIGHT");
          MetaHud_Rune6:SetPoint("TOPLEFT", MetaHud_Rune5, "TOPRIGHT");
     end

     local typ = MetaHudOptions["texturefile"];
     local name = METAHUD_LAYOUTPATH.."r"..typ;
     --print("Name: "..name);
     for i=1, 6 do
          _G["MetaHud_Rune"..i.."_Texture"]:SetTexture(name);
     end

     ---  show elite icon?
     if MetaHud:CheckElite("target") and MetaHudOptions["showtarget"] == 1 and MetaHudOptions["showeliteicon"] == 1 then
          local elite = MetaHud:CheckElite("target");
          local tex;
          if(elite == "++" or elite == "+" or elite == "Elite" or elite == "Boss") then
               tex = "MetaHud_TargetElite";
          elseif(elite == "r" or elite == "r+" or elite == "Rare" or elite == "RareElite") then
               tex = "MetaHud_TargetRare";
          end
          local texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures[tex] );
          _G["MetaHud_TargetElite_Texture"]:SetTexture(texture);
          _G["MetaHud_TargetElite_Texture"]:SetTexCoord(x0,x1,y0,y1);
          _G["MetaHud_TargetElite"]:Show();
     else
          _G["MetaHud_TargetElite"]:Hide();
     end
     MetaHud:updatePlayerPvP();
end

--- update Alpha
function MetaHud:updateAlpha()
     ---  Combat Mode
     if(MetaHud.inCombat) then
          MetaHud:setAlpha("combatalpha");
          ---  target selected             
     elseif MetaHud.Target then
          MetaHud:setAlpha("selectalpha");
          ---  Player / Pet reg
     elseif MetaHud.needHealth or MetaHud.needMana or MetaHud.PetneedHealth or MetaHud.PetneedMana then
          MetaHud:setAlpha("regenalpha");
          ---  standard mode                               
     else
          MetaHud:setAlpha("oocalpha");
     end
end

--- set alpha (combatalpha oocalpha selectalpha regenalpha)
function MetaHud:setAlpha(mode)
     --     MetaHud:printd("Alphamode: "..mode);
     for k, v in pairs(MetaHud.alpha_textures) do
          local texture = _G[v];
          texture:SetAlpha(MetaHudOptions[mode]);
     end
     for k, v in pairs(MetaHud.alpha2_textures) do
          local texture = _G[v];
          if(MetaHudOptions.textalpha == 0) then
               texture:SetAlpha(MetaHudOptions[mode]);
          else
               texture:SetAlpha(1);
          end
     end
     if(IsAddOnLoaded("EnergyWatch_v2") and MetaHudOptions["ewcontrol"] == 1) then
          EnergyWatchFrameStatusBar:SetAlpha(MetaHudOptions[mode]);
          if(MetaHudOptions.textalpha == 0) then
               EnergyWatchText:SetAlpha(MetaHudOptions[mode]);
          else
               EnergyWatchText:SetAlpha(1);
          end
     end
     ---  hide player text when alpha = 0 
     if MetaHudOptions[mode] == 0 then
          _G["MetaHud_PlayerHealth_Text"]:Hide();
          _G["MetaHud_PlayerMana_Text"]:Hide();
          _G["MetaHud_PetHealth_Text"]:Hide();
          _G["MetaHud_PetMana_Text"]:Hide();
     elseif not UnitIsDeadOrGhost("player") then
          _G["MetaHud_PlayerHealth_Text"]:Show();
          _G["MetaHud_PlayerMana_Text"]:Show();  
          _G["MetaHud_PetHealth_Text"]:Show();
          _G["MetaHud_PetMana_Text"]:Show(); 
     end 
end

--- resting status
function MetaHud:updateStatus()
     if(IsResting() and MetaHudOptions["showresticon"] == 1 and not UnitIsDeadOrGhost("player")) then
          _G["MetaHud_PlayerResting"]:Show();
          _G["MetaHud_PlayerAttacking"]:Hide();
     elseif(MetaHud.inCombat and MetaHudOptions["showresticon"] == 1 and not UnitIsDeadOrGhost("player")) then
          _G["MetaHud_PlayerAttacking"]:Show();
          _G["MetaHud_PlayerResting"]:Hide();
     else
          _G["MetaHud_PlayerResting"]:Hide();
          _G["MetaHud_PlayerAttacking"]:Hide();
     end
end

--- party/raid status
function MetaHud:updateParty()
     if(GetNumGroupMembers() > 0 or IsInRaid()) then
          MetaHud.inParty = 1;
          local lootMethod, lootMaster = GetLootMethod();
          if(UnitIsGroupLeader("player") and MetaHudOptions["showplayerleadericon"] == 1) then
               MetaHud_PlayerLeader:Show();
          else
               MetaHud_PlayerLeader:Hide();
          end
          if(lootMaster == 0 and MetaHud.inParty == 1 and MetaHudOptions["showplayerlootericon"] == 1) then
               MetaHud_PlayerLooter:Show();
          else
               MetaHud_PlayerLooter:Hide();
          end
     else
          MetaHud_PlayerLeader:Hide();
          MetaHud_PlayerLooter:Hide();
          MetaHud_TargetIcon:Hide();
          MetaHud.inParty = nil;
     end
     MetaHud:updateTargetIcon();
end

--- target icon
function MetaHud:updateTargetIcon()
     local icon = _G["MetaHud_TargetIcon"];
     icon:Hide();
     if(MetaHud.inParty == 1 and MetaHudOptions["showtargeticon"] == 1) then
          local index = GetRaidTargetIndex("target");
          if(index ~= nil and UnitExists("target")) then
               SetRaidTargetIconTexture(MetaHud_TargetIcon_Texture, index);
               icon:ClearAllPoints();
               icon:SetPoint("TOPRIGHT", _G["MetaHud_Target_Text"], "TOPLEFT");
               icon:Show();
          end
     end
end

--- pvp status
function MetaHud:updatePlayerPvP()
     local tex = _G["MetaHud_PlayerPvP_Texture"];
     local texture = nil;
     if MetaHudOptions["showplayerpvpicon"] == 1 and not UnitIsDeadOrGhost("player") then
          if UnitIsPVPFreeForAll("player")  then
               texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_FreePvP"] );
          elseif UnitIsPVP("player") then
               local faction = UnitFactionGroup("player");
               if faction == "Horde" then
                    texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_TargetPvP"] );
               else
                    texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_PlayerPvP"] );
               end
          end
          if texture then
               tex:SetTexture(texture);
               tex:SetTexCoord(x0,x1,y0,y1);
               _G["MetaHud_PlayerPvP"]:Show();
          else
               _G["MetaHud_PlayerPvP"]:Hide();
          end
     else
          _G["MetaHud_PlayerPvP"]:Hide();
     end
end

--- pvp icon target
function MetaHud:updateTargetPvP()
     local tex = _G["MetaHud_TargetPvP_Texture"];
     local texture = nil;
     local x0,x1,y0,y1;
     if MetaHudOptions["showtargetpvpicon"] == 1 and MetaHudOptions["showtarget"] == 1 then
          if UnitIsPVPFreeForAll("target")  then
               texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_FreePvP"] );
          elseif UnitIsPVP("target") then
               local faction = UnitFactionGroup("target");
               if faction == "Horde" then
                    texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_TargetPvP"] );
               else
                    texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_PlayerPvP"] );
               end
          end
          if texture then
               tex:SetTexture(texture);
               tex:SetTexCoord(x0,x1,y0,y1);
               _G["MetaHud_TargetPvP"]:Show();
          else
               _G["MetaHud_TargetPvP"]:Hide();
          end
     else
          _G["MetaHud_TargetPvP"]:Hide();
     end
end

local comment = [[--- pet icon
function MetaHud:updatePetIcon()
    if MetaHud.has_pet_health ~= nil and MetaHudOptions["showpeticon"] == 1 then
        local texture = nil;
        local x0,x1,y0,y1;
        local happiness, _, _ = GetPetHappiness();

        if happiness == 1 then
            texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_PetUnhappy"] );
        elseif happiness == 2 then
            texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_PetNormal"] );
        elseif happiness == 3 then
            texture,x0,x1,y0,y1 = unpack( MetaHud.C_textures["MetaHud_PetHappy"] );
        end

        if texture then
            local tex = _G["MetaHud_PetHappy_Texture"];
            tex:SetTexture(texture);
            tex:SetTexCoord(x0,x1,y0,y1);     
            _G["MetaHud_PetHappy"]:Show();
        else
            _G["MetaHud_PetHappy"]:Hide();
        end
    else
        _G["MetaHud_PetHappy"]:Hide();
    end
end
--]]; comment = nil

--- Toggle Options
function MetaHud:OptionsFrame_Toggle()
     if(not IsAddOnLoaded("MetaHudOptions")) then
          LoadAddOn("MetaHudOptions");
     end
     if(IsAddOnLoaded("MetaHudOptions")) then
          if(MetaHudOptionsFrame:IsVisible()) then
               MetaHudOptionsFrame:Hide();
          else
               MetaHudOptionsFrame:Show();
          end
     else
     end
end

--- target dropdown
function MetaHud_Target_DropDown_Initialize() 
     local menu = nil; 
     if(SpellIsTargeting()) then 
          SpellTargetUnit("target"); 
     elseif(CursorHasItem()) then 
          DropItemOnUnit("target"); 
     elseif(not UnitIsPlayer("target")) then 
          menu = "TARGET"; 
     elseif(UnitIsEnemy("target", "player")) then 
          if(UnitInParty("player")) then 
               menu = "RAID_TARGET_ICON"; 
          end 
     elseif(UnitIsUnit("target", "player")) then 
          menu = "SELF"; 
     elseif(UnitIsUnit("target", "pet")) then 
          menu = "PET"; 
     elseif (UnitIsPlayer("target")) then 
          if(UnitInParty("target")) then     
               menu = "PARTY"; 
          else 
               menu = "PLAYER"; 
          end 
     else 
          menu = "TARGET"; 
     end     
     if menu then     
          UnitPopup_ShowMenu( MetaHud_Target_DropDown, menu, "target" ); 
     end 
end

--- player dropdown
function MetaHud_Player_DropDown_Initialize()
     UnitPopup_ShowMenu( MetaHud_Player_DropDown, "SELF", "player" );
end

--- print Debug --
function MetaHud:printd(msg)
     if DEFAULT_CHAT_FRAME and MetaHud.debug then
          DEFAULT_CHAT_FRAME:AddMessage("MetaHud Debug: "..(msg or "null"), 1,0.5,0.5);
     end
end

--- print Message --
function MetaHud:print(msg)
     if DEFAULT_CHAT_FRAME then
          DEFAULT_CHAT_FRAME:AddMessage("|cff88ff88<MetaHud>:|r "..(msg or "null"), 1,1,1);
     end
end

--- setdefault Config
function MetaHud:SetDefaultConfig(key)
     if (not MetaHudOptions[key]) then
          if type(MetaHud.Config_default[key]) ~= "table" then
               MetaHudOptions[key] = MetaHud.Config_default[key];
          else
               MetaHudOptions[key] = MetaHud_tablecopy(MetaHud.Config_default[key]);
          end
     end  
end

--- SlashCommand Handler
function MetaHud:SCommandHandler(msg)
     local b,e,command = string.find(msg, "^%s*([^%s]+)%s*(.*)$");
     if(command and strlower(command) == "menu") then
          MetaHud:OptionsFrame_Toggle();
     else
          MetaHud:print("Commands:\n '/MetaHud Menu' for options");
     end
end

--- set config value
function MetaHud:SetConfig(key, value)
     if (MetaHudOptions[key] ~= value) then
          MetaHudOptions[key] = value;
     end
end

--- get config value
function MetaHud:GetConfig(key)
     return MetaHudOptions[key] or nil;
end

--- toggle config value
function MetaHud:ToggleConfig(key)
     local output   = "/MetaHud %s";
     local response = "|cff6666cc%s|r is now %s";
     if MetaHudOptions[key] == nil then
          MetaHudOptions[key] = 0;
     end
     if MetaHudOptions[key] == 1 then
          MetaHudOptions[key] = 0;
          MetaHud:print(string.format(
                    response,
                    key,
                    "|cffff0000OFF|r"
               ));                                                   
     else
          MetaHudOptions[key] = 1;
          MetaHud:print(string.format(
                    response,
                    key,
                    "|cff00ff00ON|r"
               ));  
     end
     MetaHud:init();
     if (key == "activename") then
          _G["MetaHud_Target_Text"]:EnableMouse((MetaHudOptions["activename"] == 1 and true) or false);
     end
end

--- is target elite?
function MetaHud:CheckElite(unit, mode)
     local el = UnitClassification(unit);
     local ret;
     if(el == "worldboss") then
          if(mode == nil) then ret = "++"; else ret = " Boss"; end
     elseif(el == "rareelite") then
          if(mode == nil) then ret = "r+"; else ret = " RareElite"; end
     elseif(el == "elite") then
          if(mode == nil) then ret = "+"; else ret = " Elite"; end
     elseif(el == "rare") then
          if(mode == nil) then ret = "r"; else ret = " Rare"; end
     else
          ret = nil;
     end
     return ret;
end

--- unit reaction
function MetaHud:GetReactionColor(unit)
     local i;
     if (UnitIsPlayer(unit)) then
          if (UnitIsPVP(unit)) then
               if (UnitCanAttack("player", unit)) then
                    i = 1;
               else
                    i = 5;
               end
          else
               if (UnitCanAttack("player", unit) or UnitFactionGroup(unit) ~= UnitFactionGroup("player")) then
                    i = 2;
               else
                    i = 4;
               end
          end
     elseif (UnitIsTapped(unit) and (not UnitIsTappedByPlayer(unit))) then
          i = 6;
     else
          local reaction = UnitReaction(unit, "player");
          if (reaction) then
               if (reaction < 4) then
                    i = 1;
               elseif (reaction == 4) then
                    i = 2;
               else
                    i = 3;
               end
          end
     end
     return MetaHud.ReacColors[i];
end

function MetaHud:FormatTime(time)
     if(not time) then return; end
     if(time > 60 or MetaHud.TimerSet) then
          local minutes = math.floor((time / 60));
          local seconds = math.ceil(time - (60 * minutes));
          if (seconds == 60) then
               minutes = minutes + 1;
               seconds = 0;
          end
          if(strlen(seconds) < 2) then
               seconds =  "0"..seconds;
          end
          return format("%s:%s", minutes, seconds);
     else
          return string.format( "%.1f", time);
     end
end

function MetaHud:FormatDate(time)
     if(time) then
          local tmp = date("*t", time)
          local month = date("%b", time)
          if(tmp.min == 0) then tmp.min = "00"; end
          tTime = tmp.day.." "..month.." "..tmp.year.." "..tmp.hour..":"..tmp.min;
          return tTime;
     else
          return "";
     end
end

--- set color
function MetaHud:SetColor(key, value)
     local output   = "/MetaHud |cff6666cc%s|r 000000 - FFFFFF";
     local response = "|cff6666cc%s|r set to: |cff%s%s|r";
     if (MetaHudOptions[key] ~= value) then
          MetaHudOptions[key] = value;
          MetaHud:print( string.format(
                    response, key, value , value
               ) ); 
     end
end

MetaHud_HexTable = {
     ["0"] = 0,
     ["1"] = 1,
     ["2"] = 2,
     ["3"] = 3,
     ["4"] = 4,
     ["5"] = 5,
     ["6"] = 6,
     ["7"] = 7,
     ["8"] = 8,
     ["9"] = 9,
     ["a"] = 10,
     ["b"] = 11,
     ["c"] = 12,
     ["d"] = 13,
     ["e"] = 14,
     ["f"] = 15
}

--- hexcolor to rgb 
function MetaHud_hextodec(hex)
     local r1 = tonumber(MetaHud_HexTable[ string.lower(string.sub(hex,1,1)) ] * 16);
     local r2 = tonumber(MetaHud_HexTable[ string.lower(string.sub(hex,2,2)) ]);
     local r  = (r1 + r2) / 255;
     local g1 = tonumber(MetaHud_HexTable[ string.lower(string.sub(hex,3,3)) ] * 16);
     local g2 = tonumber(MetaHud_HexTable[ string.lower(string.sub(hex,4,4)) ]);
     local g  = (g1 + g2) / 255;
     local b1 = tonumber(MetaHud_HexTable[ string.lower(string.sub(hex,5,5)) ] * 16);
     local b2 = tonumber(MetaHud_HexTable[ string.lower(string.sub(hex,6,6)) ]);
     local b  = (b1 + b2) / 255;
     return {r,g,b}
end

--- decimal to hex
function MetaHud_DecToHex(red,green,blue)
     if ( not red or not green or not blue ) then
          return "ffffff"
     end
     red = floor(red * 255)
     green = floor(green * 255)
     blue = floor(blue * 255)
     local a,b,c,d,e,f
     a = MetaHud_GiveHex(floor(red / 16))
     b = MetaHud_GiveHex(mod(red,16))
     c = MetaHud_GiveHex(floor(green / 16))
     d = MetaHud_GiveHex(mod(green,16))
     e = MetaHud_GiveHex(floor(blue / 16))
     f = MetaHud_GiveHex(mod(blue,16))
     return a..b..c..d..e..f
end

--- safe gsub
function MetaHud:gsub(text, var, value)
     if (value) then
          text = string.gsub(text, var, value);
     else
          text = string.gsub(text, var, "");
     end
     return text;
end

function MetaHud_GiveHex(dec)
     for key, value in pairs(MetaHud_HexTable) do
          if ( dec == value ) then
               return key
          end
     end
     return ""..dec
end

--- table copy
function MetaHud_tablecopy(tbl)
     if type(tbl) ~= "table" then return tbl end
     local t = {}
     for i,v in pairs(tbl) do
          t[i] = MetaHud_tablecopy(v)
     end
     return setmetatable(t, MetaHud_tablecopy(getmetatable(tbl)))
end

--- MyAddonsSupport
function MetaHud:myAddons()
     if (myAddOnsFrame_Register) then
          local MetaHud_mya = {
               ["name"]         = "MetaHud",
               ["version"]      = MetaHud.Config_default["version"],
               ["author"]       = "Nuckinfuts/Nuckin (Greg Flynn)",
               ["category"]     = MYADDONS_CATEGORY_COMBAT,
               ["email"]        = "freakeffects@hotmail.com",
               ["website"]      = "http://www.freakeffects.net/",
               ["optionsframe"] = "MetaHudOptionsFrame",
          };
          myAddOnsFrame_Register(MetaHud_mya);
     end
end

function MetaHud:SetLayoutElements()
     if not MetaHud_Layouts then MetaHud_Layouts = {} end;
     MetaHud_Layouts.MetaHud_Base_Layout = { 
          ["MetaHud_textures_clip"] = {
               [METAHUD_LAYOUTPATH.."cb"]   = { 256, 11  , 11 },      
               [METAHUD_LAYOUTPATH.."cbh"]  = { 256, 11  , 11 },
          },
          ["MetaHud_names"] = { 
               "MetaHud_Main", 
               "MetaHud_LeftFrame",
               "MetaHud_RightFrame",
               "MetaHud_PlayerHealth_Bar",
               "MetaHud_PlayerMana_Bar",
               "MetaHud_TargetHealth_Bar",
               "MetaHud_TargetMana_Bar",
               "MetaHud_PetHealth_Bar",
               "MetaHud_PetMana_Bar",
               "MetaHud_Combo1",
               "MetaHud_Combo2",
               "MetaHud_Combo3",
               "MetaHud_Combo4",
               "MetaHud_Combo5",
               "MetaHud_HolyPower1",
               "MetaHud_HolyPower2",
               "MetaHud_HolyPower3",
               "MetaHud_HolyPower4",
               "MetaHud_HolyPower5",
               "MetaHud_SoulShard1",
               "MetaHud_SoulShard2",
               "MetaHud_SoulShard3",
               "MetaHud_SoulShard4",
               "MetaHud_RuneFrame",
               "MetaHud_Rune1",
               "MetaHud_Rune2",
               "MetaHud_Rune3",
               "MetaHud_Rune4",
               "MetaHud_Rune5",
               "MetaHud_Rune6",
               --"MetaHud_PlayerOrb",
               --"MetaHud_TargetOrb",
               "MetaHud_Target_Text",
               "MetaHud_ToTarget_Text",
               "MetaHud_Range_Text",
               "MetaHud_Guild_Text",
               "MetaHud_PlayerHealth_Text",
               "MetaHud_PlayerMana_Text",
               "MetaHud_TargetHealth_Text",
               "MetaHud_TargetMana_Text",
               "MetaHud_PetHealth_Text",
               "MetaHud_PetMana_Text",
               "MetaHud_Threat",
               "MetaHud_Buff1",
               "MetaHud_Buff2",
               "MetaHud_Buff3",
               "MetaHud_Buff4",
               "MetaHud_Buff5",
               "MetaHud_Buff6",
               "MetaHud_Buff7",
               "MetaHud_Buff8",
               "MetaHud_Buff9",
               "MetaHud_Buff10",
               "MetaHud_Buff11",
               "MetaHud_Buff12",
               "MetaHud_Buff13",
               "MetaHud_Buff14",
               "MetaHud_Buff15",
               "MetaHud_Buff16",
               "MetaHud_Buff17",
               "MetaHud_Buff18",
               "MetaHud_Buff19",
               "MetaHud_Buff20",
               "MetaHud_Buff21",
               "MetaHud_Buff22",
               "MetaHud_Buff23",
               "MetaHud_Buff24",
               "MetaHud_Buff25",
               "MetaHud_Buff26",
               "MetaHud_Buff27",
               "MetaHud_Buff28",
               "MetaHud_Buff29",
               "MetaHud_Buff30",
               "MetaHud_Buff31",
               "MetaHud_Buff32",
               "MetaHud_Buff33",
               "MetaHud_Buff34",
               "MetaHud_Buff35",
               "MetaHud_Buff36",
               "MetaHud_Buff37",
               "MetaHud_Buff38",
               "MetaHud_Buff39",
               "MetaHud_Buff40",
               "MetaHud_DeBuff1",
               "MetaHud_DeBuff2",
               "MetaHud_DeBuff3",
               "MetaHud_DeBuff4",
               "MetaHud_DeBuff5",
               "MetaHud_DeBuff6",
               "MetaHud_DeBuff7",
               "MetaHud_DeBuff8",
               "MetaHud_DeBuff9",
               "MetaHud_DeBuff10",
               "MetaHud_DeBuff11",
               "MetaHud_DeBuff12",
               "MetaHud_DeBuff13",
               "MetaHud_DeBuff14",
               "MetaHud_DeBuff15",
               "MetaHud_DeBuff16",
               "MetaHud_DeBuff17",
               "MetaHud_DeBuff18",
               "MetaHud_DeBuff19",
               "MetaHud_DeBuff20",
               "MetaHud_DeBuff21",
               "MetaHud_DeBuff22",
               "MetaHud_DeBuff23",
               "MetaHud_DeBuff24",
               "MetaHud_DeBuff25",
               "MetaHud_DeBuff26",
               "MetaHud_DeBuff27",
               "MetaHud_DeBuff28",
               "MetaHud_DeBuff29",
               "MetaHud_DeBuff30",
               "MetaHud_DeBuff31",
               "MetaHud_DeBuff32",
               "MetaHud_DeBuff33",
               "MetaHud_DeBuff34",
               "MetaHud_DeBuff35",
               "MetaHud_DeBuff36",
               "MetaHud_DeBuff37",
               "MetaHud_DeBuff38",
               "MetaHud_DeBuff39",
               "MetaHud_DeBuff40",
               "MetaHud_PlayerResting",
               "MetaHud_PlayerAttacking",
               "MetaHud_PlayerLeader",
               "MetaHud_PlayerLooter",
               "MetaHud_PlayerPvP",
               "MetaHud_TargetIcon",
               --"MetaHud_PetHappy",
               "MetaHud_TargetPvP",
               "MetaHud_TargetElite",
               "MetaHud_TargetRare",
          },
          ["MetaHud_textures"] = {
               ["MetaHud_LeftFrame"]        = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 },
               ["MetaHud_RightFrame"]       = { METAHUD_LAYOUTPATH.."bg_21p"  , 1 , 0 , 0 , 1 },
               ["MetaHud_Combo1"]           = { METAHUD_LAYOUTPATH.."c1"      , 0 , 1 , 0 , 1 },
               ["MetaHud_Combo2"]           = { METAHUD_LAYOUTPATH.."c1"      , 0 , 1 , 0 , 1 },
               ["MetaHud_Combo3"]           = { METAHUD_LAYOUTPATH.."c1"      , 0 , 1 , 0 , 1 },
               ["MetaHud_Combo4"]           = { METAHUD_LAYOUTPATH.."c4"      , 0 , 1 , 0 , 1 },
               ["MetaHud_Combo5"]           = { METAHUD_LAYOUTPATH.."c5"      , 0 , 1 , 0 , 1 },
               ["MetaHud_HolyPower1"]       = { METAHUD_LAYOUTPATH.."c4"      , 0 , 1 , 0 , 1 },
               ["MetaHud_HolyPower2"]       = { METAHUD_LAYOUTPATH.."c4"      , 0 , 1 , 0 , 1 },
               ["MetaHud_HolyPower3"]       = { METAHUD_LAYOUTPATH.."c4"      , 0 , 1 , 0 , 1 },
               ["MetaHud_HolyPower4"]       = { METAHUD_LAYOUTPATH.."c4"      , 0 , 1 , 0 , 1 },
               ["MetaHud_HolyPower5"]       = { METAHUD_LAYOUTPATH.."c5"      , 0 , 1 , 0 , 1 },
               ["MetaHud_SoulShard1"]       = { METAHUD_LAYOUTPATH.."ss"      , 0 , 1 , 0 , 1 },
               ["MetaHud_SoulShard2"]       = { METAHUD_LAYOUTPATH.."ss"      , 0 , 1 , 0 , 1 },
               ["MetaHud_SoulShard3"]       = { METAHUD_LAYOUTPATH.."ss"      , 0 , 1 , 0 , 1 },
               ["MetaHud_SoulShard4"]       = { METAHUD_LAYOUTPATH.."ss"      , 0 , 1 , 0 , 1 },
               ["MetaHud_PlayerResting"]    = { "Interface\\CharacterFrame\\UI-StateIcon"         , 0.0625 , 0.4475 , 0.0625 , 0.4375  },
               ["MetaHud_PlayerAttacking"]  = { "Interface\\CharacterFrame\\UI-StateIcon"         , 0.5625 , 0.9375 , 0.0625 , 0.4375  },
               ["MetaHud_PlayerLeader"]     = { "Interface\\GroupFrame\\UI-Group-LeaderIcon"      , 0      , 1      , 0      , 1       },
               ["MetaHud_PlayerLooter"]     = { "Interface\\GroupFrame\\UI-Group-MasterLooter"    , 0      , 1      , 0      , 1       },
               --["MetaHud_PetHappy"]         = { "Interface\\PetPaperDollFrame\\UI-PetHappiness"   , 0      , 0.1875 , 0      , 0.359375},
               --["MetaHud_PetNormal"]        = { "Interface\\PetPaperDollFrame\\UI-PetHappiness"   , 0.1875 , 0.375  , 0      , 0.359375},
               --["MetaHud_PetUnhappy"]       = { "Interface\\PetPaperDollFrame\\UI-PetHappiness"   , 0.375  , 0.5625 , 0      , 0.359375},
               ["MetaHud_TargetPvP"]        = { "Interface\\TargetingFrame\\UI-PVP-Horde"         , 0.6    , 0      , 0      , 0.6     },
               ["MetaHud_PlayerPvP"]        = { "Interface\\TargetingFrame\\UI-PVP-Alliance"      , 0      , 0.6    , 0      , 0.6     }, 
               ["MetaHud_FreePvP"]          = { "Interface\\TargetingFrame\\UI-PVP-FFA"           , 0      , 0.6    , 0      , 0.6     },    
               ["MetaHud_TargetIcon"]       = { "Interface\\TargetingFrame\\UI-RaidTargetingIcons", 0      , 1      , 0      , 1       },    
          },
          ["MetaHud_frames"] = {
               ["MetaHud_Main"]              = { "Frame"   , "CENTER" , "UIParent"             , "CENTER"  , 0   , 0    , 512 , 256},
               ["MetaHud_LeftFrame"]         = { "Texture" , "LEFT"   , "MetaHud_Main"         , "LEFT"    , 0   , 0    , 128 , 256},
               ["MetaHud_RightFrame"]        = { "Texture" , "RIGHT"  , "MetaHud_Main"         , "RIGHT"   , 0   , 0    , 128 , 256},
               ["MetaHud_PlayerHealth_Bar"]  = { "Bar"     , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 0   , 0    , 128 , 256},
               ["MetaHud_TargetMana_Bar"]    = { "Bar"     , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 0   , 0    , 128 , 256},
               ["MetaHud_PetHealth_Bar"]     = { "Bar"     , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 0   , 0    , 128 , 256},
               ["MetaHud_Threat"]                 = { "Text"    , "TOP"    , "MetaHud_LeftFrame"    , "TOP"     , 50  , 5   , 200 , 16 },
               ["MetaHud_Target_Text"]       = { "Text"    , "BOTTOM" , "MetaHud_Main"         , "BOTTOM"  , 0   , -45  , 200 , 14 },
               ["MetaHud_ToTarget_Text"]     = { "Text"    , "CENTER" , "MetaHud_Main"         , "CENTER"  , 0   , 0    , 400 , 16 },
               ["MetaHud_Range_Text"]        = { "Text"    , "TOP"    , "MetaHud_Main"         , "TOP"     , 0   , 0    , 100 , 16 },
               ["MetaHud_Guild_Text"]        = { "Text"    , "BOTTOM" , "MetaHud_Main"         , "BOTTOM"  , 0   , -75  , 100 , 16 },
               ["MetaHud_TargetPvP"]         = { "Texture" , "BOTTOM" , "MetaHud_Target_Text"  , "TOP"     , -15 , 5    , 25  , 25 },
               ["MetaHud_TargetIcon"]        = { "Texture" , "RIGHT"  , "MetaHud_Target_Text"  , "LEFT"    , 0  , 0    , 16  , 16 },
               --["MetaHud_PlayerOrb"]         = { "Orb"     , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 40  , 0    , 16  , 16 },
               --["MetaHud_TargetOrb"]         = { "Orb"     , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , -40  , 0    , 16  , 16 },
               ["MetaHud_RuneFrame"]         = { "Frame"   , "CENTER" , "MetaHud_Main"         , "CENTER"  , 0   , -100 , METAHUD_RUNE_FRAME_X, METAHUD_RUNE_FRAME_Y },
               ["MetaHud_Rune1"]             = { "Rune"    , "LEFT"   , "MetaHud_RuneFrame"    , "LEFT"    , 0   , 0    , METAHUD_RUNE_SIZE_X, METAHUD_RUNE_SIZE_Y },
               ["MetaHud_Rune2"]             = { "Rune"    , "LEFT"   , "MetaHud_Rune1"        , "RIGHT"   , 0   , 0    , METAHUD_RUNE_SIZE_X, METAHUD_RUNE_SIZE_Y },
               ["MetaHud_Rune3"]             = { "Rune"    , "LEFT"   , "MetaHud_Rune2"        , "RIGHT"   , 0   , 0    , METAHUD_RUNE_SIZE_X, METAHUD_RUNE_SIZE_Y },
               ["MetaHud_Rune4"]             = { "Rune"    , "LEFT"   , "MetaHud_Rune3"        , "RIGHT"   , 0   , 0    , METAHUD_RUNE_SIZE_X, METAHUD_RUNE_SIZE_Y },
               ["MetaHud_Rune5"]             = { "Rune"    , "LEFT"   , "MetaHud_Rune4"        , "RIGHT"   , 0   , 0    , METAHUD_RUNE_SIZE_X, METAHUD_RUNE_SIZE_Y },
               ["MetaHud_Rune6"]             = { "Rune"    , "LEFT"   , "MetaHud_Rune5"        , "RIGHT"   , 0   , 0    , METAHUD_RUNE_SIZE_X, METAHUD_RUNE_SIZE_Y },
               ["MetaHud_Buff1"]             = { "Buff"    , "RIGHT"  , "MetaHud_LeftFrame"    , "LEFT"    , 53  , 105  , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff2"]             = { "Buff"    , "TOP"    , "MetaHud_Buff1"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff3"]             = { "Buff"    , "TOP"    , "MetaHud_Buff2"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff4"]             = { "Buff"    , "TOP"    , "MetaHud_Buff3"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff5"]             = { "Buff"    , "TOP"    , "MetaHud_Buff4"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff6"]             = { "Buff"    , "TOP"    , "MetaHud_Buff5"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff7"]             = { "Buff"    , "TOP"    , "MetaHud_Buff6"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff8"]             = { "Buff"    , "TOP"    , "MetaHud_Buff7"        , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff9"]             = { "Buff"    , "RIGHT"  , "MetaHud_Buff1"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff10"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff2"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff11"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff3"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff12"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff4"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff13"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff5"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff14"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff6"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff15"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff7"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff16"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff8"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff17"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff9"        , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff18"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff10"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff19"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff11"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff20"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff12"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff21"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff13"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff22"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff14"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff23"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff15"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff24"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff16"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff25"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff17"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff26"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff18"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff27"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff19"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff28"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff20"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff29"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff21"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff30"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff22"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff31"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff23"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff32"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff24"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff33"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff25"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff34"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff26"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff35"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff27"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff36"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff28"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff37"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff29"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff38"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff30"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff39"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff31"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_Buff40"]            = { "Buff"    , "RIGHT"  , "MetaHud_Buff32"       , "LEFT"    , -1  , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff1"]           = { "Buff"    , "LEFT"   , "MetaHud_RightFrame"   , "RIGHT"   , -53 , 105  , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff2"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff1"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff3"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff2"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff4"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff3"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff5"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff4"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff6"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff5"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff7"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff6"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff8"]           = { "Buff"    , "TOP"    , "MetaHud_DeBuff7"      , "BOTTOM"  , 0   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff9"]           = { "Buff"    , "LEFT"   , "MetaHud_DeBuff1"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff10"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff2"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff11"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff3"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff12"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff4"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff13"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff5"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff14"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff6"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff15"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff7"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff16"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff8"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff17"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff9"      , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff18"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff10"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff19"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff11"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff20"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff12"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff21"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff13"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff22"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff14"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff23"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff15"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff24"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff16"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff25"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff17"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff26"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff18"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff27"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff19"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff28"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff20"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff29"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff21"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff30"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff22"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff31"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff23"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff32"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff24"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff33"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff25"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff34"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff26"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff35"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff27"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff36"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff28"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff37"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff29"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff38"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff30"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff39"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff31"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
               ["MetaHud_DeBuff40"]          = { "Buff"    , "LEFT"   , "MetaHud_DeBuff32"     , "RIGHT"   , 1   , 0    , METAHUD_BUFF_SIZE  , METAHUD_BUFF_SIZE },
          }
     }
end

function MetaHud:UpdateLayout(LayoutType)
     local tex = MetaHudOptions.texturefile;
     local cliplayout = MetaHud_Layouts.MetaHud_Base_Layout.MetaHud_textures_clip;
     local texlayout = MetaHud_Layouts.MetaHud_Base_Layout.MetaHud_textures;
     local framelayout = MetaHud_Layouts.MetaHud_Base_Layout.MetaHud_frames;

     cliplayout[METAHUD_LAYOUTPATH.."1"..tex]  = { 256, 11  , 11 };
     cliplayout[METAHUD_LAYOUTPATH.."2"..tex]  = { 256, 5   , 5  };
     cliplayout[METAHUD_LAYOUTPATH.."p1"..tex] = { 256, 128 , 20 };
     cliplayout[METAHUD_LAYOUTPATH.."p2"..tex] = { 256, 128 , 20 };

     if(LayoutType == 1) then
          ---  Textures
          texlayout["MetaHud_PlayerHealth_Bar"] = { METAHUD_LAYOUTPATH.."1"..tex  , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_PlayerMana_Bar"]   = { METAHUD_LAYOUTPATH.."1"..tex  , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_TargetHealth_Bar"] = { METAHUD_LAYOUTPATH.."2"..tex  , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_TargetMana_Bar"]   = { METAHUD_LAYOUTPATH.."2"..tex  , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_PetHealth_Bar"]    = { METAHUD_LAYOUTPATH.."p1"..tex , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_PetMana_Bar"]      = { METAHUD_LAYOUTPATH.."p1"..tex , 1 , 0 , 0 , 1 };
          texlayout["l_none"]                   = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["r_none"]                   = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm"]                  = { METAHUD_LAYOUTPATH.."bg_1"    , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm"]                  = { METAHUD_LAYOUTPATH.."bg_1"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_em"]               = { METAHUD_LAYOUTPATH.."bg_1"    , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_em"]               = { METAHUD_LAYOUTPATH.."bg_1p"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_em"]            = { METAHUD_LAYOUTPATH.."bg_1p"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_em"]            = { METAHUD_LAYOUTPATH.."bg_1p"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh"]               = { METAHUD_LAYOUTPATH.."bg_1p"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh"]               = { METAHUD_LAYOUTPATH.."bg_1"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_th"]               = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_th"]               = { METAHUD_LAYOUTPATH.."bg_1"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_em_th"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_em_th"]            = { METAHUD_LAYOUTPATH.."bg_1p"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_1p"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_th_tm"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_th_tm"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_1"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_em_th_tm"]         = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_em_th_tm"]         = { METAHUD_LAYOUTPATH.."bg_21p"  , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_em_th"]         = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_em_th"]         = { METAHUD_LAYOUTPATH.."bg_1p"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_em_th_tm"]      = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_em_th_tm"]      = { METAHUD_LAYOUTPATH.."bg_21p"  , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_TargetElite"]      = { METAHUD_LAYOUTPATH.."elite"   , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_TargetRare"]       = { METAHUD_LAYOUTPATH.."rare"    , 0 , 1 , 0 , 1 };

          ---  Frames
          framelayout["MetaHud_PlayerMana_Bar"]    = { "Bar"     , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 0    , 0   , 128 , 256};
          framelayout["MetaHud_TargetHealth_Bar"]  = { "Bar"     , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 0    , 0   , 128 , 256};
          framelayout["MetaHud_PetMana_Bar"]       = { "Bar"     , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 0    , 0   , 128 , 256};
          framelayout["MetaHud_PlayerHealth_Text"] = { "Text"    , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 95   , 2   , 200 , 14 };
          framelayout["MetaHud_PlayerMana_Text"]   = { "Text"    , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , -95  , 2   , 200 , 14 };
          framelayout["MetaHud_TargetHealth_Text"] = { "Text"    , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 80   , -16 , 200 , 14 };
          framelayout["MetaHud_TargetMana_Text"]   = { "Text"    , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , -80  , -16 , 200 , 14 };
          framelayout["MetaHud_PetHealth_Text"]    = { "Text"    , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 110  , 19  , 200 , 14 };
          framelayout["MetaHud_PetMana_Text"]      = { "Text"    , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , -110 , 19  , 200 , 14 };
          framelayout["MetaHud_Combo1"]            = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 6    , 0   , 20  , 20 };
          framelayout["MetaHud_Combo2"]            = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -1   , 20  , 20  , 20 };
          framelayout["MetaHud_Combo3"]            = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -7   , 40  , 20  , 20 };
          framelayout["MetaHud_Combo4"]            = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -11  , 60  , 20  , 20 };
          framelayout["MetaHud_Combo5"]            = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -13  , 80  , 20  , 20 };
          framelayout["MetaHud_HolyPower1"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 6    , 0   , 20  , 20 };
          framelayout["MetaHud_HolyPower2"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -1   , 20  , 20  , 20 };
          framelayout["MetaHud_HolyPower3"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -7   , 40  , 20  , 20 };
          framelayout["MetaHud_HolyPower4"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -11  , 60  , 20  , 20 };
          framelayout["MetaHud_HolyPower5"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -13  , 80  , 20  , 20 };
          framelayout["MetaHud_SoulShard1"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , 6    , 0   , 20  , 20 };
          framelayout["MetaHud_SoulShard2"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -1   , 20  , 20  , 20 };
          framelayout["MetaHud_SoulShard3"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -7   , 40  , 20  , 20 };
          framelayout["MetaHud_SoulShard4"]        = { "Texture" , "BOTTOM" , "MetaHud_LeftFrame"    , "BOTTOM"  , -11  , 60  , 20  , 20 };
          framelayout["MetaHud_PlayerResting"]     = { "Texture" , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 2    , 0   , 22  , 22 };
          framelayout["MetaHud_PlayerAttacking"]   = { "Texture" , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 2    , 0   , 22  , 22 };
          framelayout["MetaHud_PlayerPvP"]         = { "Texture" , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 7    , 25  , 22  , 22 };
          framelayout["MetaHud_PlayerLeader"]      = { "Texture" , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 13   , 50  , 22  , 22 };
          framelayout["MetaHud_PlayerLooter"]      = { "Texture" , "BOTTOM" , "MetaHud_RightFrame"   , "BOTTOM"  , 15   , 75  , 22  , 22 };
          --framelayout["MetaHud_PetHappy"]          = { "Texture" , "TOP"    , "MetaHud_LeftFrame"    , "TOP"     , 32   , -107, 20  , 20 };
          framelayout["MetaHud_TargetElite"]       = { "Texture" , "TOP"    , "MetaHud_LeftFrame"    , "TOP"     , 18   , 20  , 64  , 64 };
     else
          ---  Textures
          texlayout["MetaHud_PlayerHealth_Bar"] = { METAHUD_LAYOUTPATH.."2"..tex  , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_PlayerMana_Bar"]   = { METAHUD_LAYOUTPATH.."1"..tex  , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_TargetHealth_Bar"] = { METAHUD_LAYOUTPATH.."2"..tex  , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_TargetMana_Bar"]   = { METAHUD_LAYOUTPATH.."1"..tex  , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_PetHealth_Bar"]    = { METAHUD_LAYOUTPATH.."p2"..tex , 0 , 1 , 0 , 1 };
          texlayout["MetaHud_PetMana_Bar"]      = { METAHUD_LAYOUTPATH.."p1"..tex , 0 , 1 , 0 , 1 };
          texlayout["l_none"]                   = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["r_none"]                   = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm"]                  = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm"]                  = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_em"]               = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_em"]               = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_em"]            = { METAHUD_LAYOUTPATH.."bg_21pp" , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_em"]            = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh"]               = { METAHUD_LAYOUTPATH.."bg_21pp" , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh"]               = { METAHUD_LAYOUTPATH.."bg_0"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_th"]               = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_th"]               = { METAHUD_LAYOUTPATH.."bg_2"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_em_th"]            = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_em_th"]            = { METAHUD_LAYOUTPATH.."bg_2"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_21pp" , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_1"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_th_tm"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_th_tm"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_21"   , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_th"]            = { METAHUD_LAYOUTPATH.."bg_2"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_em_th_tm"]         = { METAHUD_LAYOUTPATH.."bg_21p"  , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_em_th_tm"]         = { METAHUD_LAYOUTPATH.."bg_21"   , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_em_th"]         = { METAHUD_LAYOUTPATH.."bg_21pp" , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_em_th"]         = { METAHUD_LAYOUTPATH.."bg_2"    , 1 , 0 , 0 , 1 };
          texlayout["l_ph_pm_eh_em_th_tm"]      = { METAHUD_LAYOUTPATH.."bg_21pp" , 0 , 1 , 0 , 1 };
          texlayout["r_ph_pm_eh_em_th_tm"]      = { METAHUD_LAYOUTPATH.."bg_21"   , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_TargetElite"]      = { METAHUD_LAYOUTPATH.."elite"   , 1 , 0 , 0 , 1 };
          texlayout["MetaHud_TargetRare"]       = { METAHUD_LAYOUTPATH.."rare"    , 1 , 0 , 0 , 1 };

          ---  Frames
          framelayout["MetaHud_PlayerMana_Bar"]    = { "Bar"     , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , 0   , 0    , 128 , 256};
          framelayout["MetaHud_TargetHealth_Bar"]  = { "Bar"     , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 0   , 0    , 128 , 256};
          framelayout["MetaHud_PetMana_Bar"]       = { "Bar"     , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , 0   , 0    , 128 , 256};
          framelayout["MetaHud_PlayerHealth_Text"] = { "Text"    , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , 80  , -16  , 200 , 14 };
          framelayout["MetaHud_PlayerMana_Text"]   = { "Text"    , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , 95  , 2    , 200 , 14 };
          framelayout["MetaHud_TargetHealth_Text"] = { "Text"    , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , -80 , -16  , 200 , 14 };
          framelayout["MetaHud_TargetMana_Text"]   = { "Text"    , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , -95 , 2    , 200 , 14 };
          framelayout["MetaHud_PetHealth_Text"]    = { "Text"    , "BOTTOMLEFT", "MetaHud_LeftFrame"  , "BOTTOMLEFT", 130 , 36   , 200 , 14 };
          framelayout["MetaHud_PetMana_Text"]      = { "Text"    , "BOTTOMLEFT", "MetaHud_LeftFrame"  , "BOTTOMLEFT", 120 , 19   , 200 , 14 };
          framelayout["MetaHud_Combo1"]            = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , -4  , 0    , 20  , 20 };
          framelayout["MetaHud_Combo2"]            = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 3   , 20   , 20  , 20 };
          framelayout["MetaHud_Combo3"]            = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 8   , 40   , 20  , 20 };
          framelayout["MetaHud_Combo4"]            = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 11  , 60   , 20  , 20 };
          framelayout["MetaHud_Combo5"]            = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 13  , 80   , 20  , 20 };
          framelayout["MetaHud_HolyPower1"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , -4  , 0    , 20  , 20 };
          framelayout["MetaHud_HolyPower2"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 3   , 20   , 20  , 20 };
          framelayout["MetaHud_HolyPower3"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 8   , 40   , 20  , 20 };
          framelayout["MetaHud_HolyPower4"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 11  , 60   , 20  , 20 };
          framelayout["MetaHud_HolyPower5"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 13  , 80   , 20  , 20 };
          framelayout["MetaHud_SoulShard1"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , -4  , 0    , 20  , 20 };
          framelayout["MetaHud_SoulShard2"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 3   , 20   , 20  , 20 };
          framelayout["MetaHud_SoulShard3"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 8   , 40   , 20  , 20 };
          framelayout["MetaHud_SoulShard4"]        = { "Texture" , "BOTTOM"    , "MetaHud_RightFrame" , "BOTTOM"    , 11  , 60   , 20  , 20 };
          framelayout["MetaHud_PlayerResting"]     = { "Texture" , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , -2  , 0    , 22  , 22 };
          framelayout["MetaHud_PlayerAttacking"]   = { "Texture" , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , -2  , 0    , 22  , 22 };
          framelayout["MetaHud_PlayerPvP"]         = { "Texture" , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , -7  , 25   , 22  , 22 };
          framelayout["MetaHud_PlayerLeader"]      = { "Texture" , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , -13 , 50   , 22  , 22 };
          framelayout["MetaHud_PlayerLooter"]      = { "Texture" , "BOTTOM"    , "MetaHud_LeftFrame"  , "BOTTOM"    , -15 , 75   , 22  , 22 };
          --framelayout["MetaHud_PetHappy"]          = { "Texture" , "TOP"       , "MetaHud_LeftFrame"  , "TOP"       , 32  , -107 , 20  , 20 };
          framelayout["MetaHud_TargetElite"]       = { "Texture" , "TOP"       , "MetaHud_RightFrame" , "TOP"       , -18 , 20   , 64  , 64 };
     end
end
