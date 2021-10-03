//
//  GameViewControlletViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 19.07.2021.
//

import UIKit

class GameViewControlletViewController: UIViewController {
    
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    static var indecesArr: [Int] = []
    
    @IBAction func NewGame(_ sender: UIButton) {
        if Settings.shared.currentSettings.extendedMode {
            game.NewGame()
        } else {
            game.NewGame2()
            GameViewControlletViewController.indecesArr = []
        }
        sender.isEnabled = false
        sender.alpha = 0
        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        GameViewControlletViewController.indecesArr = []
        game.stopGame()
    }
    
    lazy var game = Game(countitems: buttons.count) {[weak self](status, time) in
        guard let self = self else {return}
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        Design.SetupBaseButton(button: self.newGameButton)
    }
    
    @IBAction func press_button_1(_ sender: UIButton) {
        
        if Settings.shared.currentSettings.extendedMode {
            guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
                    game.check(index: buttonIndex)
        } else {
            let isRight = game.check2(index: Int(sender.titleLabel!.text!)!)
            
            if isRight {
                sender.alpha = 0
            }
        }
        
        updateUI()
    }

    private func setupScreen(){
        for item in buttons {
            Design.SetupPlayButton(button: item)
            item.alpha = 1
        }

        if Settings.shared.currentSettings.extendedMode {
            for index in game.items.indices{
                buttons[index].setTitle(game.items[index].title, for: .normal)
                buttons[index].alpha = 1
                buttons[index].isEnabled = true
            }
            nextDigit.text = game.nextItem?.title
        } else {
            for index in game.items.indices {
                GameViewControlletViewController.indecesArr.append(index)
            }
            GameViewControlletViewController.indecesArr.shuffle()
            
            for index in 0...15{
                buttons[index].setTitle(game.items[GameViewControlletViewController.indecesArr[index]].title, for: .normal)
                buttons[index].isEnabled = true
            }
            nextDigit.text = game.nextItem?.title
        }
    }
    
    private func findButton(index: Int) -> Int {
        var i: Int = 0
        for j in self.buttons {
            if j.titleLabel!.text! == String(index) {
                return i
            } else {
                i += 1
            }
        }
        return 0
    }
    
    private func updateUI(){
        if Settings.shared.currentSettings.extendedMode {
            for index in game.items.indices{
                        //buttons[index].isHidden = game.items[index].isFound
                        buttons[index].alpha = game.items[index].isFound ? 0 : 1
                        buttons[index].isEnabled = !game.items[index].isFound
                        if game.items[index].isError{
                            UIView.animate(withDuration: 0.3) { [weak self] in
                                self?.buttons[index].backgroundColor = .red
                            } completion: { [weak self](_) in
                                self?.buttons[index].backgroundColor = .white
                                self?.game.items[index].isError = false
                            }

                        }
                    }
        } else {
            for index in game.items.indices{
                let tempIndex = findButton(index: index)
                buttons[tempIndex].isEnabled = !game.items[index].isFound
                if game.items[index].isError{
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.buttons[tempIndex].backgroundColor = .red
                    } completion: { [weak self](_) in
                        self?.buttons[tempIndex].backgroundColor = UIColor(red: 255/255, green: 125/255, blue: 50/255, alpha: 1)
                        self?.game.items[index].isError = false
                    }

                }
            }
        }
        
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame){
        switch status {
        case .start:
            statusLabel.text = "Игра началась"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Вы победили!"
            statusLabel.textColor = .black
            newGameButton.isHidden = false
            showAlertActionSheet()
        case .loose:
            statusLabel.text = "Вы проиграли!"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    private func showAlert(){
        
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы установили новый рекорд", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    private func showAlertActionSheet(){
        let alert = UIAlertController(title: "Что вы хотите сделать?", message: nil, preferredStyle: .actionSheet)
        
        let newGameActoin = UIAlertAction(title: "Начать новую игру", style: .default) { [weak self] (_) in
            self?.game.NewGame2()
            GameViewControlletViewController.indecesArr = []
            self?.setupScreen()
        }
        
        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default) { [weak self](_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelActrion = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(newGameActoin)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelActrion)
        
        present(alert, animated: true, completion: nil)
    }
    
}
