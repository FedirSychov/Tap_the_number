//
//  RecordViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 02.08.2021.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var extRecordLabel: UILabel!
    @IBOutlet weak var ResetRecordButton: UIButton!
    
    @IBAction func CloseVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Design.SetupBaseButton(button: self.ResetRecordButton)

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        
        if record != 0{
            recordLabel.text = "\(NSLocalizedString("record", comment: ""))\(record) \(NSLocalizedString("sec", comment: ""))"
        } else{
            recordLabel.text = "\(NSLocalizedString("no_record", comment: ""))"
        }
        
        let recordExt = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordExtGame)
        
        if recordExt != 0{
            extRecordLabel.text = "\(NSLocalizedString("record", comment: ""))\(recordExt) \(NSLocalizedString("sec", comment: ""))"
        } else{
            extRecordLabel.text = "\(NSLocalizedString("no_record", comment: ""))"
        }
    }
    
    @IBAction func ResetRecord(_ sender: Any) {
        Design.SetupBaseButton(button: self.ResetRecordButton)
        
        UserDefaults.standard.setValue(0, forKey: KeysUserDefaults.recordGame)
        UserDefaults.standard.setValue(0, forKey: KeysUserDefaults.recordExtGame)
        
        self.viewDidLoad()
    }
    
}
