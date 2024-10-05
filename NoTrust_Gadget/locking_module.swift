//
//  locking_module.swift
//  NoTrust_Gadget
//
//  Created by Kenzie Nabeel on 24/09/24.
//

import CoreBluetooth

class locking_module{
    func lockMacbook(peripheral: CBPeripheral, characteristic: CBCharacteristic?){
        guard let characteristic = characteristic else { return }
        let data = "LOCK".data(using: .utf8)
        print("lock button taped")
        peripheral.writeValue(data!, for: characteristic, type: .withResponse)
    }
    
    func unlockMacbook(peripheral: CBPeripheral, characteristic: CBCharacteristic?){
        guard let characteristic = characteristic else { return }
        let data = "UNLOCK".data(using: .utf8)
        peripheral.writeValue(data!, for: characteristic, type: .withResponse)
    }
    
    func disableAutolock(peripheral: CBPeripheral, characteristic: CBCharacteristic?){
        guard let characteristic = characteristic else { return }
        let data = "AUTOLOCK OFF".data(using: .utf8)
        peripheral.writeValue(data!, for: characteristic, type: .withResponse)
    }
    
    func enableAutolock(peripheral: CBPeripheral, characteristic: CBCharacteristic?){
        guard let characteristic = characteristic else { return }
        let data = "AUTOLOCK ON".data(using: .utf8)
        peripheral.writeValue(data!, for: characteristic, type: .withResponse)
    }
}
