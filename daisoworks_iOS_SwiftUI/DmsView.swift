//
//  HomeView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI
import WebKit



struct DmsDsnPreview: Decodable {

    var reqId: String
    var revNo : String
    var apprSeq: String?
    var productCd : String?
    var korProductDesc: String?
    var msinDsnEmpNm: String?
    var cmplExptDate: String?
}




struct DmsView: View {
    @State var dmsdsnpreview = [DmsDsnPreview]()

    @State private var resultText: String = ""
    @State var resultflag = false
    @State private var isLoading = false
    

 
    
    @Binding var presentSideMenu: Bool
    @State var tag: Int? = nil
    @State var vattr1: String = ""
    @State var vattr2: String = ""
 
    
    var body: some View {
        
      
            ScrollView {
                
                VStack{
                    
                    
                    NavigationLink(destination: DmsDetailView(attr1: $vattr1 , attr2: $vattr2),tag:1 , selection:self.$tag){
                        EmptyView()
                    }
                    
                    VStack{
                        Button(action: {
                            apiTest()
                        }, label:{
                            Text("API Test")
                        }).padding(20)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                    }
                    
                    
                                   
                    HStack {
                        Text("디자인진행 승인정보관리")
                            .font(.system(size:18 , weight: .bold))
                        Spacer()
                        Spacer()
                        
                    }.padding(5)
                    Divider()
                        .padding(.bottom , 35)
                    
                    ForEach(dmsdsnpreview, id: \.reqId) { item4 in
                        
                        
                        
                        VStack{
                            
                            VStack{
                                Text("\(item4.korProductDesc!)")
                                    .padding(10)
                            }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
                                .background(Color.blue )
                                .padding(10)
                                .cornerRadius(30)
                                .foregroundColor(.white)
                            
                            VStack {
                                
                                HStack{
                                    Text("의뢰번호/품번 : \(item4.reqId) / \(item4.productCd == nil ? "품번없슴" : item4.productCd! )")
                                    Spacer()
                                    Spacer()
                                }
                                .padding(.bottom , 15)
                                HStack{
                                    Text("디자인 담당자 : \(item4.msinDsnEmpNm == nil ? "  " : item4.msinDsnEmpNm! )")
                                    Spacer()
                                }
                                .padding(.bottom , 10)
                                HStack{
                                    Text("발주요청일 : \(item4.cmplExptDate == nil ? "  " : item4.cmplExptDate! )")
                                    
                                    Spacer()
                                    Button{
                                        self.vattr1=item4.reqId
                                        self.vattr2=item4.revNo
                                        self.tag = 1
                                        
                                    } label: {
                                        Image(systemName: "magnifyingglass.circle.fill" )
                                            .resizable()
                                            .frame(width:40 , height:40  )
                                        
                                    }
                                    
                                   
                                }
                                
                                
                            }.padding(.leading , 10  )
                            
                            
                            Spacer()
                            
                        }
                        .modifier(CardModifier())
                        .frame(height:120)
                        .padding(.bottom , 80)
                        //
                        
                    }//end foreach
                    
                    
                    
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
       
        loadData1()
      
        print("Loading:secondView")
    }
    
   
    
    func loadData1(){
       
        let Userid = UserDefaults.standard.string(forKey: "Userid")
        
      //  print("loadData2")
        guard let url3 = URL(string: "http://59.10.47.222:3000/dmsview1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&mUserId=\(Userid!)") else {
            print("Invalid URL")
            
            return
        }
      //  print("\(Userid)")

        let request3 = URLRequest(url: url3)
        URLSession.shared.dataTask(with: request3) { data3, response, error in
            if let data3 = data3 {
                let decoder3 = JSONDecoder()
                
                decoder3.dateDecodingStrategy = .iso8601
                
                if let decodedResponse3 = try? decoder3.decode([DmsDsnPreview].self, from: data3){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.dmsdsnpreview = decodedResponse3
                        
                     //   print("value:\(self.dmsdsnpreview)")
                     //   print("건수\(self.dmsdsnpreview.count)")
                        
                    
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
    
    
    func apiTest(){
        

        guard let url3 = URL(string: "http://herp.asunghmp.biz/FTP/Images/SUJU/10000/10005/2405055527_8819910005522_0.JPG") else {
            print("Invalid URL")
            
            return
        }
        
        var request = URLRequest(url: url3)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                 print("Error: HTTP request failed")
                
                return
            }
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
         
//            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
//                print("Error: JSON Data Parsing failed")
//                return
//            }
            
            print(response.statusCode)
        }.resume()
        
    }
      //  print("\(Userid)")

       
     //   URLSession.shared.dataTask(with: request3)     }
}


