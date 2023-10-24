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
    @State private var depositName: String = ""
    @State private var next = false

    var body: some View {
             VStack{
                Spacer()
                creditcard
                Spacer()
                Spacer()

                depositButton
            }
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark.octagon.fill")
                    }.buttonStyle(.plain)
                }
            }
        
    }
    
    
    
    
    var creditcard : some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 20)
            Image(.purp)
                .resizable()
                .frame(width: 333, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
            
            
            VStack{
                HStack{
                    Spacer()
                    Text(expenses.walletAmount,format: .currency(code: "USD"))
                    
                }
        .font(.headline)
        .foregroundStyle(.green)
              
                Text("XXX XXX XXX 0333")
                    .font(.system(size: 20, weight: .black, design: .monospaced))
                    .bold()
                    .offset(y:20)
                VStack(spacing:-12 ){
                    if !next {
                        HStack(spacing:-10){
                            TextField("Enter deposit amount", value: $depositAmount, format: .currency(code: "USD"))
                                .keyboardType(.decimalPad)
                                .textFieldStyle (.roundedBorder)
                                .frame(width: 200)
                                .padding()
                            if depositAmount != 0 {
                                Button{
                                    withAnimation(.easeIn) {
                                        next.toggle()

                                    }
                                }
                            label:{
                                Image(systemName: "arrow.forward")
                            }
                            .buttonStyle(.plain)
                            }
                        }
                    } else {
                    TextField("Deposit Name", text: $depositName)
                                .textFieldStyle (.roundedBorder)
                                .frame(width: 200)
                                .padding()
 
                    }
                }
//
                
                HStack(spacing: 5){
                    Text("CVV ")
                    Text("444").bold()

                    Text("EXP ")
                    Text("09/99")
                        .bold()


//
                    Spacer()
                    Image(.visa)
                        .resizable()
                        .frame(width: 70, height: 30)
                }
                .frame(width: 300)
            }
            
            .preferredColorScheme(.dark)
        .padding()
        }.frame(width: 333, height: 200)


    }
    
    var depositButton: some View {
        Button{
            expenses.deposit(name: depositName, amount: depositAmount)
            //                expenses.items.append(expense)
            dismiss()
        }
    label: {
        ZStack{
            Image(.purp)
                .resizable()
            VStack{
                Text("Deposit")

            }
        }
        .clipShape(.rect(cornerRadius: 10))

    }
        .frame(width: 330,height: 50)
        .bold()
        .disabled(depositAmount == 0 || depositName.isEmpty)
        .buttonStyle(.plain)
        
        
    }

}

struct DepositView_Previews: PreviewProvider {
    static var previews: some View {
        DepositView(expenses: Expenses())
            .environmentObject(Expenses())
    }
}








 
