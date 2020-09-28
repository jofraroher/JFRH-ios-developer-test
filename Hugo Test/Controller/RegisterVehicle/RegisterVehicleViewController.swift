//
//  RegisterVehicleViewController.swift
//  Hugo Test
//
//  Created by Jose Francisco Rosales Hernandez on 28/09/20.
//  Copyright © 2020 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import RealmSwift

class RegisterVehicleViewController: UIViewController {
    
    @IBOutlet weak var plateNumberTxt: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var vehicleType: VehicleType?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        registerButton.isEnabled = false
        plateNumberTxt.becomeFirstResponder()
    }
    
    @IBAction func onRegisterVehicle(_ sender: UIButton) {
        saveVehicle()
    }
    
    private func saveVehicle() {
        let realm = try! Realm()
        let vehicle = VehicleModel(plateNumberTxt.text ?? "")
        if(vehicle.checkIfUserExist(vehicle.plateNumber)) {
            let alert = UIAlertController(title: "AVISO", message: "Existe un vehiculo en el estacionamiento con el número de placa que ingresaste.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else {
            vehicle.vehicleId = vehicle.incrementID()
            vehicle.type = vehicleType ?? VehicleType.none
            
            try! realm.write {
                realm.add(vehicle)
            }
            
            let alert = UIAlertController(title: "AVISO", message: "El vehiculo fue registrado exitosamente.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true)
        }
    }
}

extension RegisterVehicleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == plateNumberTxt {
            if string == "" {
                registerButton.isEnabled = false
                textField.deleteBackward()
            } else {
                registerButton.isEnabled = true
                textField.insertText(string.uppercased())
            }
            return false
        }

        return true
    }
}
