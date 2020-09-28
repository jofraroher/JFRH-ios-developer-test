//
//  VehicleModel.swift
//  Hugo Test
//
//  Created by Jose Francisco Rosales Hernandez on 27/09/20.
//  Copyright © 2020 Jose Francisco Rosales Hernandez. All rights reserved.
//

import Foundation
import RealmSwift

enum VehicleType: Int {
    case offitial
    case resident
    case outsider
    case none
}

class VehicleModel: Object {
    
    @objc dynamic var vehicleId = 0
    @objc dynamic var plateNumber = ""
    @objc private dynamic var vehicleType: Int = VehicleType.none.rawValue
    @objc dynamic var timeIn = NSDate()
    
    var type: VehicleType {
        get { return VehicleType(rawValue: vehicleType)! }
        set { vehicleType = newValue.rawValue }
    }
    
    override class func indexedProperties() -> [String] {
        return ["vehicleId", "plateNumber"]
    }
    
    override class func primaryKey() -> String? {
        return "vehicleId"
    }
    
    func incrementID() -> Int{
        let realm = try! Realm()
        return (realm.objects(VehicleModel.self).max(ofProperty: "vehicleId") as Int? ?? 0) + 1
    }
    
    func checkIfUserExist(_ plateNumber: String) -> Bool {
        let realm = try! Realm()
        let checkIfUserExist = realm.objects(VehicleModel.self).filter("plateNumber == '\(plateNumber)'").sorted(byKeyPath: "plateNumber")
        return checkIfUserExist.count > 0
    }
    
    func retrieveVehicle(_ plateNumber: String) -> VehicleModel? {
        let realm = try! Realm()
        let vehicle = realm.objects(VehicleModel.self).filter("plateNumber == '\(plateNumber)'").sorted(byKeyPath: "plateNumber").first
        return vehicle
    }
    
    func deleteVehicle(_ vehicle: VehicleModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(vehicle)
        }
    }
    
    convenience init(_ plateNumber: String) {
        self.init()
        self.plateNumber = plateNumber
    }
    
}
