//
//  CryptoChartView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 31/01/25.
//


import SwiftUI
import Charts

enum ChartType: String, CaseIterable {
    case line = "Line Chart"
    case area = "Area Chart"
    case bar = "Bar Chart"
    case scatter = "Scatter Plot"
}


struct CryptoChartView: View {
    @Binding var priceHistory: [PricePoint]
    @State private var selectedChart: ChartType = .line
    
    var body: some View {
        VStack {
            Text("Price Trend")
                .font(.headline)
                .padding(.top)
            Picker("Select Chart Type", selection: $selectedChart) {
                ForEach(ChartType.allCases, id: \.self) { chart in
                    Text(chart.rawValue).tag(chart)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Chart {
                switch selectedChart {
                case .line:
                    ForEach(priceHistory) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Price", point.price)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.monotone)
                    }
                    
                case .area:
                    ForEach(priceHistory) { point in
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Price", point.price)
                        )
                        .foregroundStyle(Gradient(colors: [.blue.opacity(0.6), .clear]))
                        .interpolationMethod(.monotone)
                    }
                    
                case .bar:
                    ForEach(priceHistory) { point in
                        BarMark(
                            x: .value("Date", point.date),
                            y: .value("Price", point.price)
                        )
                        .foregroundStyle(.blue)
                    }
                case .scatter:
                    ForEach(priceHistory) { point in
                        PointMark(
                            x: .value("Date", point.date),
                            y: .value("Price", point.price)
                        )
                        .foregroundStyle(.blue)
                    }
                }
            }
            .frame(height: 250)
            .padding()
        }
        .onAppear {
            print("priceHistory: \(self.priceHistory.count)")
        }
    }
    func formatDate(_ value: Any) -> String {
        guard let date = value as? Date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}
