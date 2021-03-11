//
//  CustomChartView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 09/03/2021.
//

import SwiftUI

struct HorizontalChartData {
    let values: [ChartValue]
    let givenTotal: Double?
    
    var totalFromValues: Double {
        values.map { $0.value }.reduce(0, +)
    }
    
    var total: Double {
        givenTotal != nil ? givenTotal! : totalFromValues
    }
    
    func getPercentage(of value: Double) -> String {
        (value / total).toPercentage()
    }
    
    init(values: [ChartValue], givenTotal: Double? = nil) {
        self.values = values
        self.givenTotal = givenTotal
    }
    
    static let sampleData = HorizontalChartData(values: ChartValue.sampleData)
}

struct ChartValue: Identifiable {
    let name: String
    let value: Double
    let id = UUID()
    
    static let sampleData = [ChartValue(name: "Food", value: 1000), ChartValue(name: "Hobby", value: 545), ChartValue(name: "Hyginene And something", value: 120), ChartValue(name: "Charity", value: 54)]
}

extension Double {
    func toPercentage() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(for: self)!
    }
}

struct CustomChartView: View {
    let chartData: HorizontalChartData
    let title: String
    
    let titleColor: Color
    let barHeight: CGFloat
    let barSecondaryColor: Color
    let barPrimaryColor: Color
    let barSpacing: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: barSpacing) {
            if !title.isEmpty {
                Text(title)
                    .font(.title3)
                    .foregroundColor(titleColor)
            }
            ForEach(chartData.values, content: charRow)
        }
    }
    
    private func charRow(for data: ChartValue) -> some View {
        HStack {
            Text(chartData.getPercentage(of: data.value))
                .frame(width: 45, alignment: .trailing)
            
            GeometryReader { geo in
                Rectangle()
                    .foregroundColor(barSecondaryColor)
                    .overlay(ChartBar(width: getWidth(for: data.value, width: geo.size.width), color: barPrimaryColor))
            }
            .frame(height: barHeight)
            .cornerRadius(90)
            
            Text(data.name)
                .lineLimit(1)
                .frame(maxWidth: 70, alignment: .leading)
        }
    }
    
    private func getWidth(for value: Double, width: CGFloat) -> CGFloat {
        if chartData.total > 0 && value > 0 {
            return CGFloat(value / chartData.total) * width
        } else { return 0 }
    }
}

extension CustomChartView {
    init(data: HorizontalChartData,
         title: String = "",
         titleColor: Color = .primary,
         barHeight: CGFloat = 10,
         barPrimaryColor: Color = .primary,
         barSecondaryColor: Color = .secondary,
         barSpacing: CGFloat = 13) {
        
        self.chartData = data
        self.title = title
        self.titleColor = titleColor
        self.barHeight = barHeight
        self.barPrimaryColor = barPrimaryColor
        self.barSecondaryColor = barSecondaryColor
        self.barSpacing = barSpacing
    }
}

struct ChartBar: View {
    let width: CGFloat
    let color: Color
    
    @State private var slideAnimation = false
    
    var body: some View {
        Rectangle()
            .frame(width: width)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(color)
            .offset(x: slideAnimation ? 0 : -80)
            .animation(.linear(duration: duration))
            .onAppear() { withAnimation {
                slideAnimation = true
                }
            }
    }
    
    var duration: Double {
        let result = width > 100 ? width / 200 : width / 80
        return Double(result)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let data = HorizontalChartData.sampleData
        Group {
            CustomChartView(data: data)
                .preferredColorScheme(.dark)
//            CustomChartView(data: data)
//                .previewDevice("iPhone SE (2nd generation)")
        }
        .padding(10)
    }
}
