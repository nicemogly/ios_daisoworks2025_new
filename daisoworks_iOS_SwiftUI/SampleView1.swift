//
//  Untitled 2.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 4/3/25.
//
import SwiftUI


struct SamAcptListData: Decodable, Identifiable{
    let id = UUID()
    let sammgno: String
    let samnm: String
    let salercpdte: String
}



struct SampleView1: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var presentSideMenu: Bool
    @State private var showDatePicker: Bool = false
    @State private var showDate1Picker: Bool = false
    @State private var selectedDate =  Date()
    @State private var startDate = ""
    @State private var endDate = ""
    @State private var isTextFieldFocused: Bool = false
    @State private var showBottomSheet = false
    @State var samacptlistdata = [SamAcptListData]()
    @State private var showAlert: Bool = false
    
    
    
    var body: some View {
        
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
                                // loadData1()
                                SampleAcceptList()
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
                    
                    Spacer()
                    
                }
                .onAppear{
                    SampleAcceptList()
                }
                
                
                
                ScrollView {
                    
                    Divider()
                    VStack{
                        
                        ForEach(samacptlistdata, id: \.id) { nt2 in
                            
                            //  NavigationLink(destination: ExhibitionUpdateView(name: "\(nt1.exhNum)")){
                            VStack {
                                HStack{
                                    Text("\(nt2.sammgno)")
                                        .font(.system(size:16 , weight: .bold))
                                        .foregroundStyle(.black)
                                        .frame(maxWidth: .infinity , alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(5)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    
                                    
                                    Text("\(nt2.salercpdte)")
                                        .font(.system(size:16 , weight: .bold))
                                        .foregroundStyle(.black)
                                        .frame(maxWidth: .infinity , alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(5)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Spacer()
                                    
                                }.frame(maxWidth: .infinity,  alignment: .leading)
                                    .padding(10)
                            }
                            VStack {
                                HStack {
                                    Text("\(nt2.samnm)")
                                        .font(.system(size:16 , weight: .bold))
                                        .foregroundStyle(.black)
                                        .frame(maxWidth: .infinity , alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(5)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                    Button(action: {
                                        showAlert = true
                                        
                                    }){
                                        Image(systemName: "x.square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                            .padding(.leading, 10)
                                    }
                                }.frame(maxWidth: .infinity,  alignment: .leading)
                                    .padding(10)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("샘플삭제"),
                                    message: Text("해당 샘플 접수건을 삭제하시겠습니까?"),
                                    primaryButton: .destructive(Text("확인")) {
                                        unRegistSample(code: nt2.sammgno)
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                            Divider()
                        }
                        // }
                        
                        Spacer()
                    }
                    
                 
                }
                  
                .padding(.top , 100)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                
                    .scrollIndicators(.hidden)
                    
                    Spacer()
                
                if !showBottomSheet {
                    
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    showBottomSheet.toggle()
                                }
                                
                            }) {
                                // Image(systemName: "plus")
                                Text("샘플 Scan")
                                    .frame(width: 100, height: 30)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .clipShape(Rectangle())
                                    .shadow(radius: 10)
                            }
                            .padding()
                        }
                        
                       
                        
                    }
                    
                  
                }
                if showBottomSheet {
                    BottomSheetView(showBottomSheet: $showBottomSheet)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: showBottomSheet)
                        .onDisappear(perform: {
                            SampleAcceptList()
                        })
                }
                
               
            }
            .navigationTitle("샘플 접수관리")
            .onAppear(perform: INIT_1)
        
        }
        
        func INIT_1(){
            
            let date = Date()
            let edate = Calendar.current.date(byAdding: .day, value: -7, to: date)
            startDate = formattedDate(edate!)
            endDate = formattedDate(date)
        }
    
    
    func  SampleAcceptList(){
        
       var  memempmgnum = UserDefaults.standard.string(forKey: "mempmgnum")!
        print("empno:\(memempmgnum)")
       
        
       // print("test1")
        if memempmgnum.isEmpty {
          //  print("test2")
        }else{
            
           // print("test3")
            guard let url = URL(string: "http://112.175.40.40:3000/samplelist?memempmgnum=\(memempmgnum)&startdate=\(startDate)&enddate=\(endDate)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    
                    decoder.dateDecodingStrategy = .iso8601
                    
                    if let decodedResponse = try? decoder.decode([SamAcptListData].self, from: data){
                        DispatchQueue.main.async {
                            
                           // print("test2")
                            self.samacptlistdata = decodedResponse
                               // isShowingSheet = true
                            if(self.samacptlistdata.count == 0 ){
                               // resultflag = false
                               // resultText = "검색된 결과가 없습니다."
                            }else{
                               // resultText = ""
                               // startLoading()
                            }
                        }
                        return
                    }
                }
            }.resume()
        }
    }

    
    func unRegistSample(code: String ){
        var  memempmgnum = UserDefaults.standard.string(forKey: "mempmgnum")!
       
        //let itemIdOri: String = String(code.dropFirst(2))
        
        if code.isEmpty {
            
        }else{
            
            guard let url = URL(string: "http://112.175.40.40:3000/sampleunregist?samplecode=\(code)&memempmgnum=\(memempmgnum)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data , let responseStr =  String(data: data, encoding: .utf8){
                    print("\(responseStr)")
                    
                    if (responseStr=="ok") {
                        SampleAcceptList()
                      
                    }else{
                      //  showAlert = true
                    }
                }
            }.resume()
        }
    }
    
}
    
   
