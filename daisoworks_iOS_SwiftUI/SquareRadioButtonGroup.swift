//
//  SquareRadioButtonGroup.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/18/25.
//
import SwiftUI

struct SquareRadioButtonGroup: View {
    let options: [String]
    @Binding var selectedOption: String?
  
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(options, id: \.self) { option in
                
                    SquareRadioButtonLabel(
                        text: option,
                        isSelected: selectedOption == option
                    ){
                        self.selectedOption = option
                    }
            }
        }.padding(.top,0)
    }
}
