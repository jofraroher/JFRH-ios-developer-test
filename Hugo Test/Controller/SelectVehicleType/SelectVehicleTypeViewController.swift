//
//  SelectVehicleTypeViewController.swift
//  Hugo Test
//
//  Created by Jose Francisco Rosales Hernandez on 28/09/20.
//  Copyright © 2020 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit

class SelectVehicleTypeViewController: UIViewController {

    var vehicleTypeSelect: VehicleType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSelectedVehicleType(_ sender: UIButton) {
        switch sender.tag {
        case VehicleType.offitial.rawValue:
                vehicleTypeSelect = VehicleType.offitial
        case VehicleType.resident.rawValue:
                vehicleTypeSelect = VehicleType.resident
        case VehicleType.outsider.rawValue:
                vehicleTypeSelect = VehicleType.outsider
        default:
            vehicleTypeSelect = VehicleType.none
        }
        showRegisterVehicle()
    }
    
    func showRegisterVehicle() {
        performSegue(withIdentifier: "registerVehicle", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerVehicle" {
            let registerVehicleController = segue.destination as! RegisterVehicleViewController
            registerVehicleController.vehicleType = vehicleTypeSelect
        }
    }
}
