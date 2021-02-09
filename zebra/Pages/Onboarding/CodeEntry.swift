//
//  CodeEntry.swift
//  zebra
//
//  Created by Anthony on 2/8/21.
//

import SwiftUI
import NavigationStack
import Introspect
import SwiftUIX


struct CodeEntry: View {
    var phone: String
    @State var code: Int
    var id: Int
    var name: String
    @State private var passcode = ""
    @State private var oldPasscode = ""
    @State private var char1 = ""
    @State private var char2 = ""
    @State private var char3 = ""
    @State private var char4 = ""
    @State private var index = 0
    @State private var didStart = false
    @State private var timeLeft = 119
    @State private var signInComplete = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func changePasscode(index: Int){
        self.didStart = true;
        self.oldPasscode = self.passcode
        self.char1 = String(self.char1.prefix(1))
        self.char2 = String(self.char2.prefix(1))
        self.char3 = String(self.char3.prefix(1))
        self.char4 = String(self.char4.prefix(1))
        self.passcode = self.char1 + self.char2 + self.char3 + self.char4
        if String(self.code) == self.passcode{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.signInComplete = true
            }
        }
        else{
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
        }
        //print(self.index)
    }
    
    func doHighlightAll(index: Int) -> Bool{
        if self.char1.count > 0 && self.char2.count > 0 && self.char3.count > 0 && self.char4.count > 0 && self.passcode != String(self.code){
            return true
        }
        return false
    }
    
    func getSMSCode(phone: String, name: String)  {
        var p = phone.replacingOccurrences(of: "-", with: "", range: nil)
        p = p.replacingOccurrences(of: " ", with: "", range: nil)
        p = p.replacingOccurrences(of: "(", with: "", range: nil)
        p = p.replacingOccurrences(of: ")", with: "", range: nil)
        if (p.count > 10 && name.count > 1){
            let url = URL(string: "http://zedmonitor.ru/API/ClientLogIn/?format=json")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            let body = ["phone": p, "name": name]
            let bodyData = try? JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
            request.httpMethod = "POST"
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
                if let data = data{
                    if let response = try? JSONDecoder().decode(JSONResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.code = response.code
                        }
                        return
                    }
                }
            }
            task.resume()
        }
    }
    
    var body: some View {
        PushView(destination: Instructions(), isActive: $signInComplete){}
        VStack{
            HStack{
                PopView{
                    Image("BackButton").padding()
                        .onReceive(timer) { _ in
                            if self.timeLeft > 0 {
                                self.timeLeft -= 1
                            }
                        }
                }
                Spacer()
                Spacer()
            }
            Spacer()
            Spacer()
            Group{
                Text("Код подтверждения")
                    .font(
                        .custom("Roboto-Medium", size:24)
                    ).fontWeight(.regular)
                    .padding(.bottom, 6.0)
                Text("Введите код, высланный на номер")
                    .font(.custom("Roboto-Regular", size: 17))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28.0)
                Text(phone)
                    .font(.custom("Roboto-Regular", size: 17))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28.0)
            }
            Group{
                Spacer()
                Spacer()
                Spacer()
                HStack{
                    Spacer()
                    Spacer()
                    Spacer()
                    VStack{
                        CocoaTextField("X", text: $char1)
                            .foregroundColor(self.doHighlightAll(index: 0) ? Color.red : String(self.code) == self.passcode ? Color.green : Color.black)
                            .isFirstResponder(self.index == 0)
                            .onChange(of: self.char1, perform: { value in
                                self.changePasscode(index: 0)
                            })
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Roboto-Regular", size: 24))
                        Divider()
                            .padding(.horizontal)
                            .frame(width: 50, height: self.index == 0 && self.passcode.count < 4 ? 2 : 1)
                            .background((self.char1.count == 0 || self.doHighlightAll(index: 0)) && self.didStart ? Color.red : String(self.code) == self.passcode ? Color.green : Color("Main"))
                    }
                    VStack{
                        CocoaTextField("X", text: $char2)
                            .foregroundColor(self.doHighlightAll(index: 1) ? Color.red : String(self.code) == self.passcode ? Color.green : Color.black)
                            .isFirstResponder(self.index == 1)
                            .onChange(of: self.char2, perform: { value in
                                self.changePasscode(index: 1)
                            })
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Roboto-Regular", size: 24))
                        Divider()
                            .padding(.horizontal)
                            .frame(width: 50, height: self.index == 1 && self.passcode.count < 4 ? 2 : 1)
                            .background((self.char2.count == 0 || self.doHighlightAll(index: 1)) && self.didStart ? Color.red : String(self.code) == self.passcode ? Color.green : Color("Main"))
                    }
                    VStack{
                        CocoaTextField("X", text: $char3)
                            .foregroundColor(self.doHighlightAll(index: 2) ? Color.red : String(self.code) == self.passcode ? Color.green : Color.black)
                            .isFirstResponder(self.index == 2)
                            .onChange(of: self.char3, perform: { value in
                                self.changePasscode(index: 2)
                            })
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Roboto-Regular", size: 24))
                        
                        Divider()
                            .padding(.horizontal)
                            .frame(width: 50, height: self.index == 2 && self.passcode.count < 4 ? 2 : 1)
                            .background((self.char3.count == 0 || self.doHighlightAll(index: 2)) && self.didStart ? Color.red : String(self.code) == self.passcode ? Color.green : Color("Main"))
                    }
                    VStack{
                        CocoaTextField("X", text: $char4)
                            .foregroundColor(self.doHighlightAll(index: 3) ? Color.red : String(self.code) == self.passcode ? Color.green : Color.black)
                            .isFirstResponder(self.index == 3 && self.passcode.count < 4)
                            .onChange(of: self.char4, perform: { value in
                                self.changePasscode(index: 3)
                            })
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Roboto-Regular", size: 24))
                        Divider()
                            .frame(width: 50, height: self.index == 3 && self.passcode.count < 4 ? 2 : 1)
                            .background((self.char4.count == 0 || self.doHighlightAll(index: 3)) && self.didStart ? Color.red : String(self.code) == self.passcode ? Color.green : Color("Main"))
                            
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            Spacer()
            Group{
                if self.timeLeft != 0 {
                    VStack {
                        Text("Отправить код снова через: ")
                            .font(.custom("Roboto-Regular", size: 17))
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28.0)
                        if self.timeLeft%60 < 10{
                            Text("\(self.timeLeft/60):\("0" + String(self.timeLeft%60))")
                                .font(.custom("Roboto-Regular", size: 17))
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28.0)
                                .foregroundColor(Color("Main"))
                                .onReceive(timer) { _ in
                                    if self.timeLeft > 0 {
                                        self.timeLeft -= 1
                                    }
                                }
                        }
                        else{
                            Text("\(self.timeLeft/60):\(self.timeLeft%60)")
                                .font(.custom("Roboto-Regular", size: 17))
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 28.0)
                                .foregroundColor(Color("Main"))
                        }
                    }
                }
                else{
                    Button(action: {
                        self.timeLeft = 119
                        self.getSMSCode(phone: self.phone, name: self.name)
                    }){
                        Text("Запросить код повторно")
                    }.padding()
                    .frame(width: 358.0, height: 48.0)
                    .background(Color("Main"))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                }
            }.padding(.bottom)
        }
    }
}

struct CodeEntry_Previews: PreviewProvider {
    static var previews: some View {
        CodeEntry(phone: "+380999049323", code: 1234, id: 1, name: "Anton")
    }
}
