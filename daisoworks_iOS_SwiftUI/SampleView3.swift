//
//  SampleView3.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/17/25.
//
import SwiftUI
 
 
 
struct SampleList5: Decodable {
    var sammgno: String          //샘플관리번호
    var samnme: String?          //샘플명
    var clntpoolno: String?      //업체풀번호
    var clntnme: String?         //업체명
    var neganatinm: String?      //원산지
    var weit: String?            //무게
    var pozast: String?          //포장
    var cor: String?             //색상
    var zae: String?             //재질
    var gyu: String?             //규격
    var hmpdeptnme: String?      //영업부서
    var hsdeptnme: String?       //출하부서
    var suggbn: String?          //제안구분
    var shownme: String?         //전시회명
    var origmgno: String?        //구매샘플번호
    var congdschr: String?       //다이소MD
    var adpgbn: String?          //상담결과
    var gdsno: String?           //품번
    
}
 
 
struct SampleView3: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var presentSideMenu: Bool
    @State private var navigateTo: String?
    @State private var isPresentingScanner = false // QR스캐너 팝업 표시여부
    @State private var scannedCode: String?  = nil  // 스캔결과저장
    @State private var textFieldText88: String = "" //텍스트필드 값 저장
    @State private var scannedString1 : String = ""
    @State private var scnflag1 : Bool = false
    @State private var itemId1 : String? = ""
    @State var samplelist5 = [SampleList5]()
    @State private var resultText: String = "검색된 결과가 없습니다."
    @State var resultflag = false
    @State private var isLoading = false
    @State private var imageURL: String? = nil
    @State private var isUploading = false
    @State private var isUploading1 = false
    @State private var selectedImage: UIImage? = nil
    @State private var showPicker: Bool = false
    @State private var uploadflag: Bool = false
    @State private var showAlert4: Bool = false
    @State private var showAlertDel: Bool = false
    @State private var registStr = ""
    @State private var isPickerEnabled: Bool = true
    
    
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    TextField("샘플 QR코드 스캔하여 주세요", text: $textFieldText88)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.headline)
                    
                    Button(action: {
                        scnflag1.toggle()
                    }) {
                        Image(systemName: "barcode.viewfinder" )
                            .resizable()
                            .frame(width:40 , height:40 , alignment: .center)
                            .padding(.leading, 10)
                    }
                    Spacer()
                }
                
                
                
                if (resultflag == false) {
                    VStack(alignment: .center){
                        Image(systemName: "questionmark.text.page.fill")
                            .frame(width:100 , height:100)
                            .font(.system(size:80))
                            .foregroundStyle(.green)
                        Text("\(resultText)")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.headline)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                    }.padding(.top, 20)
                    
                }else{
                    
                    ScrollView{
                    
                            VStack(alignment: .leading){
                                ForEach(samplelist5, id: \.sammgno) { item5 in
                                    Text("샘플관리번호: NA\(item5.sammgno ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("샘플명: \(item5.samnme ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("업체풀번호: \(item5.clntpoolno ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("업체명: \(item5.clntnme ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("원산지: \(item5.neganatinm ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("무게: \(item5.weit ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("포장: \(item5.pozast ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("색상: \(item5.cor ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("재질: \(item5.zae ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("규격: \(item5.gyu ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("영업부서: \(item5.hmpdeptnme ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("출하부서: \(item5.hsdeptnme ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("제안구분: \(item5.suggbn ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("전시회명: \(item5.shownme ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("구매샘플번호: \(item5.origmgno ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    Text("다이소MD: \(item5.congdschr ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                    if(item5.adpgbn=="0"){
                                        Text("상담결과: 미채택")
                                            .font(.system(size:16))
                                        Divider()
                                    } else  if(item5.adpgbn=="1"){
                                        Text("상담결과: 채택")
                                            .font(.system(size:16))
                                        Divider()
                                    } else  if(item5.adpgbn=="8"){
                                        Text("상담결과: 보완")
                                            .font(.system(size:16))
                                        Divider()
                                    }else{
                                        Text("상담결과: -")
                                            .font(.system(size:16))
                                        Divider()
                                    }
                                    Text("품번: \(item5.gdsno ?? "-")")
                                        .font(.system(size:16))
                                    Divider()
                                   
                                }
                            }.padding()
                            .frame(maxWidth: .infinity , alignment: .leading)
                                .overlay(
                                    resultflag ?
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 0.2) : nil
                                )
                    }
                    .background(Color.cyan.opacity(0.1))
                    
            }
                Spacer()
            }
            .sheet(isPresented: $scnflag1){
                ScannerView4(scannedString1: $scannedString1 , scnflag1: $scnflag1 , itemId1: $itemId1)
        }
    }
        
        .onChange(of: itemId1) { newValue in
            if let value = newValue {
                textFieldText88 = value
       
                loadData1()
               
                //isLoading = false
            }
        }
       
        .padding()
        .onDisappear() {
            presentSideMenu = false
        }
        .navigationTitle("샘플정보 조회")
    }
   
   
    
    func loadData1()  {
        //itemId1 = "20250314178"
        let itemIdOri: String? = String(itemId1!.dropFirst(2))
 
        guard let url1 = URL(string: "http://59.10.47.222:3000/samplesch?samcode=\(itemIdOri!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
  
        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
       
                decoder1.dateDecodingStrategy = .iso8601
                //SampleList2
                if let decodedResponse1 = try? decoder1.decode([SampleList5].self, from: data1){
                    DispatchQueue.main.async {
                       //print("subload:\(url1)")
                       // print("itemID1:\(itemId1)")
                       // self.sampllist1.removeAll()
                        self.samplelist5 = decodedResponse1
                      //  print("건수11\(self.samplelist5.count)")
                       
                        if(self.samplelist5.count == 0 ){
                            resultflag = false
                            resultText = "검색된 샘플정보가 없습니다."
                            showAlertDel = true
                            //isUploading = false
                            isUploading1 = false
                        }else{
                            self.samplelist5.forEach {
                                if($0.sammgno==" "){
                                    showAlertDel = true
                                    isUploading1 = false
                                }else{
                                    startLoading()
 
                                    showAlertDel = false
                                   // isUploading = false
                                }
                            }
                            resultflag = true
                        
                        }
                        
                       
                    }
                 
                    return
                
                }
            }
        }.resume()
    }
 
    
  
    
   
    
    
    func startLoading() {
        //isUploading
        isUploading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            isUploading = false
            resultflag = true
            isUploading1 = true
          
        }
    }
    
   
    
}
