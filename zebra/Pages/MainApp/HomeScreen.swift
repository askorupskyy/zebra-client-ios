//
//  HomeScreen.swift
//  zebra
//
//  Created by Anthony on 2/9/21.
//

import SwiftUI
import NavigationStack

struct HomeScreen: View {
    @State var goSignUp = false
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            PushView(destination: NumberEntry(), isActive: self.$goSignUp){
                
            }
            Button(action: {self.goSignUp = true}){
                Text("Вернуться на регистрацию")
            }
        }.onAppear(perform: {
            UserDefaults.standard.set(true, forKey: "didStart")
        })
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
