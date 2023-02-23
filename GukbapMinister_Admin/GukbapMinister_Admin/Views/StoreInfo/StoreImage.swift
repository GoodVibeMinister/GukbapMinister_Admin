//
//  StoreImage.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//
import SwiftUI
import Combine

import FirebaseStorage

final class Loader : ObservableObject {
    let didChange = PassthroughSubject<Data?, Never>()
    var data: Data? = nil {
        didSet { didChange.send(data) }
    }
    
    init(_ storeName: String, imageId: String){
        let url = "storeImages/\(storeName)/\(imageId)"
        let storage = Storage.storage()
        let ref = storage.reference().child(url)
        ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error)")
            }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

let placeholder = UIImage(systemName: "photo.fill.on.rectangle.fill")!

struct StoreImage : View {
    @ObservedObject private var imageLoader : Loader
    
    init(storeName: String, imageId: String) {
        self.imageLoader = Loader(storeName, imageId: imageId)
    }
    
    
    var image: UIImage? {
        imageLoader.data.flatMap(UIImage.init)
    }
  
    var body: some View {
        Image(uiImage: image ?? placeholder)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
    }
}
