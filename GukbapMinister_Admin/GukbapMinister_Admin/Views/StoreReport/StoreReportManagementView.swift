//
//  StoreReportManagementView.swift
//  GukbapMinister_Admin
//
//  Created by Martin on 2023/02/23.
//

import SwiftUI

struct StoreReportManagementView: View {
    @StateObject var reportsManager = StoreReportsMananger()
    var body: some View {
        NavigationStack{
            List {
                if !reportsManager.usefulReports.isEmpty {
                    Section {
                        ForEach(reportsManager.usefulReports) { report in
                            getlistElement(report)
                        }
                        .onDelete() { indexSet in
                            reportsManager.removeStoreReport(atOffsets: indexSet, isUseful: true)
                        }
                    } header: {
                        Text("유용한 제보")
                    }
                }
                
                if !reportsManager.uselessReports.isEmpty{
                    Section {
                        ForEach(reportsManager.uselessReports) { report in
                            getlistElement(report)
                        }
                        .onDelete() { indexSet in
                            reportsManager.removeStoreReport(atOffsets: indexSet, isUseful: false)
                        }
                    } header: {
                        Text("확인하지 않은 제보")
                    }
                }
            }// List Ended
        }
        .onAppear {
            reportsManager.subscribeStoreReports()
        }
        .onDisappear {
            reportsManager.unsubscribeStoreReports()
        }
        
    }
    
    @ViewBuilder
    private func getlistElement(_ report: StoreReport) -> some View {
        NavigationLink(destination: StoreReportDetailView(manager: StoreReportManager(storeReport: report))) {
            VStack(alignment: .leading) {
                Text(report.storeName)
                Text(report.storeAddress)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StoreReportManagementView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            StoreReportManagementView()
        }
    }
}
