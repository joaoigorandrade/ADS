//
//  ADS_POCApp.swift
//  ADS_POC
//
//  Created by Joao Igor de Andrade Oliveira on 27/02/26.
//

import SwiftUI
import SwiftData // Keep default imports if any, adding GoogleMobileAds
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        MobileAds.shared.start(completionHandler: nil)
        return true
    }
}

@main
struct ADS_POCApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
