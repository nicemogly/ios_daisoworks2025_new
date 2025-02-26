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
        
        var date = Date()
        var edate = Calendar.current.date(byAdding: .day, value: -7, to: date)
        startDate = formattedDate(edate!)
        endDate = formattedDate(date)
        
        loadData1()
    }
  
    func loadData1(){
       // let Userid = UserDefaults.standard.string(forKey: "Userid")
      //  let ID1 = UserDefaults.standard.string(forKey: "Userid")
        var vempno = UserDefaults.standard.string(forKey: "hsid")!
//        if (vempno == nil || vempno?.isEmpty || vempno.equals("") || vempno=="") {
//            let start = ID1.index(ID1.startIndex, offsetBy:2)
//            let end = ID1.index(ID1.startIndex, offsetBy:8)
//            let vdate0 = String(ID1[start..<end])
//        }
        
       // print("\(vempno)")
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
       


#Preview {
    ExhibitionItemView()
}
