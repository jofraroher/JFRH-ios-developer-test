//
//  ExitVehicleViewController.swift
//  Hugo Test
//
//  Created by Jose Francisco Rosales Hernandez on 28/09/20.
//  Copyright © 2020 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import RealmSwift

class ExitVehicleViewController: UIViewController {

    @IBOutlet weak var plateNumberTxt: UITextField!
    @IBOutlet weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        exitButton.isEnabled = false
        plateNumberTxt.becomeFirstResponder()
    }
    
    @IBAction func onExitVehicle(_ sender: UIButton) {
        exitVehicle()
    }
    
    private func exitVehicle() {
        //let realm = try! Realm()
        let vehicle = VehicleModel(plateNumberTxt.text ?? "")
        if(vehicle.checkIfUserExist(vehicle.plateNumber)) {
            let vehicleDetail = vehicle.retrieveVehicle(vehicle.plateNumber)
            if let vehicle = vehicleDetail {
                validateVehicleType(vehicleType: vehicle.type, vehicle)
            }
        }else {
            showMessage(title: "AVISO", message: "No se encontró ningún vehiculo con el número de placa ingresado.")
        }
    }
    
    func validateVehicleType(vehicleType: VehicleType, _ vehicle: VehicleModel) {
        switch vehicleType {
        case VehicleType.offitial:
            vehicle.deleteVehicle(vehicle)
            showMessage(title: "AVISO", message: "Se registro la salida del vehiculo oficial exitosamente.")
        case VehicleType.resident:
            let residentModel = ResidentVehicleModel(vehicle.plateNumber)
            if(residentModel.checkIfResidentVehicleExist(vehicle.plateNumber)) {
                let residentVehicleDetail = residentModel.retrieveResidentVehicle(vehicle.plateNumber)
                if let residentVehicle = residentVehicleDetail {
                    let addMinutes = residentVehicle.minutes + calculateMinutes(vehicle.timeIn)
                    let timeInVehicule = vehicle.timeIn
                    residentVehicle.updateResidentVehicule(residentVehicle.vehicleId, minutes: addMinutes)
                    vehicle.deleteVehicle(vehicle)
                    showMessage(title: "AVISO", message: "Se registro la salida del vehiculo residente exitosamente. \n El total de minutos que duro en el estacionamiento fue de \(calculateMinutes(timeInVehicule)) min \n y el total de minutos en el mes es de \(addMinutes) min.")
                }
            }else {
                residentModel.vehicleId = residentModel.incrementID()
                residentModel.plateNumber = vehicle.plateNumber
                residentModel.minutes = calculateMinutes(vehicle.timeIn)
                registerResident(residentModel)
                vehicle.deleteVehicle(vehicle)
                showMessage(title: "AVISO", message: "Se registro la salida del vehiculo residente exitosamente. \n El total de minutos que duro en el estacionamiento fue de \(residentModel.minutes) min \n y el total de minutos en el mes es de \(residentModel.minutes) min.")
            }
        case VehicleType.outsider:
            let minutes = calculateMinutes(vehicle.timeIn)
            let cost = calculateCost(minutes)
            vehicle.deleteVehicle(vehicle)
            showMessage(title: "AVISO", message: "Se registro la salida del vehiculo no residente exitosamente. \n El total de minutos que duro en el estacionamiento fue de \(minutes) min \n con un costo total de $\(cost)")
        default:
            print("")
        }
    }
    
    func registerResident(_ residentModel: ResidentVehicleModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(residentModel)
        }
    }
    
    func calculateMinutes(_ timeIn: NSDate) -> Int {
        guard let date = timeIn as Date? else {
            return 0
        }
        // Calculate the actual DateTime
        let elapsed = Date().timeIntervalSince(date)
        // Truncate Duration
        let duration = Int(elapsed)
        // Total Minutes
        return duration / 60
    }
    
    func calculateCost(_ minutes: Int) -> Double{
        return Double(minutes) * 0.5
    }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ExitVehicleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == plateNumberTxt {
            if string == "" {
                exitButton.isEnabled = false
                textField.deleteBackward()
            } else {
                exitButton.isEnabled = true
                textField.insertText(string.uppercased())
            }
            return false
        }

        return true
    }
}
