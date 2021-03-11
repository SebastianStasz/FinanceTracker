//
//  CashFlowChartView.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/03/2021.
//

import SwiftUI
import CoreData

struct CashFlowChartView<T: CashFlowProtocol, CFC: CashFlowCategory>: View {
    let chartData: HorizontalChartData
    let title = T.type + "s"
    var mainColor: Color {
        T.self == Income.self ? .green : .red
    }

    var body: some View {
        if !chartData.values.isEmpty {
            CustomChartView(data: chartData,
                            title: title,
                            titleColor: mainColor,
                            barPrimaryColor: mainColor.opacity(0.6),
                            barSecondaryColor: Color.gray.opacity(0.5))
                .padding(20)
        }
    }

    init(wallet: Wallet, categories: [CFC], context: NSManagedObjectContext) {
        let date = DateSelector()
        var values: [Double] = []
        
        for category in categories {
            let predicate = NSPredicate(
                format: "%K == %@ && %K == %@ && %K >= %@ && %K <= %@",
                "wallet_", wallet,
                "category_.name_", category.name,
                "date_", date.monthRange[0] as NSDate,
                "date_", date.monthRange[1] as NSDate
            )
            
            let request = NSFetchRequest<T>(entityName: T.type)
            request.predicate = predicate
            let result = try! context.fetch(request)
            
            let resultValues = result.map { $0.value }.reduce(0, +)
            values.append(resultValues)
        }
        
        let categoriesData = zip(categories, values)
            .filter { $0.0.showInHomeView }
            .map { ChartValue(name: $0.name, value: $1) }
        let chartData = HorizontalChartData(values: categoriesData, givenTotal: values.reduce(0, +))
        self.chartData = chartData
    }
}
