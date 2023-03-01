//
//  EditImagesView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/27.
//

import SwiftUI
import PhotosUI
import Collections

enum ImageUploadingState {
    case none, loading, done
}

struct EditImagesView: View {
    @ObservedObject var manager: StoreInfoManager
    @State private var showUploadImageSheet: Bool = false
    @State private var uploadingState: ImageUploadingState = .none
    
    var body: some View {
        
        Section {
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
                            .overlay(alignment: .bottomTrailing) {
                                Text("추가")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background {
                                        Capsule()
                                    }
                            }
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
                    if uploadingState == .none {
                        if manager.imageSelections.isEmpty {
                            Label("사진추가하기", systemImage: "plus.circle")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        } else {
                            Text("완료 전에 사진 업로드를 먼저 진행해주세요")
                                .font(.subheadline)
                        }
                    } else if uploadingState == .done {
                        Text("사진 업로드 완료")
                            .font(.subheadline)
                    }
                    Spacer()
                }
            }
            .disabled(uploadingState == .done)
            .disabled(manager.storeInfo.storeName.isEmpty)
        } header : {
            Text("가게 사진")
        }
        .sheet(isPresented: $showUploadImageSheet) {
            UploadImageSheet(manager: manager, showSheet: $showUploadImageSheet, uploadingState: $uploadingState)
        }
    }
}


struct UploadImageSheet: View {
    @ObservedObject var manager: StoreInfoManager
    @Binding var showSheet: Bool
    @Binding var uploadingState: ImageUploadingState
    
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    photosPicker
                    selectedImages
                }
                .padding(.vertical)
            }
            uploadButton
        }
        .padding()
    }
    
    var photosPicker: some View {
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
    }
    var selectedImages: some View {
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
    var uploadButton: some View {
        Button {
            upload()
        } label: {
            Text(manager.imageSelections.isEmpty ? "사진을 추가해주세요" : "\(manager.imageSelections.count)장의 사진업로드")
                .overlay(alignment: .trailing){
                    if uploadingState == .loading {
                        ProgressView()
                            .offset(x: 20)
                    } else if uploadingState == .done {
                        Image(systemName: "checkmark")
                            .offset(x: 20)
                    }
                }
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(manager.imageSelections.isEmpty)
    }
    func upload() {
        Task {
            uploadingState = .loading
            manager.handleUploadTapped()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                uploadingState = .done
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showSheet = false
            }
            
        }
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

