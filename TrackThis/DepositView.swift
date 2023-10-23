//
//  DepositView.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 8/10/23.
//

import SwiftUI

import SwiftUI

struct DepositView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var expenses: Expenses
    @State private var depositAmount: Double = 0

    var body: some View {
        VStack {
            
            Text("Your Wallet: \(expenses.totalExpenses)")
                .font(.headline)
            
            TextField("Enter deposit amount", value: $depositAmount, format: .currency(code: "USD"))
                .keyboardType(.decimalPad)
                .textFieldStyle (.roundedBorder)
                .overlay {
                    RoundedRectangle (cornerRadius: 5)
                        .stroke(depositAmount == 0 ? .gray.opacity(0.5) : .indigo.opacity(0.5), lineWidth: depositAmount == 0  ? 3 :  4)
                    
                }
                .padding()
            
            Button("Deposit") {
                expenses.deposit(amount: depositAmount)
dismiss()
                
                
                
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.indigo)
            .cornerRadius(10)
        }
        .preferredColorScheme(.dark)
        .padding()
    }
}

struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        DepositView(expenses: Expenses())
            .environmentObject(Expenses())
    }
}






 
