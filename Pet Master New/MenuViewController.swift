//
//  MenuViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 01.10.2021.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var PlayExButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var RecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        Design.SetupBaseButton(button: self.PlayButton)
        Design.SetupBaseButton(button: self.PlayExButton)
        Design.SetupBaseButton(button: SettingsButton)
        Design.SetupBaseButton(button: self.RecordButton)
    }
}
