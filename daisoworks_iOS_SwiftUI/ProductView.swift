//
//  HomeView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI
import Combine

 
enum Field: Hashable {
    case itemId
}


struct User: Decodable {
    var comName: String
    var comCd: String
}

struct ItemCount: Decodable {
    var buygdsbcd : String
    var gdsno : String
}

struct ItemView1: Decodable {
    var itemNo: String!
    var barcodeNo: String!
    var itemStorePrice: String!
    var itemCategory: String!
    var itemDesc: String!
    var itemGrade: String!
    var itemSalesLead: String!
    var itemIpsu: String!
    var itemDetails: String!
    var itemPictureUrl: String!
}

struct ItemView2: Decodable {
    var clientNoP: String!
    var clientPreNoP: String!
    var clientNameP: String!
    var clientNoB: String!
    var clientPreNoB: String!
    var clientNameB: String!
    var clientNoS: String!
    var clientPreNoS: String!
    var clientNameS: String!
    
}

struct ItemView3: Decodable {
    var ownerDeptName: String!
    var ownerName: String!
    var ownerCompany: String!
    var businessOwnerDept: String!
    var businessOwnerName: String!
    var shipmentDept: String!
    var shipmentOwnerName: String!
    
}

struct ItemView4: Decodable {
    var sampleNewItemNo: String!
    var sampleNItemNo: String!
    var sampleCsNoteNo: String!
    var sampleCsNoteItemNo: String!
    var exhName: String!
    var exhPeriod: String!
    var exhDetail: String!
}

struct ProductView: View {
    
    
    //var buyers = ["주식회사 아성솔루션","(주)아성다이소","DAISO INDUSTRIES CO,LTD"]
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var itemNo: String
    @Binding var barcodeNo: String
    @Binding var buyCd: String
    @Binding var passKey: String
    @Binding var comCode1: String
    
    @State private var Tabshowing = false
    
    @State private var selection  = "바이어 선택"
    
    @State private var selection1  = "바이어 바코드 선택"
    @State var comName : String = ""
    @State  var users = [User]()

    @State var itemview1 = [ItemView1]()
    @State var itemview2 = [ItemView2]()
    @State var itemview3 = [ItemView3]()
    @State var itemview4 = [ItemView4]()
   
    
    @State var itemcount = [ItemCount]()
    @FocusState private var  focusField: Field?
    @State private var itemId : String = ""

    @State private var showingAlert = false
    @State private var showItemCntAlert = false
    @State private var isShowingSheet = false
    @State private var resultText: String = "검색된 결과가 없습니다."
    @State var showingFirstSection = true
    @State var resultflag = false
    @State private var isLoading = false
    @State private var scannedString: String = "Scan a QR code or barcode"
    @State private var scnflag: Bool = false
    
    
    @State private var v_attr5 = ""
    @State private var v_attr6 = ""
    @State private var v_attr7 = ""
   
//    @State var sujubCode:String = ""
//    @State var sujuMgno:String = ""
//    
//    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        VStack(alignment:.leading , spacing:0){
            
            VStack {
                if(scnflag) {
                    ZStack{
                        ScannerView(scannedString: $scannedString , scnflag: $scnflag , itemId: $itemId)
                        //.edgesIgnoringSafeArea(.all)
                    }
                    
                }
            }
          
            Button(""){
                Tabshowing = true
            }
            .alert("아성그룹 관계사만 이용 가능합니다.", isPresented: $Tabshowing){
                Button("OK"){
                    selectedSideMenuTab = 0
                  
                }
            }
           
          
                Picker( selection: $selection , label: Text("바이어 선택")) {
                    
                   if (selection == "바이어 선택" ) {
                       Text("바이어 선택").tag("바이어 선택")
                   }
                    ForEach(users, id: \.comCd) { item in
                        Text(item.comName).tag(item.comCd)
                   }
                }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground))
                .onAppear(perform: loadData)
            
          
                HStack{
              
                TextField("품번 입력", text: $itemId)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .focused($focusField, equals: .itemId)
                
                Spacer()
                   
                    if selection == "10005" {
                        Button(action: {
                                scnflag.toggle()
                                selection = "10005"
                            }) {
                                Image(systemName: "barcode.viewfinder" )
                                    .resizable()
                                    .frame(width:30 , height:30 , alignment: .center)
                                    .padding(.leading, 10)
                            }
                   }
                       
                
            
                    
                Button{
                    print("검색")
                
                    print("Value: \(selection)")
            
                    if selection == "바이어 선택" {
                        self.showingAlert = true
                    }
                    
                    if itemId.isEmpty {
                        focusField = .itemId
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
                        .padding()
                    
                }.alert(isPresented : $showingAlert) {
                    Alert(title: Text("알림") , message: Text("바이어 선택 또는 품번이 유효하지 않습니다"), dismissButton: .default(Text("확인")))
                }
                //alert 안에 중복 품번시 바이어바코드 선택하기
                .sheet(isPresented: $isShowingSheet , onDismiss: didDismiss) {
                    VStack {
                        Text("다수 품번으로 인한 바이어 바코드를 선택 하세요").fontWeight(.bold)
                            
                        Picker( "바이어 바코드 선택" , selection: $selection1 ) {
                            
                            if selection1 == "바이어 바코드 선택" {
                                Text("바이어 바코드 선택").tag("바이어 바코드 선택")
                            }
                   
                            ForEach(itemcount, id: \.buygdsbcd) { item1 in
                               
                                Text(item1.buygdsbcd).tag(item1.buygdsbcd)
                            }
                            
                            
                        }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                            .background(Color(uiColor: .secondarySystemBackground))
                          
                            .onAppear(perform: loadData1)
                        
                        Button("선택" , action: {
                           // selection1 = selection1
                            isShowingSheet.toggle()
                         print("display:0")
                                 //   startLoading()
                                    loadData2()
                                    loadData3()
                                    loadData4()
                                    loadData5()
                         
                        })
                        Spacer()
                        Spacer()
                    }.padding()
                }
                
            }
//            ZStack{
//                ProgressView()
//                    .frame(maxWidth: .infinity)
//                    .scaleEffect(4)
//              
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .opacity(isLoading ? 1 : 0)
//                Text("Loading...")
//                    
//                    .foregroundColor(Color.gray)
//                  
//                    .opacity(isLoading ? 1 : 0)
//            }
            
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
                                VStack(alignment: .center, spacing: 0) {
                                    if(itemview1.count == 0 ){
                                        Spacer()
                                        HStack() {
                                            Text("데이터가 없습니다")
                                            
                                        }.frame(maxWidth: .infinity, maxHeight: 50 ,  alignment: .leading)
                                            .padding()
                                    }else{
                                        ForEach(itemview1, id: \.barcodeNo) { item2 in
                                            
                                            
                                            Spacer()
                                            
                                            AsyncImage(url: URL(string: "http://59.10.47.222:3000/static/\(item2.itemNo!).jpg")){ image in
                                                image.resizable()
                                                
                                            } placeholder: {
                                                ProgressView()
                                            }.frame(width:200 , height:200 , alignment: .center)
                                            
                                            
                                            
                                            
                                            
                                            
                                                .frame(width:300 , height:300 , alignment: .center)
                                            HStack(spacing:0) {
                                                Text("\(item2.itemNo ?? "" )")
                                                Spacer()
                                                Text("\(item2.barcodeNo ?? "" )")
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            
                                            HStack (spacing:0){
                                                Text("\(item2.itemStorePrice ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack() {
                                                Text("\(item2.itemCategory ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack() {
                                                Text("\(item2.itemDesc ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack() {
                                                Text("\(item2.itemSalesLead ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            //itemPictureUrl
                                            HStack() {
                                                //    Text("\(item2.itemIpsu ?? "" )")
                                                //   Text("\(item2.itemPictureUrl ?? "" )")
                                                Spacer()
                                                Text("\(item2.itemDetails ?? "" )")
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            Spacer()
                                        }
                                        
                                        .padding(10)
                                    }
                                        
                                } //end foreach
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                           //거래처정보
                            
                            ExpandableView(thumbnail: ThumbnailView {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("거래처 정보[생산/발주/송금]")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.black)
                                        .font(.system( size: 18, weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading) {
                                    if(itemview2.count == 0 ){
                                        Spacer()
                                        HStack() {
                                            Text("데이터가 없습니다")
                                            
                                        }.frame(maxWidth: .infinity, maxHeight: 50 ,  alignment: .leading)
                                            .padding()
                                    }else{
                                        ForEach(itemview2, id: \.clientNoP) { item3 in
                                           
                                            Spacer()
                                            HStack() {
                                                Text("\(item3.clientNoP ?? "" )")
                                                Spacer()
                                                Text("\(item3.clientPreNoP ?? "" )")
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                                .onTapGesture {
                                                    selectedSideMenuTab = 2
                                                    comCode1 = item3.clientNoP
                                                    passKey = "OK"
                                                }
                                            
                                            
                                            HStack (){
                                                Text("\(item3.clientNameP ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack() {
                                                Text("\(item3.clientNoB ?? "" )")
                                                Spacer()
                                                Text("\(item3.clientPreNoB ?? "" )")
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                                .onTapGesture {
                                                    selectedSideMenuTab = 2
                                                    comCode1 = item3.clientNoP
                                                    passKey = "OK"
                                                }
                                            
                                            
                                            HStack (){
                                                Text("\(item3.clientNameB ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            HStack() {
                                                Text("\(item3.clientNoS ?? "" )")
                                                Spacer()
                                                Text("\(item3.clientPreNoS ?? "" )")
                                            }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                                .onTapGesture {
                                                    selectedSideMenuTab = 2
                                                    comCode1 = item3.clientNoP
                                                    passKey = "OK"
                                                }
                                            
                                            
                                            HStack (){
                                                Text("\(item3.clientNameS ?? "" )")
                                                Spacer()
                                                Spacer()
                                            }.frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            
                                         
                                            Spacer()
                                        }
                                        
                                        
                                        .padding(15)
                                  
                                    } //end foreach
                                    }
                                    
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                           
                            //담당부서
                
                             ExpandableView(thumbnail: ThumbnailView {
                                 
                                 VStack(alignment: .leading, spacing: 10) {
                                     Text("담당부서")
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .foregroundStyle(.black)
                                         .font(.system( size: 18, weight: .heavy))
                                         .fontWeight(.bold)
                                 }
                                 .padding()
                                 
                                 
                                 
                             }, expanded: ExpandedView{
                                 VStack(alignment: .leading) {
                                     if(itemview3.count == 0 ){
                                         Spacer()
                                         HStack() {
                                             Text("데이터가 없습니다")
                                             
                                         }.frame(maxWidth: .infinity, maxHeight: 50 ,  alignment: .leading)
                                             .padding()
                                     }else{
                                         ForEach(itemview3, id: \.ownerDeptName) { item4 in
                                             
                                             Spacer()
                                             HStack() {
                                                 Text("\(item4.ownerDeptName ?? "" )")
                                                 Spacer()
                                                 Text("\(item4.ownerName ?? "" )")
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             HStack (){
                                                 Text("\(item4.ownerCompany ?? "" )")
                                                 Spacer()
                                                 Spacer()
                                             }.frame(maxWidth: .infinity, alignment: .leading)
                                             
                                             HStack() {
                                                 Text("\(item4.businessOwnerDept ?? "" )")
                                                 Spacer()
                                                 Text("\(item4.businessOwnerName ?? "" )")
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             
                                             HStack() {
                                                 Text("\(item4.shipmentDept ?? "" )")
                                                 Spacer()
                                                 Text("\(item4.shipmentOwnerName ?? "" )")
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             
                                             
                                             
                                             Spacer()
                                         }
                                         
                                         
                                         .padding(15)
                                     }
                               
                                 } //end foreach
                                
                                
                             }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                            //샘플정보
                
                             ExpandableView(thumbnail: ThumbnailView {
                                 
                                 VStack(alignment: .leading, spacing: 10) {
                                     Text("샘플정보")
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .foregroundStyle(.black)
                                         .font(.system( size: 18, weight: .heavy))
                                         .fontWeight(.bold)
                                 }
                                 .padding()
                                 
                                 
                                 
                             }, expanded: ExpandedView{
                                 VStack(alignment: .leading) {
                                     if(itemview4.count == 0 ){
                                         Spacer()
                                         HStack() {
                                             Text("데이터가 없습니다")
                                             
                                         }.frame(maxWidth: .infinity, maxHeight: 50 ,  alignment: .leading)
                                             .padding()
                                     }else{
                                         ForEach(itemview4, id: \.sampleNItemNo) { item5 in
                                             
                                             Spacer()
                                             HStack() {
                                                 Text("\(item5.sampleNewItemNo ?? "" )")
                                                 Spacer()
                                                 Text("\(item5.sampleNItemNo ?? "" )")
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             HStack() {
                                                 Text("\(item5.sampleCsNoteNo ?? "" )")
                                                 Spacer()
                                                 Text("\(item5.sampleCsNoteItemNo ?? "" )")
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             HStack() {
                                                 Text("\(item5.exhName ?? "" )")
                                                 Spacer()
                                                 Text("\(item5.exhPeriod ?? "" )")
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             HStack() {
                                                 Text("\(item5.exhDetail ?? "" )")
                                                     .fixedSize(horizontal: false, vertical: true)
                                                 // Text("ehdgoanf동해물 과 백두산이 마르고 \n   닳도록 ehdgoanf동해물과 백두산이 마르고 닳도록 ehdgoanf동해물 과\n 백두산이 마르고 닳도록 ehdgoanf동해물 과 백두산이 마르고 닳도록 ")
                                                     .lineLimit(10)
                                                     .frame(minHeight:30 , maxHeight:100)
                                             }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                             
                                             
                                             
                                             Spacer()
                                         }
                                         
                                         
                                         .padding(15)
                                     }
                               
                                 } //end foreach
                                
                                
                             }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                            
                        }
                    }
                    .scrollIndicators(.never)
                    .padding(0)
                    
                
                   
                }
                .background(.white)
                //.onAppear(perform: loadData2)
              
        
            }else{
                
                VStack(alignment: .center){
                    Image(systemName: "questionmark.text.page.fill")
                        .frame(width:100 , height:100)
                        .font(.system(size:80))
                        .foregroundStyle(.green)
                    Text("\(resultText)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.headline)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                }
                
            
                Spacer()
            }
            
   
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
    
    func loadData(){
       
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
      
        //print("testest\(str1!)")
        guard let url = URL(string: "http://59.10.47.222:3000/buyersch?comCode=\(str1!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([User].self, from: data){
                    DispatchQueue.main.async {
                        self.users = decodedResponse
                    }
                    return
                
                }
            }
        }.resume()
    }

   
    
    func loadData1(){
        
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
      
//        print("testest\(selection)")
//        print("testest\(itemId)")
        guard let url1 = URL(string: "http://59.10.47.222:3000/itemcount?comCode=\(str1!)&buyCode=\(selection)&querytxt=\(itemId)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([ItemCount].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.itemcount = decodedResponse1
                        
                        print("value:\(self.itemcount)")
                        print("건수\(self.itemcount.count)")
                        
                        if(self.itemcount.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.itemcount.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                           
                            selection1 = self.itemcount[0].buygdsbcd
                          
                            resultText = ""
                            loadData2()
                            loadData3()
                            loadData4()
                            loadData5()
                            startLoading()
                            
                         
                       
                        }
                    }
                 
                    return
                
                }
            }
        }.resume()
    }
    
    
    
    func loadData2(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url2 = URL(string: "http://59.10.47.222:3000/itemview1?comCode=\(str1!)&buyCode=\(selection)&BuyGdsBcd=\(selection1)&GdsNo=\(itemId)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data2, response, error in
            if let data2 = data2 {
              let decoder2 = JSONDecoder()
               decoder2.dateDecodingStrategy = .iso8601
               self.itemview1 = []
                
                if let decodedResponse2 = try? decoder2.decode([ItemView1].self, from: data2){
                     DispatchQueue.main.async {
                        self.itemview1 = decodedResponse2
                         
                         self.itemview1.forEach {

                             v_attr5 = $0.itemNo ?? ""
                             v_attr6 = $0.itemPictureUrl ?? ""
                            
                           
                             requestGet1(v_attr5: v_attr5, v_attr6: v_attr6 )
                     
                         }
                         
                         
                    }
                    return
                }
            }
        }.resume()
    }
    
    func loadData3(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url3 = URL(string: "http://59.10.47.222:3000/itemview2?comCode=\(str1!)&buyCode=\(selection)&BuyGdsBcd=\(selection1)&GdsNo=\(itemId)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        let request3 = URLRequest(url: url3)
        URLSession.shared.dataTask(with: request3) { data3, response, error in
            if let data3 = data3 {
              let decoder3 = JSONDecoder()
               decoder3.dateDecodingStrategy = .iso8601
               self.itemview2 = []
                
                if let decodedResponse3 = try? decoder3.decode([ItemView2].self, from: data3){
                     DispatchQueue.main.async {
                        self.itemview2 = decodedResponse3
                    }
                    return
                }
            }
        }.resume()
    }
    
    func loadData4(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url4 = URL(string: "http://59.10.47.222:3000/itemview3?comCode=\(str1!)&buyCode=\(selection)&BuyGdsBcd=\(selection1)&GdsNo=\(itemId)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        let request4 = URLRequest(url: url4)
        URLSession.shared.dataTask(with: request4) { data4, response, error in
            if let data4 = data4 {
              let decoder4 = JSONDecoder()
               decoder4.dateDecodingStrategy = .iso8601
               self.itemview3 = []
                
                if let decodedResponse4 = try? decoder4.decode([ItemView3].self, from: data4){
                     DispatchQueue.main.async {
                        self.itemview3 = decodedResponse4
                    }
                    return
                }
            }
        }.resume()
    }
    
    func loadData5(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url5 = URL(string: "http://59.10.47.222:3000/itemview4?comCode=\(str1!)&buyCode=\(selection)&BuyGdsBcd=\(selection1)&GdsNo=\(itemId)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        let request5 = URLRequest(url: url5)
        URLSession.shared.dataTask(with: request5) { data5, response, error in
            if let data5 = data5 {
              let decoder5 = JSONDecoder()
               decoder5.dateDecodingStrategy = .iso8601
               self.itemview4 = []
                
                if let decodedResponse5 = try? decoder5.decode([ItemView4].self, from: data5){
                     DispatchQueue.main.async {
                        self.itemview4 = decodedResponse5
                    }
                    return
                }
            }
        }.resume()
    }
    
    
    func requestGet1( v_attr5:String , v_attr6:String) {
        
        
        print("==============requestGET1==============")
      
        // var attr3 = v_attr3
        let prefixattr3:String  = "http://herp.asunghmp.biz/FTP"
        let attr5 = v_attr5+".jpg"
        let attr9 = prefixattr3 + v_attr6
   
        print ("attr5: \(attr5)")
        print ("attr9: \(attr9)")
        guard let url3 = URL(string: "http://59.10.47.222:3000/imgdownload?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&reqno=\(attr5)&imgUrl=\(attr9)") else {
            print("Invalid URL")
            
            return
        }
        
        var request = URLRequest(url: url3)
        request.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, (200 ..< 305) ~= response.statusCode else {
                 print("Error: HTTP request failed")
                
                return
            }
            
            guard error == nil else {
                print("Error: error")
                print(error ?? "")
                return
            }
            
            guard data != nil else {
                print("error: did no receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("error: HTTP request failed")
                return
                
            }
            
        
            
          
        }.resume()
        
        
    }
    
    
   
    
    
    
    func ItemDoubleSheet() {
       // Text("test")
    }
    
    func INIT_1(){
        
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        if(attrComcode == "10005"){
            Tabshowing = true
        }else{
            //거래처조회에서 넘어왔다면
            if passKey == "OK" {
                if(buyCd == "" ) {
                    selection = "바이어 선택"
                }else {
                    selection = buyCd
                }
                
                selection1 = barcodeNo
                itemId = itemNo
                resultflag = false
                loadData1()
               
                
                print("Loading:ProductView-IN")
            }
            

            
        }
        
       
        print("Loading:ProductView")
    }
    

}



