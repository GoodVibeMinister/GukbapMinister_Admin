//
//  Review.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import SwiftUI

struct Review: Codable, Identifiable, Hashable {
    var id: String
    var userId: String
    var reviewText: String
    var createdAt: Double
    var images: [String]?
    var nickName: String
    var starRating: Int
    

    
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd" // "yyyy-MM-dd HH:mm:ss"
        
        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
 
    // 가게이름 추가
    var storeName: String
    // 가게Id 추가
    var storeId: String
}
