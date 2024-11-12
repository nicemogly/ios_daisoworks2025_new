//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.02
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    Login
//  Program Name       :    LoginView.swift
//  Description        :    1.APP Version Checking후 Safari APP 연동
//                          2.HR User 계정 / 임원정보 가져오기
//                          3.HERP 부서코드,부서명 가져오기
//                          4.AUTO Login Setting
//=============================================================================================================================================================

import SwiftUI
import SafariServices

// ===========================Extension Start========================
// Extension Keyboard Hidden Function
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url:URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
        
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}
// ===========================Extension End===========================

// =======================Result Data Group Start=====================

// Login Result Return
struct Response: Codable {
  var results: [Result]
}

// Login Result Unit Return value
struct Result: Codable {
  var value: String
}

// APP Version Get Info Return Value
struct Chkview1: Decodable {
    var versionName: String
    var versionMsg: String
}

// Login User -> HERP User Dept Info Return Value
struct MuserData: Decodable {
    var usrid: String   //사번
    var empmgnum: Int   //empno
    var hnme: String    //성명
    var deptcde: String //부서코드
    var deptnme: String //부서명
    var empst: String   //입사일자
    var corpcd: String  //회사코드
    var deptgbn: String //부서구분코드(영업등)
}
// =======================Result Data Group End=====================

// Login View Start
struct LoginView: View {
    
    //================= View : @State Group Define Start===============================
    @State private var results = [Result]()
    @State var muserdata = [MuserData]()
    @State var chkview1 = [Chkview1]()
    @State private var toggling = false
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isValid: Bool = false
    @State private var notCorrectLogin: Bool = false //Login Status Flag
    @State private var isShowingDetailView = false
    @State private var isActive: Bool = false
    @State var isPresented = false
    @State var chkVersionAlert = false  // Version Checking Flag
    @State var chkVerMsg : String = ""
    @State var urlStringL = "https://www.naver.com"
    @State var showSafariL = false
    @State var resultTxt: String = ""
    //================= View : @State Group Define End==================================
    
    //================= 자료구조: 열거형 Group Define Start=================================
    enum Field {
        case id
        case password
    }
    //================= 자료구조: 열거형 Group Define End===================================
    
    //Property Wrapper  ->  Text Feild Focusing
    @FocusState private var focusedField: Field?
    
    //================= View : Body View Start==========================================
    var body: some View {
        
        // For Naviagation
        NavigationStack {
            
            VStack() {
                
                //Asung Group Top Log
                Image("images/asung_logo_300")
                    .resizable()
                    .frame(width:250 , height:50, alignment: .center)
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                
                // TextField : id
                TextField("사번", text: $id)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .id)
                    .textContentType(.givenName)
                
                // SecureField : password
                SecureField("비밀번호", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .password)
                    .textContentType(.familyName)
               
                // Toggle
                Toggle(isOn: $toggling) {
                    Text("자동 로그인")
                        .font(.subheadline)
                }
                .onChange(of: toggling) {  value in
                    tchange() // auto Login Toggle Changing Event
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
            Text("\(resultTxt)")
                .foregroundStyle(.red)
                .fontWeight(.bold)
            
            //Login Click Button
            Button {
                
                     //비동기 작업 : iOS 15 이하에서는  Task 안됨.
                     //Taks : View가 나타나기 전 또는 특정한 값이 변경될 때 수행할 비동기 작업을 추가함.
                     Task {
                        await loadData1(str1: id) //HR API Access Try -> 임원여부 T/F
                        await loadData(str1: id , str2: password) //HR API Access Try - > 직원여부 T/F
                              
                    }
                
            } label: {
                Text("로그인")
                    .frame(width: 300, height: 30)
            }
            // Login View 위에 Sheet를 올림.(단,isActive = True) Then.
            .fullScreenCover(isPresented: $isActive){
                LoginView1() // 2차 보안 생체인증 View
            }
            // 최초에는 비밀번호 오류시 Alert를 통해 알리려고 했으나 , 하나의 STACK에 여려개의 isPresented  를 사용할수 없음.
            // 그래서 비밀번호 오류시 Text View로 전환하고 앱 버전 비교 Aleret의 isPresented만 살림
            //           .alert(isPresented: $notCorrectLogin) {
            //                Alert(title: Text("주의\n"), message: Text("사번, 또는 비밀번호가 일치하지 않습니다."), dismissButton: .default(Text("확인")))
            //           }
            
            // 앱버전 비교후 업데이트 사이트로 이동시킴
            .alert(isPresented: $chkVersionAlert) {
                Alert(title: Text("알림\n"),
                      message: Text("\(chkVerMsg)"),
                      dismissButton: .default(Text("확인") , action: { self.urlStringL = "https://pmc.or.kr/app/ios.php"
                      self.showSafariL = true // ios16부터 safari moddule을 앱 형태로 사용할수 있슴. 상단에 import 받아야함.
                })
                )
            }
          
            .disabled(id.isEmpty || password.isEmpty /*|| !toggling*/ )
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSafariL) {
            SafariView(url:URL(string: urlStringL)!)
        }
        .onTapGesture{ // 탭시 키보드 내림
            self.endTextEditing()
        }
        .onAppear{ // view가 보여지기 전 호출. onDisappear : 화면이 사라진뒤 호출
            chkVersion() // 버전 체크
        }
    }
    
    //앱 버전 체크
    private func chkVersion(){
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
                       
                        //서버의 버전
                        self.chkview1 = decodedResponse1
                        print(self.chkview1[0].versionName)
                        
                        //사용자 디바이스 버전 가져오기
                        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                        _ = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                      
                        //디바이스 내부 저장소에 있는 값들을 가져옴.
                        let ss = UserDefaults.standard.string(forKey: "autologin_Flag")
                        let Userid = UserDefaults.standard.string(forKey: "Userid")
                        let password = UserDefaults.standard.string(forKey: "Passwd")
                       
                        //버전이 동일 하면
                        if(version == self.chkview1[0].versionName) {
                        
                            if(ss=="T"){ //자동로그인 이면 아래값들을 다 채워서 자동로그인 로직 처리
                                self.id = Userid!
                                self.password = password!
                                self.toggling = true
                                notCorrectLogin = false
                
                                Task {
                                    await loadData2(str1: Userid!) //HERP 부서정보
                                    await loadData1(str1: Userid!)  // HR 임원여부
                                    await loadData(str1: Userid! , str2: password!) // HR 로그인 여ㅂ
                                }
                            }
                        }else {
                            //버전이 다르면 알림 메세지 뛰우고 업데이트 이동
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
    
    //자동로그인 Toggle Change
    private func tchange(){
        let  ss = UserDefaults.standard.string(forKey: "autologin_Flag")
        if(ss=="T"){
            UserDefaults.standard.set("F", forKey: "autologin_Flag")
            UserDefaults.standard.set("", forKey: "Userid")
            UserDefaults.standard.set("", forKey: "Passwd")
        }
    }
    
    //HR 직원여부 API
    func loadData(str1: String,str2: String) async {
        guard let  vstr2 = str2.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let url = URL(string: "https://hr.asungcorp.com/cm/service/BRS_CM_RetrieveReturnVal/ajax.ncd?baRq=IN_INPUT&baRs=OUT_RESULT&IN_INPUT.USER_NM="+str1+"&IN_INPUT.VALUE="+vstr2) else {
            print("Invalid URL")
            
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String: [Any]]
            
            //F도 있지만 nil도 반환함.
            if(json==nil) {
                resultTxt = "사번, 또는 비밀번호가 일치하지 않습니다."
                notCorrectLogin = true
                isActive = false
            }else{
                let items = json?["OUT_RESULT"]!
                
                items?.forEach{ item in
                    guard let object = item as? [String : Any] else { return }
                    let id = object["VALUE"] as! String
                    
                    //리턴 결과 T 이면
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
                        }
                        notCorrectLogin = false
                        isActive = true
                        resultTxt = ""
                    }else{
                        resultTxt = "사번, 또는 비밀번호가 일치하지 않습니다."
                        notCorrectLogin = true
                        isActive = false
                    }
                }
            }
        } catch {
            print("Invalid data")
        }
    }
    
    //임원여부 가져오기
    func loadData1(str1: String) async {
      
        guard let url = URL(string: "https://hr.asungcorp.com/cm/service/BRS_CM_RetrieveEmpTypeReturnVal/ajax.ncd?baRq=IN_INPUT&baRs=OUT_RESULT&IN_INPUT.USER_NM="+str1) else {
            print("Invalid URL")
            
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data,options: []) as? [String: [Any]]
            print(json ?? "")
            if(json==nil) {
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
    
    //HERP 부서정보
    func loadData2(str1: String) async{
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
                        self.muserdata = decodedResponse1
                        
                        if(self.muserdata.count == 0 ){
                            UserDefaults.standard.set("" , forKey: "memdeptgbn")
                            UserDefaults.standard.set("" , forKey: "memdeptnme")
                            UserDefaults.standard.set("" , forKey: "memdeptcde")
                        }else{
                            self.muserdata.forEach {
                                UserDefaults.standard.set($0.deptgbn , forKey: "memdeptgbn")
                                UserDefaults.standard.set($0.deptnme , forKey: "memdeptnme")
                                UserDefaults.standard.set($0.deptcde , forKey: "memdeptcde")
                                
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
