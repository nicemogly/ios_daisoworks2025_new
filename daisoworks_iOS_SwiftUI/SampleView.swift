//
//  SampleView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/17/25.
//
import SwiftUI


struct SampleList1: Decodable {
    var sammgno: String
    var samcolym: String
    var clntpoolno: String
    var clntnmkor: String
    var samnm: String
}


struct SampleView: View {
    @Binding var presentSideMenu: Bool
    @State private var navigateTo: String?
    @State private var isPresentingScanner = false // QR스캐너 팝업 표시여부
    @State private var scannedCode: String?  = nil  // 스캔결과저장
    @State private var textFieldText88: String = "" //텍스트필드 값 저장
    @State private var scannedString1 : String = ""
    @State private var scnflag1 : Bool = false
    @State private var itemId1 : String? = ""
    @State var sampllist1 = [SampleList1]()
    @State private var resultText: String = "검색된 결과가 없습니다."
    @State var resultflag = false
    @State private var isLoading = false
    
    var body: some View {
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
                VStack(alignment: .leading){
                    ForEach(sampllist1, id: \.sammgno) { item1 in
                        Text("샘플명:\(item1.samnm)")
                        Text("업체명:\(item1.clntnmkor)(\(item1.clntpoolno))")
                        Text("등록월:\(item1.samcolym)")
                    }
                }.padding(5)
                .frame(maxWidth: .infinity)
                .overlay(
                    resultflag ?
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.2) : nil
                        
                )
                   
                        
            }
            Spacer()
            Spacer()
        }
        .sheet(isPresented: $scnflag1){
           // QRCodeScannerView(scannedCode: $scannedCode , isPresentingScanner: $isPresentingScanner)
            ScannerView1(scannedString1: $scannedString1 , scnflag1: $scnflag1 , itemId1: $itemId1)
        }
       
        .onChange(of: itemId1) { newValue in
            if let value = newValue {
                textFieldText88 = value
                Task {
                    await loadData1()
                }
            }
        }
        .padding()
        .onDisappear() {
            presentSideMenu = false
        }
        .navigationTitle("샘플이미지 등록")
    }
    
    func loadData1() async {
      

        guard let url1 = URL(string: "http://59.10.47.222:3000/sampleload1?samcode=\(itemId1!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            
            return
        }
        

        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
                
                decoder1.dateDecodingStrategy = .iso8601
                //SampleList1
                if let decodedResponse1 = try? decoder1.decode([SampleList1].self, from: data1){
                    DispatchQueue.main.async {
                      
                        self.sampllist1 = decodedResponse1
                       // print("건수\(self.sampllist1.count)")
                        
                        if(self.sampllist1.count == 0 ){
                            resultflag = false
                            resultText = "검색된 샘플정보가 없습니다."
                        }else{
              
                            resultflag = true
                        
                        }
                    }
                 
                    return
                
                }
            }
        }.resume()
    }
    
    
    func startLoading() {
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
                isLoading = false
                resultflag = true
        }
    }
    
}
