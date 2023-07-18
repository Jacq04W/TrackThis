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
//                self.game = player
//                self.game.id = documentRef.documentID
                print("😎 Data added succesfully ")
                return true
            } catch{
                print("🤬Error: could not add data")
                return false
                
            }
        }
    }

}
