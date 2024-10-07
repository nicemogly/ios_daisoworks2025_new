//
//  first.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//
import SwiftUI
import Foundation
import Charts


let londonWeatherData = [ WeatherData(year: 2024, month: 1, day: 1, temperature: 19.0),
                          WeatherData(year: 2024, month: 2, day: 1, temperature: 17.0),
                          WeatherData(year: 2024, month: 3, day: 1, temperature: 17.0),
                          WeatherData(year: 2024, month: 4, day: 1, temperature: 13.0),
                          WeatherData(year: 2024, month: 5, day: 1, temperature: 8.0),
                          WeatherData(year: 2024, month: 6, day: 1, temperature: 8.0),
                          WeatherData(year: 2024, month: 7, day: 1, temperature: 5.0),
                          WeatherData(year: 2024, month: 8, day: 1, temperature: 8.0),
                          WeatherData(year: 2024, month: 9, day: 1, temperature: 9.0),
                          WeatherData(year: 2024, month: 10, day: 1, temperature: 11.0),
                          WeatherData(year: 2024, month: 11, day: 1, temperature: 15.0),
                          WeatherData(year: 2024, month: 12, day: 1, temperature: 18.0)
]

let chartData = [  (city: "London", data: londonWeatherData)]





struct WeatherData: Identifiable {
    let id = UUID()
    let date: Date
    let temperature: Double

    init(year: Int, month: Int, day: Int, temperature: Double) {
        self.date = Calendar.current.date(from: .init(year: year, month: month, day: day)) ?? Date()
        self.temperature = temperature
    }
}

struct HerpNotice: Identifiable {
    let id = UUID()
    let herp_title: String
    let herp_date: String
    let herp_conts: String
    
}


struct HerpSuju: Identifiable {
    let id = UUID()
    let herp_com: String
    let herp_sujunum: String
    let herp_itemno: String
    let herp_itemnm: String
    let herp_sujudate: String
    let herp_per: String
    
}




struct first: View {
    
    @State var isNExpanded: Bool = false
    
    
    
 // @State var herpnotice = [HerpNotice]()
  
    @State var herpnotice: [HerpNotice] = [
            HerpNotice(herp_title:"해외영업부 6월 전시회 일정" , herp_date:"2024-10-18" , herp_conts:"내용1"),
            HerpNotice(herp_title:"종합미출하 일정" , herp_date:"2024-10-18" , herp_conts:"내용2"),
            HerpNotice(herp_title:"아성다이소 상품스터디 일정" , herp_date:"2024-10-18" , herp_conts:"내용3")
    ]

    @State var herpsuju: [HerpSuju] = [
        HerpSuju(herp_com:"아성다이소" , herp_sujunum:"NC2406069230" , herp_itemno:"1058794" , herp_itemnm:"실리콘 스푼(약 15.5cm)" , herp_sujudate:"2024-06-27" , herp_per:"200pcs"),
        HerpSuju(herp_com:"DIASO INDUSTRIES CO.,LTD" , herp_sujunum:"NC2406069231" , herp_itemno:"1058794" , herp_itemnm:"실리콘 스푼(약 15.5cm)" , herp_sujudate:"2024-06-27" , herp_per:"200pcs"),
        HerpSuju(herp_com:"아성다이소" , herp_sujunum:"NC2406069232" , herp_itemno:"1058795" , herp_itemnm:"실리콘 스푼(약 15.5cm)" , herp_sujudate:"2024-06-27" , herp_per:"200pcs"),
        HerpSuju(herp_com:"아성다이소" , herp_sujunum:"NC2406069233" , herp_itemno:"1058796" , herp_itemnm:"실리콘 스푼(약 15.5cm)" , herp_sujudate:"2024-06-27" , herp_per:"200pcs"),
        HerpSuju(herp_com:"아성다이소" , herp_sujunum:"NC2406069234" , herp_itemno:"1000382" , herp_itemnm:"실리콘 스푼(약 15.5cm)" , herp_sujudate:"2024-06-27" , herp_per:"200pcs")
    ]
    var body: some View {
        
      
        ScrollView {
            
      
        VStack {
            
  
               HStack {
                    Text("전사 월별 매출")
                       .font(.system(size:18 , weight: .bold))
                   
                   Spacer()
                    Text("(단위: 억 원)")
                       .font(.system(size:18 , weight: .bold))
               }.padding(5)
          
            
                   Chart {
                      
                       ForEach(londonWeatherData) { item in
                           
                           let strval1 = String(format: "%.0f", item.temperature)
                           LineMark(
                               x: .value("Month", item.date),
                               y: .value("Temp", item.temperature)
                             
                               )
                         
                           .symbol(){
                               Circle()
                                   .fill(Color.blue)
                                   .frame(width:10)
                           }
                           PointMark(
                               x: .value("Month", item.date),
                               y: .value("Temp", item.temperature)
                               
                               )
                           .foregroundStyle(.green)
                           
                           .annotation(position:.top , alignment: .center) { Text("\(strval1)") }
                       }
                       
                   }
                   .chartXAxis {
                       AxisMarks(values: .stride(by: .month, count:1)) { _ in
                           AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                           
                       }
                   }
                   .chartYScale(domain: 0...23)
            //.chartYScale(domain: [minStockPrice ?? 0- , maxStockPrice ?? 0])
                   .frame(height: 300 , alignment: .topLeading)
                   .padding(.bottom , 30)
        
            HStack {
                 Text("전사 월별 납기율")
                    .font(.system(size:18 , weight: .bold))
                
                Spacer()
                 Text("(단위: %)")
                    .font(.system(size:18 , weight: .bold))
            }.padding(5)
       
         
                Chart {
                   
                    ForEach(londonWeatherData) { item in
                        
                        let strval1 = String(format: "%.0f", item.temperature)
                        BarMark(
                            x: .value("Month", item.date),
                            y: .value("Temp", item.temperature),
                            width: 20
                            )
                        
                       
                        PointMark(
                            x: .value("Month", item.date),
                            y: .value("Temp", item.temperature)
                            
                            )
                        .foregroundStyle(.green)
                        .annotation(position:.top , alignment: .center) { Text("\(strval1)") }
                    }
                    
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .month, count:1)) { _ in
                        AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                        
                    }
                }
                .chartYScale(domain: 0...23)
         //.chartYScale(domain: [minStockPrice ?? 0- , maxStockPrice ?? 0])
                .frame(height: 300 , alignment: .topLeading)
                .padding(.bottom , 30)
            
            
            HStack {
                Text("공지사항")
                    .font(.system(size:18 , weight: .bold))
                Spacer()
                Spacer()
               
            }.padding(5)
          
             VStack{
                 
                 ForEach(herpnotice) { nt1 in
                    
//                     HStack{
//                         Text("[\(nt1.herp_date)] \(nt1.herp_title)")
//                             .font(.system(size:16 , weight: .bold))
//                             .frame(maxWidth: .infinity , alignment: .leading)
//                     }
//                    
//                     .onTapGesture {
//                         withAnimation{
//                             isNExpanded.toggle()
//                         }
//                     }
//                     
//                     if isNExpanded {
//                         Text("\(nt1.herp_conts)")
//                             .font(.system(size:16 , weight: .bold))
//                             .frame(maxWidth: .infinity , alignment: .leading)
//                     }
                     
                     
                     DisclosureGroup{
                         HStack {
                             VStack(alignment: .leading){
                               //  Text("[\(nt1.herp_date)] \(nt1.herp_title)")
                                 Divider()
                                 Text("\(nt1.herp_conts)")
                                     .font(.system(size:16 , weight: .bold))
                                     .foregroundStyle(.gray)
                                     .frame(maxWidth: .infinity , alignment: .leading)
                                 Spacer()
                             }
                             .frame(maxWidth: .infinity , alignment: .leading)
                         }
                         
                     } label: {
                         HStack{
                            
                             Text("[\(nt1.herp_date)] \(nt1.herp_title)")
                                 .font(.system(size:16 , weight: .bold))
                                 .foregroundStyle(.black)
                             Spacer()
                             
                         }
                     }
                     Spacer()
                     Spacer()
                 }
                   
              }
             .frame(maxWidth: .infinity , alignment: .leading)
            
             .padding(.bottom , 30)
         
         
         HStack {
             Text("최근수주")
                 .font(.system(size:18 , weight: .bold))
                 
             Spacer()
            
         }.padding(.bottom ,40)
            
            ForEach(herpsuju) { item3 in
                
                
                VStack{
                    
                    VStack{
                        Text("\(item3.herp_com)")
                            .padding(10)
                    }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
                        .background(item3.herp_com == "아성다이소" ? Color.blue : Color.green)
                        .padding(10)
                        .cornerRadius(30)
                        .foregroundColor(.white)
                    
                    VStack {
                        HStack{
                            Text("\(item3.herp_sujunum)")
                            Spacer()
                            Text("\(item3.herp_itemno)")
                        }
                        .padding(.bottom , 15)
                        HStack{
                            Text("\(item3.herp_itemnm)")
                            Spacer()
                        }
                        .padding(.bottom , 15)
                        HStack{
                            Text("\(item3.herp_sujudate)")
                            Spacer()
                            Text("\(item3.herp_per)")
                        }
                        
                        ZStack{
                            Image(systemName: "magnifyingglass.circle.fill" )
                                .resizable()
                                .frame(width:50 , height:50  , alignment: .bottomTrailing)
                            
                        }.frame(maxWidth:.infinity , alignment: .bottomTrailing)
                    }.padding(.leading , 10  )
                        .padding(.trailing , 10)
                    
                    
                    Spacer()
                    
                }
                .modifier(CardModifier())
                .frame(height:160)
                .padding(.bottom , 100)
                
            }//end foreach
    
           
            
           
            
            Spacer()
            
            
            
        }.padding(15)
                
    }
        VStack{
            Spacer()
            Spacer()
            Spacer()
        }.frame(minHeight: 100)
}
}

