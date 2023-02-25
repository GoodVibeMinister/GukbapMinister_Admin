//
//  Store.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Store: Codable, Hashable, Identifiable {
    
    @DocumentID var id: String?
    var storeName: String
    var storeAddress: String
    var coordinate: GeoPoint
    var storeImages: [String]
    var menu: [String : String]
    var description: String
    var countingStar: Double
    var foodType: [String]
    var likes : Int
    var hits : Int
    static func == (lhs : Store, rhs: Store) -> Bool{
        lhs.id == rhs.id
    }
}

