//
//  CryptoChartView.swift
//  CryptoApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 31/01/25.
//


import SwiftUI
import Charts

/// Represents different types of charts available for displaying cryptocurrency data.
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
            Text(CryptoLocalizedStrings.price_trend)
                .font(.headline)
                .padding(.top)
            Picker(CryptoLocalizedStrings.select_chart_type, selection: $selectedChart) {
                ForEach(ChartType.allCases, id: \.self) { chart in
                    Text(chart.rawValue).tag(chart)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Chart {
                switch selectedChart {
                case .line:
                    /// Loops through the `priceHistory` array to create an area chart visualization.
                    ForEach(priceHistory) { point in
                        /// Creates an `LineMark` for each historical price data point.
                        LineMark(
                            x: .value("Date", point.date),// Sets the x-axis to represent dates
                            y: .value("Price", point.price) // Sets the y-axis to represent prices
                        )
                        .foregroundStyle(Color.init(hex: "B400FB"))
                        .interpolationMethod(.monotone)// Uses a smooth curve interpolation for better visualization
                    }
                case .area:
                    /// Loops through the `priceHistory` array to create an area chart visualization.
                    ForEach(priceHistory) { point in
                        /// Creates an `AreaMark` for each historical price data point.
                        AreaMark(
                            x: .value("Date", point.date),   // Sets the x-axis as the date of the price point.
                            y: .value("Price", point.price)  // Sets the y-axis as the corresponding price.
                        )
                        .foregroundStyle(Gradient(colors: [.blue.opacity(0.6), .clear]))
                        .interpolationMethod(.monotone) // Applies a smooth curve between data points for a better visual flow.
                    }
                case .bar:
                    ForEach(priceHistory) { point in
                        BarMark(
                            x: .value("Date", point.date),
                            y: .value("Price", point.price)
                        )
                        .foregroundStyle(Color.init(hex: "4682B4"))
                    }
                case .scatter:
                    ForEach(priceHistory) { point in
                        PointMark(
                            x: .value("Date", point.date),
                            y: .value("Price", point.price)
                        )
                        .foregroundStyle(Color.init(hex: "edff21"))
                    }
                }
            }
            .frame(height: 250)
            .padding()
        }
    }
}
