//
//  PlayerCard.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/18/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import SwiftUI


struct PlayerCard: View {
@State var player : Player
@StateObject var vm = ExpenseViewModel()
@Environment(\.dismiss) var dismiss
@State private var playNow = false
@AppStorage ("isOnboarding") var isOnboarding: Bool?

    @State private var showSignInView = false

    var body: some View {
        VStack(alignment: .center){
            Text("Whats Your Name?")
                .bold()
                .font(.title3)
            TextField("Name", text: $player.name)
                .textFieldStyle(.roundedBorder)

            Button("Done"){
                
                Task{
    self.player.email = Auth.auth().currentUser?.email ??
                    ""
            let success = await vm.savePlayer(player: player)
//                    player.path = "spots/\(spot.id ?? "")/reviews"

                    if success {
                        isOnboarding = false
                        playNow.toggle()
//                        dismiss()
                    } else {
                        print("🤬Error: Couldnt save Player on card")
                    }
                }
                
            }
            .buttonStyle(.plain)
            .bold()
            .offset(y:20)
        }
        .padding()
       
        .frame(width: 250, height: 200)
        .background(LinearGradient(colors: [.blue,.cyan], startPoint: .bottomLeading, endPoint: .topTrailing)
            .clipShape(RoundedRectangle(cornerRadius: 25)))

        .fullScreenCover(isPresented: $playNow) {
        
            HomePage(player: player,
            showSignInView:$showSignInView )
            
        }


    }
}

struct PlayerCard_Previews: PreviewProvider {
    static var previews: some View {
        PlayerCard(player: Player())
            .environmentObject(ExpenseViewModel())
        
    }
}
