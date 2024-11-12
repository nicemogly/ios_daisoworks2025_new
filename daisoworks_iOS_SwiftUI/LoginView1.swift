//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.03
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    Login
//  Program Name       :    LoginView1.swift
//  Description        :    1.2단계 생체인증 구현 -> deviceOwnerAuthenticationWithBiometrics FacdID Login 안될때 Pin번호 대체
//=============================================================================================================================================================

import SwiftUI
import LocalAuthentication

struct LoginView1: View {
    
    //================= View : @State Group Define Start===============================
    @State private var isFaceIdDone: Bool = false
    @State var isActiv = false
    //================= View : @State Group Define End===============================

    //================= View : Body View Start==========================================
    var body: some View {
        
        NavigationStack {
            VStack(
                alignment: .center,
                spacing: 10
            ){
                //isActiv가 True 이면 MainTabbedView로 이동
                NavigationLink(destination: MainTabbedView().navigationBarBackButtonHidden(true), isActive: $isActiv) {
                    EmptyView()
                }
                
                Text(isFaceIdDone ? "생체인증 완료" : "생체인증")
                    .onAppear{
                        Task.detached{ @MainActor in
                            print("will start on appear main")
                            faceIdAuthentication()
                        }
                    }
                
                Button{
                    isFaceIdDone = false
                    faceIdAuthentication()
                    
                } label: {
                    Text("Reset")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .padding(.vertical, 15)
                        .background{
                            Capsule()
                                .fill(.black)
                        }
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
    
//    
//    func boo() {
//        self.isActiv.toggle()
//    
//    }
    
   
    func faceIdAuthentication(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Daisoworks를 사용하려면 암호를 입력하세요"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason){ success, authenticationError in
                if success{
                    print("successed")
                    isFaceIdDone = true
                    isActiv = true
                }else{
                    print("failed")
            
                }
            }
        }else{
            // Device does not support Face ID or Touch ID
            print("생체인증을 지원하지 않는 디바이스입니다.")
        }
    }
    
 
}
