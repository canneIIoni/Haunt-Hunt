//
//  InvestigatorView.swift
//  Haunt Hunt
//
//  Created by Luca on 12/05/23.
//

import SwiftUI
import CoreLocation
import CoreBluetooth

class BeaconDetectorInvestigator: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var lastDistance: CLProximity = .unknown

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func startRanging() {
        guard let uuid = UUID(uuidString: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09") else {
            return
        }
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 100, minor: 50)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "com.yourcompany.yourapp")
        locationManager.startRangingBeacons(satisfying: beaconRegion.beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startRanging()
        }
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, intensity: beacon.rssi)
        } else {
            update(distance: .unknown, intensity: -200)
        }
    }

    private func update(distance: CLProximity, intensity: Int) {
        var adjustedDistance = distance

        if intensity >= -69 {
            adjustedDistance = .immediate
        } else if intensity >= -78 {
            adjustedDistance = .near
        } else if intensity >= -85 {
            adjustedDistance = .far
        } else {
            adjustedDistance = .unknown
        }

        self.lastDistance = adjustedDistance
    }
    
}

struct InvestigatorView: View {
    
    @Binding var investigatorToggle:Bool
    @State private var emmitToggle = false
    @State private var returnToggle = true
    @State private var isButtonVisible = true
    @StateObject var detector = BeaconDetectorInvestigator()
    @State var countdownTimer = 300
    @State var countdownHideTimer = 12
    @State var timerRunning = false
    @State var timerHideRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timerHide = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @State private var showAlert = false

    var body: some View {
        let beaconManager = BeaconManagerInvestigator()
        ZStack {
            Image("emfbackground")
                .resizable()
                .ignoresSafeArea()
                .aspectRatio(contentMode: .fill)
            
            VStack{
                ZStack {
                    if !investigatorToggle {
                        PreviousView(entityToggle: false, investigatorToggle: investigatorToggle)
                            .onAppear {
                                beaconManager.stopTransmitting()
                                
                            }
                    }
                    else{
                        VStack{
                            HStack {
                                Button {
                                    showAlert.toggle()
                                    
                                }
                            label:{
                                if screenHeight<=667{
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .foregroundColor(.purple)
                                        .frame(width: 12, height: 21)
                                        .padding(.top, screenHeight/4.5)
                                        .padding(.leading)
                                }else{
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .foregroundColor(.purple)
                                        .frame(width: 12, height: 21)
                                        .padding(.top, screenHeight/25)
                                        .padding(.leading)
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Wait!"),
                                    message: Text("Are you sure you want to leave the game?"),
                                    primaryButton: .default(Text("No"), action: {
                                        
                                    }),
                                    secondaryButton: .destructive(Text("Yes"), action: {
                                        
                                            // Action for Option 2
                                            
                                            emmitToggle = false
                                            returnToggle.toggle()
                                            beaconManager.stopTransmitting()
                                        
                                        investigatorToggle = false
                                    })
                                )
                            }.onDisappear {
                                beaconManager.stopTransmitting()
                                
                            }
                              
                                
                                Spacer()
                            }.offset(y: -380)}
                        Spacer()
                        if screenHeight<=667{
                            VStack {
                                HStack{
                                    if countdownHideTimer > 0{
                                        Circle()
                                            .foregroundColor(Color(hue: 0.40, saturation:0.70, brightness: 0.4))
                                        
                                        Circle()
                                            .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.5))
                                        Circle()
                                            .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                        Circle()
                                            .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                    }else{
                                        if detector.lastDistance.descriptionInvestigator == "UNKNOWN"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                        else if detector.lastDistance.descriptionInvestigator == "FAR"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.yellow.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                        else if detector.lastDistance.descriptionInvestigator == "NEAR"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.yellow.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.orange.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                        else if detector.lastDistance.descriptionInvestigator == "IMMEDIATE"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.yellow.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.orange.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.red.opacity(1), radius: 10)
                                        }
                                        else {
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                    }
                                    
                                    
                                    
                                }.padding()
                                    .padding(.top, 75)
                            }.position(x: screenWidth/2, y: (screenHeight)/5.8)
                        }else{
                            VStack {
                                HStack{
                                    if countdownHideTimer > 0{
                                        Circle()
                                            .foregroundColor(Color(hue: 0.40, saturation:0.70, brightness: 0.4))
                                        
                                        Circle()
                                            .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.5))
                                        Circle()
                                            .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                        Circle()
                                            .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                    }else{
                                        if detector.lastDistance.descriptionInvestigator == "UNKNOWN"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                        else if detector.lastDistance.descriptionInvestigator == "FAR"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.yellow.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                        else if detector.lastDistance.descriptionInvestigator == "NEAR"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.yellow.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.orange.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                        else if detector.lastDistance.descriptionInvestigator == "IMMEDIATE"{
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.yellow.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.orange.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.999))
                                                .shadow(color: Color.red.opacity(1), radius: 10)
                                        }
                                        else {
                                            Circle()
                                                .foregroundColor(.green)
                                                .shadow(color: Color.green.opacity(1), radius: 10)
                                            Circle()
                                                .foregroundColor(Color(hue: 0.10, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.03, saturation: 0.70, brightness: 0.5))
                                            Circle()
                                                .foregroundColor(Color(hue: 0.00, saturation: 0.70, brightness: 0.5))
                                        }
                                    }
                                    
                                    
                                    
                                }.padding()
                                    .padding(.top, 75)
                            }.position(x: screenWidth/2, y: (screenHeight)/7.5)
                        }
                        
                        Spacer()
                        ZStack {
                            if countdownHideTimer > 0{
                                
                                if countdownHideTimer != 1{
                                    Text("\(countdownHideTimer) seconds left to wait")
                                    
                                        .onReceive(timerHide) { _ in
                                            if countdownHideTimer > 0 && timerHideRunning {
                                                countdownHideTimer -= 1
                                            } else {
                                                timerHideRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.white)
                                        .offset(y: 200)
                                } else {
                                    Text("\(countdownHideTimer) second left to wait")
                                    
                                        .onReceive(timerHide) { _ in
                                            if countdownHideTimer > 0 && timerHideRunning {
                                                countdownHideTimer -= 1
                                            } else {
                                                timerHideRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.white)
                                        .offset(y: 200)
                                }
                            }
                            else {
                                
                                if countdownTimer <=  30 && countdownTimer > 0{
                                    if countdownTimer != 1{
                                        Text("\(countdownTimer) seconds left")
                                        
                                            .onReceive(timer) { _ in
                                                if countdownTimer > 0 && timerRunning {
                                                    countdownTimer -= 1
                                                } else {
                                                    timerRunning = false
                                                }
                                            }
                                            .font(Font.custom("GhoulishFrightAOE", size: 30))
                                            .foregroundColor(.red)
                                            .offset(y: 200)
                                    }
                                    else{
                                        Text("\(countdownTimer) second left")
                                        
                                            .onReceive(timer) { _ in
                                                if countdownTimer > 0 && timerRunning {
                                                    countdownTimer -= 1
                                                } else {
                                                    timerRunning = false
                                                }
                                            }
                                            .font(Font.custom("GhoulishFrightAOE", size: 30))
                                            .foregroundColor(.red)
                                            .offset(y: 200)
                                    }
                                } else if countdownTimer > 30{
                                    Text("\(countdownTimer) seconds left")
                                    
                                        .onReceive(timer) { _ in
                                            if countdownTimer > 0 && timerRunning {
                                                countdownTimer -= 1
                                            } else {
                                                timerRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.white)
                                        .offset(y: 200)
                                } else {
                                    Text("HIDE")
                                        .onReceive(timer) { _ in
                                            if countdownTimer > 0 && timerRunning {
                                                countdownTimer -= 1
                                            } else {
                                                timerRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.red)
                                        .offset(y: 200)
                                }
                            }
                            
                            if isButtonVisible == true {
                                Button {
                                    emmitToggle = true
                                    timerHideRunning = true
                                    timerRunning = true
                                    isButtonVisible = false
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 330, height: 45)
                                        
                                            .padding()
                                            .foregroundColor(Color("BrightPurple"))
                                        Text("Click to Start")
                                            .foregroundColor(.white)
                                            .font(Font.custom("GhoulishFrightAOE", size: 30))
                                    }
                                }
                                .offset(y: 200)
                                
                                
                            }
                            if countdownHideTimer != 0{
                                Text("Preparation")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 140)
                            }
                            else if countdownHideTimer == 0 && countdownTimer == 0 {
                                Text("Hunt")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 140)
                            }
                            else if countdownHideTimer == 0 && countdownTimer != 0 {
                                Text("Investigation")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 140)
                            }
                            
                        }.offset(y:100)
                        
                        
                        Spacer()
                    }
                    }//VStack end
                    
                        .onAppear {
                            if emmitToggle{
                                beaconManager.startTransmitting()
                            }
                            else {
                                beaconManager.stopTransmitting()
                            }
                        }
                        .onDisappear {
                            beaconManager.stopTransmitting()
                        }
                }
            }
        }
}


extension CLProximity {
    var colorInvestigator: Color {
        switch self {
        case .immediate:
            return .red
        case .near:
            return .yellow
        case .far:
            return .green
        default:
            return .gray
        }
    }

    var descriptionInvestigator: String {
        switch self {
        case .immediate:
            return "IMMEDIATE"
        case .near:
            return "NEAR"
        case .far:
            return "FAR"
        default:
            return "UNKNOWN"
        }
    }
}

class BeaconManagerInvestigator: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    let locationManager = CLLocationManager()
    var peripheralManager: CBPeripheralManager?
    var beaconUUID: UUID = UUID(uuidString: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA")!
    var beaconRegionIdentifier: String!
    var beaconMajorValue: CLBeaconMajorValue = 100 // default value for beaconMajorValue
    var beaconMinorValue: CLBeaconMinorValue = 50 // default value for beaconMinorValue
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startTransmitting() {
        self.beaconUUID = UUID(uuidString: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA")!
        self.beaconRegionIdentifier = "MyBeaconRegion"
        self.beaconMajorValue = 100
        self.beaconMinorValue = 50
        
        let beaconRegion = CLBeaconRegion(uuid: self.beaconUUID, major: self.beaconMajorValue, minor: self.beaconMinorValue, identifier: self.beaconRegionIdentifier)
        let peripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        self.peripheralManager!.startAdvertising(peripheralData as? [String: Any])
    }
    
    func stopTransmitting() {
        self.peripheralManager?.stopAdvertising()
        self.peripheralManager = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            let uuid = UUID(uuidString: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA")!
            let identifier = "MyBeaconRegion"
            let major: CLBeaconMajorValue = 100
            let minor: CLBeaconMinorValue = 50
            
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
            self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
            self.peripheralManager!.startAdvertising(beaconRegion.peripheralData(withMeasuredPower: nil) as? [String : Any])
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral manager powered on")
            let serviceUUID = CBUUID(string: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA")
            let characteristicUUID = CBUUID(string: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA")
            let properties: CBCharacteristicProperties = [.read, .write, .notify]
            let permissions: CBAttributePermissions = [.readable, .writeable]
            let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: properties, value: nil, permissions: permissions)
            let service = CBMutableService(type: serviceUUID, primary: true)
            service.characteristics = [characteristic]
            peripheral.add(service)
            let uuid = UUID(uuidString: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA")!
            let identifier = "MyBeaconRegion"
            let major: CLBeaconMajorValue = 100
            let minor: CLBeaconMinorValue = 50
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
            self.peripheralManager!.startAdvertising(beaconRegion.peripheralData(withMeasuredPower: nil) as? [String : Any])
        case .poweredOff:
            print("Peripheral manager powered off")
        case .resetting:
            print("Peripheral manager resetting")
        case .unauthorized:
            print("Peripheral manager unauthorized")
        case .unknown:
            print("Peripheral manager unknown")
        case .unsupported:
            print("Peripheral manager unsupported")
        @unknown default:
            print("What is even going on?")
        }
    }
}

struct InvestigatorView_Previews: PreviewProvider {
    static var previews: some View {
        InvestigatorView(investigatorToggle: .constant(true))
            
    }
}
