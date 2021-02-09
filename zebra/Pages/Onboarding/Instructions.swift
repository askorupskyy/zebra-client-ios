//
//  Instructions.swift
//  zebra
//
//  Created by Anthony on 2/9/21.
//

import SwiftUI
import NavigationStack


struct InstructionItem: Identifiable{
    var id: Int
    var name: String
    var desc: String
    var imageName: String
}


struct Instructions: View {
    @State var page = 0
    @State var didComplete = false
    var body: some View{
        PushView(destination: HomeScreen(), isActive: self.$didComplete){   
        }
        VStack{
            HStack{
                Spacer()
                Spacer()
                Button(action: {
                    self.didComplete = true
                }){
                    Text("ПРОПУСТИТЬ")
                        .font(.custom("Roboto-Regular", size: 17))
                        .fontWeight(.light)
                        .padding()
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            GeometryReader{g in
                Carousel(width: UIScreen.main.bounds.width, page: self.$page, height: g.frame(in: .global).height*1.1).frame(height:g.frame(in: .global).height).padding(.bottom,-10)
            }
            HStack{
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .background(Circle().foregroundColor(self.page == 0 ? Color("Main") : .clear))
                    .frame(width: 10, height: 10)
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .background(Circle().foregroundColor(self.page == 1 ? Color("Main") : .clear))
                    .frame(width: 10, height: 10)
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .background(Circle().foregroundColor(self.page == 2 ? Color("Main") : .clear))
                    .frame(width: 10, height: 10)
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .background(Circle().foregroundColor(self.page == 3 ? Color("Main") : .clear))
                    .frame(width: 10, height: 10)
                Circle()
                    .strokeBorder(Color.blue,lineWidth: 1)
                    .background(Circle().foregroundColor(self.page == 4 ? Color("Main") : .clear))
                    .frame(width: 10, height: 10)
            }.padding(.bottom, 50)
            Spacer()
            Button(action: {
                self.page += 1
                if self.page == 5{
                    self.didComplete = true
                }
            }){
                Text("Далее")
            }
            .padding()
            .frame(width: 358.0, height: 48.0)
            .background(Color("Main"))
            .cornerRadius(16)
            .foregroundColor(.white)
            
        }
    }
}


struct List: View {
    var body: some View {
        HStack(spacing: 0){
            ForEach(data){i in
                Card(width: UIScreen.main.bounds.width, data:i )
            }
        }
    }
}


struct Carousel: UIViewRepresentable{
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //let toVisible: CGRect = CGRect(x: CGFloat(self.page) * self.width, y: 0, width: width,   height: height)
        //uiView.scrollRectToVisible(toVisible, animated: true)
        uiView.setContentOffset(CGPoint(x: CGFloat(self.page) * self.width, y: 0), animated: true)
    }
    
    
    
    func makeCoordinator() -> Coordinator {
        return Carousel.Coordinator(parent1: self)
    }
    
    var width: CGFloat
    @Binding var page: Int {
        didSet{
            
        }
    }
    var height: CGFloat
    @State var canUpdate = false
    
    func makeUIView(context: Context) -> UIScrollView {
        let total = width * CGFloat(data.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator
        let view1 = UIHostingController(rootView: List())
        view1.view.frame = CGRect(x: 0, y: 0, width: total, height: self.height)
        view1.view.backgroundColor = .clear
        view.addSubview(view1.view)
        return view
    }
    
    
    class Coordinator : NSObject,UIScrollViewDelegate{
        
        
        var parent : Carousel
        
        init(parent1: Carousel) {
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            var page = 0
            if self.parent.page == 0{
                page = 1
            }
            else{
                page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            }
            self.parent.page = page
        }
    }
}


struct Card: View{
    var width: CGFloat
    var data: InstructionItem
    var body: some View{
        VStack{
            Image(data.imageName).resizable().frame(width: 360/1.5, height: 360/1.5)
            Text(self.data.name)
                .font(
                    .custom("Roboto-Medium", size:24)
                ).fontWeight(.regular)
                .padding(.bottom, 6.0)
            Text(self.data.desc)
                .font(.custom("Roboto-Regular", size: 17))
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }.frame(width: self.width)
    }
}

struct Instructions_Previews: PreviewProvider {
    static var previews: some View {
        Instructions()
    }
}


var data = [
    InstructionItem(id: 0, name: "Начало поездки", desc: "Найдите свой скутер на карте и забронируйте его или подойдите и отсканируйте QR-код возле руля.", imageName: ""),
    InstructionItem(id: 1, name: "Как набрать скорость", desc: "Оттолкнитесь ногой для начала движения, используйте правый рычаг для ускорения", imageName: ""),
    InstructionItem(id: 2, name: "Катайтесь безопасно", desc: "Пожалуйста, не выезжайте на проезжую часть, не ускоряйтесь возле пешеходов.", imageName: ""),
    InstructionItem(id: 3, name: "Места для катания", desc: "В некоторых районах катание и парковка не разрешены. Мы покажем на карте.", imageName: ""),
    InstructionItem(id: 4, name: "Паркуйте ответственно", desc: "Пожалуйста, не блокируйте дороги и оставляйте место для пешеходов.", imageName: "")
]
