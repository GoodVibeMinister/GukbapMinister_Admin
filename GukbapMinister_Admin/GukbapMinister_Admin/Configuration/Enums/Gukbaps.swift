//
//  Gukbaps.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/24.
//

import Foundation
import SwiftUI

enum Gukbaps: String, CaseIterable, Identifiable {
    case 전체 = "전체"
    case 순대국밥
    case 돼지국밥
    case 내장탕
    case 선지국
    case 소머리국밥
    case 뼈해장국
    case 수구레국밥
    case 굴국밥
    case 콩나물국밥
    case 설렁탕
    case 평양온반
    case 시레기국밥
    case 육개장
    case 곰탕
    case 추어탕
    
    var id: Self { self }
    
    var shortenName: String {
        switch self {
        case .전체: return "전체"
        case .순대국밥: return "순대"
        case .돼지국밥: return "돼지"
        case .내장탕: return "내장"
        case .선지국: return "선지"
        case .소머리국밥: return "소머리"
        case .뼈해장국: return "뼈해장"
        case .수구레국밥: return "수구레"
        case .굴국밥: return "굴"
        case .콩나물국밥: return "콩나물"
        case .설렁탕: return "설렁"
        case .평양온반: return "온반"
        case .시레기국밥: return "시레기"
        case .육개장, .곰탕, .추어탕: return self.rawValue
        }
    }
}
