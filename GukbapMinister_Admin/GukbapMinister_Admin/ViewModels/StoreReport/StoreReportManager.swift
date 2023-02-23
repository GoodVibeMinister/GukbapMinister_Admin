//
//  StoreReportManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore


final class StoreReportManager: ObservableObject {
    @Published var storeReport: StoreReport
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(storeReport: StoreReport = StoreReport(userId: "", storeName: "", storeAddress: "", foodType: [], description: "", isUseful: false)) {
        self.storeReport = storeReport
        
        self.$storeReport
            .dropFirst()
            .sink { [weak self] storeReport in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    private var database = Firestore.firestore()
    
    func updateStoreReportIsUseful() {
        if let documentId = self.storeReport.id {
            do {
                try database.collection("StoreReport")
                    .document(documentId)
                    .setData(from: self.storeReport)
                
                //TODO: 유저가 유용한 정보를 제공했다는 사실이 있으니 등급업해줘야 함
            }
            catch {
                print(error)
            }
            
        }
    }
    
    private func removeStoreReport() {
        if let documentId = self.storeReport.id {
            database.collection("StoreReport").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    
}
