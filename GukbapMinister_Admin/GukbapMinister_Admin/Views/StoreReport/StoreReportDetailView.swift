//
//  StoreReportDetailView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct StoreReportDetailView: View {
    @ObservedObject var manager: StoreReportManager = StoreReportManager()
    @State private var selection: Int = 1
    
    var body: some View {
        List {
            VStack(alignment: .leading){
                Text(manager.storeReport.storeName)
                    .font(.headline)
                    .padding(.bottom, 2)
                Text(manager.storeReport.storeAddress)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                Text(manager.storeReport.description)
                    .font(.caption)
            }
            
            Toggle(isOn: $manager.storeReport.isUseful) {
                Text("유용한 정보입니까?")
                    .font(.subheadline)
            }
            .onChange(of: manager.storeReport.isUseful) { _ in
                manager.updateStoreReportIsUseful()
            }

        }
    }
    
 
}

struct StoreReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreReportDetailView(manager: StoreReportManager(storeReport: StoreReport(userId: "", storeName: "가게이름", storeAddress: "가게주소", foodType: ["순대국밥"], description: "가게설명", isUseful: false)))
    }
}
