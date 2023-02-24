//
//  StoreInfoDetailView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct StoreInfoDetailView: View {
    @ObservedObject var manager = StoreInfoManager()
    var body: some View {
        VStack {
            Text(manager.storeInfo.storeName)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(manager.storeImageUrls, id: \.self) { imageURL in
                        //이렇게 사용하는 이유는 권고사항이기 때문
                        //https://github.com/SDWebImage/SDWebImageSwiftUI#common-problems
                        StoreImageView(imageURL: imageURL)
                    }
                }
            }
            .frame(height: 120)
        }
        .padding()
       
    }
    
}

struct StoreImageView: View {
    var imageURL: URL
    var body: some View {
        VStack{
            WebImage(url: imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
        }
        .padding()
                  
    }
}

struct StoreInfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreInfoDetailView()
    }
}
