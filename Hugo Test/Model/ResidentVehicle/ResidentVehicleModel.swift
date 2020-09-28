//
//  ResidentVehicleModel.swift
//  Hugo Test
//
//  Created by Jose Francisco Rosales Hernandez on 28/09/20.
//  Copyright © 2020 Jose Francisco Rosales Hernandez. All rights reserved.
//

import Foundation
import RealmSwift

class ResidentVehicleModel: Object {
    
    @objc dynamic var vehicleId = 0
    @objc dynamic var plateNumber = ""
    @objc dynamic var minutes = 0
    
    override class func indexedProperties() -> [String] {
        return ["vehicleId", "plateNumber"]
    }
    
    override class func primaryKey() -> String? {
        return "vehicleId"
    }
    
    func incrementID() -> Int{
        let realm = try! Realm()
        return (realm.objects(ResidentVehicleModel.self).max(ofProperty: "vehicleId") as Int? ?? 0) + 1
    }
    
    func checkIfResidentVehicleExist(_ plateNumber: String) -> Bool {
        let realm = try! Realm()
        let checkIfUserExist = realm.objects(ResidentVehicleModel.self).filter("plateNumber == '\(plateNumber)'").sorted(byKeyPath: "plateNumber")
        return checkIfUserExist.count > 0
    }
    
    func retrieveResidentVehicle(_ plateNumber: String) -> ResidentVehicleModel? {
        let realm = try! Realm()
        let vehicle = realm.objects(ResidentVehicleModel.self).filter("plateNumber == '\(plateNumber)'").sorted(byKeyPath: "plateNumber").first
        return vehicle
    }
    
    func updateResidentVehicule(_ primaryKey: Int, minutes: Int) {
        let realm = try! Realm()
        let residentVehicule = realm.object(ofType: ResidentVehicleModel.self, forPrimaryKey: primaryKey)
        try! realm.write {
            residentVehicule?.minutes = minutes
        }
    }
    
    func startNewMonth() {
        let realm = try! Realm()
        try! realm.write {
            let getAllResidentVehicles = realm.objects(ResidentVehicleModel.self)
            realm.delete(getAllResidentVehicles)
        }
    }
    
    convenience init(_ plateNumber: String) {
        self.init()
        self.plateNumber = plateNumber
    }
    
}
