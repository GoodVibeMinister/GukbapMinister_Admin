//
//  NoticeManagementView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/06.
//

import SwiftUI

struct NoticeManagementView: View {
    @Environment(\.colorScheme) var scheme
    @StateObject var noticesManager = NoticesManager()
    
    var body: some View {
        NavigationStack {
            List (noticesManager.notices) { notice in
                DisclosureGroup {
                    NavigationLink {
                        NoticeDetailView(manager: NoticeManager(notice: notice))
                    } label: {
                        Text(notice.contents)
                    }
                } label: {
                    Text(notice.title)
                }
            }
            .navigationBarTitle(Text("공지관리"))
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .bottomTrailing) {
                NavigationLink {
                    NoticeDetailView(manager: NoticeManager(), mode: .new)
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(scheme == .light ? .white : .black)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color.accentColor)
                        }
                }
                .offset(x: -30, y: -30)
            }
        }
        .onAppear {
            noticesManager.subscribeNotices()
        }
        .onDisappear {
            noticesManager.unsubscribeNotices()
        }
    }
}

struct NoticeManagementView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeManagementView()
    }
}
