//
//  HomeView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//


import SwiftUI

struct DmsView: View {
    
    @Binding var presentSideMenu: Bool
    
    var body: some View {
        
        
        VStack{
            HStack{
                
                NavigationLink(destination: first()) {
                    Text("Dms VIew")
                    
                }
                
                
            }
            
        }
        
    }
}


