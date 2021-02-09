//
//  LicenseAgreement.swift
//  zebra
//
//  Created by Anthony on 2/7/21.
//

import SwiftUI
import NavigationStack

struct LicenseAgreement3: View {
    @State var didAgree = false;
    var body: some View {
        VStack(){
            HStack(alignment: .center){
                Text("Политика конфиденциальности 3").font(.custom("Roboto-Regular", size: 20))
                    .fontWeight(.medium)
                    .padding()
            }
            VStack(alignment: .leading){
                Text("Значимость этих проблем настолько очевидна, что новая модель организационной деятельности влечет за собой процесс внедрения и модернизации позиций, занимаемых участниками в отношении поставленных задач. С другой стороны сложившаяся структура организации влечет за собой процесс внедрения и модернизации модели развития. Таким образом консультация с широким активом обеспечивает широкому кругу (специалистов) участие в формировании систем массового участия.").font(.custom("Roboto-Regular", size: 17))
                    .fontWeight(.light)
                    .padding(.bottom)
                Text("Идейные соображения высшего порядка, а также укрепление и развитие структуры позволяет выполнять важные задания по разработке форм развития. Таким образом новая модель организационной деятельности влечет за собой процесс внедрения и модернизации систем массового участия. Товарищи! постоянное информационно-пропагандистское обеспечение нашей деятельности позволяет выполнять важные задания по разработке существенных финансовых и административных условий.").font(.custom("Roboto-Regular", size: 17))
                    .fontWeight(.light)
                    .padding(.bottom)
                Text("Равным образом реализация намеченных плановых заданий требуют определения и уточнения форм развития. Разнообразный ").font(.custom("Roboto-Regular", size: 17))
                    .fontWeight(.light)
                    .padding(.bottom)
            }.padding(.horizontal, 10.0)
            Spacer()
            HStack{
                Spacer()
                PushView(destination: NumberEntry(), isActive: $didAgree){
                    Button(action: {self.didAgree = true}){
                        Text("Ознакомился и согласен")
                    }.padding()
                    .frame(width: 358.0, height: 48.0)
                    .background(Color("Main"))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                }
                Spacer()
            }
        }.padding(.bottom)
    }
}

struct LicenseAgreement3_Previews: PreviewProvider {
    static var previews: some View {
        LicenseAgreement()
    }
}
