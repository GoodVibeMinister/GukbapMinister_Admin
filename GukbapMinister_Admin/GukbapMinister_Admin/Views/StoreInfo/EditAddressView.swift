//
//  EditAddressView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/25.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore

enum GeocodingProcess {
    case none
    case cannotFindAddress
    case cannotFindCoordinate
    case success
    
    var errorMessage: String {
        switch self {
        case .none, .success: return ""
        case .cannotFindAddress: return "주소를 찾을 수 없습니다."
        case .cannotFindCoordinate: return "좌표를 찾을 수 없습니다."
        }
    }
    
    
}

struct EditAddressView: View {
    @ObservedObject var manager: StoreInfoManager
    @State private var newAdress: String = ""
    
    @State private var geocodingStatus: GeocodingProcess = .none
    
    var body: some View {
        Form {
            Section {
                Text("기존주소")
                    .font(.headline)
                Text(manager.storeInfo.storeAddress)
            }
            
            Section {
                Text("변경할 주소")
                    .font(.headline)
                HStack {
                    TextField("변경할 주소 입략", text: $newAdress)
                        .onChange(of: newAdress) { _ in
                            geocodingStatus = .none
                        }
                    Button {
                        newAdress = ""
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                    .disabled(newAdress == "")
                }
                HStack {
                    Spacer()
                    Button("주소 좌표 변환") {
                        forwardGeocoding(address: newAdress)
                    }
                    .disabled(newAdress.isEmpty)
                    Spacer()
                }
            }
            
            Section {
                Text("변환 결과")
                    .font(.headline)
                if geocodingStatus == .success {
                    HStack {
                        Text("위도")
                            .font(.headline)
                        Divider()
                        Text("\(manager.storeInfo.coordinate.latitude)")
                    }
                    HStack {
                        Text("경도")
                            .font(.headline)
                        Divider()
                        Text("\(manager.storeInfo.coordinate.longitude)")
                    }
                } else {
                    Text(geocodingStatus.errorMessage)
                }
            }
            
        }
        .toolbar {
            ToolbarItem {
                Button("변경주소 등록") {
                    manager.storeInfo.storeAddress = newAdress
                    newAdress = ""
                    geocodingStatus = .none
                }
                .disabled(geocodingStatus != .success)
            }
        }
    }
    
    func forwardGeocoding(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                self.geocodingStatus = .cannotFindAddress
                return
            }
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                manager.storeInfo.coordinate = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                self.geocodingStatus = .success
            } else {
                self.geocodingStatus = .cannotFindCoordinate
            }
        })
    }
}

struct EditAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EditAddressView(manager: StoreInfoManager())
    }
}
