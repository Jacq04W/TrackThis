//
//  ViewModels.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/17/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor



final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }

    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
        //Use this to decode each item added to the array
        // and save them to the user defaults
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    @Published var deposits = [DepositItem](){
        didSet {
            if let encoded = try? JSONEncoder().encode(deposits) {
                UserDefaults.standard.set(encoded, forKey: "Deposits")
            }
        }
    }
    
    var totalExpenses : Double {
          return items.reduce(0) { $0 + $1.amount }
      }
    
    var walletAmount : Double {
        return deposits.reduce(0) { $0 + $1.amount }

    }
    func deposit(amount: Double) {
            let depositItem = DepositItem(name: "Deposit", amount: amount)
            deposits.append(depositItem)
        }
    
     
    
//    var myDeposits : Int {
//        return 0 
//    }
    
    init() {
        // access the items we saved to UserStorage
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            //Decode the whole array so we can use the data in our app
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }

        items = []
    }


}




class ExpenseViewModel : ObservableObject{
    @Published var player = Player()

//    
//    func loadCurrentUser() async throws {
//        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
//    }
    
    
    
//    
//    func SavePlayer(player:Player) async -> Bool{
//        let db = Firestore.firestore()
//        if let id = player.id { // update the data that alrsady here
//        do {
//            try await db.collection("players").document(id).setData (player.dictionary)
//        print ("😎 Data updated successfully!")
//        return true
//        } catch {
//        print ("🤬ERROR: Could not update data in'players'")
//           return false
//        }
//        } else {
//            // add data to firestore
//            do{
//                
//        let documentRef = try await db.collection("players").addDocument(data: player.dictionary)
//            // this is to make sure we are updating the the 'spot' on xcode when a new value is inputed, so thay we have a id before its in fb
//                self.player = player
//                self.player.id = documentRef.documentID
//                print("😎 Data added succesfully ")
//                return true
//            } catch{
//                print("🤬Error: could not add data")
//                return false
//                
//            }
//        }
//    }
    
//    func addExpense(player:Player, expense: Expense) async -> Bool {
//          let db = Firestore.firestore()
//          
//          // Ensure we have a player ID
//        guard let playerID = player.id else {
//            print("🤬 ERROR: Could not get player ID.")
//            return false
//        }
//          // Ensure we have an event ID
//          guard let expenseID = expense.id else {
//              print("🤬 ERROR: Could not get expense ID.")
//              return false
//          }
//          
//          // Define the path to the player's events collection
//          let collectionString = "players/\(expenseID)"
//          
//          do {
//              
//                 
//              // Check if the player is already joined to the event
//              let document = try await db.collection(collectionString).document(expenseID).getDocument()
//              
//              if document.exists {
//                  print("😎 Alreayd added that expense.")
//                  return true
//              } else {
//                  // Add the player to the event
//              try await db.collection(collectionString).document(expenseID).setData(["joined": true], merge: true)
//                  print("😎 Expense added succesfully")
//                  return true
//              }
//          } catch {
//              print("🤬 ERROR: Could not join event. \(error.localizedDescription)")
//              return false
//          }
//      }

    func savePlayer(player: Player) async -> Bool {
        let db = Firestore.firestore() // ignore any error that shows up here. Wait for indexing. Clean build if it persists with shift+command+K. Error usually goes away with build + run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data deletion, see: https://deriveddata.dance
        
        if let id = player.id { // spot must alrady exist, so save
            do {
                try await db.collection("players").document(id).setData(player.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else { // no id? Then this must be a new spot to add
            do {
    let documentRef = try await db.collection("players").addDocument(data: player.dictionary)
                self.player = player
                self.player.id = documentRef.documentID
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }

    
    
    
    func saveExpense(player: Player, expense: Expense) async -> Bool {
        let db = Firestore.firestore() // ignore any error that shows up here. Wait for indexing. Clean build if it persists with shift+command+K. Error usually goes away with build + run. Otherwise try restarting Mac/Xcode and deleting derived data. For instructions on derived data deletion, see: https://deriveddata.dance
        
        guard let playerId = player.id else {
            print("🤬 ERROR: player.id = nil")
            return false
        }
        
        let collectionString = "players/\(playerId)/expenses"
        
        if let id = expense.id { // review must alrady exist, so save
            do {
                try await db.collection(collectionString).document(id).setData(expense.dictionary)
                print("😎 Data updated successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'expenses' \(error.localizedDescription)")
                return false
            }
        } else { // no id? Then this must be a new review to add
            do {
                _ = try await db.collection(collectionString).addDocument(data: expense.dictionary)
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new review in 'expenses' \(error.localizedDescription)")
                return false
            }
        }
    }


}


