//
//  ContentView.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/17/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import SwiftUI
struct ContentView: View {
    // Data
    @FirestoreQuery(collectionPath: "expenses") var expenses: [Expense]
// sheets
@Binding var showSignInView : Bool
@State private var showAddExpense = false
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(expenses,id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.category)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: "USD"))
                    }
                }
            
                
       
            }
            .padding()
            .navigationTitle("TrackThis")
.fullScreenCover(isPresented:$showSignInView) {
                NavigationStack{
                    LoginView(player: Player())
                }
            }
            .fullScreenCover(isPresented:$showAddExpense) {
                NavigationStack{
                    AddNewExpense(expense: Expense())

                }
            }

        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                Button{showAddExpense.toggle()}
                label : {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("sign out"){
                    Task {
                        do {
                try signOut()
                        showSignInView = true
                        } catch {
                            print("Error: Can not sign out")
                        }
                    }                        }
                
                .font(.system(size:20,weight: .bold))
                .foregroundColor(.red)
            }
        }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showSignInView: .constant(false))
    }
}
