//
//  SampleDataGenerator.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation
import CoreData

extension PersistenceController {
    
    // MARK: Sample data for preview
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let context = result.context
        
        try! context.save()
        return result
    }()
    
    static func generateData() {
        _ = generateSampleData(context: preview.context)
    }
}

// MARK: -- Data Generator

func generateSampleData(context: NSManagedObjectContext) -> [Wallet] {
    
    let request = NSFetchRequest<Currency>(entityName: "Currency")
    request.predicate = NSPredicate(format: "code_ == %@ || code_ == %@ || code_ == %@", "EUR", "PLN", "USD")
    let currenciesResult = try! context.fetch(request)
    
    let currencyEUR = currenciesResult.first { $0.code == "EUR" }
    let currencyPLN = currenciesResult.first { $0.code == "PLN" }
    let currencyUSD = currenciesResult.first { $0.code == "USD" }
    let currencies = [currencyEUR, currencyPLN, currencyUSD]
    
    func randomDate() -> Date {
        let months = [1, 2, 3]
        let days = Array(1...30)
        
        var components = DateComponents()
        components.day = days.randomElement()
        components.month = months.randomElement()
        components.year = 2021
        let date = Calendar.current.date(from: components)
        return date ?? Date()
    }
    
    func sampleIncomesAndExpenses(wallet: Wallet) {
        let income = Income(context: context)
        income.date_ = randomDate()
        income.category_ = incomeCategories.randomElement()
        income.value_ = (Double.random(in: 100...1000) * 100).rounded() / 100
        income.wallet_ = wallet
        
        let expense = Expense(context: context)
        expense.date_ = randomDate()
        expense.category_ = expenseCategories.randomElement()
        expense.value_ = (Double.random(in: 10...200) * 100).rounded() / 100
        expense.wallet_ = wallet
    }
    
    func sampleWallet(i: Int) -> Wallet {
        let w = Wallet(context: context)
        w.id = UUID()
        w.dateCreated_ = randomDate()
        w.name = walletNames[i]
        w.icon = walletIcons[i]
        w.iconColor = walletIconColors[i]
        w.type_ = walletTypes[i]
        w.initialBalance_ = (Double.random(in: 200...1000) * 100).rounded() / 100
        w.currency_ = currencies[Int.random(in: 0..<3)]
        
        // Create Incomes & Expenses
        for _ in 0..<20 {
            sampleIncomesAndExpenses(wallet: w)
        }
        
        return w
    }
    
    // Create Income Category
    let incomeCategoryNames = ["Payment", "Interest", "Gift", "Award"]
    var incomeCategories: [IncomeCategory] = []
    
    for name in incomeCategoryNames {
        let category = IncomeCategory(context: context)
        category.name_ = name
        incomeCategories.append(category)
    }
    
    // Create Expense Category
    let expenseCategoryNames = ["Food out", "Food", "Hobby", "Car", "Hygiene"]
    var expenseCategories: [ExpenseCategory] = []
    
    for name in expenseCategoryNames {
        let category = ExpenseCategory(context: context)
        category.name_ = name
        expenseCategories.append(category)
    }
    
    // Create Wallet Types
    let wt1 = WalletType(context: context)
    wt1.name = "Normal"
    let wt2 = WalletType(context: context)
    wt2.name = "Savings"
    let wt3 = WalletType(context: context)
    wt3.name = "Debit Card"
    let wt4 = WalletType(context: context)
    wt4.name = "Credit Card"
    let wt5 = WalletType(context: context)
    wt5.name = "Investment"
    let wt6 = WalletType(context: context)
    wt6.name = "Play"
    
    let walletTypes = [wt1, wt2, wt3, wt4, wt5, wt6]
    
    let walletNames = ["Main", "Car Expenses", "Bank Deposit", "Personal", "Cash", "Savings Account"]
    let walletIcons: [WalletIcon] = [.bag, .banknote, .cart, .bagCircle, .creditcard, .bagFill]
    let walletIconColors: [IconColor] = [.blue1, .gray, .green1, .orange, .pink, .yellow]
    
    var wallets = [Wallet]()
    
    // Create sample wallets
    for i in 0..<6 {
        wallets.append(sampleWallet(i: i))
    }
    try! context.save()
    return wallets
}
