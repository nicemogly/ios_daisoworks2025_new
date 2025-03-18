//
//  SampleView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/17/25.
//
import SwiftUI

enum Field10: Hashable {
    case sammgno
}

struct DataSamSearch: Decodable {
    var sammgno: String
    var samnm : String
    var samcoldt : String
}

struct SampleView: View {
    @Binding var presentSideMenu: Bool
    @State private var navigateTo: String?
    @State private var sammgno : String = ""
    @FocusState private var  focusField10: Field10?
    @State var resultflag = false
    @State private var showingAlert = false
    @State private var showingAlert5 = false
    @State var datasamsearch = [DataSamSearch]()
    @State private var isShowingSheet = false
    @State private var selection2 = "샘플번호 선택"
    
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading){
                HStack{
                    Text("동반자 정보")
                        .font(.system(size: 18, weight: .heavy) )
                    Spacer()
                }.padding(.leading,10)
                
            }.padding(.top,10)
            
            
            HStack{
                
                Text("NA")
                    .font(.system(size: 18, weight: .heavy) )
                
                TextField("샘플번호", text: $sammgno)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .focused($focusField10, equals: .sammgno)
                    .font(.system(size: 14))
                
                
                
                Button{
                    resultflag = false
                    
                    if sammgno.isEmpty {
                        focusField10 = .sammgno
                        self.showingAlert = true
                    }
                    
                    self.endTextEditing()
                    
                    if self.showingAlert == false {
                        loadData1()
                    }
                    
                }label:{
                    Text("Search")
                        .fontWeight(.bold)
                        .frame(width:80 , height:50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                       
                }
                .alert(isPresented : $showingAlert) {
                    Alert(title: Text("알림") , message: Text("샘플번호를 입력하세요"), dismissButton: .default(Text("확인")))
                }
                .sheet(isPresented: $isShowingSheet , onDismiss: didDismiss) {
                    VStack {
                        Text("샘플번호 선택").fontWeight(.bold)
                        
                        
                        Picker( "샘플번호 선택" , selection: $selection2) {
                            
                            if(selection2 == "샘플번호 선택" || selection2.isEmpty ) {
                                Text("샘플번호 선택").tag("샘플번호 선택")
                            }
                            
                            
                            ForEach(datasamsearch, id: \.sammgno) { item1 in
                                Text("\(item1.sammgno)(\(item1.samnm))").tag("\(item1.samnm)^\(item1.sammgno)")
                            }
                            
                        }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                            .background(Color(uiColor: .secondarySystemBackground))
                        
                            .onAppear(perform: loadData1)
                        //  Text("combo\(selection1)")
                        
                        Button("선택" , action: {
                            
                            if(selection2 == "샘플번호 선택" || selection2.isEmpty ) {
                                showingAlert5 = true
                            }else{
                                //comId = selection1
                                let  str3 = selection2.split(separator: "^")
                                
                                let  str4 = str3[1]
                                selection2 = String(str4)
                                isShowingSheet.toggle()
                            }
                                
                               
                        })
                        .alert(isPresented : $showingAlert5) {
                            Alert(title: Text("알림") , message: Text("샘플번호가 올바르게 선택되지 않았습니다."), dismissButton: .default(Text("확인")))
                        }
                       
                       
                        Spacer()
                        Button("닫기" , action: {
                            isShowingSheet = false
                        })
                    }.padding()
                }
            }.padding(.leading,10)
                .padding(.trailing,10)
              
            Spacer()
            Spacer()
                
        } .onDisappear() {
            presentSideMenu = false
         }
         .navigationTitle("샘플관리")
    }
    
    
    func loadData1(){
          let sammgno1 = "%"+sammgno+"%"

//        guard let url = URL(string: "http://59.10.47.222:3000/exhPartner?comCode=\(selection1)&uname=\(partnerName1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
//            print("Invalid URL")
//            
//            return
//        }
//        
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                
//                decoder.dateDecodingStrategy = .iso8601
//                
//                if let decodedResponse = try? decoder.decode([DataExhPartner].self, from: data){
//                    DispatchQueue.main.async {
//                        self.dataexhpartner = decodedResponse
//                            isShowingSheet = true
//                        if(self.dataexhpartner.count == 0 ){
//                            resultflag = false
//                            resultText = "검색된 결과가 없습니다."
//                        }else{
//                            resultText = ""
//                           // startLoading()
//                        }
//                    }
//                    return
//                }
//            }
//        }.resume()
    }
    
    func didDismiss() {
        
    }
    
}
