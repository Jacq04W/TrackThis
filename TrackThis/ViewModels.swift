//
//  ViewModels.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/17/23.
//

import Foundation
import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor
class ExpenseViewModel : ObservableObject{
    @Published var player = Player()

    
    func SavePlayer(player:Player) async -> Bool{
        let db = Firestore.firestore()
        if let id = player.id { // update the data that alrsady here
        do {
            try await db.collection("players").document(id).setData (player.dictionary)
        print ("😎 Data updated successfully!")
        return true
        } catch {
        print ("🤬ERROR: Could not update data in'players'")
           return false
        }
        } else {
            // add data to firestore
            do{
                
        let documentRef = try await db.collection("players").addDocument(data: player.dictionary)
            // this is to make sure we are updating the the 'spot' on xcode when a new value is inputed, so thay we have a id before its in fb
                self.player = player
                self.player.id = documentRef.documentID
                print("😎 Data added succesfully ")
                return true
            } catch{
                print("🤬Error: could not add data")
                return false
                
            }
        }
    }
    
    func addExpense(player:Player, expense: Expense) async -> Bool {
          let db = Firestore.firestore()
          
          // Ensure we have a player ID
        guard let playerID = player.id else {
            print("🤬 ERROR: Could not get player ID.")
            return false
        }
          // Ensure we have an event ID
          guard let expenseID = expense.id else {
              print("🤬 ERROR: Could not get expense ID.")
              return false
          }
          
          // Define the path to the player's events collection
          let collectionString = "players/\(expenseID)"
          
          do {
              
                 
              // Check if the player is already joined to the event
              let document = try await db.collection(collectionString).document(expenseID).getDocument()
              
              if document.exists {
                  print("😎 Alreayd added that expense.")
                  return true
              } else {
                  // Add the player to the event
              try await db.collection(collectionString).document(expenseID).setData(["joined": true], merge: true)
                  print("😎 Expense added succesfully")
                  return true
              }
          } catch {
              print("🤬 ERROR: Could not join event. \(error.localizedDescription)")
              return false
          }
      }

    

}
