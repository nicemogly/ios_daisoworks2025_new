//
//  SampleView2.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/17/25.
//
import SwiftUI
import PhotosUI


struct SampleList2: Decodable {
    var sammgno: String
    var samnm: String
    var supdeptcd: String!
    var deptsnme: String!
    var deptcde: String!
    var deptnme: String!
    var vtlpath: String!
    var clntnmkor: String!
    var adpgbn: String!
    var rsnnme: String!
    var rsncde: String!
}
struct SampleList4: Decodable {
    var rsncde: String
    var rsnnme: String
}


struct SampleView2: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var presentSideMenu: Bool
    @State private var navigateTo: String?
    @State private var isPresentingScanner = false // QR스캐너 팝업 표시여부
    @State private var scannedCode: String?  = nil  // 스캔결과저장
    @State private var textFieldText88: String = "" //텍스트필드 값 저장
    @State private var scannedString1 : String = ""
    @State private var scnflag1 : Bool = false
    @State private var itemId1 : String? = ""
    @State var samplelist2 = [SampleList2]()
    @State var samplelist4 = [SampleList4]()
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
    //@State private var registStr = ""
    @State private var selection1 = "사유를 선택하세요"
    
   //@State private var selection1 = ""
    @State private var selectedOption = "미채택"
    let options = ["미채택","채택","보완"]
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
                                                .scaledToFill()
                                                .frame(maxWidth: .infinity)
                                                .padding(25)
                                        case .failure:
                                            Text("이미지를 불러올 수 없습니다.")
                                        @unknown default:
                                            Text("알수 없는 오류 발생")
                                        }
                                    }
                                    
                                }.padding(.top , 5)
                                    .frame(maxWidth: .infinity)
                                
                            }
                            
                            VStack(alignment: .leading){
                                ForEach(samplelist2, id: \.sammgno) { item2 in
                                    Text("샘플명:\(item2.samnm)")
                                        .font(.system(size:16))
                                        .padding(.bottom, 10)
                                    Text("업체명:\(item2.clntnmkor)")
                                        .font(.system(size:16))
                                        .padding(.bottom, 10)
                                    Text("담당부서:\(item2.deptsnme)")
                                        .font(.system(size:16))
                                        .padding(.bottom, 10)
                                    Text("담당팀:\(item2.deptnme)")
                                        .font(.system(size:16))
                                        .padding(.bottom, 10)
                                    
                                    Picker("진행상태를 선택하세요", selection: $selectedOption) {
                                     
                                        ForEach(options, id: \.self) { option in
                                            Text(option)
                                        }
                                        
                                    }.frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                                        .background(Color(uiColor: .secondarySystemBackground))
                                    
                                    Picker(selection: $selection1 , label: Text("사유를 선택하세요")) {
                                        
                                        if selection1 == "사유를 선택하세요" {
                                            Text("사유를 선택하세요").tag("")
                                        }
                                      
                                        ForEach(samplelist4, id: \.rsncde) { item in
                                            Text(item.rsnnme).tag(item.rsncde)
                                        }
                                    }.disabled(!isPickerEnabled)
                                        .frame(  maxWidth: .infinity  , minHeight:50 , alignment: .leading)
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .onAppear(perform: loadData2)
                                    
                                    
                                    
                                    
                                }
                            }.padding()
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    resultflag ?
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 0.2) : nil
                                )
                            
                            Button(action: {
                                //
                                samSave()
                            }) {
                                Text("저장히기")
                                    .fontWeight(.bold)
                                    .frame(width:100 , height:50)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .buttonStyle(PlainButtonStyle())
                                    .padding()
                            }
                            
                            
                    }
            }
                Spacer()
            }
            .sheet(isPresented: $scnflag1){
                ScannerView3(scannedString1: $scannedString1 , scnflag1: $scnflag1 , itemId1: $itemId1)
        }
    }
        
        .onChange(of: selectedOption) { newValue1 in
            if ( newValue1 == "채택" || newValue1 == "보완") {
                isPickerEnabled = false
            }else{
                isPickerEnabled = true
            }
        }
       
        .onChange(of: itemId1) { newValue in
            if let value = newValue {
                textFieldText88 = value
                selection1 = ""
                loadData1()
                loadData2()
               
                //isLoading = false
            }
        }
        .padding()
        .onDisappear() {
            presentSideMenu = false
        }
        .navigationTitle("스터디 결과등록")
    }
    
  
    func subLoad(){
        resultflag = true
        isUploading = false
        showAlertDel = false
        //imageURL = "http://59.10.47.222:3000/static/NA\(itemId1!).JPG"
        imageURL = "http://59.10.47.222:3000/static/\(itemId1!).JPG"
    }
    
    func loadData1()  {
       
        let itemIdOri: String? = String(itemId1!.dropFirst(2))
        
        guard let url1 = URL(string: "http://59.10.47.222:3000/sampleload2?samcode=\(itemIdOri!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
  
        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
       
                decoder1.dateDecodingStrategy = .iso8601
                //SampleList2
                if let decodedResponse1 = try? decoder1.decode([SampleList2].self, from: data1){
                    DispatchQueue.main.async {
                       //print("subload:\(url1)")
                        print("itemID1:\(itemId1)")
                       // self.sampllist1.removeAll()
                        self.samplelist2 = decodedResponse1
                      //  print("건수11\(self.samplelist2.count)")
                       
                        if(self.samplelist2.count == 0 ){
                            resultflag = false
                            resultText = "검색된 샘플정보가 없습니다."
                            showAlertDel = true
                            //isUploading = false
                            isUploading1 = false
                            selectedOption = "미채택"
                            selection1 = "사유를 선택하세요"
                        }else{
                            self.samplelist2.forEach {
                                if($0.sammgno==" "  || $0.vtlpath==" "){
                                    imageURL = ""
                                    showAlertDel = true
                                    isUploading1 = false
                                }else{
                                    if $0.adpgbn == "0" {
                                        selectedOption = "미채택"
                                        isPickerEnabled = true
                                    }else if $0.adpgbn == "1" {
                                        selectedOption = "채택"
                                        isPickerEnabled = false
                                    }else if $0.adpgbn == "8" {
                                        selectedOption = "보완"
                                        isPickerEnabled = false
                                    }else {
                                        selectedOption = ""
                                        isPickerEnabled = true
                                    }
                                    
                                    selection1 = $0.rsncde ?? ""
                                    //selection1 = "사유를 선택하세요"
                                    if($0.vtlpath == " " || $0.vtlpath == nil  || $0.vtlpath == ""){
                                        imageURL = ""
                                    }else{
                                       // print("vtlpath:\($0.vtlpath)")
                                        requestGet(v_attr5:"NA"+($0.sammgno ??  "") ,v_attr6:"JPG",v_attr7:$0.vtlpath ??  "")
                                        imageURL = "http://59.10.47.222:3000/static/NA"+$0.sammgno+".JPG"
                                       
                                    }
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

    
    func samSave()  {
      
        startLoading()
        
        var SaveStatus : String = ""
        print("testest\(selection1)")
        if(selectedOption == "미채택"){
            SaveStatus = "0"
        }else if(selectedOption == "채택"){
            SaveStatus = "1"
            selection1 = ""
        }else if(selectedOption == "보완"){
            SaveStatus = "8"
            selection1 = ""
        }
        
        let itemIdOri: String? = String(itemId1!.dropFirst(2))
        
        
        guard let url1 = URL(string: "http://59.10.47.222:3000/samplesave?samplestatus=\(SaveStatus)&samplereason=\(selection1)&samplecode=\(itemIdOri!)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
  
        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
       
                decoder1.dateDecodingStrategy = .iso8601
                //SampleList2
                if let decodedResponse1 = try? decoder1.decode([SampleList4].self, from: data1){
                    DispatchQueue.main.async {
                        self.samplelist4 = decodedResponse1

                    }
                 
                    return
                
                }
            }
        }.resume()
    }
    
    
    func loadData2()  {
        guard let url1 = URL(string: "http://59.10.47.222:3000/samplereason?apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
            print("Invalid URL")
            return
        }
  
        let request1 = URLRequest(url: url1)
        URLSession.shared.dataTask(with: request1) { data1, response, error in
            if let data1 = data1 {
                let decoder1 = JSONDecoder()
       
                decoder1.dateDecodingStrategy = .iso8601
                //SampleList2
                if let decodedResponse1 = try? decoder1.decode([SampleList4].self, from: data1){
                    DispatchQueue.main.async {
                        self.samplelist4 = decodedResponse1

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
