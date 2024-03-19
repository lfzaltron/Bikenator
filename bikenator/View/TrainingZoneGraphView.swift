//
//  TrainingZoneGraphView.swift
//  bikenator
//
//  Created by Luis Fernando Zaltron on 18/03/24.
//

import SwiftUI
import Charts



struct EffortData: Identifiable {
    let id = UUID()
    let date: Date
    let effort: Int
    
    static func mockData() -> [EffortData] {
        return [
            .init(date: Date(timeIntervalSinceNow: 60), effort: 67),
            .init(date: Date(timeIntervalSinceNow: 120), effort: 70),
            .init(date: Date(timeIntervalSinceNow: 130), effort: 85),
            .init(date: Date(timeIntervalSinceNow: 140), effort: 88),
            .init(date: Date(timeIntervalSinceNow: 150), effort: 94),
            .init(date: Date(timeIntervalSinceNow: 160), effort: 104),
            .init(date: Date(timeIntervalSinceNow: 170), effort: 118),
            .init(date: Date(timeIntervalSinceNow: 180), effort: 121),
            .init(date: Date(timeIntervalSinceNow: 190), effort: 126),
            .init(date: Date(timeIntervalSinceNow: 200), effort: 134),
            .init(date: Date(timeIntervalSinceNow: 210), effort: 150),
            .init(date: Date(timeIntervalSinceNow: 220), effort: 160),
            .init(date: Date(timeIntervalSinceNow: 230), effort: 180),
            .init(date: Date(timeIntervalSinceNow: 240), effort: 184),
            .init(date: Date(timeIntervalSinceNow: 300), effort: 120),
            .init(date: Date(timeIntervalSinceNow: 360), effort: 113),
        ]
    }
}

struct TrainingZoneGraphView: View {
    
    @State private var overallData = EffortData.mockData()
    
    private let zonesEdges = [100, 120, 140, 160, 188]
    private var areaBackground: LinearGradient {
        return LinearGradient(colors: [Color(.red), Color(.green), Color(.blue), Color(.blue).opacity(0.3), Color(.blue).opacity(0.1)], startPoint: .top, endPoint: .bottom)
        // return Gradient(colors: [Color(.red), Color(.green), Color(.blue), Color(.blue).opacity(0.3), Color(.red).opacity(0.1)])
    }
    
    var body: some View {
        Chart(overallData) {
            LineMark(
                x: .value("Time", $0.date, unit: .second),
                y: .value("Effort", $0.effort)
            )
            .foregroundStyle(areaBackground)
            //            .symbol(.circle)
            .interpolationMethod(.catmullRom)
            
            
            AreaMark(
                x: .value("Month", $0.date, unit: .second),
//                y: .value("Amount", $0.effort)
                yStart: .value("Effort", $0.effort),
                yEnd: .value("minEffort", 40)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(areaBackground)
        }
        .chartYAxis {
            AxisMarks(
                //              format: Decimal.FormatStyle.Percent.percent.scale(1),
                values: zonesEdges
            ) {
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .minute, count: 1)) { _ in
                AxisValueLabel(format: .dateTime.second().minute(), centered: true)
            }
        }
        .chartYScale(domain: 40 ... 200)
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    TrainingZoneGraphView()
}
