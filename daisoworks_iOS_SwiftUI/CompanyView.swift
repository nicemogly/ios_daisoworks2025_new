//
//  HomeView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI
import Combine



enum Field1: Hashable {
    case comId
}

struct ComView1: Decodable {
    var clientNoP: String
    var clientPreNoP: String!
    var clientBizNoP: String!
    var clientBizMNoP: String!
    var clientBizNameK: String
    var clientBizAddrK: String!
    var clientBizCeoK: String!
    var clientBizNameE: String!
    var clientBizAddrE: String!
    var clientBizCeoE: String!
    var clientBizNameC: String!
    var clientBizAddrC: String!
    var clientBizCeoC: String!
    var clientBizCountry: String!
    var clientBizKind: String!
    var clientBizTel: String!
    var clientBizHomepage: String!
    var clientBizEmail: String!
  
}
struct ComView22: Decodable {
    var clientItemNo: String
    var clientItemName : String
    var clientItemBuyerCd: String
    var clientBuyCorpCd: String
}

struct ComView1_prev: Decodable {
    var clientNoP: String
    var clientBizNameK: String
}


struct CompanyView: View {
    

    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var itemNo: String
    @Binding var barcodeNo: String
    @Binding var buyCd: String
    @Binding var comCode1: String
    @Binding var passKey: String
    
    @State private var externalItemno = ""
    @State private var selection  = "선택"
    @State private var selection1   = "거래처 선택"
    @State private var selection2   = ""
    @State private var selection3   = ""
    @State private var isActive: Bool = false
    
    @FocusState private var  focusField: Field1?
    @State private var comId : String = ""
    @State var comview1 = [ComView1]()
    @State var comview22 = [ComView22]()
    @State var comview1_prev = [ComView1_prev]()
    @State var tmpcomId: String = ""
    @State var resultflag = false
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var isShowingSheet = false
    @State private var resultText: String = ""

    
    var body: some View {

        

            VStack{
                HStack{
                    
                    Picker( selection: $selection , label: Text("선택")) {
                        
                        Text("선택").tag("선택")
                        Text("거래처명").tag("comName")
                        Text("거래처코드").tag("comCd")
                    }
                    
                    TextField("거래처코드/명", text: $comId)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .focused($focusField, equals: .comId)
                    
                    
                    
                    Button{
                        print("검색")
                        // print("Value: \(selection)")
                        
                        resultflag = false
                        if selection == "선택" {
                            self.showingAlert = true
                        }
                        
                        if comId.isEmpty {
                            focusField = .comId
                            self.showingAlert = true
                        }
                        self.endTextEditing()
                       
                        
                        
                        if self.showingAlert == false {
                          
                            if selection == "comName" {
                                loadData11()
                            }else if selection == "comCd" {
                                selection2 = comId
                                loadData1()
                            }
                           
                        }
                        
                        
                      
                        
                        
                    }label:{
                        Text("Search")
                            .fontWeight(.bold)
                            .frame(width:80 , height:50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .buttonStyle(PlainButtonStyle())
                            .padding()
                        
                    }.alert(isPresented : $showingAlert) {
                        Alert(title: Text("알림") , message: Text("거래처 선택 또는 거래처코드/명이 유효하지 않습니다"), dismissButton: .default(Text("확인")))
                    }
                    .sheet(isPresented: $isShowingSheet , onDismiss: didDismiss) {
                        VStack {
                            Text(" 거래처를 선택 하세요").fontWeight(.bold)
                            
                            Picker( "거래처 선택" , selection: $selection1) {
                                
                                if selection1 == "거래처 선택" {
                                    Text("거래처 선택").tag("거래처 선택")
                                }
                                
                                ForEach(comview1_prev, id: \.clientNoP) { item1 in
                                    
                                    Text(item1.clientBizNameK).tag(item1.clientNoP + "^" + item1.clientBizNameK )
                                    
                                }
                                
                                
                            }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                                .background(Color(uiColor: .secondarySystemBackground))
                            
                                .onAppear(perform: loadData11)
                            //  Text("combo\(selection1)")
                            
                            Button("선택" , action: {
                                
                                
                                //comId = selection1
                                let  str3 = selection1.split(separator: "^")
                                
                                let  str4 = str3[1]
                                comId = String(str4)
                                selection2 = String(str3[0])
                                // print("str3[0]: \(str3[0])")
                                isShowingSheet.toggle()
                                print("loadData1:\(selection2)")
                                loadData1()
                                
                                
                            })
                            //Text("combo:\(selection1)")
                            Spacer()
                            Spacer()
                        }.padding()
                    }
                }
                .frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground))
                
                ZStack{
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .scaleEffect(4)
                    
                        .progressViewStyle(CircularProgressViewStyle())
                        .opacity(isLoading ? 1 : 0)
                    Text("Loading...")
                    
                        .foregroundColor(Color.gray)
                    
                        .opacity(isLoading ? 1 : 0)
                }
                if (resultflag == true) {
                    
                    
                    VStack(spacing:0) {
                        
                        ScrollView {
                            VStack(spacing: 20){
                                ExpandableView(thumbnail: ThumbnailView {
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("기본정보")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundStyle(.black)
                                            .font(.system( size: 18, weight: .heavy))
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                                    
                                    
                                }, expanded: ExpandedView{
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(comview1, id: \.clientNoP) { item2 in
                                            Spacer()
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientNoP )")
                                                Spacer()
                                                Text("\(item2.clientPreNoP ?? "" )")
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizNoP ?? "" )")
                                                Spacer()
                                                Text("\(item2.clientBizMNoP ?? "" )")
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            
                                            Divider().overlay(Color.white)
                                            
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizNameK )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            HStack {
                                                
                                            }
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizAddrK ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            HStack {
                                                
                                            }
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizCeoK ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            Divider().overlay(Color.white)
                                            
                                            // English
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizNameE ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            HStack {
                                                
                                            }
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizAddrE ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            HStack {
                                                
                                            }
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizCeoE ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            Divider().overlay(Color.white)
                                            
                                            //China
                                            
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizNameC ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            HStack {
                                                
                                            }
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizAddrC ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            HStack {
                                                
                                            }
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizCeoC ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                                
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            Divider().overlay(Color.white)
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizCountry ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                Spacer()
                                                Text("\(item2.clientBizKind ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizTel ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .underline()
                                                    .onTapGesture {
                                                        let telephone = "tel://" + item2.clientBizTel
                                                        guard let url = URL(string: telephone) else { return }
                                                        UIApplication.shared.open(url)
                                                    }
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizHomepage ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .underline()
                                                
                                                    .onTapGesture {
                                                        let urlt =  "http://" + item2.clientBizHomepage
                                                        guard let url = URL(string: urlt) else { return }
                                                        UIApplication.shared.open(url)
                                                    }
                                                
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            
                                            HStack(spacing:0) {
                                                Text("\(item2.clientBizEmail ?? "" )")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .underline()
                                                    .onTapGesture {
                                                        let mailname = "mailto://" + item2.clientBizEmail
                                                        guard let url = URL(string: mailname) else { return }
                                                        UIApplication.shared.open(url)
                                                    }
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            /*
                                             var clientBizTel: String!
                                             var clientBizHomepage: String!
                                             var clientBizEmail: String!
                                             */
                                        }//end foreach
                                        
                                        .padding(15)
                                    }
                                    
                                    
                                }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                                
                                ExpandableView(thumbnail: ThumbnailView {
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("상품정보(최근)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundStyle(.black)
                                            .font(.system( size: 18, weight: .heavy))
                                            .fontWeight(.bold)
                                    }
                                    .padding()
                                    
                                    
                                }, expanded: ExpandedView{
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(comview22, id: \.clientItemNo) { item22 in
                                            Spacer()
                                     
                                            HStack(spacing:0) {
                                               // $selectedSideMenuTab
                                               
//                                                NavigationLink(destination: MainTabbedView().navigationBarBackButtonHidden(true), isActive: $isActive) {
//                                                 
//                                                }
//                                                
//                                                ProductView(presentSideMenu: $presentSideMenu){
//                                                    Text("\(item22.clientItemNo ?? "" )")
//                                                }

                                                Text("\(item22.clientItemNo )")
                                                    .onTapGesture {
                                                     
                                                        selectedSideMenuTab = 1
                                                        itemNo = item22.clientItemNo
                                                        barcodeNo = item22.clientItemBuyerCd
                                                        buyCd = item22.clientBuyCorpCd
                                                        passKey = "OK"
                                             
                                                    }
                                                
                                                Text("\(item22.clientItemName )")
                                                    .frame(alignment: .leading)
                                                    .padding(.leading, 20)
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                        }//end foreach
                                        
                                        .padding(15)
                                    }
                                    
                                    
                                }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                                
                                
                                
                            }
                        }
                    }
                }
                
                Text("\(resultText)")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.headline)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    
                Spacer()
                Spacer()
            }.padding(5)
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
    
    
    func loadData11(){
       
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        
        let comId1 = "%"+comId+"%"
      print("\(comId1)")
        //print("testest\(str1!)")
        guard let url1 = URL(string: "http://59.10.47.222:3000/comview11?comCode=\(str1!)&comNum=\(comId1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([ComView1_prev].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.comview1_prev = decodedResponse1
                        
                        print("value:\(self.comview1_prev)")
                        print("건수\(self.comview1_prev.count)")
                        
                        
                        if(self.comview1_prev.count > 1){
                            startLoading()
                            isShowingSheet = true
                        }
                        
                        if(self.comview1_prev.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                            resultText = ""
                            startLoading()
//                            loadData2()
//                            loadData3()
//                            loadData4()
//                            loadData5()
//
                            
                           
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func loadData1(){
       
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
 
        print("testest\(selection2)")
        guard let url2 = URL(string: "http://59.10.47.222:3000/comview1?comCode=\(str1!)&comNum=\(selection2)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data2, response, error in
            if let data2 = data2 {
                let decoder2 = JSONDecoder()
                
                decoder2.dateDecodingStrategy = .iso8601
                
                if let decodedResponse2 = try? decoder2.decode([ComView1].self, from: data2){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.comview1 = decodedResponse2
                        
                        print("value:\(self.comview1)")
                        print("건수\(self.comview1.count)")
                        
                        if(self.comview1.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.comview1.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                            //selection1 = self.comview1[0].clientNoP
                           // comId = self.comview1[0].clientBizNameK
                          
                            resultText = ""
                            loadData22()
                            startLoading()
                            
                       
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func loadData22(){
       
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
 
        
        guard let url2 = URL(string: "http://59.10.47.222:3000/comview2?comCode=\(str1!)&comNum=\(selection2)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data22, response, error in
            if let data22 = data22 {
                let decoder22 = JSONDecoder()
                
                decoder22.dateDecodingStrategy = .iso8601
                
                if let decodedResponse22 = try? decoder22.decode([ComView22].self, from: data22){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.comview22 = decodedResponse22
                        
                        print("value:\(self.comview22)")
                        print("건수\(self.comview22.count)")
                     
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func INIT_1(){
        //거래처조회에서 넘어왔다면
        if passKey == "OK" {
            selection = "comCd"
           // selection1 = barcodeNo
            comId = comCode1
            selection2 = comId
            resultflag = false
            loadData1()
            print("Loading:CompanyView-IN")
        }
        print("Loading:CompanyView")
    }
    
    
}



