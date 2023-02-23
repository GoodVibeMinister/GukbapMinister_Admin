//
//  StoreInfosManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import Foundation
import UIKit

import Firebase
import FirebaseFirestore

final class StoreInfosManager: ObservableObject {
    @Published var stores: [Store] = []
    
    private var database = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func unsubscribeStoreInfos() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeStoreInfos() {
        if listenerRegistration == nil {
            listenerRegistration =  database.collection("Store")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("There are no documents")
                        return
                    }
                    self.stores = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Store.self)
                    }
                }
        }
    }
    
}
