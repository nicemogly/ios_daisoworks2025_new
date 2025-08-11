//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.03
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    First Tab(HERP)
//  Program Name       :    first.swift
//  Description        :    1.TabBar 구성
//                          2.관계사별 접근권한
//                          3.TabBar별 View화면 Define  20250317New
//========================================================================================================================================================

import SwiftUI
import Foundation
import Charts
 
// =======================Result Data Group Start=====================
// 바이어별 년도별 챠트 Data Layout
struct chartA: Decodable{
    let mmonth: String
    let buyer: String?
    var amt: Double?
}

// 전체 년도별 챠트 Data Layout
struct chartA1: Decodable{
    let mmonth: String
    var amt: Double?
}

// 최근 수주 Data Layout
struct DataSujuDetail0: Decodable, Identifiable{
    let id = UUID()
    var sujumginitno : String
    var sujudate : String
    var korstrnm : String
    var korendnm : String
    var cdenme : String
    var sujuindiqty : String
    var gdsno: String
    var gdsnmekor: String
    var buycorpcd: String
    var buygdsbcd: String
    var sujuno: String
    var rn: String
}

// HERP 공지사항(지금사용안함)
struct HerpNotice: Identifiable {
    let id = UUID()
    let herp_title: String
    let herp_date: String
    let herp_conts: String
}

// =======================Result Data Group End=====================

// first View Start
struct first: View {
    
    //================= View : @Binding Group Define Start===============================
    @Binding var selectedSideMenuTab: Int
    @Binding var comCode1: String
    @Binding var itemNo: String
    @Binding var sujubCode: String
    @Binding var sujuMgno: String
    @Binding var passKey: String
    //================= View : @Binding Group Define End=================================
    
    //================= View : @State Group Define Start===============================
    @State var isNExpanded: Bool = false
    @State var charta = [chartA]()
    @State var charta1 = [chartA1]()
    @State var datasujudetail0 = [DataSujuDetail0]()
    @State var Syear: String = ""
    @State private var resultText: String = "검색된 결과가 없거나 수주등록 대상자가 아닙니다."
    @State var resultflag = false
    //================= View : @State Group Define End===============================
   
    //================= View : Body View Start==========================================
    var body: some View {
        ScrollView {
          VStack {
                HStack { //chart title & unit
                    Text("전사 월별 매출")
                        .font(.system(size:18 , weight: .bold))
                    Spacer()
                    Text("(단위: 억 원)")
                        .font(.system(size:18 , weight: .bold))
                }.padding(5)
                
                //==============================================================================================================
                //Chart Drawing Start
                //==============================================================================================================
                Chart {
                        //Bar Chart
                        ForEach(charta, id: \.mmonth) { item in
                        //  let strval1 = String(format: "%.0f", item.amt ?? 0)
                            BarMark(
                                x: .value("Month", item.mmonth ), //해당년도 월별
                                y: .value("SalesAmount", (item.amt == nil ? 0 : item.amt)! ), //매출액
                                width: 10 //bar width setting
                            )
                            .foregroundStyle(by: .value("Buyer1", item.buyer ?? " ") )
                        }
                  
                        //Point Chart
                        ForEach(charta1, id: \.mmonth) { item1 in
                            let strval1 = String(format: "%.0f", item1.amt ?? 0)
                            PointMark(
                                x: .value("Month", item1.mmonth ),//해당년도 월별
                                y: .value("SalesAmount", (item1.amt == nil ? 0 : item1.amt)! )//매출액
                            )
                            .foregroundStyle(.red)
                            .annotation(position:.top , alignment: .center) { Text("\(strval1)").font(.system(size: 10)) }
                        }
                    }
                    .chartYScale(domain: .automatic(includesZero: false))
                    .frame(height: 300 , alignment: .topLeading )
                    .padding(.bottom , 30)
                    .chartXAxis{
                        AxisMarks(){
                             AxisValueLabel().font(.system(size: 12))
                        }
                    }
              //==============================================================================================================
              //Chart Drawing End
              //==============================================================================================================
          
              //==============================================================================================================
              //최근 수주정보 가져오기
              //==============================================================================================================
              HStack {
                     Text("최근수주")
                         .font(.system(size:18 , weight: .bold))
                     Spacer()
                 }.padding(.bottom ,40)
                
              if (resultflag == true) {
                    ForEach(datasujudetail0, id: \.id) { item3 in
                        VStack{
                            VStack{
                                Text("\(comcodeCange(str1:item3.buycorpcd))")
                                    .padding(10)
                            }.frame(maxWidth: .infinity , minHeight:40  , alignment: .leading )
                                .background(item3.buycorpcd == "10005" ? Color.blue : Color.green)
                                .background(Color.blue )
                                .padding(10)
                                .cornerRadius(30)
                                .foregroundColor(.white)
                            
                            VStack {
                                HStack{
                                    Text("\(item3.sujumginitno)")
                                    Spacer()
                                    Text("\(item3.gdsno)")
                                }
                                .padding(.bottom , 15)
                                HStack{
                                    Text("\(item3.gdsnmekor)")
                                    Spacer()
                                }
                                .padding(.bottom , 15)
                                HStack{
                                    Text("\(item3.sujudate)")
                                    Spacer()
                                    Text("\(item3.sujuindiqty)")
                                }
                                
                                ZStack{
                                    Image(systemName: "magnifyingglass.circle.fill" )
                                        .resizable()
                                        .frame(width:50 , height:50  , alignment: .bottomTrailing)
                                        .onTapGesture {
                                            selectedSideMenuTab = 3
                                            comCode1 = item3.buycorpcd
                                            itemNo = item3.gdsno
                                            sujubCode = item3.buygdsbcd
                                            sujuMgno = item3.sujuno
                                            passKey = "first_suju"
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
                    
                }else {
                    
                    VStack(alignment: .center){
                        Image(systemName: "questionmark.text.page.fill")
                            .frame(width:100 , height:100)
                            .font(.system(size:40))
                            .foregroundStyle(.green)
                      
                        Text("\(resultText)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system( size:14))
                            .fontWeight(.bold)
                            
                }
                    
            }
              //==============================================================================================================
              //최근 수주정보 가져오기
              //==============================================================================================================
            
            Spacer()
        }.onAppear{
            let UserDept  = UserDefaults.standard.string(forKey: "memdeptgbn") //부서구분
            let excutive  = UserDefaults.standard.string(forKey: "excutive") //임원구분
             
            /*
             chart Display Rule
             1.로그인 유저가 임원일 경우 00
             2.로그인 유저가 부서구분코드가 11, 13 일 경우
             3.로그인 유저가 부서구분코드가 위 3가지기 다 아닐경우 안 보여줌.
             4.로구인 유저가 부서구분코드가 12인경우 안보여줌.
            */
            
            //부서코드가 11 , 13일경우
            if(excutive == "F" && (UserDept == "11" || UserDept == "13")) {
                    
                ChartLoad3()
                ChartLoad4()
          
            //임원 포함 나머지다 일경우
            }else {
                
                ChartLoad1()
                ChartLoad2()
            }
            
            loadData1()
           
        }
        .padding(5)
            VStack{
                Spacer()
                Spacer()
                Spacer()
            }.frame(minHeight: 40)
             
    }.scrollIndicators(.hidden)

        
      
}
    //================= View : Body View End==========================================
    
    func comcodeCange(str1: String) -> String {
          var vcomname = ""
                        switch str1 {
                        case "10000" as String :
                            vcomname = "아성HMP"
                        case "10005":
                            vcomname = "아성다이소"
                        case "30510":
                            vcomname = "아성솔루션"
                        case "10001":
                            vcomname = "DAISO INDUSTRIES CO., LTD."
                        case "12004":
                            vcomname = "(주)다이소출판)"
                        case "12002":
                            vcomname = "PLUS ONE CO., LTD"
                        case "12000":
                            vcomname = "JC SALES"
                        case "12003":
                            vcomname = "IAC Commerce Inc."
                        default:
                            vcomname = "NO"
                        }
        return vcomname
    }
    
    func ChartLoad1(){
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String  else {
            return
        }
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        guard let url1 = URL(string: "http://112.175.40.40:3000/chartsamt?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(attrComcode!)&yymm=\(attrYear)") else {
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
                        self.charta.removeAll()
                        self.charta = decodedResponse1
                       
                        if(self.charta.count == 0 ){
                           
                        }else{
                            print("ChartLoad1 5")
                            self.charta.forEach {

                                print("해당년월:\($0.mmonth)")
                                print("매출액:\($0.amt ?? 0)")
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
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String  else {
            return  // \(apiKey)
        }
      
        guard let url1 = URL(string: "http://112.175.40.40:3000/chartsamt1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(attrComcode!)&yymm=\(attrYear)") else {
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
                        self.charta1.removeAll()
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
    
    
    func ChartLoad3(){
        
        let attrYear = getCurrentDateYear() //현재날짜 구하기
        let attrComcode = UserDefaults.standard.string(forKey: "LoginCompanyCode") // 로그인회사코드
        let attrDeptcode = UserDefaults.standard.string(forKey: "memdeptcde") // 로그인부서코드
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String  else {
            return  // \(apiKey)
        }
        
        guard let url1 = URL(string: "http://112.175.40.40:3000/chartsamt_1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(attrComcode!)&yymm=\(attrYear)&corpCd1=\(attrComcode!)&saleCd=\(attrDeptcode!)") else {
            print("Invalid URL")
            return
        }

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                if let decodedResponse1 = try? decoder1.decode([chartA].self, from: data1){
                    DispatchQueue.main.async {
                        self.charta.removeAll()
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
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String  else {
            return  // \(apiKey)
        }
        guard let url1 = URL(string: "http://112.175.40.40:3000/chartsamt1_1?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&corpCd=\(attrComcode!)&yymm=\(attrYear)&corpCd1=\(attrComcode!)&saleCd=\(attrDeptcode!)") else {
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
                        self.charta1.removeAll()
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
    
    
    func loadData1(){
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String  else {
            return  // \(apiKey)
        }
        let comCode: String? = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        let Userid = UserDefaults.standard.string(forKey: "Userid")
        guard let url2 = URL(string: "http://112.175.40.40:3000/sujuview0?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&comCode=\(comCode!)&mUserId=\(Userid!)") else {
            print("Invalid URL")
            
            return
        }
    
        let request2 = URLRequest(url: url2)
        URLSession.shared.dataTask(with: request2) { data2, response, error in
            if let data2 = data2 {
                let decoder2 = JSONDecoder()
                
                decoder2.dateDecodingStrategy = .iso8601
                
                if let decodedResponse2 = try? decoder2.decode([DataSujuDetail0].self, from: data2){
                    DispatchQueue.main.async {
                        datasujudetail0 = decodedResponse2
                        
                        print("value:\(datasujudetail0)")
                        print("testest12312\(datasujudetail0.count)")
                        
                    
                        if(datasujudetail0.count == 0 ){
                            resultflag = false
                            resultText = "검색된 결과가 없거나 수주조회 대상자가 아닙니다."
                        }else{
                            resultflag = true
                        }
                    }
                    return
                
                }
            }
        }.resume()
    }
    
}

