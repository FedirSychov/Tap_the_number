//
//  SelectTimeViewController.swift
//  Pet Master New
//
//  Created by Fedor Sychev on 29.07.2021.
//

import UIKit

class SelectTimeViewController: UIViewController {

    var data:[Int] = []
    
    @IBOutlet weak var TableView: UITableView!{
        didSet{
            TableView?.dataSource = self
            TableView?.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

//Реализация протокола
extension SelectTimeViewController: UITableViewDataSource, UITableViewDelegate{

    //Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data.count
    }
    
    //Указать какие будут ячейки. Нужно создать шаблон, по которому будут создаваться ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
        
        Settings.shared.currentSettings.TimeForGame = data[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
}
