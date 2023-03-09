//
//  UserGrades.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/01.
//

import Foundation

enum UserGrades: String, Identifiable {
    case 깍두기 = "깍두기"
    case 배추김치
    case 공깃밥
    case 뚝배기
    case 국밥부차관
    case 국밥부장관
    
    var id: Self { self }
}
