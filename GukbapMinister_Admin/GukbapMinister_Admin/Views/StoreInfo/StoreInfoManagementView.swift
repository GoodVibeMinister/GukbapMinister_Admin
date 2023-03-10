//
//  StoreInfoManagementView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct StoreInfoManagementView: View {
    @StateObject var manager = StoreInfosManager()
    @Environment(\.colorScheme) var scheme
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText: String = ""

    
    var body: some View {
        NavigationStack{
            list
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("총")
                            .font(.title2)
                            .bold()
                        Text("\(manager.filter == .전체 ? manager.stores.count : manager.filteredStores.count)개")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("국밥", selection: $manager.filter) {
                        ForEach(Gukbaps.allCases) { gukbap in
                            Text(gukbap.shortenName)
                                .tag(gukbap.shortenName)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                NavigationLink {
                    StoreInfoDetailView(manager: StoreInfoManager(), mode: .new)
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
            manager.subscribeStoreInfos()
        }
        .onDisappear {
            manager.unsubscribeStoreInfos()
        }
    }
    
  
    private var list: some View {
        List {
            ForEach(manager.filter == .전체 ? manager.stores : manager.filteredStores ) { store in
                NavigationLink {
                    StoreInfoDetailView(manager: StoreInfoManager(storeInfo: store), mode: .edit) { result in
                        if case .success(let action) = result, action == .delete {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(store.storeName)
                            .font(.headline)
                            .foregroundColor(scheme == .light ? .black : .white)
                        Text(store.storeAddress)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 2)
                    }
                }
            }
        }
    }
}

struct StoreInfoManagementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StoreInfoManagementView()
        }
    }
}
