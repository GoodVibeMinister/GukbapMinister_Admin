//
//  UsersManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/28.
//

import Foundation

import Firebase
import FirebaseFirestore

final class UsersManager: ObservableObject {
    @Published var users: [User] = []
    
    private var database = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    func unsubscribeUsers() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeUsers() {
        if listenerRegistration == nil {
            listenerRegistration =  database.collection("User")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("There are no documents")
                        return
                    }
                    self.users = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: User.self)
                    }
                }
        }
    }
    
}

