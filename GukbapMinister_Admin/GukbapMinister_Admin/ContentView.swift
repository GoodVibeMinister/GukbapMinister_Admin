//
//  ContentView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var tabSelection: Int = 1
    
    
    var body: some View {
        if authManager.isLoggedIn {
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
                        Text("정보관리")
                    }
                    .tag(2)
                
                StoreRegistrationManagementView()
                    .tabItem {
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                        Text("등록관리")
                    }
                    .tag(3)
                
                StoreReportManagementView()
                    .tabItem {
                        Image(systemName: "megaphone.fill")
                        Text("제보목록")
                    }
                    .tag(4)
                
                NoticeManagementView()
                    .tabItem {
                        Image(systemName: "bell.fill")
                        Text("공지관리")
                    }
                    .tag(5)
            }
        } else {
            AuthView()
                .environmentObject(authManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
