//
//  HealthKitManager.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 05/03/24.
//

import Foundation
import HealthKit

let healthDataTypes: Set = [
    HKQuantityType(.heartRate)
]

class HealthKitManager: ObservableObject {
    var healthStore = HKHealthStore()
    
    @Published var currentHeartRate: Double = 0
    var age = 33 //TODO: remove
    
    static let shared = HealthKitManager()
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        healthStore.requestAuthorization(toShare: [], read: healthDataTypes) { success, error in
            if success {
                self.fetchAllDatas()
            } else {
                print("HealthKit authorization denied.")
            }
        }
    }
    
    func fetchAllDatas() {
        startMonitoringHeartRateUpdates()
    }
    
    func startMonitoringHeartRateUpdates() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available.")
            return
        }
        
        // Define the heart rate type
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            print("Heart rate type is not available.")
            return
        }
        
        // Create an observer query to listen for heart rate updates
        let observerQuery = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, error) in
            if let error {
                print("Observer query returned an error: \(error.localizedDescription)")
                return
            }
            
            // Fetch the most recent heart rate
            self.fetchLatestHeartRate { (heartRate, error) in
                if let error {
                    print("Error fetching heart rate: \(error.localizedDescription)")
                    return
                }
                
                if let heartRate {
                    print("Latest heart rate: \(heartRate) bpm")
                    DispatchQueue.main.async {
                        self.currentHeartRate = heartRate
                    }
                } else {
                    print("Heart rate not available.")
                }
            }
            
            // Call the completion handler to signal that the query has completed
            completionHandler()
        }
        
        // Add the observer query to the health store
        healthStore.execute(observerQuery)
        
        // Enable background delivery for heart rate updates
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
            if let error = error {
                print("Error enabling background delivery: \(error.localizedDescription)")
            } else {
                print("Background delivery enabled for heart rate updates.")
            }
        }
    }
    
    func fetchLatestHeartRate(completion: @escaping (Double?, Error?) -> Void) {
        // Create a query for the most recent heart rate sample
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let query = HKStatisticsQuery(quantityType: heartRateType, quantitySamplePredicate: predicate, options: .mostRecent) { (query, result, error) in
            guard let result, let lastHeartRate = result.mostRecentQuantity() else {
                completion(nil, error)
                return
            }
            
            // Convert the last heart rate to beats per minute (bpm)
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            let heartRate = lastHeartRate.doubleValue(for: heartRateUnit)
            completion(heartRate, nil)
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    func getCurrentEffort() -> Double {
        return (currentHeartRate * 100) / Double((220-age));
    }
    
    let trainingZones = [(zone: "VO2Max", detail: "Develops maximum performance and speed", color: "red"),
                         (zone: "Anaerobic", detail: "Increases maximum performance capacity", color: "orange"),
                         (zone: "Aerobic", detail: "Improves aerobic fitness", color: "yellow"),
                         (zone: "Endurance", detail: "Improves basic endurance and fat burning", color: "green"),
                         (zone: "Recovery", detail: "Improves overall health and helps recovery", color: "aqua")]
    func getCurrentTrainingZone() -> (zone: String, detail: String, color: String ) {
        let currentEffort = getCurrentEffort()
        
        if currentEffort >= 90 {
            return trainingZones[0]
        }
        if currentEffort >= 80 {
            return trainingZones[1]
        }
        if currentEffort >= 70 {
            return trainingZones[2]
        }
        if currentEffort >= 60 {
            return trainingZones[3]
        }
        return trainingZones[4]
    }
}
