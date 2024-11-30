//
//  Test2.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/20/25.
//

import SwiftUI

import PhotosUI



struct Test2: View {

    @State private var selectedItems: [PhotosPickerItem] = []

    @State private var selectedImagesData: [Data] = []

    @State private var additionalParameters: [String: String] = ["param1": "value1", "param2": "value2"]



    var body: some View {

        VStack {

            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {

                Text("Select Photos")

            }

            TabView {

                ForEach(selectedImagesData, id: \.self) { imageData in

                    if let image = UIImage(data: imageData) {

                        Image(uiImage: image)

                            .resizable()

                            .scaledToFit()

                    }

                }

            }

            .tabViewStyle(PageTabViewStyle())

            .frame(height: 300)

            Button(action: loadImages) {

                Text("Load Images")

            }

            Button(action: uploadImages) {

                Text("Upload Images and Parameters")

            }

        }

        .onChange(of: selectedItems) { newItems in

            loadImages()

        }

    }



    func loadImages() {

        selectedImagesData.removeAll()

        for item in selectedItems {

            item.loadTransferable(type: Data.self) { result in

                switch result {

                case .success(let data?):

                    selectedImagesData.append(data)

                case .success(nil):

                    print("No data found")

                case .failure(let error):

                    print("Error loading image data: \(error.localizedDescription)")

                }

            }

        }

    }



    func uploadImages() {

        guard !selectedImagesData.isEmpty else { return }



        let url = URL(string: "http://59.10.47.222:3000/upload")!

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.timeoutInterval = 60



        let boundary = UUID().uuidString

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")



        let httpBody = NSMutableData()



        for (index, imageData) in selectedImagesData.enumerated() {

            httpBody.append(convertFileData(fieldName: "files", fileName: "image\(index).jpg", mimeType: "image/jpeg", fileData: imageData, using: boundary))

        }



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

                return

            }

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

}



//extension NSMutableData {
//
//    func appendString(_ string: String) {
//
//        if let data = string.data(using: .utf8) {
//
//            append(data)
//
//        }
//
//    }
//
//}
