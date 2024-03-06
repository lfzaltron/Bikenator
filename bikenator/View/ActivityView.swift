//
//  ActivityView.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 05/03/24.
//

import SwiftUI

struct ActivityView: View {
    
    @ObservedObject var healthKitManager: HealthKitManager
    
    var body: some View {
        VStack {
            HStack {
                Text("Hey Luís!")
                    .font(.system(size: 36))
                    .fontWeight(.semibold)
                Spacer()
            }.padding(.horizontal).padding(.top, 12).padding(.bottom, 2)
            ScrollView {
                VStack {
                    CurrentHeartRateCardView(healthKitManager: healthKitManager)
                        .onAppear {
                            healthKitManager.fetchAllDatas()
                        }
                }
            }
        }.padding(.top, 16)
    }
}

#Preview {
    ActivityView(healthKitManager: HealthKitManager())
}
