//
//  zebraApp.swift
//  zebra
//
//  Created by Anthony on 2/3/21.
//

import SwiftUI
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@main
struct zebraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func didFinishLaunchingWithOptions(){
        AppCenter.start(withAppSecret: "032fafb0-7c1c-431c-9184-663b62ec5849", services:[
          Analytics.self,
          Crashes.self
        ])
    }
}
