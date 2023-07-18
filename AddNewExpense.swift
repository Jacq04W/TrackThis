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

struct AddNewExpense: View {
    // data
    @State private var selectedCategory = "🍔"
    @State var expense: Expense
    var categories =
    [
    "🍔",
    "🏎️",
    "📺",
    "💨"
    
    ]
    
    // view model
    @StateObject var vm = ExpenseViewModel()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    TextField("Expense Name", text: $expense.title)
                    TextField("Amount", value: $expense.amount, format: .currency(code: "USD"))
                                       .keyboardType(.decimalPad)
                    Picker("Select a category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                                       Text(category)
                                        .font(.subheadline)
                                        
                                   }
                               }
                               .pickerStyle(InlinePickerStyle())
                }
                
                
            }
            .navigationTitle("Add Expenses")
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
                        
                        Task{
                            do {
//                                let success =
                                
                            } catch{
                                
                            }
                        }
                      
                        
                    }
                label: {
                    Image(systemName: "bonjour")
                        .bold()
                        
                }.buttonStyle(PlainButtonStyle())
                }

            }
        }
        



    }
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense(expense: Expense())
            .environmentObject(ExpenseViewModel())
    }
}
