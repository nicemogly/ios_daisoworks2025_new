//
//  ContentView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
        
        ZStack {
                 ScrollView {
                     VStack(spacing: 5){
                         ForEach(0..<9) { i in
                             ExpandableView(thumbnail: ThumbnailView {
                                 
                                 VStack(alignment: .leading, spacing: 10) {
                                     Text("The art of being an artist")
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .foregroundStyle(.white)
                                         
                                         .font(.custom("ArialRoundedMTBold", size: 20))
                                     
                                     Text("Reading time: 3 mins")
                                         .font(.custom("ArialRoundedMTBold", size: 8))
                                         .foregroundStyle(.white)
                                 }
                                 .padding()
                                 
                             }, expanded: ExpandedView{
                                 VStack(alignment: .leading, spacing: 12) {
                                     Text("The art of being an artist")
                                         .frame(maxWidth: .infinity, alignment: .leading)
                                         .foregroundStyle(.white)
                                         .font(.custom("ArialRoundedMTBold", size: 28))
                                     
                                     Text("Reading time: 3 mins")
                                         .font(.custom("ArialRoundedMTBold", size: 14))
                                         .foregroundStyle(.white)
                                     
                                     Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                                         .font(.custom("ArialRoundedMT", size: 14))
                                         .foregroundStyle(.white)
                                     
                                     Spacer()
                                 }
                                 .padding()
                             }, thumbnailViewBackgroundColor: Color("Gray").opacity(0.7), expandedViewBackgroundColor: Color("Gray"))
                         }
                     }
                 }
                 .scrollIndicators(.never)
                 .padding()
             }
             .background(Color("Yellow"))
    }
}

#Preview {
    ContentView()
}
