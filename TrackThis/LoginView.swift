//
//  LoginView.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/17/23.
//

import SwiftUI
 import FirebaseAuth
import FirebaseCore


struct LoginView: View {
    enum Field{
        case email,password
    }
    @AppStorage("name") var userName: String = ""
    @AppStorage ("isOnboarding") var isOnboarding = false 

    @State private var showOnboard = false

    @State var player: Player
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusField : Field?
    @State private var buttonsDisabled = false
    @State private var showSignInView: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var presentSheet = false
@StateObject private var vm = ExpenseViewModel()
    var wok = LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
     var body: some View {
         VStack{
             ZStack{
                 Color.black
                 RoundedRectangle(cornerRadius: 30, style: .continuous)
                     .foregroundStyle(wok) .frame (width: 1900, height: 400) .rotationEffect(.degrees (135))
                 .offset (y: -350)
                 
                 VStack{
                     Text("Waddup Doe")
                         .foregroundColor (.white).font(.system(size: 40, weight: .bold, design: .rounded))
                     .offset(x: -70, y: -100)
//                     Text(userName)
//                         .autocorrectionDisabled()
//                         .lineLimit(1)
//                         .foregroundColor (.white).font(.system(size: 40, weight: .bold, design: .rounded))
//                     .offset(x: -70, y: -90)
                      
                
                     Group{
                         TextField("Email", text:$email)
                             .keyboardType(.emailAddress)
                             .autocorrectionDisabled()
                             .textInputAutocapitalization(.never)
                             .submitLabel(.next)
                             .focused($focusField, equals: .email)
                             .onSubmit{
                               focusField = .password
                             }
                             .onChange(of: email){ _ in
                                 enablebuttons()
                             }
                     
                         SecureField("Password", text: $password)
                             .textInputAutocapitalization(.never)
                             .submitLabel(.done)
                             .focused($focusField, equals: .password)
                             .onSubmit{
//                                 userName = player.name

                                 focusField = nil
                                 
                                 
                             }
                             .onChange(of: password){ _ in
                                 enablebuttons()
                             }
                         
                     }
                     .frame(width: 300)

                     .textFieldStyle(.roundedBorder)
                     .overlay{
                         RoundedRectangle(cornerRadius: 5)
                         .stroke(.gray.opacity(0.5),lineWidth:2)
                     }
                     .padding(.horizontal)
                     
                     HStack{
                         Button{
                             register()
                         } label : {
                             Text("Sign Up")
                             
                         }
                         .buttonStyle(.borderedProminent)
                         .padding(.trailing)
                         Button{
                             login()
                             
                         } label : {
                             Text("Log in")
                                 
                         }.tint(Color.red)
                         .padding(.leading)
                     }//Hstsack
                     .disabled(buttonsDisabled)
                     .buttonStyle(.borderedProminent)
                   
                     .font(.title2)
                     .padding(.top)
                 }
                 
             }.ignoresSafeArea()
            
             
             .navigationBarTitleDisplayMode(.inline)
             // how to properly naviaget to a new view
     .navigationDestination(for: String.self){ view in
                 if view == "ContentView"{
                     HomePage(player: player, showSignInView:$showSignInView)
                 }
             }
         }// nav stack
         .alert(alertMessage, isPresented: $showingAlert){
             Button("OK",role:.cancel){
                  
             }
         }

         .onAppear{
             if Auth.auth().currentUser != nil {
                 print ("🪵 Login successful !")
                 presentSheet = true
              
             }
         }
         .fullScreenCover(isPresented: $showOnboard){
             PlayerCard(player: player, expenses: Expenses())
             
     }
         .fullScreenCover(isPresented: $presentSheet){
             HomePage(player: player, showSignInView: $showSignInView)
     }
        
        
        
        
    }
    
    
    
    
    // fucntions
    func enablebuttons(){
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonsDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register(){
        Auth.auth().createUser(withEmail:email,password:password){
            result,error in
            if let error = error {
                print("🤬 Error: SIGN-UP Error:\(error.localizedDescription)")
                alertMessage = "SIGN-UP Error:\(error.localizedDescription)"
                showingAlert = true
                // mayhbe
            }
            else{
                print ("😎 Registration success!")
                /// load  view
                    showOnboard = true

            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail:email,password:password){
            result,error in
            if let error = error {
                print("🤬 Error: Login Error:\(error.localizedDescription)")
                alertMessage = "Login Error:\(error.localizedDescription)"
                showingAlert = true
            }
            else{
                print ("🪵 Login successful !")
                presentSheet = true
                /// load list view
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(player:Player())
            .environmentObject(ExpenseViewModel())
    }
}
