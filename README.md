# Phoenix Bloodtypes System

**A new Roleplay Experience**
![glow](https://github.com/Ph-o-e-n-ix/phoenix_policetraining/assets/119653707/a515ecb3-9596-4f81-a616-4cfc97c688db)

[<img alt="alt_text"  src="https://i.imgur.com/yRsZ96F.png" />](https://discord.gg/CUXK7CWx3P)

<h1> PHOENIX STUDIOS </h1>

Hey Guys im releasing my new Script. I hope youre Guys enjoying. 
If you have any Questions, feel free to ask me on my Discord (Via Ticket)
 
-------------------------------------------------------------------

Features:
* Station for getting your Bloodtype
* Bloodtype saved in Database
* All img/sql included. just copy/paste
* Usable Items to do Blood transfusion
* Take Blood as a Doctor (and get the Bloodtype from the Player)
-> use empty bloodbag to fill it up with the blood the Player has
* If you use wrong Blood you will be unconscious after a time
-> compatible & not compatible Blood
* Easy Notify/Progressbar integration
* Use Exports to set/get Bloodtype (easy add in another Scripts)

-------------------------------------------------------------------
#CLIENT EXPORTS 
```
exports["phoenix_bloodtypes"]:setbloodtype()
exports["phoenix_bloodtypes"]:setbloodtype('AB+')

exports["phoenix_bloodtypes"]:callbloodtype()
exports["phoenix_bloodtypes"]:callbloodtypetarget(targetplayer)
exports["phoenix_bloodtypes"]:deletebloodtype()
```

-------------------------------------------------------------------

Examples:
```
RegisterCommand("setbloodtype", function()
    exports["phoenix_bloodtypes"]:setbloodtype()
end)
```
```
RegisterCommand("getbloodtype", function()
    local bloodtype = exports["phoenix_bloodtypes"]:callbloodtype() 
    print(bloodtype)
end)
```
```
RegisterCommand("targetbloodtype", function()
    local targetplayer, distance = ESX.Game.GetClosestPlayer()
    local targetid = GetPlayerServerId(targetplayer)
    if distance < 3 then 
        local bloodtype = exports["phoenix_bloodtypes"]:callbloodtypetarget(targetplayer)
        print(bloodtype)
    end
end)
```
```
RegisterCommand("getbloodtype", function()
    exports["phoenix_bloodtypes"]:deletebloodtype()
    --Database Entry from player will be deleted
end)
```
-------------------------------------------------------------------
