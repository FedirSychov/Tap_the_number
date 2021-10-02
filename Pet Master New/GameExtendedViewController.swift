//
//  GameViewControlletViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 19.07.2021.
//

import UIKit

class GameExtendedViewController: UIViewController {
    
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func NewGame(_ sender: UIButton) {
        game.NewGame()
        sender.isEnabled = false
        sender.alpha = 0
        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
        game.check(index: buttonIndex)
        
        updateUI()
    }

    private func setupScreen(){
        for item in buttons {
            Design.SetupPlayButton(button: item)
        }
        
        //game.setupGame()
        var tempArr: [Int] = []
        for i in 0...game.items.count - 1 {
            tempArr.append(i)
        }

        for index in game.items.indices{
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        nextDigit.text = game.nextItem?.title
    }
    
    private func setupScreenBase() {
        
    }
    
    private func updateUI(){
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
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            if game.isNewRecord{
                showAlertActionSheet()
            }
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
            self?.game.NewGame()
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
