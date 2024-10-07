//
//  HomeView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI

struct HomeView: View {
    
    @Binding var presentSideMenu: Bool
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
                        first()
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


