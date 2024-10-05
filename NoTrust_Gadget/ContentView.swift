//
//  ContentView.swift
//  NoTrust_Gadget
//
//  Created by Kenzie Nabeel on 17/09/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var bluetoothModule = Bluetooth_module()
    @State private var didTap:Bool = false
    var lock = locking_module()
    var Transmitter = transmitter()
    
    var body: some View {
        ZStack{
            Color(hex: "#FAFAFA")
                .edgesIgnoringSafeArea(.all)
            
            Text("NoTrust - Gadget")
                .font(.title)
                .foregroundColor(.black)
    //            .frame(maxWidth: 250, maxHeight: 100, alignment: .center)
    //            .position(x: 200, y: -120)
                .padding(.top, -370)
            
            HStack{
                circleIconView(iconName: "laptop-2", label: "Device:", xPos: 100, yPos: -50)
                circleIconView(iconName: "signal1", label: "RSSI:", xPos: 100, yPos: -50)
            }
            .padding(.top, 220)
            
            
            Text("Controls")
                .font(.system(size: 20))
    //            .fontWeight(.bold)
                .padding(.top, -20)
            
            
            VStack{
                HStack(){
                    if !bluetoothModule.macConnected {
                        controlButtonView(iconName: "connected3", label: "Connect Device"){
                            bluetoothModule.startScanning()
                        }
                            .position(x: 100, y: 260)
                               
                    } else {
                        controlButtonView(iconName: "connected3", label: "Disconnect Device") {
                            bluetoothModule.disconnect()
                        }
                            .position(x: 100, y: 260)
                    }
                    
                    if didTap {
                        controlButtonView(iconName: "unnamed.webp", label: "Autolock: OFF"){
                            Transmitter.sendCommand("AUTOLOCK ON")
                        }
                            .position(x: 100, y: 260)
                            
                    } else{
                        controlButtonView(iconName: "unnamed.webp", label: "Autolock: OFF") {
                            Transmitter.sendCommand("AUTOLOCK OFF")
                        }
                        .position(x: 100, y: 260)
                    }
                }
                .padding(.top, 250)
        }
            VStack{
                HStack{
                    controlButtonView(iconName: "locked-icon", label: "Lock Device"){
                        Transmitter.sendCommand("LOCK")
                    }
                        .position(x: 100, y: 100)
                    
                    controlButtonView(iconName: "unlock-icon", label: "Unlock Device"){
                        Transmitter.sendCommand("UNLOCK")
                    }
                        .position(x: 100, y: 100)
                }
                .padding(.top, 580)
                }
            }
        }
    }

struct circleIconView: View {
    var iconName: String
    var label: String
    var xPos: CGFloat
    var yPos: CGFloat
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .stroke(Color(hex: "#939298").opacity(0.3), lineWidth: 4)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 1)
                    .frame(width:200, height:100)
                    .position(x: xPos, y: yPos)
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 40)
                    .position(x: xPos, y: yPos)

            }
            Text(label)
                .font(.footnote)
                .foregroundColor(.black)
                .position(x: xPos, y: yPos-200)
        }
    }
}

struct controlButtonView: View {
    var iconName: String
    var label: String
    var action: ()->Void
    
    var body: some View{
        
        VStack{
            Button(action: {
                action()
            }) {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#939298").opacity(0.3), lineWidth: 4)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 1)
                        .frame(width: 100, height: 100)
                    Image(iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 100, height: 100)
            
            Text(label)
                .foregroundColor(.black)
                .font(.footnote)
                .padding(.top, 5)
        }
    }
    
}

extension Color{
    init(hex: String){
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

#Preview {
    ContentView()
}
