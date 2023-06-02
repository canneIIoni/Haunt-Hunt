//
//  EntityLinkView.swift
//  Haunt Hunt
//
//  Created by Luca on 31/05/23.
//

import SwiftUI
import CoreLocation
import CoreBluetooth

//classe para o detector de beacons
class BeaconDetectorEntityLink: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var lastDistance: CLProximity = .unknown

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    //Função para começar a busca do sinal do outro iBeacon
    func startRanging() {
        guard let uuid = UUID(uuidString: "F1C4EAC1-3E6B-4D46-8C8F-4E4CC9A89DCA") else {
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

//função para a atualização da intensidade e distância do sinal do outro iBeacon
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

struct EntityLinkView: View {
    
    @Environment(\.presentationMode) var isPresented
    
    @Binding var entityToggle:Bool
    @State private var emmitToggle = false
    @State private var isButtonVisible = true
    @State private var returnToggle = true
    @StateObject var detector = BeaconDetectorEntityLink()
    @State var countdownTimer = 300 //segundos do segundo timer
    @State var countdownHideTimer = 12 //segundos do timer de preparação
    @State var timerRunning = false //toggle do segundo timer
    @State var timerHideRunning = false //toggle do timer de preparação
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() //segundo timer
    let timerHide = Timer.publish(every: 1, on: .main, in: .common).autoconnect() //timer de preparação
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    @State private var showAlert = false

    var body: some View {
        let beaconManagerEntity = BeaconManagerLinkEntity()
        VStack{
            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                
                if !entityToggle {
                    PreviousView(entityToggle: entityToggle, investigatorToggle: false)
                        .onAppear {
                            beaconManagerEntity.stopTransmitting()
                            
                        }
                }else{
                    HStack{
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
                                }else if screenHeight >= 926{
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .foregroundColor(.purple)
                                        .frame(width: 12, height: 21)
                                        .padding(.leading)
                                }else{
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .foregroundColor(.purple)
                                        .frame(width: 12, height: 21)
                                        .padding(.top, screenHeight/25)
                                        .padding(.leading)
                                }
                                
                            }.alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Wait!"),
                                    message: Text("Are you sure you want to leave the game?"),
                                    primaryButton: .default(Text("No"), action: {
                                        
                                    }),
                                    secondaryButton: .destructive(Text("Yes"), action: {
                                            // Action for Option 2
                                            entityToggle = false
                                            returnToggle.toggle()
                                            emmitToggle = false
                                            
                                            beaconManagerEntity.stopTransmitting()
                                        
                                    })
                                )
                            }.onDisappear {
                                beaconManagerEntity.stopTransmitting()
                                
                            }
                                
                                Spacer()
                            }.offset(y: -200)
                            if countdownHideTimer > 0{
                                Image("pentagram")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 350)
                                    .shadow(color: Color.purple.opacity(0), radius: 20)
                                    .offset(y: -150)
                                    .opacity(0.3)
                            }
                            else if countdownHideTimer <= 0{
                                if detector.lastDistance.descriptionEntityLink == "UNKNOWN"{
                                    Image("pentagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 350, height: 350)
                                        .shadow(color: Color.purple.opacity(0), radius: 20)
                                        .offset(y: -150)
                                        .opacity(0.3)
                                }
                                else if detector.lastDistance.descriptionEntityLink == "FAR"{
                                    Image("pentagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 350, height: 350)
                                        .shadow(color: Color.purple.opacity(0.3), radius: 10)
                                        .offset(y: -150)
                                        .opacity(0.5)
                                    
                                }
                                else if detector.lastDistance.descriptionEntityLink == "NEAR"{
                                    Image("pentagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 350, height: 350)
                                        .shadow(color: Color.purple.opacity(0.5), radius: 10)
                                        .offset(y: -150)
                                        .opacity(0.7)
                                    
                                }
                                else if detector.lastDistance.descriptionEntityLink == "IMMEDIATE"{
                                    Image("pentagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 350, height: 350)
                                        .shadow(color: Color.purple.opacity(1), radius: 10)
                                        .offset(y: -150)
                                        .opacity(1)
                                }
                                else {
                                    Image("pentagram")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 350, height: 350)
                                        .shadow(color: Color.yellow.opacity(0), radius: 10)
                                        .offset(y:-150)
                                        .opacity(0.3)
                                }
                            }
                        }
                        
                    }.padding()
                    ZStack {
                        if screenHeight<=667{
                            if countdownHideTimer > 0{
                                if countdownHideTimer != 1{
                                    Text("\(countdownHideTimer) seconds left to hide")
                                    
                                        .onReceive(timerHide) { _ in
                                            if countdownHideTimer > 0 && timerHideRunning {
                                                countdownHideTimer -= 1
                                            } else {
                                                timerHideRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.white)
                                        .offset(y: 180)
                                } else {
                                    Text("\(countdownHideTimer) second left to hide")
                                    
                                        .onReceive(timerHide) { _ in
                                            if countdownHideTimer > 0 && timerHideRunning {
                                                countdownHideTimer -= 1
                                            } else {
                                                timerHideRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.white)
                                        .offset(y: 180)
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
                                            .offset(y: 180)
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
                                            .offset(y: 180)
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
                                        .offset(y: 180)
                                } else {
                                    Text("FIND THEM")
                                        .onReceive(timer) { _ in
                                            if countdownTimer > 0 && timerRunning {
                                                countdownTimer -= 1
                                            } else {
                                                timerRunning = false
                                            }
                                        }
                                        .font(Font.custom("GhoulishFrightAOE", size: 30))
                                        .foregroundColor(.red)
                                        .offset(y: 180)
                                }
                            }
                        }else{
                            if countdownHideTimer > 0{
                                if countdownHideTimer != 1{
                                    Text("\(countdownHideTimer) seconds left to hide")
                                    
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
                                    Text("\(countdownHideTimer) second left to hide")
                                    
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
                                    Text("FIND THEM")
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
                        }
                        
                        if isButtonVisible == true {
                            
                            if screenHeight<=667{
                                Button {
                                    timerHideRunning = true
                                    timerRunning = true
                                    isButtonVisible = false
                                    emmitToggle = true
                                    print(screenHeight)
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 350, height: 50)
                                            .padding()
                                            .foregroundColor(Color("BrightPurple"))
                                        Text("Click to Start")
                                            .foregroundColor(.white)
                                            .font(Font.custom("GhoulishFrightAOE", size: 30))
                                    }
                                }.offset(y: 180)
                            }else{
                                Button {
                                    timerHideRunning = true
                                    timerRunning = true
                                    isButtonVisible = false
                                    emmitToggle = true
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 350, height: 50)
                                            .padding()
                                            .foregroundColor(Color("BrightPurple"))
                                        Text("Click to Start")
                                            .foregroundColor(.white)
                                            .font(Font.custom("GhoulishFrightAOE", size: 30))
                                    }
                                }.offset(y: 200)
                            }
                            
                        }
                        if countdownHideTimer != 0{
                            if screenHeight<=667{
                                Text("Preparation")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 120)
                            }else{
                                Text("Preparation")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 140)
                            }
                        }
                        else if countdownHideTimer == 0 && countdownTimer == 0 {
                            if screenHeight<=667{
                                Text("Hunt")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 120)
                            }else{
                                Text("Hunt")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 140)
                            }
                        }
                        else if countdownHideTimer == 0 && countdownTimer != 0 {
                            if screenHeight<=667{
                                Text("Investigation")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 120)
                            }else{
                                Text("Investigation")
                                    .foregroundColor(.white)
                                    .font(Font.custom("GhoulishFrightAOE", size: 50))
                                    .offset(y: 140)
                            }
                        }
                        
                    }
                    
                    .offset(y:100)
                }
                
                Spacer()
                
                
            }
            .onAppear {
                if emmitToggle{
                    beaconManagerEntity.startTransmitting()
                }
                else {
                    beaconManagerEntity.stopTransmitting()
                }
            }
            .onDisappear {
                beaconManagerEntity.stopTransmitting()
                
            }
        }
    }
}


extension CLProximity {
    var colorEntityLink: Color {
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

    var descriptionEntityLink: String {
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

class BeaconManagerLinkEntity: NSObject, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    let locationManager = CLLocationManager()
    var peripheralManager: CBPeripheralManager?
    var beaconUUID: UUID = UUID(uuidString: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09")!
    var beaconRegionIdentifier: String!
    var beaconMajorValue: CLBeaconMajorValue = 100 // default value for beaconMajorValue
    var beaconMinorValue: CLBeaconMinorValue = 50 // default value for beaconMinorValue
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startTransmitting() {
        self.beaconUUID = UUID(uuidString: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09")!
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
            let uuid = UUID(uuidString: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09")!
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
            let serviceUUID = CBUUID(string: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09")
            let characteristicUUID = CBUUID(string: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09")
            let properties: CBCharacteristicProperties = [.read, .write, .notify]
            let permissions: CBAttributePermissions = [.readable, .writeable]
            let characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: properties, value: nil, permissions: permissions)
            let service = CBMutableService(type: serviceUUID, primary: true)
            service.characteristics = [characteristic]
            peripheral.add(service)
            let uuid = UUID(uuidString: "598a7b3e-63b5-4a0c-a52a-d3e3bde20d09")!
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

struct EntityLinkView_Previews: PreviewProvider {
    static var previews: some View {
        EntityLinkView(entityToggle: .constant(true))

    }
}
