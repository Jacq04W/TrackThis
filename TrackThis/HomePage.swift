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



@MainActor
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}



final class ProfileViewModel : ObservableObject{
    @Published private (set) var user: AuthDataResultModel? = nil
    
    
    
    
//    func loadCurrentUser() async throws {
//        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
//    }
//    func loadCurrentUser()  throws{
//        self.user = try  AuthenticationManager.shared.getAuthenticatedUser()
//
//    }
}
struct HomePage: View {
    // Data
    @State var player: Player

//    @FirestoreQuery(collectionPath: "expenses") var expenses: [Expense]
    @FirestoreQuery(collectionPath: "expenses") var players: [Player]
 
// sheets
@Binding var showSignInView : Bool
@State private var showAddExpense = false
@StateObject private var viewModel = ProfileViewModel()
    @StateObject private var expenses = Expenses()
    var previewRunning = false
    var body: some View {
        NavigationView {
            List{
                ForEach(expenses.items,id: \.id) { item in
                    HStack {
                           VStack(alignment: .leading) {
                               Text(item.name)
                                   .font(.headline)
                               Text(item.type)
                           }

                           Spacer()
                           Text(item.amount, format: .currency(code: "USD"))
                       }                }
                
                .onDelete(perform: removeItems)
            }
            .listStyle(PlainListStyle())
            
//
//                Task{
//                    do{
//                        let reusult = Auth.auth().currentUser?.displayName
//                        player.name = reusult ?? "Unkown Name"
//                    }
//                    catch
//                    {
//                        print("Error: can not find user name")
//                    }
//
//                }
                
//
//                update the paths so the show the reviews
            
            .padding()
            .navigationTitle("TrackThis")
.fullScreenCover(isPresented:$showSignInView) {
                NavigationStack{
                    LoginView(player: Player())
                }
            }
            .fullScreenCover(isPresented:$showAddExpense) {
                NavigationStack{
                    AddNewExpense(player: player, expenses: expenses)

                }
            }

        .toolbar{
            ToolbarItem(placement: .primaryAction) {
                Button{
//        let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
//                            expenses.items.append(expense)
//                }
                    
                    showAddExpense.toggle()}
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
        }.preferredColorScheme(.dark)
    }
    // to remove items from an array
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(player: Player(), showSignInView: .constant(false),previewRunning: true)
            .environmentObject(ProfileViewModel())
    }
}
