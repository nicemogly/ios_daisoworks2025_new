//
//  RemoveFocusModifier.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/14/25.
//

import SwiftUI

struct RemoveFocusModifier: ViewModifier {
    @Binding var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                self.isFocused = false
                DispatchQueue.main.async{
                    self.isFocused = false
                }
            }
            .disabled(true)
    }
}
