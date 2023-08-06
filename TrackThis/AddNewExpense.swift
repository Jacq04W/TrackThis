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
"food",
"whip",
"gas",
"outside",


]
    
    // view model
    @StateObject var vm = ExpenseViewModel()
    // use observed objecet when tryign to use stuff thats alwaready created
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) private var dismiss
//    @FirestoreQuery(collectionPath: "players") var expenses: [Expense]

    // alerts
    @State private var alert = false
    
    //view changers
    var previewRunning = false
    @State private var selectedButton: ExpenseType?


    var body: some View {
        NavigationView{
            ZStack{
                Form{
                    TextField("Name", text: $name)
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                        .keyboardType(.decimalPad)
                }
               
                  VStack {
                      
Text("Choose Category")
                          .font(.title).bold()
                          .padding(.top)
                      ForEach(ExpenseType.allCases, id: \.self) { category in
                        Button{
                            ChooseCategory(category)
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
                                        .foregroundColor(Color.white)
                                        .font(.title2).bold()
                                    
                                }
                                 
                            }                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                 .overlay(
                                    
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.green, lineWidth:  selectedButton == category ? 3 : 0)
                                        
                                    
                                    
                                   

                                         
                                    )
                            
                        }
                    }
                        
                       
                                      
                                        
                                   }
                               }
                  .padding(.top,40)
                  
                
                
                
                
            }
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
                expenses.items.append(expense)
                                  
                        dismiss()
                        
                        
                        
                        
//                        Task{
//            let success = await vm.saveExpense(player: player, expense: expense)
//                                if success {
//                                    dismiss()
//
//                                } else {
//                                    alert.toggle()
//                                    print("🤬Error: Couldnt save expense")                                }
//
//                        }
                        
                        
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
//            .onAppear{
//
//                if !previewRunning && player.id != nil { // This is to prevent PreviewProvider error
//                    $expenses.path = "players/\(player.id ?? "")/expenses"
//                    print("reviews.path = \($expenses.path)")
//
//
//                } else { // spot.id starts out as nil
////                    showingAsSheet = true
//                }
//
//
//            }
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
