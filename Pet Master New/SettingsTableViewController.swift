//
//  SettingsTableViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 29.07.2021.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var switchTimer: UISwitch!
    
    @IBOutlet weak var ExtendedMode: UISwitch!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func ModeChanged(_ sender: Any) {
        Settings.shared.currentSettings.extendedMode = self.ExtendedMode.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func ChangeTimerState(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadSettings()
    }
    
    @IBAction func resetSettings(_ sender: Any) {
        Settings.shared.resetSettings()
        loadSettings()
    }
    
    func loadSettings(){
        timeLabel.text = "\(Settings.shared.currentSettings.TimeForGame) сек"
        switchTimer.isOn = Settings.shared.currentSettings.timerState
        ExtendedMode.isOn = Settings.shared.currentSettings.extendedMode
    }
    
    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectTimeVC":
            if let VC = segue.destination as? SelectTimeViewController{
                VC.data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
            }
        default:
            break
        }
    }
    
}
