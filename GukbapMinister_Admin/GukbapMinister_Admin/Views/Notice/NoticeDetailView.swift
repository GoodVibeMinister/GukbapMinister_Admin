//
//  NoticeDetailView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/03/07.
//

import SwiftUI

struct NoticeDetailView: View {
    @Environment(\.colorScheme) var scheme
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var manager = NoticeManager()
    @State private var showDeleteAlert: Bool = false
    
    var mode: Mode = .edit
    
    func handleDoneTapped() {
        self.manager.handleDoneTapped()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss()}) {
            Text("취소")
        }
    }
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "추가하기" : "수정완료")
        }
        .disabled(!manager.modified)
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("공지제목", text: $manager.notice.title)
                } header: {
                    Text("공지제목")
                }
                
                Section {
                    TextEditor(text: $manager.notice.contents)
                        .frame(height: 200)
                } header: {
                    Text("공지내용")
                }
                
                if mode == .edit {
                    deleteButton
                }
                
            }
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    var deleteButton: some View {
        Section {
            Button {
                showDeleteAlert = true
            } label: {
                Text("공지 삭제")
                    .foregroundColor(.red)
            }
            .alert("공지 삭제", isPresented: $showDeleteAlert) {
                Button("취소") {
                    showDeleteAlert = false
                }
                Button {
                    manager.handleDeleteTapped()
                    showDeleteAlert = false
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("영구삭제")
                        .foregroundColor(.red)
                }
            } message: {
                Text(
                     """
                     정말로 공지사항을 삭제하시겠습니까?
                     """
                )
            }
        }
    }
}

struct NoticeManagementDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeDetailView()
    }
}
