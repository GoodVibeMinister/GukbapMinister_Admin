//
//  UserManagementView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct UserManagementView: View {
    @StateObject var manager = UsersManager()
    var body: some View {
        NavigationStack {
            List(manager.users) { user in
                VStack(alignment: .leading) {
                    Text(user.userNickname)
                        .font(.headline)
                    Text(user.userEmail)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 2)
                }
            }
            .navigationBarTitle(Text("유저관리"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            manager.subscribeUsers()
        }
        .onDisappear {
            manager.unsubscribeUsers()
        }
    }
}

struct UserManagementView_Previews: PreviewProvider {
    static var previews: some View {
        UserManagementView()
    }
}
