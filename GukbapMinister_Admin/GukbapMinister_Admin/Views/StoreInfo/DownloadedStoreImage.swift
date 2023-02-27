//
//  DownloadedStoreImage.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DownloadedStoreImage: View {
    var imageURL: URL
    var body: some View {
        VStack{
            WebImage(url: imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Rectangle())
        }
        .padding(5)
        
    }
}

