//
//  NumberEntry.swift
//  zebra
//
//  Created by Anthony on 2/3/21.
//

import SwiftUI
import iPhoneNumberField
import NavigationStack


struct JSONResponse: Codable{
    var id: Int
    let code: Int;
}


struct NumberEntry: View {
    @State var username: String = ""
    @State var isEditing = false
    @State var phone = "+79780475641"
    @State var nameWasChanged = false
    @State var nextPage = false
    @State var result: JSONResponse?
    
    var body: some View {
        PushView(
            destination: CodeEntry(phone: self.phone, code: self.result?.code ?? 0000, id: self.result?.id ?? 0, name: self.username), isActive: $nextPage
        ){}
        VStack{
            Spacer()
            Spacer()
            Group{
                Text("Введите свой номер")
                    .font(
                        .custom("Roboto-Medium", size:24)
                    ).fontWeight(.regular)
                    .padding(.bottom, 6.0)
                Text("Мы отправим вам код для подтверждения номера телефона")
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
                    Spacer()
                    iPhoneNumberField(text: $phone)
                        .onEdit(perform: {_ in
                            
                        })
                        .flagHidden(false)
                        .flagSelectable(true)
                        .prefixHidden(false)
                        .font(UIFont(size: 24, weight: .light, design: .default))
                        .maximumDigits(10)
                        .accentColor(Color("Secondary"))
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.leading, 50)
                }
                Divider()
                    .frame(height: 1.0)
                    .background(self.validate(phone: self.phone) ? Color("Secondary") : Color.red)
                    .padding(.horizontal)
                    .padding(.bottom)
                TextField("Иван", text: $username, onEditingChanged: {_ in
                        self.nameWasChanged = true
                    })
                    .multilineTextAlignment(.center)
                    .font(.custom("Roboto-Regular", size: 24))
                
                Divider()
                    .frame(height: 1.0)
                    .background(self.username.count > 0 || !self.nameWasChanged ? Color("Secondary") : Color.red)
                    .padding(.horizontal)
                Spacer()
                Spacer()
                Spacer()
            }
            VStack {
                Text("Нажимая кнопку “Запросить код” вы соглашаетесь с ").font(.custom("Roboto-Regular", size: 17))
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28.0)
                HStack(spacing: 0) {
                    PushView(destination: LicenseAgreement()){
                        Text("пользовательским соглашением")
                            .underline()
                            .font(.custom("Roboto-Regular", size: 17))
                            .fontWeight(.light)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28.0)
                            
                    }
                }
                    
            }
            Spacer()
            Button(action: {
                self.getSMSCode(phone: self.phone, name: self.username)
            }){
                Text("Согласится и запросить код")
            }.padding()
            .frame(width: 358.0, height: 48.0)
            .background(Color("Main"))
            .cornerRadius(16)
            .foregroundColor(.white)
        }.padding(.bottom)
    }
    func validate(phone: String) -> Bool {
        var p = phone.replacingOccurrences(of: "-", with: "", range: nil)
        p = p.replacingOccurrences(of: " ", with: "", range: nil)
        p = p.replacingOccurrences(of: "(", with: "", range: nil)
        p = p.replacingOccurrences(of: ")", with: "", range: nil)
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{10,12}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: p)
        return result
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
                            self.result = response
                            self.nextPage = true
                        }
                        return
                    }
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
            task.resume()
        }
    }
}



struct NumberEntry_Previews: PreviewProvider {
    static var previews: some View {
        NumberEntry()
    }
}
