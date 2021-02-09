//
//  ContentView.swift
//  zebra
//
//  Created by Anthony on 2/3/21.
//

import SwiftUI
import NavigationStack
import Introspect
import AppCenter
import AppCenterCrashes


struct ContentView: View {
    @State var didStart = false
    var body: some View {
        NavigationStackView {
            if self.didStart{
                HomeScreen()
            }
            else{
                NumberEntry()
            }
        }.onAppear(
            perform: {
                self.didStart = UserDefaults.standard.object(forKey: "didStart") as? Bool ?? false
                print(self.didStart)
            }
        )
    }
    func viewDidLoad(){
        AppCenter.start(withAppSecret: "032fafb0-7c1c-431c-9184-663b62ec5849", services:[
          Crashes.self
        ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
