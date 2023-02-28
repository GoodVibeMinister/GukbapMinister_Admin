//
//  StoreInfoDetailView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI


enum Mode {
    case new
    case edit
}

enum Action {
    case delete
    case done
    case cancel
}


struct StoreInfoDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var scheme
    
    @StateObject var manager = StoreInfoManager()
    
    //About Update Or Add A Menu
    @State private var showMenuEditor: Bool = false
    @State private var showMenuAdder: Bool = false
    @State private var selectedMenu: String = ""
    @State private var menuPrice: String = ""
    
    
    @State private var showDeleteAlert: Bool = false
    
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    

    func handleDoneTapped() {
        self.manager.handleDoneTapped()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "추가하기" : "수정완료")
        }
        .disabled(!manager.modified)
    }
    
    
    var body: some View {
        NavigationStack{
            List {
                storeNameAndAddress
                
                if mode == .edit {
                    storeEvaluation
                }
                
                storeDescription
                
                storeFoodTypes
                
                storeMenus
                
                EditImagesView(manager: manager)
                
                if mode == .edit {
                    Section {
                        Button {
                            showDeleteAlert = true
                        } label: {
                            Text("가게정보 영구삭제")
                        }
                        .alert("가게정보 영구삭제", isPresented: $showDeleteAlert) {
                            Button("취소") {
                                showDeleteAlert = false
                            }
                            Button("영구삭제") {
                                manager.handleDeleteTapped()
                                showDeleteAlert = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        } message: {
                            Text(
                             """
                             정말로 삭제하시겠습니까?
                             한번 삭제한 가게정보는 되돌릴 수 없습니다.
                             """
                            )
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton
            }
        }
        .navigationBarBackButtonHidden(manager.modified)
    }
    
    var storeNameAndAddress: some View {
        Section {
            HStack {
                Text("상호")
                    .font(.headline)
                Divider()
                TextField("상호명", text: $manager.storeInfo.storeName)
            }
            
            NavigationLink {
                EditAddressView(manager: manager)
            } label: {
                HStack {
                    Text("주소")
                        .font(.headline)
                    Divider()
                    Text(manager.storeInfo.storeAddress)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            latlong
        } header: {
            Text("가게명, 주소")
        }
    }
    var latlong: some View {
        GeometryReader { geo in
            HStack {
                HStack {
                    Text("위도")
                        .font(.headline)
                    Divider()
                    Text("\(manager.storeInfo.coordinate.latitude)")
                }
                
                
                HStack {
                    Text("경도")
                        .font(.headline)
                    Divider()
                    Text("\(manager.storeInfo.coordinate.longitude)")
                }
                
                Spacer()
                
            }
        }
        .foregroundColor(.secondary)
    }
    var storeEvaluation: some View {
        Section {
            HStack {
                Spacer()
                Group {
                    Image("Ggakdugi")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .padding(.leading)
                    Text(String(format: "%.2f", manager.storeInfo.countingStar))
                        .padding(.trailing)
                }
                
                Divider()
                
                Group {
                    Image(systemName: "suit.heart.fill")
                        .padding(.leading)
                    Text("\(manager.storeInfo.likes)")
                        .padding(.trailing)
                }
                
                Divider()
                
                Group {
                    Image(systemName: "eye.fill")
                        .padding(.leading)
                    Text("\(manager.storeInfo.hits)")
                        .padding(.trailing)
                }
                Spacer()
            }
            .font(.caption)
        } header: {
            Text("가게평가")
        }
    }
    var storeDescription: some View {
        Section {
            TextEditor(text: $manager.storeInfo.description)
                .frame(height: 120)
        } header: {
            Text("가게설명")
        }
    }
    var storeFoodTypes: some View {
        Section {
            ForEach(manager.storeInfo.foodType, id: \.self) { gukbap in
                Text(gukbap)
                    .contextMenu {
                        Button("삭제", role: .destructive) {
                            if let index = manager.storeInfo.foodType.firstIndex(of: gukbap) {
                                manager.storeInfo.foodType.remove(at: index)
                            }
                        }
                    }
            }
            Menu {
                ForEach(Gukbaps.allCases) { gukbap in
                    if gukbap != .전체 {
                        Button("\(gukbap.rawValue)") {
                            manager.storeInfo.foodType.append(gukbap.rawValue)
                        }
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Label("국밥종류 추가하기", systemImage: "plus.circle")
                        .font(.subheadline)
                    Spacer()
                }
            }
            
        } header: {
            Text("국밥종류")
        }
    }
    var storeMenus: some View {
        Section {
            ForEach(manager.storeInfo.menu.sorted(by: >), id: \.key) { menu, price in
                Button {
                    selectedMenu = menu
                    menuPrice = price
                    showMenuEditor = true
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                        Group {
                            Text(menu)
                            Spacer()
                            Text(price)
                        }
                        .foregroundColor(scheme == .light ? .black : .white)
                    }
                }
            }
            .disabled(mode == .new)
            .sheet(isPresented: $showMenuEditor) {
                MenuEditor(manager: manager, presentSheet: $showMenuEditor, menu: selectedMenu, price: menuPrice)
            }
            
            Button {
                showMenuAdder = true
            } label: {
                HStack {
                    Spacer()
                    Label("메뉴 추가하기", systemImage: "plus.circle")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    Spacer()
                }
            }
            .sheet(isPresented: $showMenuAdder) {
                MenuEditor(manager: manager, presentSheet: $showMenuAdder, mode: .new)
            }
        } header: {
            Text("가게메뉴")
        }
    }
}





struct StoreInfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreInfoDetailView()
    }
}
