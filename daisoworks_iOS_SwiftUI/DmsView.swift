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
    var apprSeq: String
    var productCd : String?
    var korProductDesc: String?
    var apprStts: String?
    var msinDsnEmpNm: String?
    var cmplExptDate: String?
}

var dmsdsnpreview: [DmsDsnPreview] = []


struct DmsView: View {
    @State var dmsdsnpreview = [DmsDsnPreview]()
    @State var dmsdsnpreview1 = [DmsDsnPreview]()

    @State private var resultText: String = ""
    @State var resultflag = false
    @State private var isLoading = false

    

 
    
    @Binding var presentSideMenu: Bool
    @State var tag: Int? = nil
    @State var vattr1: String = ""
    @State var vattr2: String = ""
    @State var vattr3: String = ""
 
    
    var body: some View {
              
        
                VStack{
                    
              
                    NavigationLink(destination: DmsDetailView(attr1: $vattr1 , attr2: $vattr2, attr3: $vattr3),tag:1 , selection:self.$tag){
                        EmptyView()
                    }
                                   
                    HStack {
                        Text("디자인진행 승인정보관리")
                          .font(.system(size:18 , weight: .bold))
                        Spacer()
                        Spacer()
                        
                    }.padding(5)
                  
                   
                    VStack(alignment: .trailing) {
                        HStack{
                            
                            Button(action: {
                                updateFilteredArray(str1:"All")
                            } , label: {
                                Text("전 체").padding(10)
                                .font(.system(size:15 , weight: .bold))
                                .background(Color.black)
                                .foregroundStyle(.white)
                            })
                            
                                Button(action: {
                                    updateFilteredArray(str1:"RQ")
                                } , label: {
                                    Text("진 행").padding(10)
                                    .font(.system(size:15 , weight: .bold))
                                    .background(Color.blue)
                                    .foregroundStyle(.white)
                                })
                                Button(action: {
                                    updateFilteredArray(str1:"CM")
                                } , label: {
                                    Text("완 료").padding(10)
                                    .font(.system(size:15 , weight: .bold))
                                    .background(Color.gray)
                                    .foregroundStyle(.white)
                                })
//                                Button(action: {
//                                    updateFilteredArray(str1:"NO")
//                                } , label: {
//                                    Text("미대상").padding(10)
//                                    .font(.system(size:15 , weight: .bold))
//                                    .background(Color.yellow)
//                                    .foregroundStyle(.white)
//                                })
                               
                            }
                    }.frame(maxWidth: .infinity , minHeight:20  , alignment: .trailing)
                    
                    
                    
                    ZStack(alignment: .center){
                        
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(4)
                        
                            .progressViewStyle(CircularProgressViewStyle())
                            .opacity(isLoading ? 1 : 0)
                        Text("Loading...")
                        
                            .foregroundColor(Color.gray)
                        
                            .opacity(isLoading ? 1 : 0)
                      
                    }
                 
                    
                    ScrollView {
                        
                        ForEach(dmsdsnpreview1, id: \.reqId) { item4 in
                            
                        VStack{
                            
                            if item4.apprStts == "CM"{
                                VStack{
                                    Text("\(item4.korProductDesc!)")
                                        .padding(10)
                                }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
                                    .background(Color.gray )
                                    .padding(10)
                                    .cornerRadius(30)
                                    .foregroundColor(.white)
                            }else if item4.apprStts == "RQ"{
                                VStack{
                                    Text("\(item4.korProductDesc!)")
                                        .padding(10)
                                }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
                                    .background(Color.blue )
                                    .padding(10)
                                    .cornerRadius(30)
                                    .foregroundColor(.white)
//                            }else if item4.apprStts == "NO"{
//                                VStack{
//                                    Text("\(item4.korProductDesc!)")
//                                        .padding(10)
//                                }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
//                                    .background(Color.yellow )
//                                    .padding(10)
//                                    .cornerRadius(30)
//                                    .foregroundColor(.white)
                            }else {
                                VStack{
                                    Text("\(item4.korProductDesc!)")
                                        .padding(10)
                                }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
                                    .background(Color.blue )
                                    .padding(10)
                                    .cornerRadius(30)
                                    .foregroundColor(.white)
                            }
                            
                            
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
                                        self.vattr3=item4.apprSeq
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
                        .padding(.top , 40)
                        //
                        
                    }//end foreach
                    
                    
                    
                    Spacer()
                }.scrollIndicators(.hidden)
                
              
            }.padding(10)
                .onAppear(perform: INIT_1)
            
               
                 
        }
  
    
        
    func startLoading() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
                isLoading = false
                resultflag = true
        }
    }
    func didDismiss() {
            }
    
    func INIT_1(){
       
        loadData1()
      
        
     
    }
    
   
    
    func loadData1(){
       
        let Userid = UserDefaults.standard.string(forKey: "Userid")
     //   let Userid:String = "AH2201001" //정은빈
       // let Userid:String = "AH0403070" //이유용
        //print("\(Userid)")
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
                        
                            updateFilteredArray(str1:"All")
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
    
    func updateFilteredArray(str1:String) {
        startLoading()
        var vFilter = str1
        
        print("\(vFilter)")
        switch vFilter {
        case "All":
            dmsdsnpreview1 = dmsdsnpreview.filter { $0.apprStts != "NULL" }
        case "CM":
            dmsdsnpreview1 = dmsdsnpreview.filter { $0.apprStts == "CM" }
        case "RQ":
            dmsdsnpreview1 = dmsdsnpreview.filter { $0.apprStts == "RQ" }
//        case "NO":
//            dmsdsnpreview1 = dmsdsnpreview.filter { $0.apprStts == "NO" }
        default:
            dmsdsnpreview1 = dmsdsnpreview.filter {$0.apprStts != "NULL" }
        }
    
      
        
    }
    
   
       
     //   URLSession.shared.dataTask(with: request3)     }
}



