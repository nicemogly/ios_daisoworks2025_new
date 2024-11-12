//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.01
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    StartAPP
//  Program Name       :    daisoworks_iOS_SwiftUIApp.swift
//  Description        :    1.Start View 지정
//=============================================================================================================================================================

import SwiftUI

@main // => 시작파일임을 알림.
struct daisoworks_iOS_SwiftUIApp: App {
   
    var body: some Scene {
        WindowGroup { // 뷰들의 컨테이너 역할을 하면서 동시에 터치 이벤트와 같은 이벤트를 가장 먼저 수신하여 서브뷰에게 전달하는 기능을 가지고 있슴.통상 모바일에스는 하나만 사용하는 편임.
        LoginView() // Start View 지정
        }
    }
}
