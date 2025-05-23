//
//  ExpandableView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/11/24.
//

import SwiftUI

struct ExpandableView: View {
     
    @Namespace private var namespace
    @State private var show = false
    
    var thumbnail: ThumbnailView
    var expanded: ExpandedView
    
    var thumbnailViewBackgroundColor: Color = .red.opacity(0.8)
    var expandedViewBackgroundColor: Color = .red
    
    var thumbnailViewCornerRadius: CGFloat = 10
    var expandedViewCornerRadius: CGFloat = 10
    
    var body: some View {
        ZStack {
            if !show {
                thumbnailView()
            } else {
                expandedView()
            }
        }
        .onTapGesture {
            if !show {
                withAnimation (.spring(response: 0.6, dampingFraction: 0.8)){
                    
                    show.toggle()
                }
            }
        }
    }
    
    @ViewBuilder
    private func thumbnailView() -> some View {
        ZStack {
            thumbnail
                .matchedGeometryEffect(id: "view", in: namespace)
        }
        
        .background(
            thumbnailViewBackgroundColor.matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: thumbnailViewCornerRadius, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
        )
        
    }
    
    @ViewBuilder
    private func expandedView() -> some View {

        ZStack {
            expanded
                .matchedGeometryEffect(id: "view", in: namespace)
            .background(
                expandedViewBackgroundColor
                    .matchedGeometryEffect(id: "background", in: namespace)
            )
            .mask(
                RoundedRectangle(cornerRadius: expandedViewCornerRadius, style: .continuous)
                    .matchedGeometryEffect(id: "mask", in: namespace)
            )

            Button {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    show.toggle()
                }  
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .matchedGeometryEffect(id: "mask", in: namespace)
        }
    }
}


