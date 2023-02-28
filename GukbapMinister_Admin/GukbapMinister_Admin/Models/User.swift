//
//  User.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var userNickname: String
    var userEmail: String
    var userGrade : String
    var reviewCount: Int
    var storeReportCount: Int
    var favoriteStoreId: [String]
}
