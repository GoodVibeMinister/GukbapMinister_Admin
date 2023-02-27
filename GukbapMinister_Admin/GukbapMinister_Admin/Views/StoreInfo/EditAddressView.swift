//
//  EditAddressView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/25.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseFirestore

enum GeocodingStatus {
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
    @State private var geocodingStatus: GeocodingStatus = .none
    
    
    var body: some View {
        Form {
            Section {
                Text("기존주소")
                    .font(.headline)
                Text(manager.storeInfo.storeAddress)
                MapUIView(region: MKCoordinateRegion(center: .init(latitude: manager.storeInfo.coordinate.latitude,
                                                                   longitude: manager.storeInfo.coordinate.longitude),
                                                     latitudinalMeters: 500,
                                                     longitudinalMeters: 500))
                .frame(height: 150)
            }
            
            Section {
                Text("변경할 주소")
                    .font(.headline)
                HStack {
                    TextField("변경할 주소 입력", text: $newAdress)
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
    
    
    /// 주소를 위도경도로 변환하는 함수
    func forwardGeocoding(address: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { (placemarks, error) in
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
                manager.storeInfo.coordinate = GeoPoint(latitude: coordinate.latitude,
                                                        longitude: coordinate.longitude)
                self.geocodingStatus = .success
            } else {
                self.geocodingStatus = .cannotFindCoordinate
            }
        }
    }
}
