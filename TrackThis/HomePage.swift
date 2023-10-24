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
@State private var showAddDeposit = false
@State private var confirmDelete = false
@StateObject private var viewModel = ProfileViewModel()
    @StateObject private var expenses = Expenses()
    var previewRunning = false
    var body: some View {
        NavigationView {
            
            Group{
                
                if expenses.items.isEmpty {
//                    Text("Welcome \(viewModel.)")
                    Text("Track Your First Expense 😎")
                        .font(.system(size: 15, weight: .black, design: .monospaced))
                        
                        .lineLimit(1)
                        .frame(width: 250, height: 250)
                        .padding()
                        .background(RadialGradient(colors: [.red,.indigo], center: .topTrailing, startRadius: 70, endRadius: 108))
                        .cornerRadius(20)
                        .onTapGesture {
                            showAddExpense.toggle()
                        }
 
                } else {
                    List{
                        ForEach(expenses.deposits, id: \.id) { deposit in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(deposit.name)
                                        .font(.headline)
//                                    Text(deposit.date) // Assuming there's a date associated with the deposit
                                }
                                
                                Spacer()
                                let depositAmount = Text(deposit.amount, format: .currency(code: "USD"))
                                
                                Text("+\(depositAmount)")
                                    .foregroundStyle(.green) // Assuming deposits should be highlighted in green
                            }
                        }

                        Text("Expenses")
                            .font(Font.custom("Marker Felt", size: 40))
                            .frame(width: 300, height: 20)
                        ForEach(expenses.items, id: \.id) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.type)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                let itemAmount = Text(item.amount, format: .currency(code: "USD"))
                                
                                Text("-\(itemAmount)")
                                    .foregroundStyle(.red)
                            }
                        }.onDelete(perform: removeItems)

                        HStack{
                            Text("Amount Spent:")
                            Text(expenses.totalExpenses, format: .currency(code: "USD"))
                                .foregroundColor(.green).bold()
                        }

                    }
                    .listStyle(PlainListStyle())
                    .labelsHidden()
                    
                }
            }
            .padding()
            .navigationTitle("TrackThis")
//            .onAppear{
//                let ni = ExpenseItem(name: "Test", type: "OIJ", amount: 50)
//                expenses.items.append(ni)
//            }
.fullScreenCover(isPresented:$showSignInView) {
                NavigationStack{
                    LoginView(player: Player())
                }
            }
.sheet(isPresented: $showAddDeposit, content: {
    NavigationStack{
        DepositView(expenses: expenses)
    }
})
            .fullScreenCover(isPresented:$showAddExpense) {
                NavigationStack{
                    AddNewExpense(player: player, expenses: expenses)
                }

                
            }
            .alert("Are you sure you want to sign out? ", isPresented: $confirmDelete) {
                Button("OK", role: .destructive) {
                    Task {
                        do {
                try signOut()
                        showSignInView = true
                        } catch {
                            print("Error: Can not sign out")
                        }
                    }
                    
                }
                      } message: {
                          Text("All your data will be deleted.")
                      }
              
        .toolbar{
            ToolbarItemGroup(placement: .primaryAction) {
                Button{
                    showAddDeposit.toggle()
                }
            label: {
                    HStack{
            Text(expenses.walletAmount,format: .currency(code: "USD"))
                        Image(systemName: "creditcard")
 
                    }
                    
                }
                .bold()
                .frame(width: 130, height: 35)
                .background{
                    Image("purp")
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                
                Button{
                    showAddExpense.toggle()}
                label:{
                    Image(systemName: "plus")
                }
                .buttonStyle(.bordered)
                .tint(Color.green)
                
            }
            
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button("Sign out"){
                    confirmDelete.toggle()
                    //are you sure you want to sign out
                }
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
