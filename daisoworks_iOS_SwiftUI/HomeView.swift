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
    
    private let tabs = [TabData(id:0 , name:"HERP")
                        ,TabData(id:1 , name:"DMS")
    ]
    var body: some View {
        
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
                ForEach(tabs, id:\.id){ tab in
                    if(tab.id == 0 ) {
                        first(selectedSideMenuTab: $selectedSideMenuTab , comCode1: $comCode1  , itemNo: $itemNo  , sujubCode: $sujubCode , sujuMgno: $sujuMgno, passKey: $passKey )
                    } else if(tab.id == 1) {
                        second()
                    }
                    
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        
        
    }

    
    struct TabData {
        let id: Int
        let name: String
    }
    
    struct TabBarItem: View {
        @Binding var selectedTab: Int
        let data : TabData
        
        var body: some View {
            
            Text(data.name)
                .frame(width: 100 , height:40)
                .foregroundColor(selectedTab == data.id ? .white : Color.blue.opacity(0.5))
                .fontWeight(.bold)
                .padding(.horizontal, 35)
                .background(Color.blue.opacity(selectedTab == data.id ? 1 : 0))
                .clipShape(Capsule())
                .onTapGesture {
                    withAnimation {
                        self.selectedTab = data.id
                    }
                }
            
        }
        
    }
    
  
}


