//
//  Settings.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 29.07.2021.
//

import Foundation

enum KeysUserDefaults{
    static let settingsGame = "SettingsGame"
    static let recordGame = "RecordGame"
    static let recordExtGame = "RecordExtGame"
}

struct SettingsGame: Codable{
    var timerState: Bool
    var TimeForGame: Int
    var extendedMode: Bool
}

class Settings{
    static var shared = Settings()
    
    private let defaultSettings = SettingsGame(timerState: true, TimeForGame: 30, extendedMode: false)
    
    var currentSettings: SettingsGame{
        get{
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsGame) as? Data{
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            }
            else{
                if let data = try? PropertyListEncoder().encode(defaultSettings){
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
                }
                return defaultSettings
            }
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsGame)
            }
        }
    }
    
    func resetSettings(){
        currentSettings = defaultSettings
    }
}
