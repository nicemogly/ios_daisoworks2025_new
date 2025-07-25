//
//  ExhibitionUpdateView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/24/25.
//


import SwiftUI
import Combine
import PhotosUI
import UIKit  

import SafariServices


enum uField3: Hashable {
    case partnerName
}

enum uField4: Hashable {
    case autoCodeNum
}


enum uField5: Hashable {
    case exhcomname
}

enum uField6: Hashable {
    case exhcomname1
}

enum uField7: Hashable {
    case exhsamp
}

enum uField8: Hashable {
    case exhdaily
}

enum uField9: Hashable {
    case exhcomowner
}


struct uExhAutonum: Decodable {
    var autonum: String
}



struct uExhListItem: Decodable {
    var ckey: String
    var cname: String
}

struct uDataExhPartner: Decodable {
    var nme: String
    var corpcd : String
    var hnme : String
    
}

struct uDataExhCounselNum: Decodable {
    var counselautonum : String
}

struct uDataClientSchDetail1: Decodable {
    var clientNoP: String = ""
    var clientPreNoP: String = ""
    var clientBizNameK: String = ""
    var clientUser1: String = ""
    var clientDept: String = ""
}

struct exhibitionUpdateData: Decodable {
    
    var upoolno: String = ""
    var uvautonum : String
    var uexhDate : String
    var uvdateFormat1 : Int = 0
    var ukint: Int = 0
    var ucomCd: String = ""
    var uexhNum: String = ""
    var uexhSangdamCnt: Int = 0
    var uexhSelCode: String = ""
    var usuggbn: String = ""
    var umemempmgnum: Int = 0
    var upartnerEmpNo: String = ""
    var uexhComName: String = ""
    var uexhSampleCnt: Int = 0
    var uexhSampleRtnYN1: String = ""
    var uuserdept : String = ""
    
}

struct uDataExhPartner1: Decodable {
    
    var nme: String
    var corpcd : String
    var hnme : String
}

struct uDataExhDetail1: Decodable {
    var tclntconno: String
    var seq: Int
    var gbn: String
    var filenme: String
    var fileext: String
    var vtlpath: String
    
}

struct ExhibitionUpdateView: View {
    @Environment(\.presentationMode) var presentationMode
    var refreshData: () -> Void
    
    @State private var selectedURL: IdentifiableURL? = nil
    @State var urlString = ""
    @State var urlString1 = ""
    @State var showSafari = false
    @State private var isDisabled = true
    
    @State private var selection  = "전시회 선택"
    @State private var selection1 = "선택"
    @State private var selection2 = "동반자 선택"
    @State private var selection_partner = ""
    @State private var selection3 = ""
    @State private var selection4 = "업체 선택"
    @State var exhlistitem = [uExhListItem]()
    @State var exhautonum  = [uExhAutonum]()
    @State var dataexhpartner = [uDataExhPartner]()
    @State var dataexhpartner1 = [uDataExhPartner1]()
    @State var dataexhcounselnum = [uDataExhCounselNum]()
    @State var dataclientschdetail1 = [uDataClientSchDetail1]()
    @State var dataexhibitionupdatedata = [exhibitionUpdateData]()
    @State var dataexhdetail1 = [uDataExhDetail1]()
    @State var exhselDadte: String = ""
    @State private var selectedDate =  Date()
    @State private var showDatePicker: Bool = false
    @State private var isTextFieldFocused: Bool = false
    @State var memhnme : String = ""
    @State var memempmgnum : String = ""
    @State var id1 : String = ""
    @FocusState private var  focusField: Field3?
    @FocusState private var  focusField3: Field4?
    @FocusState private var  focusField4: Field5?
    @FocusState private var  focusField5: Field6?
    @FocusState private var  focusField6: Field7?
    @FocusState private var  focusField7: Field8?
    @FocusState private var  focusField8: uField9?
    @State var exhcomname : String = ""
    @State var exhcomname1 : String = ""
    @State var exhcomowner : String = ""
    @State private var partnerName : String = ""
    @State var exhcomname2 : String = ""
    @State var resultflag = false
    @State private var showingAlert = false
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    @State private var showingAlert3 = false
    @State private var showingAlert4 = false
    @State private var showingAlert5 = false
    @State private var isShowingSheet = false
    @State private var isShowingSheet1 = false
    @State private var resultText: String = "검색된 결과가 없습니다."
    @State private var autoCodeNum: String = ""
    @State private var selectedOption: String?
    @State private var selectedOption1: String?
    @State private var selcomflag: Bool = false
    @State private var VLoginCompanyCode: String = ""
    @State private var exhsamp: String = ""
    @State private var exhdaily: String = ""
    @State private var isLoading = false
    @State private var selectedImages: [UIImage] = []
    @State private var selectedImages0: [UIImage] = []
    @State private var additionalParameters: [String: String] = ["vyear": "vyear" , "vmonth": "vmonth" , "vattr1": "value1", "vattr2": "0", "vattr3": "value3", "vattr4": "value4", "vattr5": "value5", "vattr6": "value6", "vattr7": "value7" , "apikey": "value8"]
    
    @State private var additionalParameters0: [String: String] = ["vyear": "vyear" , "vmonth": "vmonth" , "vattr1": "value1", "vattr2": "0", "vattr3": "value3", "vattr4": "value4", "vattr5": "value5", "vattr6": "value6", "vattr7": "value7" , "apikey": "value8"]
    @State private var isImagePickerPresented = false
    @State private var authorizationStatus: PHAuthorizationStatus = .notDetermined
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedItems0: [PhotosPickerItem] = []
    
    @State private var selectedImagesData: [Data] = []
    @State private var selectedImagesData0: [Data] = []
    
    //@State private var selectedImagesData: [(Data)] = []
    @State private var showAlert = false
    @State private var showAlert4 = false
    @State private var alertTitle = ""
    @State var exhcomnamedept : String = ""
    @State private var alertMessage = ""
    @State private var autoCousNum = ""
    @State private var registStr = ""
    @State private var navigateToNextView = false
    @State private var progress = 0.0
    var  paramname1 : String = ""  //파라미터 넘어온값
    
    @State private var imgCount: Int = 0
    @State private var imgCount0: Int = 0

    
    
    @State private var v_attr5 = ""
    @State private var v_attr6 = ""
    @State private var v_attr7 = ""
    @State private var vvseq: Int = 0
    @State private var v_gbn = ""
    
    
    
    
    

    
    var body: some View {
        
        ZStack {
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
//                Color.black.opacity(0.4)
//                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    ProgressView("저장하는 중...", value: progress, total: 1.0)
//                        .progressViewStyle(LinearProgressViewStyle())
//                        .padding()
//
//                }
//                .frame(maxWidth:300)
//                .background(Color.white)
//                .cornerRadius(10)
            }else{
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    VStack {
                        
                        Picker( selection: $selection , label: Text("전시회 선택")) {
                            
                            if selection == "전시회 선택" {
                                Text("전시회 선택").tag("전시회 선택")
                            }
                            
                            
                            ForEach(exhlistitem, id: \.ckey) { item in
                                Text(item.cname).tag(item.ckey)
                            }
                        }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .onAppear(perform: loadData)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담일자")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        HStack(alignment: .top) {
                            
                            TextField("상담일자", text: $exhselDadte)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .frame(width:300)
                                .font(.system(size: 14))
                                .modifier(RemoveFocusModifier(isFocused: $isTextFieldFocused))
                            
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 45))
                                .onTapGesture {
                                    self.showDatePicker.toggle()
                                }
                            
                            Spacer()
                        }.padding(5)
                            .sheet(isPresented: $showDatePicker) {
                                DatePickerView(showDatePicker: self.$showDatePicker , selectDate: self.$selectedDate, dDate: self.$exhselDadte)
                            }
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담자 정보")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text(memhnme+"("+id1+")"+memempmgnum)
                                    .font(.system(size: 18 ))
                                    .foregroundColor(Color.gray)
                                
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("동반자 정보")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        
                        HStack{
                            
                            Picker( selection: $selection1 , label: Text("선택")) {
                                
                                Text("선택").tag("선택")
                                Text("아성HMP").tag("10000")
                                Text("아성").tag("00001")
                                Text("아성다이소").tag("10005")
                            }
                            
                            TextField("동반자 성명", text: $partnerName)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .focused($focusField, equals: .partnerName)
                                .font(.system(size: 14))
                            
                            
                            
                            Button{
                                resultflag = false
                                
                                if selection1 == "선택" {
                                    self.showingAlert = true
                                }
                                
                                if partnerName.isEmpty {
                                    focusField = .partnerName
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
                            }
                            .alert(isPresented : $showingAlert) {
                                Alert(title: Text("알림") , message: Text("동반자 성명이 유효하지 않습니다"), dismissButton: .default(Text("확인")))
                            }
                            .sheet(isPresented: $isShowingSheet , onDismiss: didDismiss) {
                                VStack {
                                    Text("동반자 선택").fontWeight(.bold)
                                    
                                    
                                    Picker( "동반자 선택" , selection: $selection2) {
                                        
                                        if selection2 == "동반자 선택" {
                                            Text("동반자 선택").tag("동반자 선택")
                                        }
                                        
                                        
                                        ForEach(dataexhpartner, id: \.nme) { item1 in
                                            
                                            // Text(item1.hnme).tag(item1.nme + "^" + item1.hnme )
                                            Text("\(item1.hnme)(\(item1.nme))").tag("\(item1.nme)^\(item1.hnme)")
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                    }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                                        .background(Color(uiColor: .secondarySystemBackground))
                                    
                                        .onAppear(perform: loadData1)
                                    //  Text("combo\(selection1)")
                                    
                                    Button("선택" , action: {
                                        
                                        if(selection2 == "동반자 선택" || selection2.isEmpty ) {
                                            showingAlert5 = true
                                        }else{
                                            //comId = selection1
                                            let  str3 = selection2.split(separator: "^")
                                            
                                            let  str4 = str3[1]
                                            partnerName = String(str4)
                                            var vcomname1:String = ""
                                            if(selection1=="10000"){
                                                vcomname1 = "AH"
                                            }else if(selection1=="00001"){
                                                vcomname1 = "AS"
                                            }else if(selection1=="10005"){
                                                vcomname1 = "AD"
                                            }
                                            
                                            
                                            selection3 = "["+vcomname1+"]"+str3[1]+"("+str3[0]+")"
                                            selection_partner = String(str3[0])
                                            
                                            print("aaa:\(selection_partner)")
                                            isShowingSheet.toggle()
                                        }
                                        
                                        
                                    })
                                    .alert(isPresented : $showingAlert5) {
                                        Alert(title: Text("알림") , message: Text("동반자 정보가 올바르게 선택되지 않았습니다."), dismissButton: .default(Text("확인")))
                                    }
                                   
                                    //Text("combo:\(selection1)")
                                   
                                    Spacer()
                                    Button("닫기" , action: {
                                        isShowingSheet = false
                                    })
                                }.padding()
                            }
                        }
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("\(selection3)")
                                    .font(.system(size: 18, weight: .regular) )
                                    .foregroundColor(Color.gray)
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,0)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담일지코드 번호")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        
                        VStack(alignment: .leading){
                            HStack{
                                
                                TextField("상담일지코드 번호", text: $autoCodeNum)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .focused($focusField3, equals: .autoCodeNum)
                                    .font(.system(size: 14))
                                    .disabled(isDisabled)
                                
                                Button{
                                    if(selection=="전시회 선택" || exhselDadte==""){
                                        showingAlert1 = true
                                    }else{
                                       
                                        loadData2()
                                        
                                    }
                                }label:{
                                    Text("자동발번")
                                        .fontWeight(.bold)
                                        .frame(width:80 , height:50)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .buttonStyle(PlainButtonStyle())
                                        .padding()
                                        
                                }
                                .disabled(isDisabled)
                            }
                        }.padding(.leading,10)
                            .alert(isPresented : $showingAlert1) {
                                Alert(title: Text("알림") , message: Text("전시회 미선택 또는 상담일자가 입력되지 않았습니다."), dismissButton: .default(Text("확인")))
                            }
                        
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담업체정보")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        
                        HStack(alignment: .top){
                            SquareRadioButtonGroup(options: ["신규","기존"], selectedOption: $selectedOption)
                            
                            if(selectedOption=="기존") {
                                TextField("업체명 입력", text: $exhcomname)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .focused($focusField4, equals: .exhcomname)
                                    .font(.system(size: 14))
                                    .onDisappear{
                                        exhcomname = ""
                                        exhcomname1 = ""
                                        //exhcomowner = ""
                                    }
                                
                                Button{
                                    
                                    if(exhcomname=="" ){
                                        showingAlert2 = true
                                    }else{
                                        loadData3()
                                    }
                                    
                                }label:{
                                    Text("검색")
                                        .fontWeight(.bold)
                                        .frame(width:60 , height:50)
                                        .background(Color.blue)
                                        .padding(.trailing , 10)
                                        .foregroundColor(.white)
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }else{
                                
                               Spacer()
                            }
                            
                        }
                        .padding(.leading,10)
                        
                        .alert(isPresented : $showingAlert2) {
                            Alert(title: Text("알림") , message: Text("업체명을 입력하세요"), dismissButton: .default(Text("확인")))
                        }
                        .sheet(isPresented: $isShowingSheet1 , onDismiss: didDismiss) {
                            VStack {
                                Text("업체 선택").fontWeight(.bold)
                                
                                
                                Picker( "업체 선택" , selection: $selection4) {
                                    
                                    if selection4 == "업체 선택" {
                                        Text("업체 선택").tag("업체 선택")
                                    }
                                    
                                    
                                    ForEach(dataclientschdetail1, id: \.clientNoP) { item2 in
                                        // print("\(item2.ClietBizNameK)")
                                        //Text("\(item2.clientBizNameK)(\(item2.clientNoP))").tag("\(item2.clientNoP)^\(item2.clientBizNameK)")
                                        //Text("\(item2.clientBizNameK)(\(item2.clientNoP))").tag("\(item2.clientNoP)^\(item2.clientBizNameK)^\(item2.clientPreNoP)")
                                        Text("\(item2.clientBizNameK)(\(item2.clientNoP))").tag("\(item2.clientNoP)^\(item2.clientBizNameK)^\(item2.clientPreNoP)^\(item2.clientUser1)^\(item2.clientDept)")
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                                    .background(Color(uiColor: .secondarySystemBackground))
                                
                                    .onAppear(perform: loadData3)
                                //  Text("combo\(selection1)")
                                
                                Button("선택" , action: {
                                    
                                    if(selection4 == "업체 선택" || selection4.isEmpty ) {
                                        showingAlert4 = true
                                    }else{
                                        
                                        let  str3 = selection4.split(separator: "^")
                                        
                                        let  str4 = str3[1]
                                        let strdept = str3[2]
                                        exhcomname1 = String(str4)
                                        exhcomnamedept =  String(strdept)
                                        
                                        exhcomowner = str3[3] + " : " + str3[4]
                                        print("test\(str4)")
                                        isShowingSheet1.toggle()
                                    }
                       
                                    
                                    
                                })
                                .alert(isPresented : $showingAlert4) {
                                    Alert(title: Text("알림") , message: Text("업체 정보가 올바르게 선택되지 않았습니다."), dismissButton: .default(Text("확인")))
                                }
                                Spacer()
                                Button("닫기" , action: {
                                    isShowingSheet1 = false
                                })
                            }.padding()
                        }
                        
                        
                        VStack(alignment: .leading){
                            
                            TextField("상담업체명을 입력하세요", text: $exhcomname1, axis: .vertical)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .focused($focusField5, equals: .exhcomname1)
                                .font(.system(size: 14))
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }.padding(10)
                        
                        if(selectedOption=="기존") {
                            VStack(alignment: .leading){
                                HStack{
                                    Text("업체 등록 담당부서 정보")
                                        .font(.system(size: 18, weight: .heavy) )
                                    Spacer()
                                }.padding(.leading,10)
                                
                            }.padding(.top,10)
                            
                            VStack(alignment: .leading){
                                
                                TextField("담당부서 정보", text: $exhcomowner, axis: .vertical)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .focused($focusField8, equals: .exhcomowner)
                                    .font(.system(size: 14))
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }.padding(10)
                        }
                        
                
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담샘플수/상담일지장수")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        HStack{
//                            CustomTextField(placeholder:"상담샘플수", text: $exhsamp, onDone:{ hidekeyboard()})
//                                .padding()
//                                .background(Color(uiColor: .secondarySystemBackground))
//                                .focused($focusField6, equals: .exhsamp)
//                               
//                                .font(.system(size: 14))
//                                .onChange(of: exhsamp) { newValue in
//                                    let filteredValue = newValue.filter { ("0"..."9").contains($0) }
//                                    if filteredValue != newValue {
//                                        self.exhsamp = filteredValue
//                                    }
//                                }
                            
                            TextField("상담샘플수", text: $exhsamp)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .focused($focusField6, equals: .exhsamp)
                                .font(.system(size: 14))
                            
                            TextField("상담일지장수", text: $exhdaily)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .focused($focusField7, equals: .exhdaily)
                                .font(.system(size: 14))
                            
//                            CustomTextField(placeholder:"상담일지장수", text: $exhdaily, onDone:{ hidekeyboard()})
//                                .padding()
//                                .background(Color(uiColor: .secondarySystemBackground))
//                                .focused($focusField7, equals: .exhdaily)
//                                .font(.system(size: 14))
//                                .onChange(of: exhdaily) { newValue in
//                                    let filteredValue = newValue.filter { ("0"..."9").contains($0) }
//                                    if filteredValue != newValue {
//                                        self.exhdaily = filteredValue
//                                    }
//                                }
                            
                            Spacer()
                        }.padding(.leading,10)
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("샘플반송여부")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        HStack(alignment: .top){
                            SquareRadioButtonGroup(options: ["Y","N"], selectedOption: $selectedOption1)
                            Spacer()
                        }
                        
                        
                        //상담일지 이미지 업로드
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담일지  : 좌우 스크롤 가능(10장까지만 가능)")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        
                        
                        if(v_attr5 != ""){
                        
                            ForEach(dataexhdetail1, id: \.filenme) { item4 in
                                if(item4.gbn == "D") {
                                    
                                    VStack(alignment: .leading ){
                                        
                                        ScrollView(.horizontal){
                                            
                                            
                                            HStack{
                                                
                                                Text("\(item4.filenme).\(item4.fileext)")
                                                    .frame(width:200)
                                                
                                                
                                                Button(action: {
                                                    //   url =
                                                    //  self.urlString = "http://59.10.47.222:3000/static/\(item4.filenme).\(item4.fileext.trimmingCharacters(in: .whitespacesAndNewlines))"
                                                    selectedURL = IdentifiableURL(url: URL(string: "http://59.10.47.222:3000/static/\(item4.filenme.trimmingCharacters(in: .whitespacesAndNewlines)).\(item4.fileext.trimmingCharacters(in: .whitespacesAndNewlines))")!)
                                                    // self.urlString = "http://59.10.47.222:3001/static/BN2025020172_1.JPG"
                                                   
                                                   // self.showSafari = true
                                                }) {
                                                    Text("이미지보기")
                                                        .foregroundStyle(.white)
                                                        .frame(maxWidth: .infinity)
                                                    //  Text("\(urlString)")
                                                }
                                                .frame(maxWidth: .infinity , maxHeight:50, alignment: .center)
                                                .buttonStyle(.borderedProminent)
                                                .tint(.blue)
                                                
//                                                .sheet(isPresented: $showSafari) {
//                                                    SafariView(url:URL(string:urlString)!)
//
//                                                }
                                              
                                            
                                                
                                                
                                            }.padding(.leading , 10)
                                                .font(.system(size: 14, weight: .heavy) )
                                            
                                            Spacer()
                                            Divider()
                                            
                                                .frame(
                                                    minWidth: 0 ,
                                                    maxWidth: .infinity ,
                                                    minHeight: 0,
                                                    maxHeight: .infinity,
                                                    alignment: .topLeading
                                                )
                                        }
                                        
                                    }
                                }
                          
                            }//end foreach design info
                          
                            .sheet(item: $selectedURL) { IdentifiableURL in
                                SafariView(url: IdentifiableURL.url)
                            }
                        }
                        
                        
                        HStack{
                            
                            PhotosPicker(selection: $selectedItems0 , maxSelectionCount: 10, matching: .images){
                                Text("선택")
                                    .padding()
                                    .background(Color.darkGraycolor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .frame(width:80, height: 50)
                            }
                            
                            .onChange(of: selectedItems0) { newItems in
                                Task {
                                   // selectedImagesData = []
//                                    for item in newItems {
//                                        if let data = try? await item.loadTransferable(type: Data.self){
//                                            selectedImagesData.append(data)
//                                        }
//                                    }
                                    
//                                    for item in newItems {
//                                        if let data = try? await item.loadTransferable(type: Data.self){
//                                            let fileName = item.itemIdentifier?.components(separatedBy: ".").first ?? UUID().uuidString
//                                            let fileExtension = item.itemIdentifier?.components(separatedBy: ".").last ?? "unknown"
//                                            selectedImagesData.append((data, fileName, fileExtension))
//                                            }
//                                        }
                                    
                                    loadImages0()
                                }
                            }
                            .padding()
                            
                            if selectedImagesData0.isEmpty {
                                
                            }else {
                                
                                
                                TabView {
                                    ForEach(selectedImagesData0, id: \.self) { imageData in
                                        if let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxHeight: 200)
                                            
                                            
                                        }
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .frame(width: 200, height: 200)
                            }
                            
                            Spacer()
                        }
                        
                        
                        
                        //상담샘플 이미지 업로드
                        VStack(alignment: .leading){
                            HStack{
                                Text("상담샘플 : 좌우 스크롤 가능(10장까지만 가능)")
                                    .font(.system(size: 18, weight: .heavy) )
                                Spacer()
                            }.padding(.leading,10)
                            
                        }.padding(.top,10)
                        
                        
                        
                        if(v_attr5 != ""){
                        
                            ForEach(dataexhdetail1, id: \.filenme) { item4 in
                                
                                if(item4.gbn == "O") {
                                    VStack(alignment: .leading ){
                                        
                                        ScrollView(.horizontal){
                                            
                                            
                                            HStack{
                                                
                                                Text("\(item4.filenme).\(item4.fileext)")
                                                    .frame(width:200)
                                                
                                                Button(action: {
                                                    //   url =
                                                    //  self.urlString = "http://59.10.47.222:3000/static/\(item4.filenme).\(item4.fileext.trimmingCharacters(in: .whitespacesAndNewlines))"
                                                    selectedURL = IdentifiableURL(url: URL(string: "http://59.10.47.222:3000/static/\(item4.filenme.trimmingCharacters(in: .whitespacesAndNewlines)).\(item4.fileext.trimmingCharacters(in: .whitespacesAndNewlines))")!)
                                                    // self.urlString = "http://59.10.47.222:3001/static/BN2025020172_1.JPG"
                                                    
                                                    urlString1 = urlString
                                                    self.showSafari = true
                                                }) {
                                                    Text("이미지보기")
                                                        .foregroundStyle(.white)
                                                        .frame(maxWidth: .infinity)
                                                    //  Text("\(urlString)")
                                                }
                                                .frame(maxWidth: .infinity , maxHeight:50, alignment: .center)
                                                .buttonStyle(.borderedProminent)
                                                .tint(.blue)
//                                                
//                                                .sheet(isPresented: $showSafari) {
//                                                      
//                                                    
//                                                    SafariView(url:URL(string:urlString)!)
//                                                      
//                                                   
//                                                }
//                                                
//                                               
                                                
                                                
                                            }.padding(.leading , 10)
                                                .font(.system(size: 14, weight: .heavy) )
                                            
                                            Spacer()
                                            Divider()
                                            
                                                .frame(
                                                    minWidth: 0 ,
                                                    maxWidth: .infinity ,
                                                    minHeight: 0,
                                                    maxHeight: .infinity,
                                                    alignment: .topLeading
                                                )
                                        }
                                        
                                    }
                                }
                                
                            }//end foreach design info
                            .sheet(item: $selectedURL) { IdentifiableURL in
                                SafariView(url: IdentifiableURL.url)
                            }
                        }
                        
                        
                        HStack{
                            
                            PhotosPicker(selection: $selectedItems , maxSelectionCount: 10, matching: .images){
                                Text("선택")
                                    .padding()
                                    .background(Color.darkGraycolor)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .frame(width:80, height: 50)
                            }
                            
                            .onChange(of: selectedItems) { newItems in
                                Task {
                                   // selectedImagesData = []
//                                    for item in newItems {
//                                        if let data = try? await item.loadTransferable(type: Data.self){
//                                            selectedImagesData.append(data)
//                                        }
//                                    }
                                    
//                                    for item in newItems {
//                                        if let data = try? await item.loadTransferable(type: Data.self){
//                                            let fileName = item.itemIdentifier?.components(separatedBy: ".").first ?? UUID().uuidString
//                                            let fileExtension = item.itemIdentifier?.components(separatedBy: ".").last ?? "unknown"
//                                            selectedImagesData.append((data, fileName, fileExtension))
//                                            }
//                                        }
                                    
                                    loadImages()
                                }
                            }
                            .padding()
                            
                            if selectedImagesData.isEmpty {
                                
                            }else {
                                
                                
                                TabView {
                                    ForEach(selectedImagesData, id: \.self) { imageData in
                                        if let uiImage = UIImage(data: imageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(maxHeight: 200)
                                            
                                            
                                        }
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle())
                                .frame(width: 200, height: 200)
                            }
                            
                            Spacer()
                        }
                        
                        VStack{
                            
                            HStack{
                                Button(action: {
                                    if(VLoginCompanyCode=="10005"){
                                        memempmgnum = String(id1.suffix(7))
                                        
                                      //  print("확인:\(memempmgnum)")
                                    }
                                    
                                    //전시회코드 체크
                                    if(selection=="" || selection=="전시회 선택"){
                                        alertTitle = "알림"
                                        alertMessage = "전시회를 선택해주세요."
                                        showAlert = true
                                    } else if(exhselDadte==""){  //전시회 상담일자 체크
                                        alertTitle = "알림"
                                        alertMessage = "상담일자를 선택해주세요."
                                        showAlert = true
                                    }else if(memempmgnum==""){ //전시회 상담자 체크
                                        alertTitle = "알림"
                                        alertMessage = "상담자 정보가 없습니다."
                                        showAlert = true
                                    }else if(selection_partner=="" ){ //전시회 동반자 체크
                                        alertTitle = "알림"
                                        alertMessage = "동반자 정보가 없습니다."
                                        showAlert = true
                                    }else if(autoCodeNum=="" ){  //전시회 상담번호 발번 체크
                                        alertTitle = "알림"
                                        alertMessage = "상담번호가 발번되지 않았습니다."
                                        showAlert = true
                                    }else if(exhcomname1=="" ){ //전시회 상담업체 체크
                                        alertTitle = "알림"
                                        alertMessage = "상담업체명 정보가 없습니다."
                                        showAlert = true
                                    }else if(exhsamp=="" ){ //상담샘플수 체크
                                        alertTitle = "알림"
                                        alertMessage = "상담샘플수 정보가 없습니다."
                                        showAlert = true
                                    }else if(exhdaily=="" ){ //상담일지장수 체크
                                        alertTitle = "알림"
                                        alertMessage = "상담일지장수 정보가 없습니다."
                                        showAlert = true
                                    }else {
                                        
                                        isLoading = true
                                        loadDataUpdate()
                                        
                                        //autoCousNum
                                    }
                                    
                                    
                                }) {
                                    Text("수정하기")
                                        .fontWeight(.bold)
                                        .frame(width:100 , height:50)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .buttonStyle(PlainButtonStyle())
                                        .padding()
                                }
                                .alert(isPresented: $showAlert){
                                    Alert(
                                        title: Text(alertTitle),
                                        message: Text(alertMessage),
                                        dismissButton: .default (Text("확인"))
                                    )
                                }
                               
                                
                                NavigationLink(destination: ExhibitionItemView(), isActive: $navigateToNextView) {
                                    EmptyView()
                                } .alert(isPresented : $showingAlert3) {
                                    Alert(title: Text("알림") , message: Text("수정되었습니다."), dismissButton: .default(Text("확인"), action: {
                                        navigateToNextView = true
                                    }))
                                }
                                Spacer()
                                Button(action: {
                                    showAlert4 = true
                                }) {
                                    Text("삭제하기")
                                        .fontWeight(.bold)
                                        .frame(width:100 , height:50)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .buttonStyle(PlainButtonStyle())
                                        .padding()
                                }
                                .alert(isPresented: $showAlert4){
                                    Alert(
                                        title: Text("중요"),
                                        message: Text("정말로 삭제하시겠습니까?"),
                                        primaryButton: .destructive(Text("확인")){
                                            loadDataDelete()
                                           // navigateToNextView = true
                                            self.presentationMode.wrappedValue.dismiss()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                               
                                
//                                NavigationLink(destination: ExhibitionItemView(), isActive: $navigateToNextView) {
//                                    EmptyView()
//                                }
                            }
                            
                        }.padding(10)
                        
                        
                        Spacer()
                        
                        
                    }
                    
                }
                .navigationTitle("전시회 상담수정")
                .onAppear(perform: initData)
            }
        }
    }
    
    
    func registCheck(){
       
    }
    
    
    func loadDataDelete() {
        
       
        //yyyymm , apikey
        guard let url = URL(string: "http://59.10.47.222:3000/exhdelete?vautonum=\(autoCousNum)&vseq=\(vvseq)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data , let responseStr =  String(data: data, encoding: .utf8){
                   
                    registStr = responseStr
                    
               
            }
        }.resume()
    }
    //memempmgnum
    func initData(){
        
      
        checkPhotoLibraryPermission()
        
        //authorizationStatus = PHPhotoLibrary.authorizationStatus()
    
        selectedOption = "신규"
        selectedOption1 = "Y"
//        exhsamp = "1"
//        exhdaily = "1"
        VLoginCompanyCode = UserDefaults.standard.string(forKey: "LoginCompanyCode")!
        //print("paramname1::::\(paramname1)")
        if(!paramname1.isEmpty){
            getExhUpdate()
        }
        
        
    }
    
    func loadDataAutonum() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        var vyymm = formatter.string(from: Date())
       
        //yyyymm , apikey
        guard let url = URL(string: "http://59.10.47.222:3000/autonum?yyyymm=\(vyymm)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([uExhAutonum].self, from: data){
                    DispatchQueue.main.async {
                        self.exhautonum = decodedResponse
                        
                        autoCousNum = self.exhautonum[0].autonum
                         
                        if(autoCousNum != ""){
                            isLoading = true
                            //startLoading()
                           // loadDataRegist()
                        }
                       // print("\(autoCousNum)")
                    }
                    return
                    
                }
            }
        }.resume()
        
    }
    
    func loadDataUpdate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
       // var vyymm = Int(formatter.string(from: Date()))
      
        //BN2025020132
        let start1 = autoCousNum.index(autoCousNum.startIndex , offsetBy: 2)
        let end1 = autoCousNum.index(autoCousNum.startIndex, offsetBy:8)
        var vyymm = autoCousNum[start1..<end1]
        
        let start = autoCousNum.index(autoCousNum.startIndex, offsetBy:8)
        let end = autoCousNum.index(autoCousNum.startIndex, offsetBy:12)
        let vseq = Int(autoCousNum[start..<end])
        let suggbn = "300"
        var vselectedOption = ""
        if( selectedOption1 == "Y"){
            vselectedOption = "0"
        }else{
            vselectedOption = "1"
        }
        
        let memempmgnum1 = memempmgnum
        let memempmgnum2 = memempmgnum
        let memdeptcde  =  UserDefaults.standard.string(forKey: "memdeptcde")!
        let exhDate1 = exhselDadte
        let exhdailyint = Int(exhdaily)
        let exhsampint = Int(exhsamp)
        if(selectedOption=="신규"){
            exhcomnamedept = ""
        }
        //print("Tes")
       
//        ForEach(selectedImagesData, id: \.self) { imageData in
//            rint("\(imageData.)")
//        }
//        for (index , imageData) in selectedImagesData.enumerated() {
//            var kindex = index+1
//            let fileName = autoCousNum + "_" + String(kindex)
//            let fileExtension = imageData.2
//            print("Image \(index + 1): \(fileName).\(fileExtension)")
//        }
        
       //print("selection_partner:\(selection_partner)")
        //20250507 동반자가 아성다이소의 경우 corp_cd = 10005로 변경함.
        var tpartnerEmpNo:Int = selection_partner.count
        var VLoginCompanyCode1 = ""
        
        if(tpartnerEmpNo == 7){
            VLoginCompanyCode1 = "10005"
        }else{
            VLoginCompanyCode1 = VLoginCompanyCode
        }
        
       
        guard let url = URL(string: "http://59.10.47.222:3000/exhupdate1?vautonum=\(autoCousNum)&exhDate=\(exhselDadte)&vdateFormat1=\(vyymm)&kint1=\(vseq!)&comCd=\(VLoginCompanyCode1)&exhNum=\(autoCodeNum)&exhSangdamCnt=\(exhdailyint!)&exhSelCode=\(selection)&suggbn=\(suggbn)&memempmgnum=\(memempmgnum)&partnerEmpNo=\(selection_partner)&exhComName=\(exhcomname1)&exhDate1=\(exhDate1)&memempmgnum1=\(memempmgnum1)&memempmgnum2=\(memempmgnum2)&exhSampleRtnYN1=\(vselectedOption)&exhSampleCnt=\(exhsampint!)&exhDeptNum=\(memdeptcde)&exhClntPoolno=\(exhcomnamedept)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
        
       // print("\(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
     
        URLSession.shared.dataTask(with: request) { data, response, error in
        
            if let error = error {
                registStr = "Error: \(error.localizedDescription)"
            
            } else if let data = data , let responseStr =  String(data: data, encoding: .utf8){
               
                registStr = responseStr
                
                
                if(selectedImagesData.count == 0 && selectedImagesData0.count == 0){
                   
                }else{
                    
                    uploadImages0()
                }
               
               
                
               
                
            } else {
                registStr = "Unknown Error"
            }
        }.resume()
        
        
       
        
        
        refreshData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            showingAlert3 = true
            presentationMode.wrappedValue.dismiss()
        }
       
        
      //  print("\(registStr)")
    }
   
    
    func loadImages0() {

        selectedImagesData0.removeAll()

        for item in selectedItems0 {

            item.loadTransferable(type: Data.self) { result in

                switch result {

                case .success(let data?):

                    selectedImagesData0.append(data)

                case .success(nil):

                    print("No data found")

                case .failure(let error):

                    print("Error loading image data: \(error.localizedDescription)")

                }

            }

        }

    }
    
    
    func loadImages() {

        selectedImagesData.removeAll()

        for item in selectedItems {

            item.loadTransferable(type: Data.self) { result in

                switch result {

                case .success(let data?):

                    selectedImagesData.append(data)

                case .success(nil):

                    print("No data found")

                case .failure(let error):

                    print("Error loading image data: \(error.localizedDescription)")

                }

            }

        }

    }

    
    func uploadImages0(){
    
      //  guard !selectedImagesData.isEmpty else { return }
        
        //print("testest\(str1!)")
        guard let url = URL(string: "http://59.10.47.222:3000/saveImg9") else {
            print("Invalid URL")
            
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
     

        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
   
        
        //print("selectedImagesData.count:\(selectedImagesData.count)")
        //print("selectedImagesData.vvseq:\(vvseq)")
        
        for(index, imageData) in selectedImagesData0.enumerated(){
           // let data = image.jpegData(compressionQuality: 1.0)!
            
            
            imgCount = index+1+vvseq
            imgCount0 = index+1+vvseq
            
            
            
            //var kindex = index+1+vvseq
            var fileName = autoCousNum + "_" + String(imgCount)
           
            
            
            httpBody.append(convertFileData(fieldName: "files0" , fileName: "\(fileName).JPG" , mimeType: "image/jpeg", fileData: imageData, using: boundary))

        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        var vyear = formatter.string(from: Date())
        
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MM"
        var vmonth = formatter1.string(from: Date())
        
        additionalParameters0["vyear"] = vyear
        additionalParameters0["vmonth"] = vmonth
        additionalParameters0["vattr1"] = autoCousNum
        additionalParameters0["vattr2"] = String(vvseq)
        additionalParameters0["vattr4"] = memempmgnum
        additionalParameters0["vattr5"] = memempmgnum
        additionalParameters0["vattr6"] = "/IMAGES/CLNTCON/BCON/" + vyear + "/" + vmonth + "/"
        additionalParameters0["vattr7"] = "\\IMAGES\\CLNTCON\\BCON\\" + vyear + "\\" + vmonth + "\\"
        additionalParameters0["apikey"] = "WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10"
        
        
        
        
        
        for (key, value) in additionalParameters0 {

            httpBody.appendString2("--\(boundary)\r\n")

            httpBody.appendString2("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")

            httpBody.appendString2("\(value)\r\n")

        }



        httpBody.appendString2("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("Error uploading images: \(error)")

                return

            }
         //   isLoading = false
           // print("Upload successful")
            uploadImages()

        }.resume()
        
      
     
        
        
    }
    
    
    func uploadImages(){
    
      //  guard !selectedImagesData.isEmpty else { return }
        
        //print("testest\(str1!)")
        guard let url = URL(string: "http://59.10.47.222:3000/saveImg") else {
            print("Invalid URL")
            
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
     

        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
   
        
        print("selectedImagesData.count:\(selectedImagesData.count)")
        print("selectedImagesData.vvseq:\(vvseq)")
        
        for(index, imageData) in selectedImagesData.enumerated(){
           // let data = image.jpegData(compressionQuality: 1.0)!
            
            
            var kindex = index+1+vvseq
            var fileName = autoCousNum + "_" + String(kindex)
           
            
            
            httpBody.append(convertFileData(fieldName: "files" , fileName: "\(fileName).JPG" , mimeType: "image/jpeg", fileData: imageData, using: boundary))

        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        var vyear = formatter.string(from: Date())
        
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MM"
        var vmonth = formatter1.string(from: Date())
        
        additionalParameters["vyear"] = vyear
        additionalParameters["vmonth"] = vmonth
        additionalParameters["vattr1"] = autoCousNum
        additionalParameters["vattr2"] = String(vvseq)
        additionalParameters["vattr4"] = memempmgnum
        additionalParameters["vattr5"] = memempmgnum
        additionalParameters["vattr6"] = "/IMAGES/CLNTCON/BCON/" + vyear + "/" + vmonth + "/"
        additionalParameters["vattr7"] = "\\IMAGES\\CLNTCON\\BCON\\" + vyear + "\\" + vmonth + "\\"
        additionalParameters["apikey"] = "WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10"
        
        
        
        
        
        for (key, value) in additionalParameters {

            httpBody.appendString2("--\(boundary)\r\n")

            httpBody.appendString2("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")

            httpBody.appendString2("\(value)\r\n")

        }



        httpBody.appendString2("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("Error uploading images: \(error)")

                return

            }
         //   isLoading = false
            print("Upload successful")

        }.resume()
        
      
        
        
//        print("test0\(selectedImagesData.count)")
//
//
//        guard !selectedImagesData.isEmpty else { return }
//
//        let url = URL(string: "http://59.10.47.222:3000/db/postImg?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10")!
//        print("test1")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let httpBody = NSMutableData()
//        print("test2")
//        for(index, imageData) in selectedImagesData.enumerated(){
//           // let data = image.jpegData(compressionQuality: 1.0)!
//            httpBody.append(convertFileData(fieldName: "file\(index)" , fileName: "image\(index).jpg" , mimeType: "image/jpeg", fileData: imageData, using: boundary))
//        print("test2_1")
//        }
//
//        print("test3")
//        for(key, value) in additionalParameters {
//            httpBody.appendString("--\(boundary)\r\n")
//            httpBody.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            httpBody.appendString("\(value)\r\n")
//            print("test3_1")
//        }
//
//        httpBody.appendString("--\(boundary)--")
//        request.httpBody = httpBody as Data
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }else {
//                print("upload successful")
//            }
//
//        }.resume()
//
//        for (index , imageData) in selectedImagesData.enumerated() {
//            var kindex = index+1
//            let fileName = autoCousNum + "_" + String(kindex)
//            let fileExtension = imageData.2
//            print("Image \(index + 1): \(fileName).\(fileExtension)")
//        }
        
        
        
    }
    
    
    
    
    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {

        let data = NSMutableData()

        data.appendString2("--\(boundary)\r\n")

        data.appendString2("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")

        data.appendString2("Content-Type: \(mimeType)\r\n\r\n")

        data.append(fileData)

        data.appendString2("\r\n")

        return data as Data

    }
    
   
    
    func loadData(){
        
        memhnme = UserDefaults.standard.string(forKey: "hnme")!
        memempmgnum = UserDefaults.standard.string(forKey: "hsid")!
        id1 = UserDefaults.standard.string(forKey: "Userid")!
        
       // let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        
        //print("testest\(str1!)")
        guard let url = URL(string: "http://59.10.47.222:3000/exhList?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([uExhListItem].self, from: data){
                    DispatchQueue.main.async {
                        self.exhlistitem = decodedResponse
                    }
                    return
                    
                }
            }
        }.resume()
        
       
    }
    
    func getExhUpdate(){
       // print("paramvalueparamname11111\(paramname1)")
        memhnme = UserDefaults.standard.string(forKey: "hnme")!
        memempmgnum = UserDefaults.standard.string(forKey: "hsid")!
        id1 = UserDefaults.standard.string(forKey: "Userid")!
       
       // let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        
        //print("testest\(str1!)")
        guard let url = URL(string: "http://59.10.47.222:3000/exhupdate?vautonum=\(paramname1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
       
        
     
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
              
             //   print("paramvaluecnt11111:\(data)")
                if let decodedResponse = try? decoder.decode([exhibitionUpdateData].self, from: data){
                    DispatchQueue.main.async {
                        self.dataexhibitionupdatedata = decodedResponse
                       // print("paramvaluecnt32222:")
                        
                        print("paramvaluecnt\(dataexhibitionupdatedata.count)")
                        if(self.dataexhibitionupdatedata.count == 0 ){
                            //resultflag = false
                            //resultText = "검색된 결과가 없습니다."
                        }else{
                            autoCousNum = self.dataexhibitionupdatedata[0].uvautonum
                            selection =  self.dataexhibitionupdatedata[0].uexhSelCode
                            exhselDadte = self.dataexhibitionupdatedata[0].uexhDate
                            memempmgnum = String(self.dataexhibitionupdatedata[0].umemempmgnum)
                            selection_partner = String(self.dataexhibitionupdatedata[0].upartnerEmpNo)
                            loadexhpartner1(upartnerEmpno1: String(self.dataexhibitionupdatedata[0].upartnerEmpNo))
                            
                            autoCodeNum = self.dataexhibitionupdatedata[0].uexhNum
                            exhcomname1 = self.dataexhibitionupdatedata[0].uexhComName
                            exhsamp = String(self.dataexhibitionupdatedata[0].uexhSampleCnt)
                            exhdaily = String(self.dataexhibitionupdatedata[0].uexhSangdamCnt)
                           
                            var vselectedOption1 = self.dataexhibitionupdatedata[0].uexhSampleRtnYN1
                            if(vselectedOption1 == "0"){
                                selectedOption1 = "Y"
                            }else{
                                selectedOption1 = "N"
                            }
                            exhcomowner = self.dataexhibitionupdatedata[0].uuserdept
                            
                            exhcomnamedept = self.dataexhibitionupdatedata[0].upoolno.replacingOccurrences(of: " ", with: "")
                           //print("compoolno:\(exhcomnamedept)")
                            if(exhcomnamedept.isEmpty){
                                selectedOption = "신규"
                            }else{
                                selectedOption = "기존"
                            }
                           
                            loadexhdetail(vparamname1: paramname1)
                            
                         
                        }
                        
                        
//                        if(self.dataexhcounselnum[0].counselautonum == "0" ){
//                            autoCodeNum = "T"+exhselDadte+"-01"
//                        }else{
//                            //T2025-01-22-01
//                            var VautoCodeNum: String = ""
//                            VautoCodeNum = self.dataexhcounselnum[0].counselautonum
//                        }
                    }
                    return
                    
                }
            }
        }.resume()
        
       
    }
    
    func loadexhdetail(vparamname1:String){
          //let partnerName1 = "%"+partnerName+"%"
//print("testest:\(vparamname1)")
        guard let url = URL(string: "http://59.10.47.222:3000/exhDetail?vautonum=\(vparamname1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        // = [uDataExhDetail1]()
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([uDataExhDetail1].self, from: data){
                    DispatchQueue.main.async {
                        self.dataexhdetail1 = decodedResponse
                            //isShowingSheet = true
                        
                       // print("tttt\(self.dataexhdetail1.count)")
                        if(self.dataexhdetail1.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                            var ktint: Int = 0
                           // print("==============requestGET1==============2")
                            self.dataexhdetail1.forEach {
                                
                                v_gbn = $0.gbn.trimmingCharacters(in: .whitespacesAndNewlines)
                                v_attr5 = $0.filenme.trimmingCharacters(in: .whitespacesAndNewlines)
                                v_attr6 = $0.fileext.trimmingCharacters(in: .whitespacesAndNewlines)
                                v_attr7 = $0.vtlpath.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                
                               
                                
//                                print("v_attr5:\(v_attr5)")
//                                print("v_attr5cnt:\(v_attr5.count)")
//                                print("v_attr6:\(v_attr6)")
//                                print("v_attr6cnt:\(v_attr6.count)")
                                
                                 requestGet(v_attr5:v_attr5,v_attr6:v_attr6,v_attr7:v_attr7)
                                
                                
                                if(ktint == 0) {
                                    self.urlString = "http://59.10.47.222:3000/static/\($0.filenme.trimmingCharacters(in: .whitespacesAndNewlines)).\($0.fileext.trimmingCharacters(in: .whitespacesAndNewlines))"
                                  //  print("\(self.urlString)")
                                   // urlString = ""
                                }
                                ktint = ktint + 1
                                vvseq = ktint
                            }
                            
                           // print("vvseqvvseqvvseq:\(vvseq)")
                            
                        }
                    }
                    return
                }
            }
        }.resume()
    }
    
    
    func loadexhpartner1(upartnerEmpno1:String){
          //let partnerName1 = "%"+partnerName+"%"

        guard let url = URL(string: "http://59.10.47.222:3000/exhPartner1?empno=\(upartnerEmpno1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([uDataExhPartner1].self, from: data){
                    DispatchQueue.main.async {
                        self.dataexhpartner1 = decodedResponse
                            //isShowingSheet = true
                        if(self.dataexhpartner1.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                            resultText = ""
                           // startLoading()
                            
                            var ktitle=""
                            var kcomcd1 = ""
                            if(dataexhpartner1[0].corpcd=="77777"){
                                kcomcd1=""
                            }else if(dataexhpartner1[0].corpcd=="10000"){
                                kcomcd1="AH"
                            }else if(dataexhpartner1[0].corpcd=="00001"){
                                kcomcd1="AS"
                            }else if(dataexhpartner1[0].corpcd=="10005"){
                                kcomcd1="AD"
                            }
                            
                            
                            selection3 = "["+kcomcd1+"]"+dataexhpartner1[0].hnme+"("+dataexhpartner1[0].nme+")"
                            
                        }
                    }
                    return
                }
            }
        }.resume()
    }
    
    
    func loadData1(){
          let partnerName1 = "%"+partnerName+"%"

        guard let url = URL(string: "http://59.10.47.222:3000/exhPartner?comCode=\(selection1)&uname=\(partnerName1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([uDataExhPartner].self, from: data){
                    DispatchQueue.main.async {
                        self.dataexhpartner = decodedResponse
                            isShowingSheet = true
                        if(self.dataexhpartner.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                            resultText = ""
                           // startLoading()
                        }
                    }
                    return
                }
            }
        }.resume()
    }
    
    //전시회 상담 번호 자동발번
    func loadData2(){
        
//        print("test\(selection)")
//        print("test\(exhselDadte)")
        guard let url = URL(string: "http://59.10.47.222:3000/exhCounselNum?exhnum=\(selection)&mdate=\(exhselDadte)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([uDataExhCounselNum].self, from: data){
                    DispatchQueue.main.async {
                        self.dataexhcounselnum = decodedResponse
                        
                        
                        if(self.dataexhcounselnum[0].counselautonum == "0" ){
                            autoCodeNum = "T"+exhselDadte+"-01"
                        }else{
                           //T2025-01-22-01
                            var VautoCodeNum: String = ""
                            VautoCodeNum = self.dataexhcounselnum[0].counselautonum
                            
                            let vstart = VautoCodeNum.index(VautoCodeNum.startIndex, offsetBy:0)
                            let vend = VautoCodeNum.index(VautoCodeNum.startIndex, offsetBy:11)
                            let start = VautoCodeNum.index(VautoCodeNum.startIndex, offsetBy:12)
                            let end = VautoCodeNum.index(VautoCodeNum.startIndex, offsetBy:14)
                            let vdate0 = String(VautoCodeNum[vstart..<vend])
                            let vdate = Int(VautoCodeNum[start..<end])!+1
                           
                           
                            var strvdate = String(vdate)
                            if vdate < 10 {
                                strvdate = "0"+strvdate
                            }
                            
                            autoCodeNum = vdate0+"-"+strvdate
                        }
                       
                    }
                    return
                }
            }
        }.resume()
    }
    
    func loadData3(){
          var vexhcomname = "%"+exhcomname+"%"

        guard let url = URL(string: "http://59.10.47.222:3000/comview11?comCode=\(VLoginCompanyCode)&comNum=\(vexhcomname)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
     
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
           
                if let decodedResponse = try? decoder.decode([uDataClientSchDetail1].self, from: data){
                    DispatchQueue.main.async {
                        self.dataclientschdetail1 = decodedResponse
                         
                       
//                        if(self.dataclientschdetail1.count == 0 ){
//                           
//                        }else{
                            isShowingSheet1 = true
                           
                       // }
                    }
                    return
                }
            }
        }.resume()
    }
    
    func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            isLoading = false
            //resultflag = true
        }
    }
    

    
    
    
    func didDismiss() {
        
    }
    
    func getFileName(from item: PhotosPickerItem) async -> String {
        
        //print("test1\(item.itemIdentifier)")
        return item.itemIdentifier ?? UUID().uuidString
    }
    
    func getFileExtension(from item: PhotosPickerItem) async -> String {
        
      //  print("test2")
        if let assetType = item.supportedContentTypes.first?.preferredFilenameExtension {
            return assetType
            
        }else {
            return "unknown"
        }
    }
    
    func checkPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                authorizationStatus = status
                if status == .authorized {
                    if status == .authorized {
                       // isImagePickerPresented = true
                    }else{
                        print("사진 라이브러리 접근권한이 거부되었습니다.")
                    }
                }
            }
        }
    }
    
    func hidekeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func requestGet( v_attr5:String , v_attr6:String, v_attr7:String) {
        
     
        var prefixattr3 = ""
        var attr5 = ""
        var imgUrl1 = ""
        
        attr5 = v_attr5+"."+v_attr6
        
        
      
        prefixattr3 = "http://herpold.asunghmp.biz/FTP"
   
        
        imgUrl1 = prefixattr3+v_attr7+v_attr5+"."+v_attr6
        
        guard let url3 = URL(string: "http://59.10.47.222:3000/imgdownload?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&reqno=\(attr5)&imgUrl=\(imgUrl1)") else {
            Swift.print("Invalid URL")
            
            return
        }
        
        var request = URLRequest(url: url3)
        request.httpMethod = "GET"
        
        
        Foundation.URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 305) ~= response.statusCode else {
                Swift.print("Error: HTTP request failed")
                
                return
            }
            
            guard error == nil else {
                Swift.print("Error: error")
                
                return
            }
            
            guard data != nil else {
                Swift.print("error: did no receive data")
                return
            }
            
            
            
            
            
        }.resume()
        
        
    }
    
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

extension NSMutableData {

    func appendString2(_ string: String) {

        if let data = string.data(using: .utf8) {

            append(data)

        }

    }

}




//
//#Preview {
//    ExhibitionWriteView()
//}
