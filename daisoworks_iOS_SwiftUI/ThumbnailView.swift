//
//  ThumbnailView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/11/24.
//
import SwiftUI

struct ThumbnailView: View, Identifiable {
    var id = UUID()
    @ViewBuilder var content: any View
    
    var body: some View {
        ZStack {
            AnyView(content)
        }
    }
} 
 
