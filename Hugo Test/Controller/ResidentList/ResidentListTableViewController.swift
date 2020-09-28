//
//  ResidentListTableViewController.swift
//  Hugo Test
//
//  Created by Jose Francisco Rosales Hernandez on 28/09/20.
//  Copyright © 2020 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import RealmSwift

class ResidentListTableViewController: UITableViewController {

    var residentList: [ResidentVehicleModel] = []
    @IBOutlet weak var clearResidentList: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveList()
    }
    
    func retrieveList() {
        let realm = try! Realm()
        let residentListResult = realm.objects(ResidentVehicleModel.self)
        for resident in residentListResult {
            residentList.append(resident)
        }
        if(residentList.count == 0){
            clearResidentList.removeFromSuperview()
        }
        tableView.reloadData()
    }

    @IBAction func onStartMonth(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "AVISO", message: "¿Seguro que deseas comenzar un nuevo mes?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            let residentList = ResidentVehicleModel("")
            residentList.startNewMonth()
            self.navigationController?.popToRootViewController(animated: true)
        }))

        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(residentList.count == 0) {
            tableView.setEmptyView(title: "No hay vehículos de residentes", message: "Aquí se mostrara la lista de \n vehículos de residentes.")
        }
        return residentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResidentCell", for: indexPath) as! ResidentCell
        let resident = residentList[indexPath.row]
        cell.plateNumberTxt?.text = resident.plateNumber
        cell.parkingMinutesTxt?.text = "\(resident.minutes)"
        let calculateParkingAmonut = Double(resident.minutes) * 0.05
        cell.amountTxt?.text = String(format: "$ %.2f", calculateParkingAmonut)
        return cell
    }
}
