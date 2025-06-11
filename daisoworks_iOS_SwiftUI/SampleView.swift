//
//  SampleView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/17/25.
//
import SwiftUI
import PhotosUI


struct SampleList1: Decodable {
    var sammgno: String
    var samcolym: String
    var clntpoolno: String
    var clntnmkor: String
    var samnm: String
    var vtlpath: String
    var filesec: String
    var sammgnof: String
}


struct SampleView: View {
    @Environment(\.presentationMode) var presentationMode
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
    @State private var imageURL: String? = nil
    @State private var isUploading = false
    @State private var isUploading1 = false
    @State private var selectedImage: UIImage? = nil
    @State private var showPicker: Bool = false
    @State private var uploadflag: Bool = false
    @State private var showAlert4: Bool = false
    @State private var showAlertDel: Bool = false
    @State private var registStr = ""
    
    
    
    
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
                    
                    if isUploading {
                        ProgressView("데이터 조회중...")
                            .padding()
                    } else if let imageURL1 = imageURL {
                        
                        VStack(alignment: .leading){
                                AsyncImage(url: URL(string: imageURL1)) { image in
                                    switch image {
                                    case .empty:
                                        if isUploading1 == false {
                                            imageView(itemId1: Binding(
                                                get: { itemId1 ?? ""},
                                                set: { newValue in itemId1 = newValue}
                                            ), onButtonPressed: subLoad)
                                        }
                                    case .success(let image):
                                         image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 300)
                                    case .failure:
                                        Text("이미지를 불러올 수 없습니다.")
                                    @unknown default:
                                        Text("알수 없는 오류 발생")
                                    }
                                }
                                
                        }.padding(.top , 30)
                        
                        if showAlertDel {
                            
                        }else{
                            HStack{
                                Button(action: {
                                    showAlert4 = true
                                }) {
                                    Text("삭제하기")
                                        .fontWeight(.bold)
                                        .frame(width:100 , height:50)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .buttonStyle(PlainButtonStyle())
                                        .padding()
                                }
                                .alert(isPresented: $showAlert4){
                                    Alert(
                                        title: Text("중요"),
                                        message: Text("정말로 삭제하시겠습니까?"),
                                        primaryButton: .destructive(Text("확인")){
                                            deleteImages()
                                            //self.presentationMode.wrappedValue.dismiss()
                                            imageURL = ""
                                            
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                        }
                        
                        
                       
                    }
                }
                Spacer()
                Spacer()
            }
            .sheet(isPresented: $scnflag1){
                ScannerView1(scannedString1: $scannedString1 , scnflag1: $scnflag1 , itemId1: $itemId1)
        }
    }
       
        .onChange(of: itemId1) { newValue in
            if let value = newValue {
                textFieldText88 = value
//        print("isUploading1 : \(isUploading1)")
//                print("imageURL: \(imageURL)")
                loadData1()
               
                //isLoading = false
            }
        }
        .padding()
        .onDisappear() {
            presentSideMenu = false
        }
        .navigationTitle("샘플이미지 등록")
    }
    
    func  deleteImages(){
        
        isUploading1 = false
        let itemIdOri: String? = String(itemId1!.dropFirst(2))
        guard let url = URL(string: "http://59.10.47.222:3000/sampleImgDel?sammgno=\(itemIdOri!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data , let responseStr =  String(data: data, encoding: .utf8){
            registStr = responseStr
                showAlertDel = true
               
                
            }
        }.resume()
    }
    
    func subLoad(){
        resultflag = true
        isUploading = false
        showAlertDel = false
       // imageURL = "http://59.10.47.222:3000/static/NA\(itemId1!).JPG"
        imageURL = "http://59.10.47.222:3000/static/\(itemId1!).JPG"
    }
    
    func loadData1()  {
      
        //isUploading = true
        //startLoading()
        let itemIdOri: String? = String(itemId1!.dropFirst(2))
        guard let url1 = URL(string: "http://59.10.47.222:3000/sampleload1?samcode=\(itemIdOri!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
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
                       //print("subload:\(url1)")
                        
                       // self.sampllist1.removeAll()
                        self.sampllist1 = decodedResponse1
                        print("건수\(self.sampllist1.count)")
                       
                        if(self.sampllist1.count == 0 ){
                            resultflag = false
                            resultText = "검색된 샘플정보가 없습니다."
                            showAlertDel = true
                            //isUploading = false
                            isUploading1 = false
                        }else{
                            self.sampllist1.forEach {
                                if($0.sammgnof==" " || $0.filesec==" " || $0.vtlpath==" "){
                                    imageURL = ""
                                    showAlertDel = true
                                    isUploading1 = false
                                }else{
                                    
                                    requestGet(v_attr5:"NA"+($0.sammgnof ??  "") ,v_attr6:$0.filesec ??  "",v_attr7:$0.vtlpath ??  "")
                                    imageURL = "http://59.10.47.222:3000/static/NA"+$0.sammgnof+"."+$0.filesec
                                    
                                   // requestGet(v_attr5:""+($0.sammgnof ??  "") ,v_attr6:$0.filesec ??  "",v_attr7:$0.vtlpath ??  "")
                                   // imageURL = "http://59.10.47.222:3000/static/"+$0.sammgnof+"."+$0.filesec
                                   
                                    
                                    
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
    
    func requestGet( v_attr5:String , v_attr6:String, v_attr7:String) {
       // isUploading = true
       
        // 7:path , 5: filename , 6: fileext
        var prefixattr3 = ""
        var attr5 = ""
        var imgUrl1 = ""
        attr5 = v_attr5+"."+v_attr6
        prefixattr3 = "http://herpold.asunghmp.biz/FTP"
        imgUrl1 = prefixattr3+v_attr7+v_attr5+"."+v_attr6
        
        guard let url3 = URL(string: "http://59.10.47.222:3000/imgdownload?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10&reqno=\(attr5)&imgUrl=\(imgUrl1)") else {
            Swift.print("Invalid URL")
            
            return
        }
        
        var request = URLRequest(url: url3)
        request.httpMethod = "GET"
        
        
        Foundation.URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 {
                  //  isUploading = false
                   
                }
                
                if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 304 {
                  //  isUploading = false
                   
                }
                
                guard let response = response as? HTTPURLResponse, (200 ..< 305) ~= response.statusCode else {
                    Swift.print("Error: HTTP request failed")
                    //isUploading = false
                    return
                }
                
                guard error == nil else {
                    Swift.print("Error: error")
                    //isUploading = false
                    return
                }
                
                guard data != nil else {
                    Swift.print("error: did no receive data")
                    //isUploading = false
                    return
                }
                
            }
        }.resume()
        
    }
    
}
