//
//  DownloadedStoreImage.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/25.
//

import SwiftUI
import Kingfisher

struct DownloadedStoreImage: View {
    var imageURL: URL?
    var body: some View {
        VStack{
            if let imageURL {
                KFImage.url(imageURL)
                    .resizable()
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 100, height: 100)
                    }
                    .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 200, height: 200)))
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 1)
                    .cancelOnDisappear(true)
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Rectangle())
            }
        }
        .padding(5)
        
    }
}

