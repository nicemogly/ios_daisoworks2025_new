//
//  CardModifier.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/18/24.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius : 1 , x: 1 , y: 1)
                    .opacity(0.9)
            )
    }
}
