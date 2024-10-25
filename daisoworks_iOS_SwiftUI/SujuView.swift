//
//  SujuView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI

enum Field2: Hashable {
    case itemId
}


struct UserSuju: Decodable {
    var comName: String
    var comCd: String
}

struct SujuCount: Decodable {
    var suju_mginit_no : String?
    var suju_dte : String
    var harb_hnmes : String?
    var harb_hnmee : String?
    var cde_nme : String?
    var suju_indi_qty : String?
    var suju_mg_no : String
    var buy_gds_bcd : String
}

struct SujuView1: Decodable {
    var sujumginitno: String?
    var sujudate : String?
    var sujuamt : String?
    var sujuipsum : String?
    var sujuper : String?
    var sujutcategory : String?
    var sujuitemcategory : String?
    var sujuitemdesc : String?
    var sujuitemno : String?
    var sujudelicondition : String?
    var sujumadein  : String?
    var sujumgno : String?
    var sujubarcode : String?
}

struct SujuView2: Decodable {
    var sujustnation : String?
    var sujustcity : String?
    var sujustcenter : String?
    var sujuednation : String?
    var sujuedcity : String?
    var sujuedcenter : String?
}

struct SujuView3: Decodable {
    var buyerinfo : String?
    var buyercif : String?
    var buyertax : String?
}

struct SujuView4: Decodable {
    var clnt_nm_kor : String?
    var cde_nme : String?
    var cde_nmea : String?
    var clnt_corp_cd : String?
}

struct SujuView5: Decodable {
    var comname : String?
    var comdept : String?
    var ownername : String?
    var comdepths : String?
    var ownernamehs : String?
}

struct SujuView6: Decodable {
    var etc1 : String?
    var etc2 : String?
    var etc3 : String?
    var etc4 : String?
}

struct SujuView: View {
    
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    @Binding var itemNo: String
    @Binding var barcodeNo: String
    @Binding var buyCd: String
    @Binding var passKey: String
    @Binding var comCode1: String
    @Binding var sujubCode: String
    @Binding var sujuMgno: String
    

    
    
    @State private var selection  = "바이어 선택"
    
    @State private var selection4  = "수주 선택"
    @State  var usersuju = [UserSuju]()
    @State var sujucount = [SujuCount]()
    @State var sujuview1 = [SujuView1]()
    @State var sujuview2 = [SujuView2]()
    @State var sujuview3 = [SujuView3]()
    @State var sujuview4 = [SujuView4]()
    @State var sujuview5 = [SujuView5]()
    @State var sujuview6 = [SujuView6]()
    
    
    @FocusState private var  focusField2: Field2?
    @State private var itemId : String = ""
    
    @State private var showingAlert = false
    @State private var showItemCntAlert = false
    @State private var isShowingSheet = false
    @State private var resultText: String = ""
    @State var showingFirstSection = true
    @State var resultflag = false
    @State private var isLoading = false
    @State private var sujubcode  = ""
    @State private var sujumgno  = ""
    @State private var scannedString: String = "Scan a QR code or barcode"
    @State private var scnflag: Bool = false
    
    
    var body: some View {
        if(scnflag) {
            ZStack{
                ScannerView(scannedString: $scannedString , scnflag: $scnflag , itemId: $itemId)
                    .edgesIgnoringSafeArea(.all)
            }

        }
        
        
        VStack(alignment:.leading , spacing:0){
            
            Picker( selection: $selection , label: Text("바이어 선택")) {
                
                if selection == "바이어 선택" {
                    Text("바이어 선택").tag("바이어 선택")
                }
                
                
                ForEach(usersuju, id: \.comCd) { item in
                    Text(item.comName).tag(item.comCd)
                }
            }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground))
                .onAppear(perform: loadData)
            
            
            HStack{
                
                TextField("품번 입력", text: $itemId)
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .focused($focusField2, equals: .itemId)
                
                Spacer()
                   
                    if selection == "10005" {
                        Button(action: {
                                scnflag.toggle()
                            }) {
                                Image(systemName: "barcode.viewfinder" )
                                    .resizable()
                                    .frame(width:30 , height:30 , alignment: .center)
                                    .padding(.leading, 10)
                            }
                   }
                       
                
                Button{
                    print("검색")
                    
                    //   print("Value: \(selection)")
                    resultflag = false
                    if selection == "바이어 선택" {
                        self.showingAlert = true
                    }
                    
                    if itemId.isEmpty {
                        focusField2 = .itemId
                        self.showingAlert = true
                    }
                    self.endTextEditing()
                    
                    if self.showingAlert == false {
                        
                         loadData1()
                        
                    }
                    
                    
                }label:{
                    Text("Search")
                        .fontWeight(.bold)
                        .frame(width:100 , height:50)
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
                        Text("수주조회 결과를 선택 하세요").fontWeight(.bold)
                        
                            Picker( selection: $selection4 , label: Text("수주 선택")) {
                            if selection4 == "수주 선택" {
                                Text("수주 선택").tag("수주 선택")
                            }
                            
                            ForEach(sujucount, id: \.suju_mg_no) { item1 in
                                
                                Text("(" + item1.suju_dte + ")" + item1.suju_mg_no).tag(item1.buy_gds_bcd + "^" + item1.suju_mg_no)
                            }
                            
                            
                        }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                            .background(Color(uiColor: .secondarySystemBackground))
                        
                          .onAppear(perform: loadData1)
                        
                        Button("선택" , action: {
                            // selection1 = selection1
                            print("selection4: \(selection4)")
                            let  strsuju = selection4.split(separator: "^")
                            
                            sujubcode = String(strsuju[0])
                            sujumgno = String(strsuju[1])
                     
                            print("sujubcode: \(sujubcode)")
                            print("sujumgno: \(sujumgno)")
                            
                            isShowingSheet.toggle()
                            
                                  loadData2()
                            
                        })
                        Spacer()
                    }.padding(.top , 20)
                    .presentationDetents([.fraction(0.3) , .medium, .large])
                }
                
            }
            
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
                                        .font(.system(size: 18 , weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(sujuview1, id: \.sujumginitno) { item2 in
                                        Spacer()
                                        AsyncImage(url: URL(string: "https://cdn.daisomall.co.kr/file/PD/20240708/fDLihH42tRGSTqojDpSQ1029927_00_00fDLihH42tRGSTqojDpSQ.jpg/dims/optimize/dims/resize/100x150"))
                                        
                                            .frame(maxWidth:.infinity , alignment: .center)
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.sujumginitno ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujudate ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        
                                        HStack (spacing:0){
                                            Text("\(item2.sujuamt ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujuipsum ?? "" )")
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack() {
                                            Text("\(item2.sujuper ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack() {
                                            Text("\(item2.sujuitemno ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujubarcode ?? "" )")
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack() {
                                            Text("\(item2.sujutcategory ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack() {
                                            Text("\(item2.sujuitemcategory ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        HStack() {
                                            Text("\(item2.sujuitemdesc ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        HStack() {
                                            Text("\(item2.sujudelicondition ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujumadein ?? "" )")
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        Spacer()
                                    }
                                    
                                    .padding(10)
                                } //end foreach
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                            //출발/도착 정보
                            
                            ExpandableView(thumbnail: ThumbnailView {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("출발/도착 정보")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.black)
                                        .font(.system( size: 18, weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(sujuview2, id: \.sujustnation) { item2 in
                                        Spacer()
                                      
                                        
                                        HStack(spacing:0) {
                                            Text("출발:\(item2.sujustnation ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujustcity ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujustcenter ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            .padding(.top, 20)
                                        Spacer()
                                        
                                        HStack(spacing:0) {
                                            Text("도착:\(item2.sujuednation ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujuedcity ?? "" )")
                                            Spacer()
                                            Text("\(item2.sujuedcenter ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        
                                        Spacer()
                                    }
                                    
                                    .padding(10)
                                } //end foreach
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                            
                            //바이어 거래 정보
                            
                            ExpandableView(thumbnail: ThumbnailView {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("바이어 거래 정보")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.black)
                                        .font(.system( size: 18, weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(sujuview3, id: \.buyerinfo) { item2 in
                                        Spacer()
                                      
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.buyerinfo ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            .padding(.top, 20)
                                        Spacer()
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.buyercif ?? "" )")
                                            Spacer()
                                           
                                            Text("\(item2.buyertax ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        
                                        Spacer()
                                    }
                                    
                                    .padding(10)
                                } //end foreach
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                           
                            //거래업체 정보
                            
                            ExpandableView(thumbnail: ThumbnailView {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("거래업체 정보")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.black)
                                        .font(.system( size: 18, weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(sujuview4, id: \.clnt_nm_kor) { item2 in
                                        Spacer()
                                      
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.clnt_nm_kor ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            .padding(.top, 20)
                                        Spacer()
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.cde_nme ?? "" )")
                                            Spacer()
                                           
                                            Text("\(item2.cde_nmea ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        
                                        Spacer()
                                    }
                                    
                                    .padding(10)
                                } //end foreach
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                            //담당부서 정보
                            
                            ExpandableView(thumbnail: ThumbnailView {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("담당부서 정보")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.black)
                                        .font(.system( size: 18, weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(sujuview5, id: \.comname) { item2 in
                                        Spacer()
                                      
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.comname ?? "" )")
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                            .padding(.top, 20)
                                        Spacer()
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.comdept ?? "" )")
                                            Spacer()
                                           
                                            Text("\(item2.ownername ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        
                                        Spacer()
                                        
                                        HStack(spacing:0) {
                                            Text("\(item2.comdepths ?? "" )")
                                            Spacer()
                                           
                                            Text("\(item2.ownernamehs ?? "" )")
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        Spacer()
                                    }
                                    
                                    .padding(10)
                                } //end foreach
                               
                               
                            }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.5), expandedViewBackgroundColor: Color("Purplelightcolor"))
                            
                            //기타 정보
                            
                            ExpandableView(thumbnail: ThumbnailView {
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("기타")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(.black)
                                        .font(.system( size: 18, weight: .heavy))
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                
                            }, expanded: ExpandedView{
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(sujuview6, id: \.etc1) { item2 in
                                        Spacer()
                                      
                                        HStack(spacing:0) {
                                            Text("[전용비고]")
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    
                                        HStack(spacing:0) {
                                            Text("\(item2.etc1 ?? "" )")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        
                                        Divider()
                                           
                                        Spacer()
                                        HStack(spacing:0) {
                                            Text("[품질관리]")
                                        }
                                       
                                        HStack(spacing:0) {
                                            Text("\(item2.etc2 ?? "" )")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        Divider()
                                        Spacer()
                                        HStack(spacing:0) {
                                            Text("[불량유형]")
                                        }
                                       
                                        HStack(spacing:0) {
                                            Text("\(item2.etc3 ?? "" )")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        Divider()
                                        Spacer()
                                        HStack(spacing:0) {
                                            Text("[기타]")
                                        }
                                       
                                        HStack(spacing:0) {
                                            Text("\(item2.etc4 ?? "" )")
                                                .fixedSize(horizontal: false, vertical: true)
                                            Spacer()
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 5 ,  alignment: .leading)
                                        Spacer()
                                        
                                        
                                    }
                                    
                                    .padding(10)
                                } //end foreach
                               
                               
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
        }.padding(5)
            .onAppear(perform: INIT_1)
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
                
                if let decodedResponse = try? decoder.decode([UserSuju].self, from: data){
                    DispatchQueue.main.async {
                        self.usersuju = decodedResponse
                    }
                    return
                    
                }
            }
        }.resume()
    }
    
    
    func loadData1(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujucount?comCode=\(str1!)&buyCode=\(selection)&querytxt=\(itemId)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuCount].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujucount = decodedResponse1
                        
                        print("value:\(self.sujucount)")
                        print("건수\(self.sujucount.count)")
                        
                        if(self.sujucount.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujucount.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                           
                          //  selection4 = self.sujucount[0].suju_mg_no
                          
                            resultText = ""

                            
                            
                       
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func loadData2(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
//        print("str1-in:\(str1)")
//        print("selection-in:\(selection)")
//        print("sujumgno-in:\(sujumgno)")
//        print("sujubcode-in:\(sujubcode)")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujuview1?comCode=\(str1!)&buyCode=\(selection)&sujuMgNo=\(sujumgno)&BuyGdsBcd=\(sujubcode)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuView1].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujuview1 = decodedResponse1
                        
                        print("value:\(self.sujuview1)")
                        print("건수\(self.sujuview1.count)")
                        
                        if(self.sujuview1.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujuview1.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                            startLoading()
                            loadData3()
                            loadData4()
                            loadData5()
                            loadData6()
                            loadData7()
                            //selection4 = self.sujuview1[0].sujubarcode
                         
                            resultText = ""
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func loadData3(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
//        print("str1-in:\(str1)")
//        print("selection-in:\(selection)")
//        print("sujumgno-in:\(sujumgno)")
//        print("sujubcode-in:\(sujubcode)")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujuview2?comCode=\(str1!)&buyCode=\(selection)&sujuMgNo=\(sujumgno)&BuyGdsBcd=\(sujubcode)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuView2].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujuview2 = decodedResponse1
                        
                        print("value:\(self.sujuview2)")
                        print("건수\(self.sujuview2.count)")
                        
                        if(self.sujuview2.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujuview2.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
               
                       
                            //selection4 = self.sujuview1[0].sujubarcode
                         
                            resultText = ""
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func loadData4(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujuview3?comCode=\(str1!)&buyCode=\(selection)&sujuMgNo=\(sujumgno)&BuyGdsBcd=\(sujubcode)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuView3].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujuview3 = decodedResponse1
                        
                        print("value:\(self.sujuview3)")
                        print("건수\(self.sujuview3.count)")
                        
                        if(self.sujuview3.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujuview3.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
               
                       
                            //selection4 = self.sujuview1[0].sujubarcode
                         
                            resultText = ""
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func loadData5(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujuview4?comCode=\(str1!)&buyCode=\(selection)&sujuMgNo=\(sujumgno)&BuyGdsBcd=\(sujubcode)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuView4].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujuview4 = decodedResponse1
                        
                        print("value:\(self.sujuview4)")
                        print("건수\(self.sujuview4.count)")
                        
                        if(self.sujuview4.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujuview4.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
               
                       
                            //selection4 = self.sujuview1[0].sujubarcode
                         
                            resultText = ""
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func loadData6(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujuview5?comCode=\(str1!)&buyCode=\(selection)&sujuMgNo=\(sujumgno)&BuyGdsBcd=\(sujubcode)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuView5].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujuview5 = decodedResponse1
                        
                        print("value:\(self.sujuview5)")
                        print("건수\(self.sujuview5.count)")
                        
                        if(self.sujuview5.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujuview5.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
               
                       
                            //selection4 = self.sujuview1[0].sujubarcode
                         
                            resultText = ""
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func loadData7(){
        let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        guard let url1 = URL(string: "http://59.10.47.222:3000/sujuview6?comCode=\(str1!)&buyCode=\(selection)&sujuMgNo=\(sujumgno)&BuyGdsBcd=\(sujubcode)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([SujuView6].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.sujuview6 = decodedResponse1
                        
                        print("value:\(self.sujuview6)")
                        print("건수\(self.sujuview6.count)")
                        
                        if(self.sujuview6.count > 1){
                            isShowingSheet = true
                        }
                        
                        if(self.sujuview6.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
               
                       
                            //selection4 = self.sujuview1[0].sujubarcode
                         
                            resultText = ""
                        }
                    }
                    return
                
                }
            }
        }.resume()
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
        if passKey == "OK" {
            selection = comCode1
            itemId = itemNo
            sujubcode = sujubCode
            sujumgno = sujuMgno
            resultflag = false
            loadData2()
            print("Loading:firstView-IN")
        }
        print("Loading:firstView")
    }
    
}


