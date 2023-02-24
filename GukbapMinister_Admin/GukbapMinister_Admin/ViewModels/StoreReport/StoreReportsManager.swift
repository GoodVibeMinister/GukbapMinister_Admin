//
//  StoreReportsManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import Firebase
import FirebaseFirestore

final class StoreReportsMananger: ObservableObject {
    @Published var storeReports: [StoreReport] = [] {
        willSet(newValue) {
            usefulReports = newValue.filter { $0.isUseful }
            uselessReports = newValue.filter { !$0.isUseful }
        }
    }
    @Published var usefulReports: [StoreReport] = []
    @Published var uselessReports: [StoreReport] = []
    
    private var database = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func unsubscribeStoreReports() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeStoreReports() {
        if listenerRegistration == nil {
            listenerRegistration =  database.collection("StoreReport")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("There are no documents")
                        return
                    }
                    self.storeReports = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: StoreReport.self)
                    }
                }
        }
    }
    
    
    func removeStoreReport(atOffsets indexSet: IndexSet, isUseful: Bool) {
        let storeReports = indexSet.lazy.map {
            if isUseful {
                return self.usefulReports[$0]
            } else {
                return self.uselessReports[$0]
            }
        }
        
        storeReports.forEach { storeReport in
            if let documentId = storeReport.id {
                database.collection("StoreReport").document(documentId).delete { error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    
}
