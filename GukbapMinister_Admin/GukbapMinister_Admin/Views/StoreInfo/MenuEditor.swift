//
//  MenuEditor.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/25.
//

import SwiftUI

struct MenuEditor: View {
    @ObservedObject var manager: StoreInfoManager
    @Binding var presentSheet: Bool
    var menu: String = ""
    var price: String = ""
    var mode: Mode = .edit
    
    
    @State private var newMenu: String = ""
    @State private var newPrice: String = ""
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        presentSheet = false
                    } label: {
                        Text("취소")
                    }
                    Spacer()
                    
                    if mode == .edit {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text("메뉴삭제")
                        }
                        .alert("메뉴삭제", isPresented: $showDeleteAlert) {
                            Button("취소") {
                                showDeleteAlert = false
                            }
                            Button("삭제하기") {
                                Task {
                                    manager.storeInfo.menu.removeValue(forKey: menu)
                                    showDeleteAlert = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        presentSheet = false
                                    }
                                }
                            }
                        } message: {
                            Text("정말로 메뉴를 삭제하시겠습니까?")
                        }
                    }

                    Button {
                        if mode == .edit {
                            manager.storeInfo.menu.removeValue(forKey: menu)
                        }
                        manager.storeInfo.menu[newMenu] = newPrice
                        presentSheet = false
                    } label: {
                        Text(mode == .new ? "추가하기": "수정완료")
                    }
                    .disabled(newMenu == "" || newPrice == "")
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                Form {
                    HStack {
                        Text("메뉴")
                        TextField(menu, text: $newMenu )
                        Divider()
                        Text("가격")
                        TextField(price, text: $newPrice)
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
            }
        }
        .presentationDetents([.height(200)])
    }
}


