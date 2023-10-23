//
//  AddNewExpense.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/18/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift

enum ExpenseType:String, CaseIterable {
    case food = "Food"
    case whip = "Whip"
    case gas = "Gas"
    case outside = "Outside"

    
}


struct AddNewExpense: View {
    // data
    @State private var selectedCategory : ExpenseType? = nil
    @State var player: Player
    @State private var name = ""
      @State private var type = "Personal"
      @State private var amount = 0.0

    var categories = [
"Food",
"Whip",
"Gas",
"Outside",


]
    
    // view model
    @StateObject var vm = ExpenseViewModel()
    // use observed objecet when tryign to use stuff thats alwaready created
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) private var dismiss
 
    // alerts
    @State private var alert = false
    @State private var moneyAlert = false
    @State private var showDepositView = false


    //view changers
    var previewRunning = false
    @State private var selectedButton: ExpenseType?


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                        Section{
                            TextField("Name", text: $name)
                                .textFieldStyle (.roundedBorder)
                                .overlay {
                                    RoundedRectangle (cornerRadius: 5)
                                        .stroke(name.isEmpty ? .gray.opacity(0.5) : .indigo.opacity(0.5), lineWidth: name.isEmpty ? 3 :  4)
                                    
                                }
                            TextField("Amount", value: $amount, format: .currency(code: "USD"))
                                .textFieldStyle (.roundedBorder)
                                .overlay {
                                    RoundedRectangle (cornerRadius: 5)
                                    .stroke(amount == 0 ? .gray.opacity(0.5) : .indigo.opacity(0.5), lineWidth: name.isEmpty ? 3 :  4)                            }
                                .keyboardType(.numbersAndPunctuation)
                        }
                       
                          Section {
                              
        Text("Choose Category")
                                  .font(.title).bold()
                                  .padding(.top)
                              ForEach(ExpenseType.allCases, id: \.self) { category in
                                Button{
                                    withAnimation{
                                        ChooseCategory(category)

                                    }
                                }
                            label:{
                                HStack{
                                    ZStack{
                                        Image(category.rawValue)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 100)
                                            .frame(width: 350)
                                        VStack{
                                            Text(category.rawValue)
                                                .foregroundColor(selectedButton == category ? .green : .white)
                                                .font(selectedButton == category ? .title : .title2 ).bold()
                                            
                                        }
                                         
                                    }        .clipShape(RoundedRectangle(cornerRadius: 20))
                                         .overlay(
                                            
                                                RoundedRectangle(cornerRadius: 20)
        .stroke(Color.green, lineWidth:  selectedButton == category ? 3 : 0)
                                            )
                                    
                                }
                            }
                                           }
                                       }
    //                      .padding(.top,40)
                           
                        
                    }
                                    .padding()

                     .navigationTitle("Add Expense")
                     .navigationBarTitleDisplayMode(.inline)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button{
                                dismiss()
                                
                            }
                        label: {
                            Image(systemName: "xmark.octagon.fill")
                                
                        }.buttonStyle(PlainButtonStyle())
                        }
                        ToolbarItem(placement: .automatic) {
                            
                            Button{
            // let the new values be filled in from the user whemn we hit the save button add the new values to the array
                let expense = ExpenseItem(name: name, type: selectedCategory?.rawValue ?? "" , amount: amount)
    //
                                
                                let expenseAmount = expense.amount
                                   
                                   // Calculate remaining wallet amount after adding the new expense
                                let remainingAmount = expenses.walletAmount - expenseAmount
                                   
                                   // Check if the new expense is within the wallet's remaining amount
                                   if remainingAmount >= 0 {
                                       // Expense is within budget, so add it to the items array
                                       expenses.items.append(expense)
                                       dismiss()
                                   } else {
                                       // Expense is greater than the wallet amount, so don't allow adding
                                       moneyAlert.toggle()
                                       print("🤬ERROR: Not enough money in Virtual wallet")
                                   }
                            }
                        label: {
                            VStack{
                                Image(systemName: "bonjour")
                                    .bold()
                                Text("Save")
                                    .font(.callout)
                                
                            }
                           
                                
                        }.buttonStyle(PlainButtonStyle())
                        }

                    }
                    .alert("Error", isPresented: $alert) {
                        
                        Button("OK"){}
                    }
                    .alert("Can Not Add Expense", isPresented: $moneyAlert) {
                        Button("Add Now "){ showDepositView.toggle()}
                    } message: {Text("Add more money to your Virtual Wallet first")}
                
        
            }
        }
        .preferredColorScheme(.dark)





    }
    func ChooseCategory(_ pressed: ExpenseType){
        switch pressed {
        case .food:
            selectedCategory = .food
            selectedButton = .food
        case .whip:
            selectedCategory = .whip
            selectedButton = .whip

        case .outside:
            selectedCategory = .outside
            selectedButton = .outside


        case .gas:
            selectedCategory = .gas
            selectedButton = .gas

       
      }
        

    }
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense(player: Player(),expenses: Expenses())
            .environmentObject(ExpenseViewModel())
            .environmentObject(Expenses())

    }
}
