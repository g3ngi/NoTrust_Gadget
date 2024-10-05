//
//  Bluetooth_connection.swift
//  NoTrust_Gadget
//
//  Created by Kenzie Nabeel on 18/09/24.
//

// panggil Bluetooth_scanner trus parse data macbook dan ambil service sm characteristic uuid

import CoreBluetooth
import UIKit

class Bluetooth_module: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @Published var macConnected = false  // Track connection status
    var macPeripheral: CBPeripheral?
    var macCharacteristics: CBCharacteristic?
    
    var centralManager: CBCentralManager?
    var onPeripheralDiscovered: ((CBPeripheral) -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Start scanning for peripherals
    func startScanning() {
        guard centralManager?.state == .poweredOn else {
            print("Cannot start scanning. Bluetooth is not powered on.")
            return
        }
        print("Started scanning for peripherals...")
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // Stop scanning for peripherals
    func stopScanning() {
        centralManager?.stopScan()
        print("Stopped scanning for peripherals.")
    }
    
    func disconnect(){
        print("Disconnecting from \(String(describing: macPeripheral))")
        centralManager?.cancelPeripheralConnection(macPeripheral!)
        macConnected = false
    }
    
    // Connect to a discovered device
    func connectToDevice(_ peripheral: CBPeripheral) {
        stopScanning()
        centralManager?.connect(peripheral, options: nil)
        macPeripheral = peripheral
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    
    // Handle state changes in Bluetooth
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on. Ready to scan.")
        case .poweredOff:
            print("Bluetooth is off. Please enable Bluetooth.")
        default:
            print("Bluetooth state: \(central.state.rawValue)")
        }
    }
    
    // Called when a peripheral is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown")")
        
        print(peripheral.name ?? "Unkown")
        if peripheral.name == "Kenzie’s MacBook Pro" {
            print("Found \(peripheral.name!). Connecting...")
            connectToDevice(peripheral)
        }
        
        // Optional: Use callback to notify about the discovery
        onPeripheralDiscovered?(peripheral)
    }
    
    // Called when a peripheral connects
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown"). Discovering services...")
        macConnected = true
        peripheral.delegate = self
        peripheral.discoverServices(nil)  // Discover all services
    }
    
    // MARK: - CBPeripheralDelegate Methods
    
    // Called when services are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)  // Discover all characteristics
        }
    }
    
    // Called when characteristics are discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            // Store the first characteristic found (or add logic to select a specific one)
            self.macCharacteristics = characteristic
        }
    }
}
