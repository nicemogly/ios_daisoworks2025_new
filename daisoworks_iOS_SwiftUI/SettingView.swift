//
//  SettingView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 11/13/24.
//

import SwiftUI


struct Com : Identifiable{
    var id = UUID()
    var string: String
}


struct SettingView: View {
    @State private var autoLoginT: Bool = false
    @State private var excutiveT: Bool = false
    
    @State private var version : String = ""
    @State private var vuserid : String = ""
    @State private var showsetAlert = false
   // @State var selectedOption: Option? = nil
    
    @State var coms : [Com] = [
        Com(string:"AD"),
        Com(string:"AH"),
        Com(string:"AS")
    ]
    @State var comSelected: Com?
    
    init(){
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        if(attrComcode == "10005"){
            _comSelected = .init(initialValue: coms[0])
        }else if(attrComcode == "10000"){
            _comSelected = .init(initialValue: coms[1])
        }else if(attrComcode == "00001"){
            _comSelected = .init(initialValue: coms[2])
        }
        
    }
    var body: some View {
        

        VStack(spacing:5){
                HStack{
                    
                    Text("로그인")
                        .font( .system(size: 20))
                        .bold()
                        .padding()
                    Spacer()
                }
                
                HStack{
                    
                    Toggle("자동 로그인", isOn: $autoLoginT)
                        .padding()
                        .font( .system(size: 16))
                        .onChange(of: autoLoginT) {  value in
                            tchange()
                        }
                }.background(Color.lightGray_100)
                    .padding(5)
                    .frame(height: 30)
            
            
            HStack{
                
                Text("버전정보")
                    .font( .system(size: 20))
                    .bold()
                    .padding()
                Spacer()
            }
            .padding(.top,20)
            HStack{
                Text("버전").padding(10)  .font( .system(size: 16))
                Spacer().frame(height:60)
                Text("\(version)").padding(10)  .font( .system(size: 16))
            }.background(Color.lightGray_100)
                .padding(5)
                .frame(height: 30)
            
            
           
            
            let  ss22 = UserDefaults.standard.string(forKey: "Userid")!
            
            if(ss22=="AD2201016" || ss22=="AD2201004" || ss22=="AD2201005"){
               
                HStack{
                    
                    Text("개발자 환경")
                        .font( .system(size: 20))
                        .bold()
                        .padding()
                    Spacer()
                }
                .padding(.top,20)
                VStack{
                    
               
                    HStack{
                        Text("회사정보").padding(10)  .font( .system(size: 16))
                        Spacer().frame(height:60)
                        ForEach(coms) { com in
                            SeasonButton(com: com , comSelected: $comSelected)
                        }
                       
                    }
                
                
                    HStack{
                        
                        Toggle("임원여부", isOn: $excutiveT)
                            .padding(10)
                            .font( .system(size: 16))
                            .onChange(of: excutiveT) {  value in
                                tchange1()
                            }
                    }
                    
                    HStack{
                        Text("사원정보").padding(10)  .font( .system(size: 16))
                        Spacer().frame(height:60)
                        TextField("", text: $vuserid)
                            .padding(5)
                            .background(Color.white)
                        Button(action: {
                            UserDefaults.standard.set("\(vuserid)", forKey: "Userid")
                            
                            if(vuserid=="HS1106470"){
                                UserDefaults.standard.set("10000", forKey: "LoginCompanyCode")
                                UserDefaults.standard.set("430", forKey: "hsid")
                                UserDefaults.standard.set("김교령", forKey: "hnme")
                            }else if(vuserid=="HS1106240"){
                                UserDefaults.standard.set("00001", forKey: "LoginCompanyCode")
                                UserDefaults.standard.set("452", forKey: "hsid")
                                UserDefaults.standard.set("최군", forKey: "hnme")
                            }
                            
                            endTextEditing()
                            showsetAlert = true
                        }, label: {
                            Text("저장")
                        })
                        .alert("알림" , isPresented: $showsetAlert){
                            Button("확인") {
                                
                            }
                        } message: {
                            Text("저장되었습니다")
                        }
                      
                        
                    }
                    HStack{
                        Text("HS사용자").padding(5)  .font( .system(size: 14))
                        Spacer()
                       
                       
                    }
                    
                    HStack{
                        Text("김교령 HS1106470 HMP").padding(5)  .font( .system(size: 14))
                        
                        Text("최군 HS1106240 HS" ).padding(5)  .font( .system(size: 14))
                       
                    }
                    HStack{
                        
                        
                    }
                        
                    
                }.background(Color.lightGray_100)
                    .padding(5)
                    .frame(height: 30)
                   
                    
                }
            
            }
            
        Spacer()
            .onAppear{
                let  ss = UserDefaults.standard.string(forKey: "autologin_Flag")!
                let  ss1 = UserDefaults.standard.string(forKey: "excutive_Flag")!
                let  ss2 = UserDefaults.standard.string(forKey: "Userid")!
                
           
                
                if(ss=="T"){
                    autoLoginT = true
                }
                if(ss1=="T"){
                    excutiveT = true
                }
                
                vuserid = ss2
                
                 version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
                _ = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
                
            }
    
        }
    

    
    func tchange(){
      //  print("autologin\(ss)")
       if(autoLoginT == false){
           UserDefaults.standard.set("F", forKey: "autologin_Flag")
           UserDefaults.standard.set("", forKey: "Userid")
           UserDefaults.standard.set("", forKey: "Passwd")
       }
       
   }
    
    func tchange1(){
       if(excutiveT == false){
           UserDefaults.standard.set("F", forKey: "excutive_Flag")
       }else{
           UserDefaults.standard.set("T", forKey: "excutive_Flag")
       }
       
   }

    
    
    
}

struct SeasonButton: View {
    let com: Com
    @Binding var comSelected: Com?
    let brandColor: Color = Color(red: 28/255, green: 35/255, blue: 40/255)

  //  var action: () -> Void // <-- add closure


    
    var isPressed: Bool {
        if let comSelected {
            if comSelected.id == com.id { return true }
        }
        return false
    }

    var body: some View {
        Button {
            comSelected = com
            if(com.string == "AD") {
                UserDefaults.standard.set("10005", forKey: "LoginCompanyCode")
            }else if(com.string == "AH") {
                UserDefaults.standard.set("10000", forKey: "LoginCompanyCode")
            }else if (com.string == "AS") {
                UserDefaults.standard.set("00001", forKey: "LoginCompanyCode")
            }
            
            
            
           // action() // <-- will be triggered upon button press
            print("\(com.string)")
        } label: {
            Text("\(com.string)")
        }
        .font(.system(size: 16))
        .frame(width: 40, height: 40)
        .background(RoundedRectangle(cornerRadius: 8)
            .fill(brandColor)
        )
        .foregroundStyle(isPressed ? .orange : .white)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isPressed ? Color.orange : Color.white, lineWidth: 3)
        }
    }
}

