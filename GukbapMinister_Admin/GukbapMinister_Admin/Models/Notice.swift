//
//  Notice.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/06.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Notice: Codable, Hashable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var contents: String
}
