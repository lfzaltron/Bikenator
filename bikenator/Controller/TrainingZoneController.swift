//
//  TrainingZoneController.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 13/03/24.
//

import Foundation

enum TrainingZone {
    case VO2Max, Anaerobic, Aerobic, Endurance, Recovery
    var zone: String {
        switch self {
        case .VO2Max:
            return "VO2Max"
        case .Anaerobic:
            return "Anaerobic"
        case .Aerobic:
            return "Aerobic"
        case .Endurance:
            return "Endurance"
        case .Recovery:
            return "Recovery"
        }
    }
    var description: String {
        switch self {
        case .VO2Max:
            return "Develops maximum performance and speed"
        case .Anaerobic:
            return "Increases maximum performance capacity"
        case .Aerobic:
            return "Improves aerobic fitness"
        case .Endurance:
            return "Improves basic endurance and fat burning"
        case .Recovery:
            return "Improves overall health and helps recovery"
        }
    }
    var color: String {
        switch self {
        case .VO2Max:
            return "red"
        case .Anaerobic:
            return "orange"
        case .Aerobic:
            return "yellow"
        case .Endurance:
            return "green"
        case .Recovery:
            return "aqua"
        }
    }
}

class TrainingZoneController: ObservableObject {
    static let shared = TrainingZoneController()
    
    private init() {
        
    }
    
    func getCurrentEffort() -> Double {
        let currentHeartRate = HealthKitManager.shared.currentHeartRate
        let test = UserController()
        
        let age = test.age // UserController.shared.age
        return (currentHeartRate * 100) / Double((220-age));
    }
    
    func getCurrentTrainingZone() -> TrainingZone {
        let currentEffort = getCurrentEffort()
        
        if currentEffort >= 90 {
            return .VO2Max
        }
        if currentEffort >= 80 {
            return .Anaerobic
        }
        if currentEffort >= 70 {
            return .Aerobic
        }
        if currentEffort >= 60 {
            return .Endurance
        }
        return .Recovery
    }
    
}
