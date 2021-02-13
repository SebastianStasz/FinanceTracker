//
//  SampleDataGenerator.swift
//  FinanceTracker
//
//  Created by Sebastian Staszczyk on 11/02/2021.
//

import Foundation
import CoreData

extension PersistenceController {
    
    // MARK: Empty database
    
    static var empty: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let context = result.context
        
        try! context.save()
        
        return result
    }()
    
    // MARK: Sample data for preview
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let context = result.context
        
        generateSampleData(context: context)
        try! context.save()
        
        return result
    }()
    
    // MARK: -- Data Generator
    
    static private func generateSampleData(context: NSManagedObjectContext) {
        
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
            income.category_ = incomes[Int.random(in: 0..<3)]
            income.value_ = (Double.random(in: 100...1000) * 100).rounded() / 100
            income.wallet_ = wallet
            
            let expense = Expense(context: context)
            expense.date_ = randomDate()
            expense.category_ = expenses[Int.random(in: 0..<4)]
            expense.value_ = (Double.random(in: 10...200) * 100).rounded() / 100
            expense.wallet_ = wallet
        }
        
        func sampleWallet(i: Int) {
            let w = Wallet(context: context)
            w.id = UUID()
            w.dateCreated_ = randomDate()
            w.name = walletNames[i]
            w.icon = walletIcons[i]
            w.iconColor = walletIconColors[i]
            w.type_ = walletTypes[i]
            w.initialBalance_ = (Double.random(in: 200...1000) * 100).rounded() / 100
            
            // Create Incomes & Expenses
            for _ in 0..<20 {
                sampleIncomesAndExpenses(wallet: w)
            }
        }
        
        // Create Income Category
        let inCat1 = IncomeCategory(context: context)
        inCat1.name_ = "Payment"
        let inCat2 = IncomeCategory(context: context)
        inCat2.name_ = "Interest"
        let inCat3 = IncomeCategory(context: context)
        inCat3.name_ = "Gift"
        let inCat4 = IncomeCategory(context: context)
        inCat4.name_ = "Award"
        
        // Create Expense Category
        let exCat1 = ExpenseCategory(context: context)
        exCat1.name_ = "Food out"
        let exCat2 = ExpenseCategory(context: context)
        exCat2.name_ = "Food"
        let exCat3 = ExpenseCategory(context: context)
        exCat3.name_ = "Hobby"
        let exCat4 = ExpenseCategory(context: context)
        exCat4.name_ = "Car"
        let exCat5 = ExpenseCategory(context: context)
        exCat5.name_ = "Hygiene"
        
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
        let incomes = [inCat1, inCat2, inCat3, inCat4]
        let expenses = [exCat1, exCat2, exCat3, exCat4]
        let walletNames = ["Main", "Car Expenses", "Bank Deposit", "Personal", "Cash", "Savings Account"]
        let walletIcons: [WalletIcon] = [.bag, .banknote, .cart, .bagCircle, .creditcard, .bagFill]
        let walletIconColors: [IconColor] = [.blue1, .gray, .green1, .orange, .pink, .yellow]
        
        // Create sample wallets
        for i in 0..<6 {
            sampleWallet(i: i)
        }
    }
}
