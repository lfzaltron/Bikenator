//
//  CurrentHeartRateCardView.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 05/03/24.
//

import SwiftUI

struct CurrentHeartRateCardView: View {
    let barWidth = CGFloat(240)
    
    @ObservedObject var healthKitManager: HealthKitManager
    
    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
    
    var body: some View {
        VStack {
            Text("Heart Rate")
                .fontWeight(.medium)
                .foregroundColor(.gray)
            VStack {
                HStack(alignment: .bottom, spacing: 0) {
                    Text("\(healthKitManager.currentHeartRate)")
                        .font(.system(size: 72, weight: .bold))
                        .padding(.leading, 20)
                    Image(systemName: "heart")
                        .padding(.bottom, 14).padding(.leading, -2)
                }
                .padding(.bottom, -16)
            }
        }.frame(width: 361, height: 360)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            )
    }
    
}

#Preview {
    CurrentHeartRateCardView(healthKitManager: HealthKitManager.shared)
}
