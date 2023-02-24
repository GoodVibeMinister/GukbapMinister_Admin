//
//  StoreInfoManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI



final class StoreInfoManager: ObservableObject {
    @Published var storeInfo: Store
    @Published var storeImageUrls: [URL] = []
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    private var database = Firestore.firestore()
    private var storage = Storage.storage()
    
    init(storeInfo: Store = Store(storeName: "", storeAddress: "", coordinate: GeoPoint(latitude: 0, longitude: 0), storeImages: [], menu: [:], description: "", countingStar: 0.0, foodType: [], likes: 0, hits: 0)) {
        self.storeInfo = storeInfo
        
        self.$storeInfo
            .dropFirst()
            .sink { [weak self] storeInfo in
                self?.modified = true
            }
            .store(in: &self.cancellables)
        
        loadImageUrl(storeInfo)
    }
    
    // 이미지URL을 sdweb에서 요구하는 방식으로 생성하고 storeImageUrls에 append
     private func loadImageUrl(_ storeInfo: Store) {
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
                try database.collection("Store")
                    .document(documentId)
                    .setData(from: storeInfo)
            }
            catch {
                print(error)
            }
        }
    }
    
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
