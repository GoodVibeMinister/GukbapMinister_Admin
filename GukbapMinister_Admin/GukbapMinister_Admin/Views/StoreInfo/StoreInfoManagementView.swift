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
    @State private var searchText: String = ""
    
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(manager.stores) { store in
                    NavigationLink {
                        StoreInfoDetailView(manager: StoreInfoManager(storeInfo: store))
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
                    .padding(.vertical, 6)
                    
                    Divider()
                }
            }
        }
        .searchable(text: $searchText)
        .padding()
        .onAppear {
            manager.subscribeStoreInfos()
        }
        .onDisappear {
            manager.unsubscribeStoreInfos()
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
