//
//  ExhibitionItemView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/13/25.
//
 
import SwiftUI

struct ExhListData: Decodable, Identifiable{
    let id = UUID()
    let tclntConNo: String
    let exhComName: String
    let exhNum: String
}

struct ExhibitionItemView: View {
   @State private var showDatePicker: Bool = false
   @State private var showDate1Picker: Bool = false
   @State private var selectedDate =  Date()
   @State private var startDate = ""
   @State private var endDate = ""
   @State private var isTextFieldFocused: Bool = false
   @State var exhlistdata = [ExhListData]()
   @State private var resultText: String = ""
   @State var resultflag = false
   @State private var isLoading = false
   @State private var showAlert = false
   @State private var data = "original data"
   @State private var isSheetPresented: Bool = false
   @State private var isToggleOn: Bool = false
 
    
    
        var body: some View {
          
            NavigationView {
                
                ZStack {
                    
                    
                    VStack {
                        
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                TextField("시작날짜", text: $startDate)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .modifier(RemoveFocusModifier(isFocused: $isTextFieldFocused))
                                    .frame(width:120)
                                    .font(.system(size: 14))
                                    .onTapGesture {
                                        
                                        self.showDatePicker.toggle()
                                    }
                                
                                TextField("종료날짜", text: $endDate)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                    .modifier(RemoveFocusModifier(isFocused: $isTextFieldFocused))
                                    .frame(width:120)
                                    .font(.system(size: 14))
                                    .onTapGesture {
                                       
                                        self.showDate1Picker.toggle()
                                    }
                                
                                Spacer()
                                Button(action: {
                                    loadData1()
                                }){
                                    Text("조 회")
                                        .padding(14)
                                        .padding(.leading)
                                        .padding(.trailing)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                    
                                }
                                
                                
                                
                            }
                            .frame(maxWidth: .infinity)
                            .sheet(isPresented: $showDatePicker) {
                                DatePickerView(showDatePicker: self.$showDatePicker , selectDate: self.$selectedDate, dDate: self.$startDate)
                            }
                            .sheet(isPresented: $showDate1Picker) {
                                DatePickerView(showDatePicker: self.$showDate1Picker , selectDate: self.$selectedDate, dDate: self.$endDate)
                            }
                            .padding()
                            
                            
                        }.background(Color(.bottomcolor))
                            .frame(maxWidth: .infinity)
                        
                        VStack{
                            Toggle(isOn: $isToggleOn){
                                Text("자동입력")
                                .foregroundColor(isToggleOn ? .green : .red)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .padding()
                            .onChange(of: isToggleOn) { newValue in
                                if newValue {
                                    isSheetPresented = true
                                }else{
                                    UserDefaults.standard.set("N", forKey: "autoExhFlag")
                                }
                            }
                        }
                        .frame(height:30)
                        .sheet(isPresented: $isSheetPresented, onDismiss: {
                            isToggleOn = true
                        }) {
                            ExhAutoSetView(isSheetPresented: self.$isSheetPresented)
                        }
                        
                        ScrollView {
                            
                            Divider()
                            VStack{
                               
                                ForEach(exhlistdata, id: \.id) { nt1 in
                                    
                                  //  NavigationLink(destination: ExhibitionUpdateView(name: "\(nt1.exhNum)")){
                                        HStack{
                                            NavigationLink{ExhibitionUpdateView(refreshData: refreshData, paramname1: "\(nt1.tclntConNo)")} label: {
                                                Text("\(nt1.exhNum)")
                                                    .font(.system(size:16 , weight: .bold))
                                                    .foregroundStyle(.black)
                                                    .frame(maxWidth: .infinity , alignment: .leading)
                                                    .multilineTextAlignment(.leading)
                                                    .lineSpacing(5)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                
                                                Text("\(nt1.exhComName)")
                                                    .font(.system(size:16 , weight: .bold))
                                                    .foregroundStyle(.black)
                                                    .frame(maxWidth: .infinity , alignment: .leading)
                                                    .multilineTextAlignment(.leading)
                                                    .lineSpacing(5)
                                                    .lineLimit(1)
                                                    .truncationMode(.tail)
                                                
                                                Spacer()
                                            }
                                        }.frame(maxWidth: .infinity,  alignment: .leading)
                                            .padding(10)
                                        
                                        Divider()
                                    }
                               // }
                                    
                                    Spacer()
                                }
                            }
                            .padding(10)
                            .scrollIndicators(.hidden)
                            
                            Spacer()
                        
                    }
                    
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                           NavigationLink{ExhibitionWriteView(refreshData: refreshData)} label: {
                          //  NavigationLink{Test2()} label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width:24, height:24)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                           
                            .padding()
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("알림"), message: Text("Data updated."), dismissButton: .default(Text("확인"), action: {
                    refreshData()
                }))
            }
            .navigationTitle("전시회 상담관리")
            .onAppear(perform: INIT_1)
            //.modifier(AppearanceModifier())
           
        }
    
    func refreshData() {
        data = "Rrefresh Data"
        showAlert = false
    }
    func startLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
                isLoading = false
                resultflag = true
        }
    }
    
    func INIT_1(){
        
        if(startDate==""){
            var date = Date()
            var edate = Calendar.current.date(byAdding: .day, value: -7, to: date)
            startDate = formattedDate(edate!)
            endDate = formattedDate(date)
        }

        
        var kautoExhFlag = UserDefaults.standard.string(forKey: "autoExhFlag")
        if(kautoExhFlag=="Y"){
            isToggleOn = true
        }
         
        loadData1()
    }
  
    func loadData1(){
       // let Userid = UserDefaults.standard.string(forKey: "Userid")
        let ID1 = UserDefaults.standard.string(forKey: "Userid")!
        var vempno = UserDefaults.standard.string(forKey: "hsid")!
        if (vempno == nil || vempno.isEmpty ||  vempno=="") {
            let start = ID1.index(ID1.startIndex, offsetBy:2)
            let end = ID1.index(ID1.startIndex, offsetBy:9)
            let vdate0 = String(ID1[start..<end])
            vempno = vdate0
        }
        
        //print("VEMPNO:\(vempno)")
        guard let url2 = URL(string: "http://59.10.47.222:3000/exhMyList?schsdate=\(startDate)&schedate=\(endDate)&empno=\(vempno)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data2, response, error in
            if let data2 = data2 {
                let decoder2 = JSONDecoder()
                
                decoder2.dateDecodingStrategy = .iso8601
                
                if let decodedResponse2 = try? decoder2.decode([ExhListData].self, from: data2){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        exhlistdata.removeAll()
                        self.exhlistdata = decodedResponse2
                     
                        if(self.exhlistdata.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                        
                            resultText = ""
                        
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func formattedDate(_ date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
        //let date = dateFormatter.date(from: date)
        return dateFormatter.string(from: date)
    }
}
       


struct ExhAutoSetView: View {
  @Binding var isSheetPresented: Bool
    @State private var aselection  = "전시회 선택"
    @State var exhlistitem = [ExhListItem]()
    @State var aexhselDadte: String = ""
    @State private var selectedDate =  Date()
    @State private var showDatePicker: Bool = false
    @State private var isTextFieldFocused: Bool = false
    @State private var selection1 = "선택"
    @State private var selection2 = "동반자 선택"
    @State private var selection_partner = ""
    @State private var partnerName : String = ""
    @FocusState private var  focusField: Field3?
    @State var resultflag = false
    @State private var showingAlert = false
//    @State private var showingAlert1 = false
//    @State private var showingAlert2 = false
//    @State private var showingAlert3 = false
//    @State private var showingAlert4 = false
    @State private var showingAlert5 = false
    @State private var isShowingSheet = false
    @State private var isShowingSheet1 = false
    @State private var resultText: String = "검색된 결과가 없습니다."
    @State var dataexhpartner = [DataExhPartner]()
    @State private var selection3 = ""
    
   

    var body: some View {
        VStack {
            
            
            VStack(alignment: .center){
             
                    Text("전시회 자동항목 입력")
                        .font(.system(size: 22, weight: .heavy) )
                 
            }.padding(.top,30)
                .padding(.leading,10)
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            VStack(alignment: .leading){
                HStack{
                    Text("전시회 선택")
                        .font(.system(size: 18, weight: .heavy) )
                    Spacer()
                }.padding(.leading,10)
                
            }.padding(.top,10)
            
            
            Picker( selection: $aselection , label: Text("전시회 선택")) {
                
                if aselection == "전시회 선택" {
                    Text("전시회 선택").tag("전시회 선택")
                }
                
                
                ForEach(exhlistitem, id: \.ckey) { item in
                    Text(item.cname).tag(item.ckey)
                }
            }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                .background(Color(uiColor: .secondarySystemBackground))
                .onAppear(perform: loadData)
                .padding(.leading,10)
                .padding(.trailing,10)
            
            
            VStack(alignment: .leading){
                HStack{
                    Text("상담일자")
                        .font(.system(size: 18, weight: .heavy) )
                    Spacer()
                }.padding(.leading,10)
                
            }.padding(.top,10)
            
            HStack(alignment: .top) {
                
                TextField("상담일자", text: $aexhselDadte)
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
                    DatePickerView(showDatePicker: self.$showDatePicker , selectDate: self.$selectedDate, dDate: self.$aexhselDadte)
                }
            
            
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
                            
                            if(selection2 == "동반자 선택" || selection2.isEmpty ) {
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
                                isShowingSheet.toggle()
                            }
                                
                               
                        })
                        .alert(isPresented : $showingAlert5) {
                            Alert(title: Text("알림") , message: Text("동반자 정보가 올바르게 선택되지 않았습니다."), dismissButton: .default(Text("확인")))
                        }
                       
                        //Text("combo:\(selection1)")
                       
                        Spacer()
                        Button("확인" , action: {
                           
                         
                            
                            isShowingSheet = false
                        })
                    }.padding()
                }

            }  
            
            Button("확인") {
                
                //전시회코드, 전시회일자, 동반자정보(selection3, selection_partner)
                  UserDefaults.standard.set("Y", forKey: "autoExhFlag")
                  UserDefaults.standard.set("\(aselection)", forKey: "autoExhselection")
                  UserDefaults.standard.set("\(aexhselDadte)", forKey: "autoExhdate")
                  UserDefaults.standard.set("\(selection3)", forKey: "autoExhselection3")
                  UserDefaults.standard.set("\(selection_partner)", forKey: "autoExhselect_partner")
                  
                
                
             isSheetPresented = false
            }
            .padding()
        }
        
        Spacer()
        Spacer()
    }
    

       
    
  
    
    func loadData(){
        
        guard let url = URL(string: "http://59.10.47.222:3000/exhList?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                if let decodedResponse = try? decoder.decode([ExhListItem].self, from: data){
                    DispatchQueue.main.async {
                        self.exhlistitem = decodedResponse
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
                
                if let decodedResponse = try? decoder.decode([DataExhPartner].self, from: data){
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
    
    func didDismiss() {
        
    }
}


#Preview {
    ExhibitionItemView()
}
