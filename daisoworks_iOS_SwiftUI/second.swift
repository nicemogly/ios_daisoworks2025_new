//
//  second.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/17/24.
//

import SwiftUI
import WebKit


struct HTMLText: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        DispatchQueue.main.async {
            let data = Data(self.html.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html , .characterEncoding: String.Encoding.utf8.rawValue  ],  documentAttributes: nil) {
                label.attributedText = attributedString
                label.font = .systemFont(ofSize: 16)
            }
            
        }
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {}
}

struct DmsNotice: Decodable, Identifiable{
    let id = UUID()
    let boardTitle: String
    let boardContents: String
}



struct second: View {
    @State  var dmsnotice = [DmsNotice]()
    @State var dmsdsnpreview = [DmsDsnPreview]()
    
    @State private var resultText: String = ""
    @State var resultflag = false
    @State private var isLoading = false
    
    var body: some View {
   
        ScrollView {
            
            VStack {
                
                HStack {
                    Text("공지사항")
                        .font(.system(size:18 , weight: .bold))
                    Spacer()
                    Spacer()
                   
                }.padding(5)
                Divider()
                 VStack{
                     
                     ForEach(dmsnotice, id: \.id) { nt1 in
                         DisclosureGroup{
                             HStack {
                                 VStack(alignment: .leading){
                                     Divider()
                                   //  Text(HtmlRenderedString(fromStrimg:"\(nt1.boardContents)")
                                   //  HTMLStringView(htmlContent: "\(nt1.boardContents)")
//                                     HTMLText(html: "\(nt1.boardContents)")
//                                         .font(.system(size:16 , weight: .bold))
//                                         .foregroundStyle(.gray)
//                                         .frame(maxWidth: .infinity , alignment: .leading)
                                     
                                     Text("\(nt1.boardContents.removeHTMLTag().replacingOccurrences(of: "&nbsp;", with: ""))").padding(.bottom , 10)
                                     Spacer()
                                 }
                                 .frame(maxWidth: .infinity , alignment: .leading)
                             }
                             
                         } label: {
                             HStack{
                                
                               //  Text("[\(nt1.boardTitle)] \(nt1.herp_title)")
                                 Text("\(nt1.boardTitle)")
                                 .font(.system(size:16 , weight: .bold))
                                     .foregroundStyle(.black)
                                 Spacer()
                                 
                             }
                         }
                         Spacer()
                         Spacer()
                     }
                       
                  }
                 .frame(maxWidth: .infinity , alignment: .leading)
                
                 .padding(.bottom , 20)
                 .padding(.leading , 10)
                
                
                Spacer()
            }
        }.padding(10)
            .onAppear(perform: INIT_1)
    }
    
    func startLoading() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
                isLoading = false
                resultflag = true
        }
    }
    func didDismiss() {
            }
    
    func INIT_1(){
        //메인에서 넘어왔다면
//        if passKey == "OK" {
//            selection = comCode1
//            itemId = itemNo
//            sujubcode = sujubCode
//            sujumgno = sujuMgno
//            resultflag = false
//            loadData2()
//            print("Loading:firstView-IN")
//        }
        loadData1()
      
        print("Loading:secondView")
    }
    
    func loadData1(){
       
       // let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        let Userid = UserDefaults.standard.string(forKey: "Userid")
        
       // print("testest\(selection2)")
        guard let url2 = URL(string: "http://59.10.47.222:3000/dmsnotice?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&mUserId=\(Userid!)") else {
            print("Invalid URL")
            
            return
        }
        

        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data2, response, error in
            if let data2 = data2 {
                let decoder2 = JSONDecoder()
                
                decoder2.dateDecodingStrategy = .iso8601
                
                if let decodedResponse2 = try? decoder2.decode([DmsNotice].self, from: data2){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.dmsnotice = decodedResponse2
                        
                        print("value:\(self.dmsnotice)")
                        print("건수\(self.dmsnotice.count)")
                        
                    
                        if(self.dmsnotice.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                        
                            resultText = ""
                            loadData2()
                           // startLoading()
                            
                       
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func loadData2(){
       
        let Userid = UserDefaults.standard.string(forKey: "Userid")
        
        print("loadData2")
        guard let url3 = URL(string: "http://59.10.47.222:3000/dmsview1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&mUserId=\(Userid!)") else {
            print("Invalid URL")
            
            return
        }
        print("\(Userid)")

        let request3 = URLRequest(url: url3)
        URLSession.shared.dataTask(with: request3) { data3, response, error in
            if let data3 = data3 {
                let decoder3 = JSONDecoder()
                
                decoder3.dateDecodingStrategy = .iso8601
                
                if let decodedResponse3 = try? decoder3.decode([DmsDsnPreview].self, from: data3){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.dmsdsnpreview = decodedResponse3
                        
                        print("value:\(self.dmsdsnpreview)")
                        print("건수\(self.dmsdsnpreview.count)")
                        
                    
                        if(self.dmsdsnpreview.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                        
                            print("OKAY")
                            resultText = ""
                          
                            startLoading()
                            
                       
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
}
