//
//  SquareRadioButtonLabel.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/18/25.
//

import SwiftUI

struct SquareRadioButtonLabel: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action){
                Rectangle()
                    .fill(isSelected ? Color.blue : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Rectangle()
                            .stroke(Color.blue , lineWidth: 2)
                    )
            }
            
            Text(text)
                .foregroundColor(.black)
               
                .font(.system(size: 14))
            
            
        }
       
  
        .frame(width: 60, height: 50)
    }
}



