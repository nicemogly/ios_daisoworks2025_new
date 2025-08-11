//
//  second.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/17/24.
//

import SwiftUI
import WebKit
import Charts
 

struct chartDmsA: Decodable{
   
    var avgLt01: Float
    var avgLt02: Float
    var avgLt03: Float
    var avgLt04: Float
    var avgLt05: Float
    var avgLt06: Float
    var avgLt07: Float
    var avgLt08: Float
    var avgLt09: Float
    var avgLt10: Float
    var avgLt11: Float
    var avgLt12: Float
}


struct chartDmsA1: Decodable{
   
    let mmonth: String
    var amt: Float?
}

struct HTMLText: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        DispatchQueue.main.async {
            let data = Data(self.html.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html , .characterEncoding: String.Encoding.utf8.rawValue  ],  documentAttributes: nil) {
                label.attributedText = attributedString
                label.font = .systemFont(ofSize: 16)
            }
            
        }
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<Self>) {}
}

struct DmsNotice: Decodable, Identifiable{
    let id = UUID()
    let boardTitle: String
    let boardContents: String
}



struct second: View {
    @State  var dmsnotice = [DmsNotice]()
    @State var dmsdsnpreview = [DmsDsnPreview]()
    
    @State private var resultText: String = ""
    @State var resultflag = false
    @State private var isLoading = false
    
    @State var chartdmsa = [chartDmsA]()
    @State var chartdmsA1 = [chartDmsA1]()
    


    var body: some View {
   
        ScrollView {
            
            VStack {
                
                
                HStack {
                    Text("디자인 리드타임 현황")
                        .font(.system(size:18 , weight: .bold))
                    
                    Spacer()
                    
                }.padding(5)
                
                
                Chart {
                  
                    ForEach(chartdmsA1, id: \.mmonth) { item in
                      
                        
                      //  let strval1 = String(format: "%.0f", item.amt ?? 0)
                        BarMark(
                            x: .value("Month", item.mmonth),
                            y: .value("Temp", (item.amt == nil ? 0 : item.amt)! )
                            
                        )
                       // .foregroundStyle(by: .value("Buyer1", item.buyer ?? " "))
                        
                        
                    }
                    
                }
                //                   .chartXAxis {
                //                       AxisMarks(values: .stride(by: .month, count:1)) { _ in
                //                           AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                //
                //                       }
                //                   }
                //   .chartYScale(domain: 0...2000)
                //   .chartYScale(domain: [minStockPrice ?? 0- , maxStockPrice ?? 0])
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 300 , alignment: .topLeading)
                .padding(.bottom , 30)
        

                
                
                
                HStack {
                    Text("공지사항")
                        .font(.system(size:18 , weight: .bold))
                    Spacer()
                    Spacer()
                   
                }.padding(5)
                Divider()
                 VStack{
                     
                     ForEach(dmsnotice, id: \.id) { nt1 in
                         DisclosureGroup{
                             HStack {
                                 VStack(alignment: .leading){
                                     Divider()
                                   //  Text(HtmlRenderedString(fromStrimg:"\(nt1.boardContents)")
                                   //  HTMLStringView(htmlContent: "\(nt1.boardContents)")
//                                     HTMLText(html: "\(nt1.boardContents)")
//                                         .font(.system(size:16 , weight: .bold))
//                                         .foregroundStyle(.gray)
//                                         .frame(maxWidth: .infinity , alignment: .leading)
                                     
                                     Text("\(nt1.boardContents.removeHTMLTag().replacingOccurrences(of: "&nbsp;", with: ""))").padding(.bottom , 10)
                                         .font(.system(size:14))
                                         .frame(maxWidth: .infinity , alignment: .leading)
                                         .foregroundStyle(.gray)
                                         .lineSpacing(10)
                                     Spacer()
                                 }
                                 .frame(maxWidth: .infinity , alignment: .leading)
                             }
                             
                         } label: {
                             HStack{
                                
                                   Text("\(nt1.boardTitle)")
                                 .font(.system(size:16 , weight: .bold))
                                     .foregroundStyle(.black)
                                     .frame(maxWidth: .infinity , alignment: .leading)
                                     .multilineTextAlignment(.leading)
                                     .lineSpacing(5)
                                     .lineLimit(1)
                                     .truncationMode(.tail)
                                 Spacer()
                                 
                             }.frame(maxWidth: .infinity , alignment: .leading)
                         }
                         Spacer()
                         Spacer()
                     }
                       
                  }
                 .frame(maxWidth: .infinity , alignment: .leading)
                
                 .padding(.bottom , 20)
                 .padding(.leading , 10)
                
                
                Spacer()
            }
        }.padding(10)
            .scrollIndicators(.hidden)
            .onAppear(perform: INIT_1)
       
    }
    

    
    func startLoading() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
                isLoading = false
                resultflag = true
        }
    }
    func didDismiss() {
            }
    
    func INIT_1(){
        
        ChartLoad1()
        
        
        //메인에서 넘어왔다면
//        if passKey == "OK" {
//            selection = comCode1
//            itemId = itemNo
//            sujubcode = sujubCode
//            sujumgno = sujuMgno
//            resultflag = false
//            loadData2()
//            print("Loading:firstView-IN")
//        }
        loadData1()
      
        print("Loading:secondView")
    }
    
    func loadData1(){
       
       // let str1: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        let Userid = UserDefaults.standard.string(forKey: "Userid")
        
       // print("testest\(selection2)")
        guard let url2 = URL(string: "http://112.175.40.40:3000/dmsnotice?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&mUserId=\(Userid!)") else {
            print("Invalid URL")
            
            return
        }
        

        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data2, response, error in
            if let data2 = data2 {
                let decoder2 = JSONDecoder()
                
                decoder2.dateDecodingStrategy = .iso8601
                
                if let decodedResponse2 = try? decoder2.decode([DmsNotice].self, from: data2){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        dmsnotice.removeAll()
                        self.dmsnotice = decodedResponse2
                        
                        print("value:\(self.dmsnotice)")
                        print("건수\(self.dmsnotice.count)")
                        
                    
                        if(self.dmsnotice.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                        
                            resultText = ""
                            loadData2()
                           // startLoading()
                            
                       
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func loadData2(){
       
        let Userid = UserDefaults.standard.string(forKey: "Userid")
        
        print("loadData2")
        guard let url3 = URL(string: "http://112.175.40.40:3000/dmsview1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&mUserId=\(Userid!)") else {
            print("Invalid URL")
            
            return
        }
 

        let request3 = URLRequest(url: url3)
        URLSession.shared.dataTask(with: request3) { data3, response, error in
            if let data3 = data3 {
                let decoder3 = JSONDecoder()
                
                decoder3.dateDecodingStrategy = .iso8601
                
                if let decodedResponse3 = try? decoder3.decode([DmsDsnPreview].self, from: data3){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        dmsdsnpreview.removeAll()
                        self.dmsdsnpreview = decodedResponse3
                        
                        print("value:\(self.dmsdsnpreview)")
                        print("건수\(self.dmsdsnpreview.count)")
                        
                    
                        if(self.dmsdsnpreview.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없습니다."
                        }else{
                        
                            print("OKAY")
                            resultText = ""
                          
                            startLoading()
                            
                       
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func ChartLoad1(){
        
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let  ss2 = UserDefaults.standard.string(forKey: "Userid")
        
        
       // print("comcode: \(attrComcode)")
        guard let url1 = URL(string: "http://112.175.40.40:3000/chartdmsc?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&mUserId=\(ss2!)&stdYear=\(attrYear)") else {
            print("Invalid URL")
            return
        }
    
      

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                print("ChartLoad1 3")
                print("\(data1)")
                if let decodedResponse1 = try? decoder1.decode([chartDmsA].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        chartdmsa.removeAll()
                        print("333333")
                        self.chartdmsa = decodedResponse1
                        print("2222222222222222")
                        print("value:\(self.chartdmsa)")
                        print("chart건수\(self.chartdmsa.count)")
                        print("ChartLoad1 4")
                        
                        if(self.chartdmsa.count == 0 ){
                           
                        }else{
                            print("ChartLoad1 5")
                            chartdmsA1.removeAll()
                        self.chartdmsa.forEach {

                                  print("해당년월")
                               // print("매출액:\($0.amt ?? 0)")
                               // var v_attr4 = $0.avgLt01
                            chartdmsA1.append(chartDmsA1(mmonth: "1", amt: Float($0.avgLt01)))
                            chartdmsA1.append(chartDmsA1(mmonth: "2", amt: Float($0.avgLt02)))
                            chartdmsA1.append(chartDmsA1(mmonth: "3", amt: Float($0.avgLt03)))
                            chartdmsA1.append(chartDmsA1(mmonth: "4", amt: Float($0.avgLt04)))
                            chartdmsA1.append(chartDmsA1(mmonth: "5", amt: Float($0.avgLt05)))
                            chartdmsA1.append(chartDmsA1(mmonth: "6", amt: Float($0.avgLt06)))
                            chartdmsA1.append(chartDmsA1(mmonth: "7", amt: Float($0.avgLt07)))
                            chartdmsA1.append(chartDmsA1(mmonth: "8", amt: Float($0.avgLt08)))
                            chartdmsA1.append(chartDmsA1(mmonth: "9", amt: Float($0.avgLt09)))
                            chartdmsA1.append(chartDmsA1(mmonth: "10", amt: Float($0.avgLt10)))
                            chartdmsA1.append(chartDmsA1(mmonth: "11", amt: Float($0.avgLt11)))
                            chartdmsA1.append(chartDmsA1(mmonth: "12", amt: Float($0.avgLt12)))
                            
                               
                                
                            }
                            
                            print("ok")
               
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    func getCurrentDateYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date())
    }
    
}
