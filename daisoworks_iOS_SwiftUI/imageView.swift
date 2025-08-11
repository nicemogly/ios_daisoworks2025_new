//
//  imageView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 3/19/25.
//
import SwiftUI
import Combine
import PhotosUI


struct imageView: View {
    @State var selectedImage: UIImage?
    @State var showPicker: Bool = false
    @Binding var itemId1: String
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isImageSelected: Bool = false
    @State private var selectedImagesData: [Data] = []
    @State private var additionalParameters: [String: String] = [ "vattr1": "value1", "vattr2": "value2", "vattr3": "value3",  "apikey": "value4"]
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isSaving = false
  
    
    
    let onButtonPressed: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            //Text("이미지를 가져오지 못했습니다.")
            HStack(){
                
                PhotosPicker(selection: $selectedItems , maxSelectionCount: 1, matching: .images){
                    Image(systemName: "photo.fill")
                                            .resizable()
                                            .frame(maxWidth: 150, maxHeight: 150)
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                  
                }
                
                .onChange(of: selectedItems) { newItems in
                    Task {
                        loadImages()
                    }
                }
                
                if selectedImagesData.isEmpty {
                    TabView {
                       
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(width: 200, height: 200)
                    .background(Color.gray.opacity(0.1))
                }else {
                    
                    
                    TabView {
                        ForEach(selectedImagesData, id: \.self) { imageData in
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxHeight: 200)
                                
                                
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(width: 200, height: 200)
                }
                
                Spacer()
                
                
            }
            if isSaving {
                ProgressView("데이터 등록중...")
                    .padding()
            }else {
                Button(action: {
                    
                    if(isImageSelected == false){
                        alertTitle = "알림"
                        alertMessage = "선택된 샘플이미지가 존재하지 않습니다."
                        showAlert = true
                    }else{
                        //scnflag1.toggle()
                        // imageURL="http://112.175.40.40/static/NA20250200001.JPG"
                        // onButtonPressed()
                        // uploadImages()
                        isSaving = true
                        uploadImages()
                        
                    }
                    
                }) {
                    Text("샘플 이미지 등록")
                        .fontWeight(.bold)
                        .frame(width:200 , height:50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                } .alert(isPresented: $showAlert){
                    Alert(
                        title: Text(alertTitle),
                        message: Text(alertMessage),
                        dismissButton: .default (Text("확인"))
                    )
                }
            }
            
        }.padding(.top , 30)
    }
    

    func uploadImages(){
        let ss = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        
         guard let url = URL(string: "http://112.175.40.40:3000/sampleImg") else {
            print("Invalid URL")
            return
        }
        //print("testtest" , "1111111")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        //print("testtest" , "22222")
        for(index, imageData) in selectedImagesData.enumerated(){
            //var fileName = "NA"+itemId1
            var fileName = itemId1
            fileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
            httpBody.append(convertFileData(fieldName: "files" , fileName: "\(fileName).JPG" , mimeType: "image/jpeg", fileData: imageData, using: boundary))
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let vyear = formatter.string(from: Date())
        
        
        let itemIdOri: String = String(itemId1.dropFirst(2))
        
        additionalParameters["vattr1"] = itemIdOri
        additionalParameters["vattr2"] = "/IMAGES/SIN/" + vyear + "/"
        additionalParameters["vattr3"] = "\\IMAGES\\SIN\\" + vyear + "\\"
        additionalParameters["vattr4"] = ss
        additionalParameters["vattr5"] = itemIdOri
        
        additionalParameters["apikey"] = "WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10"
        
        for (key, value) in additionalParameters {

            httpBody.appendString("--\(boundary)\r\n")

            httpBody.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")

            httpBody.appendString("\(value)\r\n")

        }

        //print("testtest" , "33333")

        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                //print("testtest" , "77777")
                //print("Error uploading images: \(error)")
                isSaving = false
                return

            }
           
            
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 {
               // isSaving = false
               // onButtonPressed()
                //print("testtest" , "33")
                uploadImages1()
            }
            
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 304 {
                //isSaving = false
               // print("testtest" , "333")
                //onButtonPressed()
                uploadImages1()
              
            }
            
            
          //  isLoading = false
           // print("Upload successful")

        }.resume()
        
      
    }
    
    func uploadImages1(){
        let ss = UserDefaults.standard.string(forKey: "LoginCompanyCode")
        
         guard let url = URL(string: "http://112.175.40.40:3000/sampleImg1") else {
            print("Invalid URL")
            return
        }
        
        //print("testtest" , "dddddddd")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
   
        for(index, imageData) in selectedImagesData.enumerated(){
            //var fileName = "NA"+itemId1
            var fileName = itemId1
            fileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
            httpBody.append(convertFileData(fieldName: "files" , fileName: "\(fileName).JPG" , mimeType: "image/jpeg", fileData: imageData, using: boundary))
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let vyear = formatter.string(from: Date())
        
        let itemIdOri: String = String(itemId1.dropFirst(2))
        
        additionalParameters["vattr1"] = itemIdOri
        additionalParameters["vattr2"] = "/IMAGES/SIN/" + vyear + "/"
        additionalParameters["vattr3"] = "\\IMAGES\\SIN\\" + vyear + "\\"
        additionalParameters["vattr4"] = ss
        additionalParameters["vattr5"] = itemIdOri
        
        additionalParameters["apikey"] = "WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10"
        
        for (key, value) in additionalParameters {

            httpBody.appendString("--\(boundary)\r\n")

            httpBody.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")

            httpBody.appendString("\(value)\r\n")

        }



        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("Error uploading images: \(error)")
                isSaving = false
                return

            }
           
            
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 200 {
                isSaving = false
                onButtonPressed()
              
            }
            
            if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 304 {
                isSaving = false
                onButtonPressed()
              
            }
            
            
          //  isLoading = false
            print("Upload successful")

        }.resume()
        
      
    }
    
    
    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {

        let data = NSMutableData()

        data.appendString("--\(boundary)\r\n")

        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")

        data.appendString("Content-Type: \(mimeType)\r\n\r\n")

        data.append(fileData)

        data.appendString("\r\n")

        return data as Data

    }
    
    func loadImages() {

        selectedImagesData.removeAll()

        for item in selectedItems {

            item.loadTransferable(type: Data.self) { result in

                switch result {

                case .success(let data?):

                    selectedImagesData.append(data)
                    isImageSelected = true

                case .success(nil):

                    print("No data found")

                case .failure(let error):

                    print("Error loading image data: \(error.localizedDescription)")

                }

            }

        }

    }

    
    
    
}
