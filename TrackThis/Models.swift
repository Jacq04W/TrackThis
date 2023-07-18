//
//  Player.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/17/23.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift

enum ExpenseCategory: String, CaseIterable {
    case food
    case transportation
    case entertainment
    case gas
}
///TODO: Making this codable in firebase 
//struct CodableExpenseCategory: Codable {
//    let category: ExpenseCategory
//}

struct Player: Identifiable,Codable,Equatable{
    @DocumentID var id: String?
    var name = ""
    var email = ""
    var dictionary:[String:Any]{
        return [
            "name" : name,
            "email" : email
            
        ]
    }

}




struct Expense : Identifiable,Codable {
    @DocumentID var id: String?
    var title = ""
    var amount = 0.0
    var date = Date()
    var category = "" 
    var isBusinessExpense = false
    
    var dictionary:[String:Any]{
       
        return [
            "title": title,
            "amount": amount,
            "date": Timestamp(date: date),
            "category": category,
            "isBusinessExpense":isBusinessExpense,
            
            
        ]
    }
}

