//
//  transmitter.swift
//  NoTrust_Gadget
//
//  Created by Kenzie Nabeel on 04/10/24.
//

import CoreBluetooth

class transmitter: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var txCharacteristic: CBMutableCharacteristic?
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager){
        if peripheral.state == .poweredOn {
            startAdvertising()
        }
            
    }
    
    func startAdvertising(){
        let serviceUUID =  CBUUID(string: "522d268a-d7eb-441b-84f1-5f4e465ceedb")
        let characteristicUUID = CBUUID(string: "59e87c5e-4b70-4631-bc6c-a0d069f421c7")
        
        txCharacteristic = CBMutableCharacteristic(type: characteristicUUID, properties: [.read, .notify], value: nil, permissions: [.readable])
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [txCharacteristic!]
        
        peripheralManager?.add(service)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
    }
    
    func sendCommand(_ command: String){
        let data = command.data(using: .utf8)
        if let txCharacteristic = txCharacteristic {
            peripheralManager?.updateValue(data!, for: txCharacteristic, onSubscribedCentrals: nil)
        }
    }
}
