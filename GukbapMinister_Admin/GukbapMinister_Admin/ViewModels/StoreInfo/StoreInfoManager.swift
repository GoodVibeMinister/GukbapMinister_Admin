//
//  StoreInfoManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI


import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI




final class StoreInfoManager: ObservableObject {
    @Published var storeInfo: Store
    
    /// SDWebImage가 다운로드 받을 수 있는 형식의 URL을 모아둔 배열
    @Published var storeImageUrls: [URL] = []
    @Published var modified = false
    
    
    private var cancellables = Set<AnyCancellable>()
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    
    //MARK: - 이미지 처리 과정
    enum ImageState {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct StoreImage: Transferable {
        
        let uiImage: UIImage
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                
                return StoreImage(uiImage: uiImage)
            }
        }
    }
    
    @Published private(set) var imageStates: [PhotosPickerItem : ImageState] = [:]
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            imageStates = [:]
            for selection in imageSelections {
                let progress = loadTransferable(from: selection)
                imageStates[selection] = .loading(progress)
            }
        }
    }
    
    //MARK: - Initializer

    init(storeInfo: Store = Store(storeName: "", storeAddress: "", coordinate: GeoPoint(latitude: 0, longitude: 0), storeImages: [], menu: [:], description: "", countingStar: 0.0, foodType: [], likes: 0, hits: 0)) {
        self.storeInfo = storeInfo
        
        self.$storeInfo
            .dropFirst()
            .sink { [weak self] storeInfo in
                self?.modified = true
            }
            .store(in: &self.cancellables)
        
        self.$imageSelections
            .dropFirst()
            .sink { [weak self] imageSelections in
                self?.modified = true
            }
            .store(in: &self.cancellables)
        
        loadImageUrl(storeInfo)
    }
    
    //MARK: - Private Methods
    /// SDWebImage가 다운로드 받을 수 있는 형식의 URL생성
     private func loadImageUrl(_ storeInfo: Store) {
         
        //FIXME: 이렇게 스토리지 레퍼런스에서 url을 통해 이미지를 로드한다면 나중에는 Store Model의 storeImages 필드가 굳이 필요 없지 않을까 생각해봅니다.
         
        if let _ = storeInfo.id {
            for imageName in storeInfo.storeImages {
                let ref = storage.reference().child("storeImages/\(storeInfo.storeName)/\(imageName)")
                
                let storageURL = NSURL.sd_URL(with: ref) as URL?
                self.storeImageUrls.append(storageURL!)
            }
        }
    }
    
    private func addStoreInfo() {
        do {
            self.storeInfo.storeImages += uploadImages(storeInfo)
            let _ = try database.collection("Store")
                .addDocument(from: self.storeInfo)
        }
        catch {
            print(error)
        }
    }
    
    private func updateStoreInfo(_ storeInfo: Store) {
        if let documentId = storeInfo.id {
            do {
                self.storeInfo.storeImages += uploadImages(storeInfo)
                try database.collection("Store")
                    .document(documentId)
                    .setData(from: storeInfo)
            }
            catch {
                print(error)
            }
        }
    }
    
    /// imageStates를 순회하며 Firebase Stroage에 이미지를 업로드하는 함수
    private func uploadImages(_ storeInfo: Store) -> [String] {
        var imageNames: [String] = []
        
        guard !imageStates.isEmpty else {
            return []
        }
        
        
        
        for (_, imageState) in self.imageStates {
            let imageName = UUID().uuidString
            let storageRef = storage.reference().child("storeImages/\(storeInfo.storeName)/\(imageName)")
            
            switch imageState {
                
            case .success(let uiImage):
                let data = uiImage.jpegData(compressionQuality: 0.1)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                if let data = data {
                    storageRef.putData(data, metadata: metadata) { (metadata, err) in
                        guard let _ = metadata else {
                            return
                        }
                        imageNames.append(imageName)
                    }
                }
                
            default: print("cannot upload this image")
            }
        }
        
        return imageNames
    }
    
    
    //MARK: - PhotosPicker 데이터 처리
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: StoreImage.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let storeImage?):
                    self.imageStates[imageSelection] = .success(storeImage.uiImage)
                case .success(nil):
                    self.imageStates[imageSelection] = .empty
                case .failure(let error):
                    self.imageStates[imageSelection] = .failure(error)
                }
            }
        }
    }
    

    
    //MARK: - UI Handler
    func removeStoreInfo() {
        if let documentId = self.storeInfo.id {
            database.collection("Store").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func handleDoneTapped() {
        if let _ = self.storeInfo.id {
            updateStoreInfo(self.storeInfo)
        } else {
            addStoreInfo()
        }
    }
}
