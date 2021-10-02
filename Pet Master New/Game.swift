//
//  Game.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 19.07.2021.
//

import Foundation

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
            if status != .start{
                if status == .win{
                    let newRecord = TimeForGame - SecondsGame
                    
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    if record == 0 || record > newRecord{
                        UserDefaults.standard.setValue(newRecord, forKey: KeysUserDefaults.recordGame)
                        isNewRecord = true
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
        setupGame()
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
    
    func NewGame(){
        status = .start
        self.SecondsGame = TimeForGame
        setupGame()
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
