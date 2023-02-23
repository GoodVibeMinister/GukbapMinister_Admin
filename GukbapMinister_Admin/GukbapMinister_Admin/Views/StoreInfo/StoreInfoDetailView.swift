//
//  StoreInfoDetailView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct StoreInfoDetailView: View {
    @ObservedObject var manager = StoreInfoManager()
    var body: some View {
        VStack {
            Text(manager.storeInfo.storeName)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(manager.storeInfo.storeImages, id: \.self) { imageId in
                        StoreImage(storeName: manager.storeInfo.storeName, imageId: imageId)
                           
                    }
                }
            }
            .frame(height: 120)
        }
        .padding()
    }
}

struct StoreInfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreInfoDetailView()
    }
}
