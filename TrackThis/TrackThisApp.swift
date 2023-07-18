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
struct TrackThisApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init(){
        FirebaseApp.configure()
       
        UITabBar.appearance().backgroundColor = UIColor( Color(.black))
        
    }
    @StateObject var expenseVm = ExpenseViewModel()
    var body: some Scene {
        WindowGroup {
            LoginView(player: Player())
                .environmentObject(expenseVm)
        }
    }
}
