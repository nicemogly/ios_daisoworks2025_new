import SwiftUI
//
//  DetailView.swift
//  daisoworks_ios
//
//  Created by AD2201016P02 on 10/2/24.
//

struct Response: Codable {
  var results: [Result]
}

struct Result: Codable {
  var value: String
}


extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Chkview1: Decodable {
    var versionName: String
    var versionMsg: String
}

struct MuserData: Decodable {
    var usrid: String
    var empmgnum: Int
    var hnme: String
    var deptcde: String
    var deptnme: String
    var empst: String
    var corpcd: String
    var deptgbn: String
}


struct LoginView: View {
    @State private var results = [Result]()
    @State var muserdata = [MuserData]()
    
    enum Field {
        case id
        case password
    }
    
    @State var chkview1 = [Chkview1]()
    
    
    
    
    @State private var toggling = false
    
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isValid: Bool = false
    @State private var notCorrectLogin: Bool = false
    @State private var isShowingDetailView = false
    @State private var isActive: Bool = false
    @FocusState private var focusedField: Field?
    @State var isPresented = false
    @State var chkVersionAlert = false
    @State var chkVerMsg : String = ""
    
    
    var body: some View {
        
        NavigationStack {
            VStack() {
                Image("images/asung_logo_300")
                    .resizable()
                    .frame(width:250 , height:50, alignment: .center)
                    .padding(.top, 50)
                    .padding(.bottom, 30)
            
//                Text("Introduce your credentials")
//                    .foregroundColor(.gray)
//
                TextField("사번", text: $id)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .id)
                    .textContentType(.givenName)
                
                SecureField("비밀번호", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .password)
                    .textContentType(.familyName)
                
                Toggle(isOn: $toggling) {
                    Text("자동 로그인")
                        .font(.subheadline)
                }
                .onChange(of: toggling) {  value in
                    // print("tesT")
                    tchange()
                }
            }
            .onSubmit {
                switch focusedField {
                case .id:
                    focusedField = .password
                default:
                    print("Done")
                }
            }
            .padding()
            
            Button {
                //  isValid = !checkEmailForm(input: id)
                checkLogin(isId: id, isPassword: password)
                
                
                if notCorrectLogin == false {
                    //isActive = true
                    
                    Task {
                        
                        // "AS1410020"
                         //HERP 직책정보등 가져오기
                         // loadData2(str1: str1)
                        // var tmp1 : String = "AS1410020"
                        let tmp1 : String = "AH2101001"
                         loadData2(str1: tmp1)
                     //   await loadData2(str1: id)
                        await loadData1(str1: id)
                        await loadData(str1: id , str2: password)
                    }
                    
                }
            } label: {
                Text("로그인")
                    .frame(width: 300, height: 30)
            }
            .fullScreenCover(isPresented: $isActive){
                LoginView1()
            }
      
            .alert(isPresented: $notCorrectLogin) {
                Alert(title: Text("주의\n"), message: Text("사번, 또는 비밀번호가 일치하지 않습니다."), dismissButton: .default(Text("확인")))
                
            }
            .alert(isPresented: $chkVersionAlert) {
                Alert(title: Text("알림\n"), message: Text("\(chkVerMsg)"), dismissButton: .default(Text("확인")))
                
            }
          
            
   
            
            
            .disabled(id.isEmpty || password.isEmpty /*|| !toggling*/ )
            .buttonStyle(.borderedProminent)
            .padding()
            
            
            if(notCorrectLogin == false) {
//                                NavigationLink(destination: DetailView1(), isActive: $isActive) {
//                                    EmptyView()
//                                }
            }
            
            Spacer()
            
//                .navigationTitle("Login")
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture{
            self.endTextEditing()
        }
        .onAppear{
            
           
            chkVersion()
          
            
        }
    }
    
    private func chkVersion(){
       
     
        //print("testest\(str1!)")
        guard let url1 = URL(string: "http://59.10.47.222:3000/checkversion?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                
                if let decodedResponse1 = try? decoder1.decode([Chkview1].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.chkview1 = decodedResponse1
                        print(self.chkview1[0].versionName)
                        
                        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                        _ = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                      
                        let ss = UserDefaults.standard.string(forKey: "autologin_Flag")
                        let Userid = UserDefaults.standard.string(forKey: "Userid")
                        let password = UserDefaults.standard.string(forKey: "Passwd")
                        // print("testestet"+password!)
                        
                        
                        if(version == self.chkview1[0].versionName) {
                            
                            if(ss=="T"){
                                self.id = Userid!
                                self.password = password!
                                //self.password = "1234"
                                self.toggling = true
                                notCorrectLogin = false
                                
                                Task {
                                    
                                    // "AS1410020"
                                     //HERP 직책정보등 가져오기
                                     // loadData2(str1: str1)
                                   //  var tmp1 : String = "AS1410020"
                                  
                                    let tmp1 : String = "AH2101001"
                                       loadData2(str1: tmp1)
                                    
                                  //  await loadData2(str1: Userid!)
                                    
                                    await loadData1(str1: Userid!)  // HR grade
                                    await loadData(str1: Userid! , str2: password!)
                                    // isActive = true
                                }
                            }
                        }else {
                            chkVerMsg = self.chkview1[0].versionMsg
                            chkVersionAlert = true
                            notCorrectLogin = true
                        }
                      
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    
    private func tchange(){
        let  ss = UserDefaults.standard.string(forKey: "autologin_Flag")
        if(ss=="T"){
            UserDefaults.standard.set("F", forKey: "autologin_Flag")
            UserDefaults.standard.set("", forKey: "Userid")
            UserDefaults.standard.set("", forKey: "Passwd")
        }
        
    }
    private func autoLogin(){
      //  print("test")
    }
    
    private func checkLogin(isId: String, isPassword: String) {
        if !isId.isEmpty || !isPassword.isEmpty  {
            
            if(!notCorrectLogin){
                notCorrectLogin = false
            }else{
                chkVersionAlert = true
            }
        }
        
    }
    
    func loadData(str1: String,str2: String) async {
        guard let  vstr2 = str2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        //let str2 = "%21%40%23Yoon890"
        print(vstr2)
        
        
        guard let url = URL(string: "https://hr.asungcorp.com/cm/service/BRS_CM_RetrieveReturnVal/ajax.ncd?baRq=IN_INPUT&baRs=OUT_RESULT&IN_INPUT.USER_NM="+str1+"&IN_INPUT.VALUE="+vstr2) else {
            print("Invalid URL")
            
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            
            
            let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String: [Any]]
            print(json ?? "")
            if(json==nil) {
                
                notCorrectLogin = true
                
                isActive = false
            }else{
                let items = json?["OUT_RESULT"]!
                
                items?.forEach{ item in
                    guard let object = item as? [String : Any] else { return }
                    let id = object["VALUE"] as! String
                    print(id)
                    if(id=="T") {
                        
                      
                        if(self.toggling){
                            UserDefaults.standard.set("T", forKey: "autologin_Flag")
                            UserDefaults.standard.set(str1, forKey: "Userid")
                            UserDefaults.standard.set(str2, forKey: "Passwd")
                            if(str1.prefix(2)=="AD"){
                                UserDefaults.standard.set("00000", forKey: "LoginCompanyCode")
                            }else if(str1.prefix(2)=="AH"){
                                UserDefaults.standard.set("10000", forKey: "LoginCompanyCode")
                            }else if(str1.prefix(2)=="AS"){
                                UserDefaults.standard.set("00001", forKey: "LoginCompanyCode")
                            }
                            
                            if(str1=="AD2201016"){
                                UserDefaults.standard.set("10000", forKey: "LoginCompanyCode")
                            }
                        }
                        
                        
                     
                        notCorrectLogin = false
                        isActive = true
                        
                        
                        
                    }else{
                        notCorrectLogin = true
                        isActive = false
                    }
                }
            }
            
            
            
        } catch {
            print("Invalid data")
        }
    }
    
    
    func loadData1(str1: String) async {
      
      
        guard let url = URL(string: "https://hr.asungcorp.com/cm/service/BRS_CM_RetrieveEmpTypeReturnVal/ajax.ncd?baRq=IN_INPUT&baRs=OUT_RESULT&IN_INPUT.USER_NM="+str1) else {
            print("Invalid URL")
            
            return
        }
        
        do {
            let (data, meta) = try await URLSession.shared.data(from: url)
            print(meta)
            
            
            let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String: [Any]]
            print(json ?? "")
            if(json==nil) {
                
                notCorrectLogin = true
                
                isActive = false
            }else{
                let items = json?["OUT_RESULT"]!
                
                items?.forEach{ item in
                    guard let object = item as? [String : Any] else { return }
                    let gradeid = object["VALUE"] as! String
                    
                    if(gradeid=="T") {
                        UserDefaults.standard.set("T", forKey: "excutive_Flag")
                    }else{
                        UserDefaults.standard.set("F", forKey: "excutive_Flag")
                    }
                 
                }
            }
            
        } catch {
            print("Invalid excutive return data")
        }
    }
    
    func loadData2(str1: String){
      
        
       // print("str1: \(str1)")
        guard let url1 = URL(string: "http://59.10.47.222:3000/memuser?mUserId=\(str1)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
  

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
    
                
                
                if let decodedResponse1 = try? decoder1.decode([MuserData].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.muserdata = decodedResponse1
                        
                        
                        print("str11")
                        print("value:\(self.muserdata)")
                        print("str1건수\(self.muserdata.count)")
                        
                        
                        
                        if(self.muserdata.count == 0 ){
                    
                        }else{
                            self.muserdata.forEach {
                               
                                UserDefaults.standard.set($0.deptgbn == nil ? "" : $0.deptgbn, forKey: "memdeptgbn")
                                UserDefaults.standard.set($0.deptnme == nil ? "" : $0.deptnme, forKey: "memdeptnme")
                                UserDefaults.standard.set($0.deptcde == nil ? "" : $0.deptcde, forKey: "memdeptcde")
                                
                                
                            }
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
