//
//  NoticeManager.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/07.
//
import Foundation
import Combine

import Firebase
import FirebaseFirestore
import FirebaseStorage

final class NoticeManager: ObservableObject {
    @Published var notice: Notice
    @Published var modified = false
    
    private var cancellables = Set<AnyCancellable>()
    private var database = Firestore.firestore()
    
    init(notice: Notice = Notice(title: "", contents: "")) {
        self.notice = notice
        
        self.$notice
            .dropFirst()
            .sink { [weak self] notice in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    private func addNotice() {
        do {
            let _ = try database.collection("Notice")
                .addDocument(from: self.notice)
        }
        catch {
            print(error)
        }
    }
    
    private func updateNotice() {
        if let documentId = self.notice.id {
            do {
                try database.collection("Notice")
                    .document(documentId)
                    .setData(from: self.notice)
            }
            catch {
                print(error)
            }
        }
    }
    
    private func removeNotice() {
        if let documentId = self.notice.id {
            database.collection("Notice").document(documentId).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - UI Handler
    
    func handleDoneTapped() {
        if let _ = self.notice.id {
            updateNotice()
        } else {
            addNotice()
        }
    }
    
    func handleDeleteTapped() {
        removeNotice()
    }
}
