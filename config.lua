Config = {}

Config.Locale = 'en'

Config.Debug = false

Config.MSG = function(msg)
    ESX.ShowNotification(msg) 
end

Config.ProgressBar = function(text, time)
    exports["esx_progressbar"]:Progressbar(text, time,{
        FreezePlayer = false, 
        animation ={
            type = "",
            dict = "", 
            lib =""
        },
        onFinish = function()
    end})
end

Config.AfterBloodtransfusion = function()
    --SetEntityHealth(PlayerPedId(), 100) | this is a Example. You can add some more functions for your Scripts after a Blood transfusion
end

Config.JobForMenu = 'ambulance' -- If you use the Blood Packs, you will get a Menu to give closestplayer the blood or yourself (Only the Job)

Config.WrongBlood = true -- if true you can use wrong type of blood but you will get passed out after a few minutes

Config.PayFee = true -- Pay Fee for asking for Bloodtype or doing the Test at the NPC / If false you have to edit the Translation!

Config.NeededItem = 'syringe' -- If you take Blood from somebody else he will need this Item too / set to nil if you dont want this

Config.StationToggle = true -- Enable / Disable Station to interact if someone has no Bloodtype yet
Config.Station = {
    {
        coords = vector4(296.1379, -591.3516, 43.2757, 72.5051), -- Where the NPC should stand
        pedname = 's_m_m_doctor_01', -- Pedname
        sitcoords = vector4(295.0022, -593.3331, 43.2554, 68.6172), -- Where the Player should sit if you do the Bloodtest (will tp)
    }
}

Translation = {
    ['de'] = {
        ['bloodgroup'] = 'Du hast Blutgruppe',
        ['press_e'] = 'Drücke ~p~[E]~w~ um deine Blutgruppe abzufragen ~w~(Gebühr ~g~50$~w~)',
        ['press_g'] = 'Drücke ~p~[G]~w~ um deine Blutgruppe zu testen ~w~(Gebühr ~g~500$~w~)',
        ['already_busy'] = 'Du bekommst bereits eine Bluttransfusion',
        ['no_player_nearby'] = 'Kein Spieler in der Nähe',
        ['you_get_Blood_transfusion'] = 'Dir wird eine Bluttransfusion gelegt',
        ['blood_took_successfull'] = 'Du hast erfolgreich Blut abgenommen',
        ['your_dizzy'] = 'Du bist etwas benommen.',
        ['go_to_doc'] = 'Frage deine Blutgruppe am besten beim Arzt an',
        ['blood_transfusion_success'] = 'Bluttransfusion abgeschlossen',
        ['youre_not_good'] = 'Dir geht es nicht gut',
        ['youre_getting_weaker'] = 'Du wirst schwächer',
        ['cant_walk'] = 'Du kannst nicht mehr richtig laufen',
        ['you_died'] = 'Du bist durch die falsche Bluttransfusion in Ohnmacht gefallen',
        ['blood_not_compatible'] = 'Diese Blutgruppe ist nicht mit deiner Kompatibel',
        ['bloodgroup_not_avaiable'] = 'Deine Blutgruppe wurde noch nicht untersucht',
        ['already_have_bloodtype'] = 'Du hast bereits deine Blutgruppe getestet',
        ['Blood_menu_title'] = 'Bluttransfusion',
        ['give_player'] = 'Spieler verabreichen',
        ['give_self'] = 'Selber verabreichen',
        ['blood_will_be_taken'] = 'Blut wird abgenommen...',
        ['blood_transfusion_started'] = 'Bluttransfusion wird durchgeführt...',
        ['received_blootype'] = 'Du hast ein Bluttyp zugewiesen bekommen',
        ['bloodtype_target'] = 'Die Person hat Blutgruppe',
        ['item_got_nil'] = 'Es ist ein Fehler aufgetreten',
        ['you_took_blood'] = 'Du hast erfolgreich Blut abgenommen. Blutgruppe',
        ['do_not_have_syringe'] = 'Du brauchst eine Spritze dafür',
        ['do_not_have_syringe'] = 'Du brauchst eine Spritze dafür',
        ['you_deleted_your_bloodtype'] = 'Du hast deine Blutgruppe gelöscht',
        ['no_bloodtype_in_sql'] = 'Es gibt keinen Eintrag in der Datenbank',
        ['giving_blood_transfusion'] = 'Du gibst der Person vor dir eine Bluttransfusion',
        ['blipname'] = 'Blutbank',
        ['has_to_test_blood'] = 'Der Spieler muss erst noch sein Blut testen gehen'
    },

    ['en'] = {
        ['bloodgroup'] = 'Your Bloodtype is',
        ['press_e'] = 'Press ~p~[E]~w~ to ask for your Bloodtype ~w~(Pay ~g~50$~w~)',
        ['press_g'] = 'Press ~p~[G]~w~ to test your Bloodtype ~w~(Pay ~g~500$~w~)',
        ['already_busy'] = 'You already get a Blood transfusion',
        ['no_player_nearby'] = 'No Player nearby',
        ['you_get_Blood_transfusion'] = 'Youre getting a Blood transfusion',
        ['blood_took_successfull'] = 'You have successfully drawn blood',
        ['your_dizzy'] = 'Youre feeling a little dizzy.',
        ['go_to_doc'] = 'ask your doctor about your blood type',
        ['blood_transfusion_success'] = 'Blood transfusion completed',
        ['youre_not_good'] = 'You are not feeling well',
        ['youre_getting_weaker'] = 'Youre getting weaker',
        ['cant_walk'] = 'You cant walk properly anymore',
        ['you_died'] = 'You fell unconscious from the wrong blood transfusion',
        ['blood_not_compatible'] = 'This blood type is not compatible with yours',
        ['bloodgroup_not_avaiable'] = 'Your blood type has not been tested yet',
        ['already_have_bloodtype'] = 'You have already tested your blood type',
        ['Blood_menu_title'] = 'Blood transfusion',
        ['give_player'] = 'Give Player',
        ['give_self'] = 'Give Self',
        ['blood_will_be_taken'] = 'Blood is drawn...',
        ['blood_transfusion_started'] = 'Blood transfusion in progress...',
        ['received_blootype'] = 'You have been assigned a blood type',
        ['bloodtype_target'] = 'The person has blood type',
        ['item_got_nil'] = 'An error has occurred',
        ['you_took_blood'] = 'You have successfully drawn blood. blood type',
        ['do_not_have_syringe'] = 'You need a syringe for it',
        ['you_deleted_your_bloodtype'] = 'You deleted your Bloodtype',
        ['no_bloodtype_in_sql'] = 'Theres no assigned Bloodtype in the Database',
        ['giving_blood_transfusion'] = 'You give the closest Person a Blood transfusion',
        ['blipname'] = 'Bloodbank',
        ['has_to_test_blood'] = 'The Player has to test his Bloodtype first'
    },

}
