//
//  bikenatorApp.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 04/03/24.
//

import SwiftUI
import HealthKit
import HealthKitUI
import os

private let logger = Logger(subsystem: "br.com.zaltron.bikenator",
                            category: "iOS App")


@main
struct bikenatorApp: App {

    @StateObject var healthKitManager = HealthKitManager.shared
    
    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(healthKitManager: healthKitManager)
        }
    }
}

