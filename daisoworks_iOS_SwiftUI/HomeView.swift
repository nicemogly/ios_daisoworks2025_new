//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.03
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    HomeView
//  Program Name       :    HomeView.swift
//  Description        :    1.TabBar 구성
//                          2.관계사별 접근권한
//                          3.TabBar별 View화면 Define
//=============================================================================================================================================================

import SwiftUI

struct HomeView: View {
    
    //================= View : @Binding Group Define Start===============================
    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    @Binding var itemNo: String
    @Binding var comCode1: String
    @Binding var sujubCode: String
    @Binding var sujuMgno: String
    @Binding var passKey: String
    //================= View : @Binding Group Define End===============================
    
    //================= View : @State Group Define Start===============================
    @State private var selectedTab = 0
    //================= View : @State Group Define End===============================
    
    //================= View : Variable Define Start===============================
    private let tabs = [TabData(id:0 , name:"HERP"),TabData(id:1 , name:"DMS")]
    //================= View : Variable Define End===============================
    
    var body: some View {
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        VStack{
            HStack(spacing:0){
                ForEach(tabs, id: \.id) { tab in
                    TabBarItem(selectedTab: $selectedTab, data: tab)
                    Spacer()
                }
            }.background(Color.black.opacity(0.06))
                .clipShape(Capsule())
                .padding(.horizontal)
                .padding(.top, 25)
            Spacer()
           
            TabView(selection: $selectedTab){
                ForEach(tabs, id:\.id){ tab  in
                     if(tab.id == 0  ) {
                         if(attrComcode == "00000"){
                            
                         }else{
                           //첫번째 탭(HERP)이동
                          first(selectedSideMenuTab: $selectedSideMenuTab , comCode1: $comCode1  , itemNo: $itemNo  , sujubCode: $sujubCode , sujuMgno: $sujuMgno, passKey: $passKey )
                         }
                    } else{
                        //DMS탭이동
                        second()
                    }
                    
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .padding(10)
        .onAppear{
                if(attrComcode == "00000"){
                    selectedTab = 1
                }
        }
    }
    
    struct TabData {
        let id: Int
        let name: String
    }
    
    struct TabBarItem: View {
        @Binding var selectedTab: Int
        @State private var Tabshowing = false
        let data : TabData
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
      
        var body: some View {
            
            Button("안내"){
                Tabshowing = true
            }
            .hidden()
            .alert("아성그룹 관계사만 이용 가능합니다.", isPresented: $Tabshowing){
                Button("OK"){
                }
            }
                    Text(data.name)
                        .frame(width: 100 , height:40)
                        .foregroundColor(selectedTab == data.id ? .white : Color.blue.opacity(0.5))
                        .fontWeight(.bold)
                        .padding(.horizontal, 35)
                        .background(Color.blue.opacity(selectedTab == data.id ? 1 : 0))
                        .clipShape(Capsule())
                        .onTapGesture {
                            withAnimation {
                                if(attrComcode == "00000"){ //아성다이소여부
                                    Tabshowing = true
                                }else{
                                    self.selectedTab = data.id
                                }
                            }
                        }
      
        }
    }
    
  
}


