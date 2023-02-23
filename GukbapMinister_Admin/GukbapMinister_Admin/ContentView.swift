//
//  ContentView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Int = 1
    
    var body: some View {
        
        NavigationStack {
            TabView(selection: $tabSelection) {
                UserManagementView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("유저관리")
                    }
                    .tag(1)
                
                StoreInfoManagementView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("국밥집 정보관리")
                    }
                    .tag(2)
                
                StoreRegistrationManagementView()
                    .tabItem {
                        Image(systemName: "doc.richtext.fill")
                        Text("국밥집 등록관리")
                    }
                    .tag(3)
                
                StoreReportManagementView()
                    .tabItem {
                        Image(systemName: "megaphone.fill")
                        Text("국밥집 제보목록")
                    }
                    .tag(4)
                
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
