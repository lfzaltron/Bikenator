//
//  ContentView.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 04/03/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var healthKitManager: HealthKitManager
    
    var body: some View {
        ActivityView(healthKitManager: healthKitManager)
            .onAppear {
                healthKitManager.requestAuthorization()
            }
    }
    
}

#Preview {
    ContentView(healthKitManager: HealthKitManager.shared)
}
