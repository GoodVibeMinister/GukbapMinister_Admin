//
//  StoreInfoDetailView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI
import SDWebImageSwiftUI

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
    
    //About Editing Menu
    @State private var showingMenuEditor: Bool = false
    @State private var selectedMenu: String = ""
    @State private var menuPrice: String = ""
  
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    
    
    
    
    func handleDoneTapped() {
        self.manager.handleDoneTapped()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    var saveButton: some View {
        Button(action: { self.handleDoneTapped() }) {
            Text(mode == .new ? "추가하기" : "수정사항 저장")
        }
        .disabled(!manager.modified)
    }
    
    
    var body: some View {
        NavigationStack{
            List {
                infoOnMap
                
                Section {
                    TextEditor(text: $manager.storeInfo.description)
                        .frame(height: 120)
                } header: {
                    Text("가게설명")
                }
                
                Section {
                    ForEach(manager.storeInfo.menu.sorted(by: >), id: \.key) { menu, price in
                        Button {
                            selectedMenu = menu
                            menuPrice = price
                            showingMenuEditor = true
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
                } header: {
                    Text("가게메뉴")
                }
                .sheet(isPresented: $showingMenuEditor) {
                    MenuEditor(manager: manager, presentSheet: $showingMenuEditor, menu: selectedMenu, price: menuPrice)
                }
                
                
                if manager.storeImageUrls.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            //TODO: 사진 추가하기
                        } label: {
                            VStack {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .padding()
                                Text("사진추가하기")
                            }
                        }
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(manager.storeImageUrls, id: \.self) { imageURL in
                                //이렇게 사용하는 이유는 권고사항이기 때문
                                //https://github.com/SDWebImage/SDWebImageSwiftUI#common-problems
                                StoreImageView(imageURL: imageURL)
                            }
                            
                            Button {
                                //TODO: 사진 추가하기
                            } label: {
                                VStack {
                                    Image(systemName: "plus.circle")
                                        .font(.title)
                                        .padding()
                                    Text("사진추가하기")
                                }
                            }
                        }
                    }
                    .frame(height: 120)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton
            }
        }
        
    }
    
}


extension StoreInfoDetailView {
    var infoOnMap: some View {
        Section {
            HStack {
                Text("상호명")
                    .font(.headline)
                TextField("상호명", text: $manager.storeInfo.storeName)
            }
            
            HStack {
                Text("주소")
                    .font(.headline)
                TextField("주소", text: $manager.storeInfo.storeAddress)
            }
            
            latlong
            
          
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
                .frame(width: geo.size.width / 2)
                
                Spacer()
                
                HStack {
                    Text("경도")
                        .font(.headline)
                    Divider()
                    Text("\(manager.storeInfo.coordinate.longitude)")
                }
                .frame(width: geo.size.width / 2)
            }
        }
        .foregroundColor(.secondary)
    }
}




struct StoreImageView: View {
    var imageURL: URL
    var body: some View {
        VStack{
            WebImage(url: imageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
        }
        .padding()
        
    }
}

struct StoreInfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreInfoDetailView()
    }
}
