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
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 333, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.regularMaterial)
            
            
            VStack{
                HStack{
                    Spacer()
                    Text(expenses.walletAmount,format: .currency(code: "USD"))
                    
                }.frame(width: 300)
        .font(.headline)
        .foregroundStyle(.green)
                
                Text("XXX XXX XXX 0433")
                    .font(.title3)     
                    .bold()
                    .offset(y:20)
                TextField("Enter deposit amount", value: $depositAmount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                    .textFieldStyle (.roundedBorder)
                    .frame(width: 200)
//                    .overlay {
//                        RoundedRectangle (cornerRadius: 5)
//                            .stroke(depositAmount == 0 ? .gray.opacity(0.5) : .indigo.opacity(0.5), lineWidth: depositAmount == 0  ? 3 :  4)
//                        
//                    }
                    .padding()
                
                Button("Deposit") {
                    expenses.deposit(amount: depositAmount)
    //                expenses.items.append(expense)
    dismiss()
                }
                .bold()
                .padding(.horizontal)
                .padding(.vertical,10)

                .foregroundColor(.white)
                .background(Color.indigo)
                .cornerRadius(10)
            }
            .preferredColorScheme(.dark)
        .padding()
        }
    }
}

struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        DepositView(expenses: Expenses())
            .environmentObject(Expenses())
    }
}






 
