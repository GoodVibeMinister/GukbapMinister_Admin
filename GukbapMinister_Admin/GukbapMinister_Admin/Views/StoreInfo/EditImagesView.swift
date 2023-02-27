//
//  EditImagesView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/27.
//

import SwiftUI
import PhotosUI
import Collections

struct EditImagesView: View {
    @ObservedObject var manager: StoreInfoManager
    @State private var showUploadImageSheet: Bool = false
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(manager.storeImageUrls, id: \.self) { imageURL in
                        //이렇게 사용하는 이유는 권고사항이기 때문
                        //https://github.com/SDWebImage/SDWebImageSwiftUI#common-problems
                        DownloadedStoreImage(imageURL: imageURL)
                    }
                    
                    ForEach(manager.imageSelections, id: \.self) { selection in
                        StoreImage(imageState: manager.imageStates[selection] ?? .empty)
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Rectangle())
                            .padding(5)
                    }
                }
                .padding(.trailing, 15)
            }
            .frame(height: 120)
            
            Button {
                showUploadImageSheet = true
            } label: {
                HStack {
                    Spacer()
                    Label("사진추가하기", systemImage: "plus.circle")
                        .font(.subheadline)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showUploadImageSheet) {
            UploadImageSheet(manager: manager)
        }
    }
}


struct UploadImageSheet: View {
    @ObservedObject var manager: StoreInfoManager
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    PhotosPicker(selection: $manager.imageSelections, photoLibrary: .shared()) {
                        VStack {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .padding()
                            Text("사진추가하기")
                        }
                        .frame(width: 100, height: 100)
                        .background {
                            Rectangle()
                                .stroke(.blue)
                        }
                    }
                    
                    
                    ForEach(manager.imageSelections, id: \.self) { selection in
                        StoreImage(imageState: manager.imageStates[selection] ?? .empty)
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Rectangle())
                            .overlay(alignment: .bottomTrailing) {
                                Button {
                                    if let index = manager.imageSelections.firstIndex(of: selection)  {
                                        manager.imageSelections.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.white)
                                        .padding(3)
                                        .background {
                                            Circle()
                                                .fill(.black)
                                        }
                                        
                                }
                            }
                            .background {
                                    Rectangle()
                                        .fill(.blue)
                            }
                    }
                }
                .padding(.vertical)
            }
            
            Button {
                
            } label: {
                Text("업로드")
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


struct StoreImage: View {
    let imageState: StoreInfoManager.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let uiImage):
            Image(uiImage: uiImage).resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "house.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

struct EditImagesView_Previews: PreviewProvider {
    static var previews: some View {
        EditImagesView(manager: StoreInfoManager())
    }
}

