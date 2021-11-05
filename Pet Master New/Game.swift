//
//  Game.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 19.07.2021.
//

import Foundation
import UIKit

enum StatusGame{
    case start
    case win
    case loose
}

class Game{
    
    struct Item{
        var title: String
        var isFound: Bool = false
        var isError = false
    }
    
    private let data = Array(1...99)
    
    var items:[Item] = []
    
    private var countItems: Int
    
    var nextItem: Item?
    
    var isNewRecord: Bool = false
    
    var status: StatusGame = .start{
        didSet{
            if status != .start && Settings.shared.currentSettings.timerState{
                if status == .win{
                    let newRecord = TimeForGame - SecondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    let recordExt = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordExtGame)
                    
                    if Settings.shared.currentSettings.extendedMode {
                        if recordExt == 0 || recordExt > newRecord{
                            UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.recordExtGame)
                            isNewRecord = true
                        }
                    } else {
                        if record == 0 || record > newRecord{
                            UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.recordGame)
                            isNewRecord = true
                        }
                    }
                }
                stopGame()
            }
        }
    }
    private var TimeForGame: Int
    
    private var SecondsGame: Int{
        didSet{
            if SecondsGame == 0{
                status = .loose
            }
            updateTimer(status, SecondsGame)
        }
    }
    
    private var timer: Timer?
    private var updateTimer:((StatusGame, Int) -> Void)
    
    init(countitems: Int, updateTimer: @escaping (_ status: StatusGame, _ seconds: Int) -> Void) {
        self.countItems = countitems
        self.TimeForGame = Settings.shared.currentSettings.TimeForGame
        self.SecondsGame = self.TimeForGame
        self.updateTimer = updateTimer
        if Settings.shared.currentSettings.extendedMode {
            setupGame()
        } else {
            setupGame2()
        }
    }
    
    func setupGame(){
        isNewRecord = false
        
        var digits = data.shuffled()
        
        items.removeAll()
        while items.count < countItems{
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        
        nextItem = items.randomElement()
        
        updateTimer(status, SecondsGame)
        if Settings.shared.currentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](_) in
                self?.SecondsGame -= 1
            })
        }
        
    }
    
    func setupGame2(){
        isNewRecord = false
        
        var digits = data
        
        items.removeAll()
        while items.count < countItems{
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        
        nextItem = items[0]
        
        updateTimer(status, SecondsGame)
        if Settings.shared.currentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](_) in
                self?.SecondsGame -= 1
            })
        }
        
    }
    
    func NewGame(){
        status = .start
        self.SecondsGame = TimeForGame
        setupGame()
    }
    
    func NewGame2(){
        status = .start
        self.SecondsGame = TimeForGame
        setupGame2()
    }
    
    func findItem(item: Int) -> Int {
        var i: Int = 0
        for j in items {
            if j.title == String(item) {
                return i
            } else {
                i += 1
            }
        }
        return 0
    }
    
    func check(index: Int){
            guard status == .start else {return}
            
            if items[index].title == nextItem?.title{
                items[index].isFound = true
                
            nextItem = items.shuffled().first(where: {(item) -> Bool in item.isFound == false})
                
            } else {
                items[index].isError = true
            }
            
            if nextItem == nil{
                status = .win
            }
        }
    
    func check2(index: Int) -> Bool {
        guard status == .start else {return false}
        var result: Bool
        //if items[index].title == nextItem?.title{

        if String(index) == nextItem?.title{
            result = true
            items[findItem(item: index)].isFound = true
            //TODO: - Change this
            nextItem = items.first(where: {(item) -> Bool in item.isFound == false})
            //nextItem = items.shuffled().first(where: {(item) -> Bool in item.isFound == false})
            
        } else {
            result = false
            items[findItem(item: index)].isError = true
        }
        
        if nextItem == nil{
            status = .win
        }
        return result
    }
    
    func stopGame(){
        timer?.invalidate()
    }
    
}


extension Int{
    func secondsToString() -> String{
        let minutes = self / 60
        let seconds = self % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
