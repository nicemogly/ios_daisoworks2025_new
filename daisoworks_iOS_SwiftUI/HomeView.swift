//
//  HomeView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI

struct HomeView: View {
    

    @Binding var presentSideMenu: Bool
    @Binding var selectedSideMenuTab: Int
    
    @Binding var itemNo: String
    @Binding  var comCode1: String
    
    @Binding var sujubCode: String
    @Binding var sujuMgno: String
    @Binding  var passKey: String

    
    @State private var selectedTab = 0
    
    private let tabs = [TabData(id:0 , name:"HERP"),TabData(id:1 , name:"DMS")]
    
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
                             first(selectedSideMenuTab: $selectedSideMenuTab , comCode1: $comCode1  , itemNo: $itemNo  , sujubCode: $sujubCode , sujuMgno: $sujuMgno, passKey: $passKey )
                         }
                    } else{
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
                                
                                if(attrComcode == "00000"){
                                    Tabshowing = true
                                }else{
                                    self.selectedTab = data.id
                                }
                                
                                
                                
                            }
                        }
      
        }
    }
    
  
}


