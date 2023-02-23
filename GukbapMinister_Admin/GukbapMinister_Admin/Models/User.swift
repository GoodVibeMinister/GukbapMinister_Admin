//
//  User.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var userNickname: String = ""
    var userEmail: String =  ""
    var preferenceArea: String = ""
    var gender: String = ""
    var ageRange: Int = 0
    var gukbaps: [String] = []
    var filterdGukbaps: [String] = []
    var status : String = ""
    var reviewCount: Int = 0
    var storeReportCount: Int = 0
}
