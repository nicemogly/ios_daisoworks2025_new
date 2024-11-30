//
//  DatePickerView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/14/25.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var showDatePicker: Bool
    @Binding var selectDate: Date
    @Binding var dDate: String
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectDate,displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            
            
            Button(action: {
                self.dDate = formattedDate(self.selectDate)
                self.showDatePicker = false
            }){
                Text("Done")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationBarTitle("DatePicker", displayMode: .inline)
    }
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
    
}
