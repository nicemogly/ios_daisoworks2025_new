//
//  AppearanceModifier.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/14/25.
//
 
import SwiftUI

struct AppearanceModifier: ViewModifier {
    init(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mycolor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
    func body(content: Content)-> some View {
        content
    }
}
