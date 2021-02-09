//
//  InputText.swift
//  zebra
//
//  Created by Anthony on 2/9/21.
//

import SwiftUI
import SwiftUIX


struct InputText: View {
    @State private var passcode = ""
    @State private var oldPasscode = ""
    @State private var char1 = ""
    @State private var char2 = ""
    @State private var char3 = ""
    @State private var char4 = ""
    @State private var index = 0
    
    func changePasscode(index: Int){
        self.oldPasscode = self.passcode
        self.char1 = String(self.char1.prefix(1))
        self.char2 = String(self.char2.prefix(1))
        self.char3 = String(self.char3.prefix(1))
        self.char4 = String(self.char4.prefix(1))
        self.passcode = self.char1 + self.char2 + self.char3 + self.char4
        if self.oldPasscode.count < self.passcode.count{
            if self.index < 3{
                self.index = self.index + 1
            }
        }
        if self.oldPasscode.count > self.passcode.count{
            if self.index > 0{
                self.index = self.index - 1
            }
        }
        print(self.index)
    }
    
    var body: some View {
        HStack {
            CocoaTextField("X", text: $char1)
                .isFirstResponder(self.index == 0)
                .onChange(of: self.char1, perform: { value in
                    self.changePasscode(index: 0)
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(Font.custom("Roboto-Regular", size: 24))
            Divider().padding(.horizontal).frame(height: self.index == 3 ? 2 : 1)
            CocoaTextField("X", text: $char2)
                .isFirstResponder(self.index == 1)
                .onChange(of: self.char2, perform: { value in
                    self.changePasscode(index: 1)
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(Font.custom("Roboto-Regular", size: 24))
            Divider().padding(.horizontal).frame(height: self.index == 3 ? 2 : 1)
            CocoaTextField("X", text: $char3)
                .isFirstResponder(self.index == 2)
                .onChange(of: self.char3, perform: { value in
                    self.changePasscode(index: 2)
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(Font.custom("Roboto-Regular", size: 24))
            Divider().padding(.horizontal).frame(height: self.index == 3 ? 2 : 1)
            CocoaTextField("X", text: $char4)
                .isFirstResponder(self.index == 3 && self.passcode.count < 4)
                .onChange(of: self.char4, perform: { value in
                    self.changePasscode(index: 3)
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(Font.custom("Roboto-Regular", size: 24))
            Divider().padding(.horizontal).frame(height: self.index == 3 ? 2 : 1)
        }
    }
}

struct InputText_Previews: PreviewProvider {
    static var previews: some View {
        InputText()
    }
}
