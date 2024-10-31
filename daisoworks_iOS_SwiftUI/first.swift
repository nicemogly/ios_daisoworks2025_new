//
//  first.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//
import SwiftUI
import Foundation
import Charts




struct chartA: Decodable{
   
    let mmonth: String
    let buyer: String?
    var amt: Double?
}

struct chartA1: Decodable{
   
    let mmonth: String
    var amt: Double?
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
    
    @Binding var selectedSideMenuTab: Int
    @Binding var comCode1: String
    @Binding var itemNo: String
    
    @Binding var sujubCode: String
    @Binding var sujuMgno: String

    
    
    @Binding var passKey: String
    @State var isNExpanded: Bool = false
    @State var charta = [chartA]()
    @State var charta1 = [chartA1]()
    
    @State var Syear: String = ""
    
    
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
        
        let UserDept  = UserDefaults.standard.string(forKey: "memdeptgbn") //부서구분
        /*
         chart Display Rule
         1.로그인 유저가 임원일 경우 00
         2.로그인 유저가 부서구분코드가 11, 13 일 경우
         3.로그인 유저가 부서구분코드가 위 3가지기 다 아닐경우 안 보여줌.
         4.로구인 유저가 부서구분코드가 12인경우 안보여줌.
        */
      
        ScrollView {
            
      
        VStack {

            if(UserDept == "00" || UserDept == "11" || UserDept == "13") {
                
                HStack {
                    Text("전사 월별 매출")
                        .font(.system(size:18 , weight: .bold))
                    
                    Spacer()
                    Text("(단위: 억 원)")
                        .font(.system(size:18 , weight: .bold))
                }.padding(5)
                
                
                Chart {
                    
                    ForEach(charta, id: \.mmonth) { item in
                        
                        
                      //  let strval1 = String(format: "%.0f", item.amt ?? 0)
                        BarMark(
                            x: .value("Month", item.mmonth),
                            y: .value("Temp", (item.amt == nil ? 0 : item.amt)! )
                            
                        )
                        .foregroundStyle(by: .value("Buyer1", item.buyer ?? " "))
                        
                        
                    }
                    
                    
                    ForEach(charta1, id: \.mmonth) { item1 in
                        
                       
                        let strval1 = String(format: "%.0f", item1.amt ?? 0)
                        PointMark(
                            x: .value("Month", item1.mmonth),
                            y: .value("Temp", (item1.amt == nil ? 0 : item1.amt)! )
                            
                        )
                        .foregroundStyle(.red)
                        
                        .annotation(position:.top , alignment: .center) { Text("\(strval1)").font(.system(size: 10)) }
                        
                        
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
                
       
       
         
            }
                  
            
            HStack {
                Text("공지사항")
                    .font(.system(size:18 , weight: .bold))
                Spacer()
                Spacer()
               
            }.padding(5)
          
             VStack{
                 
                 ForEach(herpnotice) { nt1 in
                    
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
                                .onTapGesture {
                                    selectedSideMenuTab = 3
                                    comCode1 = "10005"
                                    itemNo = "1000382"
                                    sujubCode = "8819910003825"
                                    sujuMgno = "2018030681"
                                    
                                    
                                    passKey = "OK"
                                }
                            
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
            
            
            
        }.onAppear{
           
           // let UserDept  = UserDefaults.standard.string(forKey: "memdeptgbn") //부서구분
           // let UserName = UserDefaults.standard.string(forKey: "memdeptnme") // 부서명
            
            //임원일경우
            if(UserDept == "00") {
                    
                ChartLoad1()
                ChartLoad2()
          
            //부서코드가 11 , 13일경우
            }else if(UserDept == "11" || UserDept == "13") {
                
                ChartLoad3()
                ChartLoad4()
            }
           
        }
        .padding(15)
            VStack{
                Spacer()
                Spacer()
                Spacer()
            }.frame(minHeight: 40)
             
    }

        
      
}
    
    
    func ChartLoad1(){
        
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        
        guard let url1 = URL(string: "http://59.10.47.222:3000/chartsamt?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(String(describing: attrComcode))&yymm=\(attrYear)") else {
            print("Invalid URL")
            return
        }
        
      

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                print("ChartLoad1 3")
                if let decodedResponse1 = try? decoder1.decode([chartA].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.charta = decodedResponse1
                        
                        print("value:\(self.charta)")
                        print("chart건수\(self.charta.count)")
                        print("ChartLoad1 4")
                        
                        if(self.charta.count == 0 ){
                           
                        }else{
                            print("ChartLoad1 5")
                            self.charta.forEach {

                                print("해당년월:\($0.mmonth)")
                                print("매출액:\($0.amt ?? 0)")
                                //v_attr4 = $0.reqId
                                
                                
                                
                            }
                            
                            print("ok")
               
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    
    func ChartLoad2(){
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
      
        guard let url1 = URL(string: "http://59.10.47.222:3000/chartsamt1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(String(describing: attrComcode))&yymm=\(attrYear)") else {
            print("Invalid URL")
            return
        }

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
      
                if let decodedResponse1 = try? decoder1.decode([chartA1].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.charta1 = decodedResponse1

                        if(self.charta1.count == 0 ){
                           
                        }else{
//                            self.charta1.forEach {
//
//                                
//                            }
               
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
    
    func ChartLoad3(){
        
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        let attrDeptcode = UserDefaults.standard.string(forKey: "memdeptcde") // 로그인부서코드
        
     
        
        guard let url1 = URL(string: "http://59.10.47.222:3000/chartsamt_1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(attrComcode!)&yymm=\(attrYear)&corpCd1=\(attrComcode!)&saleCd=\(attrDeptcode!)") else {
            print("Invalid URL")
            return
        }

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                print("ChartLoad1 3")
                if let decodedResponse1 = try? decoder1.decode([chartA].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.charta = decodedResponse1
                        
                        if(self.charta.count == 0 ){
                           
                        }else{

                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
  
    func ChartLoad4(){
        
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        let attrDeptcode = UserDefaults.standard.string(forKey: "memdeptcde") // 로그인부서코드
        
        guard let url1 = URL(string: "http://59.10.47.222:3000/chartsamt1_1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(attrComcode!)&yymm=\(attrYear)&corpCd1=\(attrComcode!)&saleCd=\(attrDeptcode!)") else {
            print("Invalid URL")
            return
        }
        
        print("ChartLoad1 4")

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                if let decodedResponse1 = try? decoder1.decode([chartA1].self, from: data1){
                    DispatchQueue.main.async {
                       // self.users = decodedResponse
                        self.charta1 = decodedResponse1
                         
                        if(self.charta1.count == 0 ){
                           
                        }else{
               
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

