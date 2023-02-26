//
//  MapUIView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/26.
//

import SwiftUI
import MapKit

struct MapUIView: UIViewRepresentable {
    var region: MKCoordinateRegion
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        
        mapView.region = self.region
        mapView.addAnnotation(Annotation(coordinate: region.center))
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(self.region, animated: true)
    }
}

class Annotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
