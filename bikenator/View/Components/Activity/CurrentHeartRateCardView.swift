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
            // MARK: Heart Rate
            Text("Heart Rate")
                .fontWeight(.medium)
                .foregroundColor(.gray)
            VStack {
                HStack(alignment: .bottom, spacing: 0) {
                    Text("\(Int(healthKitManager.currentHeartRate))")
                        .font(.system(size: 72, weight: .bold))
                        .padding(.leading, 20)
                    Image(systemName: "heart")
                        .padding(.bottom, 14).padding(.leading, -2)
                }
                .padding(.bottom, 16)
            }
            
            let currentEffort = healthKitManager.getCurrentEffort()
            let trainingZone = healthKitManager.getCurrentTrainingZone()
            
            // MARK: Effort dashboard
            Text("Training zone")
                .fontWeight(.medium)
                .foregroundColor(.gray)
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .frame(width: barWidth)
                HStack {
                    // Progress
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(trainingZone.color))
                        .frame(width: CGFloat(currentEffort/100) * barWidth)
                        .foregroundColor(.pink)
                        .animation(.spring(), value: CGFloat(currentEffort/100)  * barWidth)
                    
                    if !(CGFloat(currentEffort/100) * barWidth == barWidth) {
                        Spacer()
                    }
                }
                
                HStack(alignment: .bottom, spacing: 0) {
                    Text("\(Int(currentEffort))")
                        .padding(.leading, 12)
                        .foregroundColor(
                            .black.opacity(0.6)
                        )
                    Text(" %").font(.caption2)
                    Spacer()
                    Text("\(trainingZone.zone)")
                        .padding(.trailing, 12)
                        .foregroundColor(
                            .black.opacity(0.6)
                        )
                }.foregroundColor(
                    .black.opacity(0.6)
                )
                .fontWeight(.semibold)
                
            }.frame(width: barWidth, height: 36)
            
            Text("\(trainingZone.detail)").font(.caption2).foregroundColor(.gray)
            
        }.frame(width: 361, height: 460)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
            )
    }
    
}

#Preview {
    CurrentHeartRateCardView(healthKitManager: HealthKitManager.shared)
}
