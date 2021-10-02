//
//  RecordViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 02.08.2021.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    @IBAction func CloseVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        
        if record != 0{
            recordLabel.text = "Ваш рекорд - \(record)"
        } else{
            recordLabel.text = "Рекорд не установлен"
        }
    }
    
}
