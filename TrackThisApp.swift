//
//  TrackThisApp.swift
//  TrackThis
//
//  Created by Jacquese Whitson on 7/17/23.
//
import SwiftUI
import Firebase
import FirebaseCore
import WeatherKit

//
//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//    return true
//  }
//}

@main

//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//
//    return true
//  }
//}




struct TrackThisApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init(){
        FirebaseApp.configure()
       
        UITabBar.appearance().backgroundColor = UIColor( Color(.black))
        
    }
    

    @StateObject var expenseVm = ExpenseViewModel()
    @AppStorage("isOnboarding") var isOnboarding = true

    var body: some Scene {
        WindowGroup {
            onb1()
            
            if isOnboarding{
                OnBoarding()
            } else {
//                PlayerCard(player: Player(), expenses: Expenses())
                              LoginView(player: Player())
                                  .environmentObject(expenseVm)
            }
//
            
           
        }
    }
}
