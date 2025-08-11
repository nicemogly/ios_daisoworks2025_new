//
//  BottoSheetView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 4/3/25.
//

import SwiftUI
import AVFoundation
import Vision
import PhotosUI

struct BottomSheetView: View {
  
    @Binding var showBottomSheet : Bool
    @State private var isScannerPresented = false
    @State private var scannedCodes: [String] = []
    
    @State private var scannedString1 : String = ""
    @State private var scnflag1 : Bool = false
    @State private var itemId1 : String = ""
    @State private var itemId1prev : String = ""
    @State private var textFieldText88 : String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Text("샘플접수")
                .font(.headline)
                .padding()
            
           VStack(alignment: .center) {
               
                               Button(action: {
                                   
                                   showAlert = false
                                   scnflag1.toggle()
                               }) {
                                   Text("스캔 시작")
                                       .frame(width: 80, height: 20)
                                       .padding()
                                       .foregroundColor(.white)
                                       .background(Color.red)
                                       .clipShape(Rectangle())
                                       .shadow(radius: 0)
                               }
                             
              
                              
                .padding()
                .sheet(isPresented: $scnflag1) {
                    ScannerView2(scannedString1: $scannedString1 , scnflag1: $scnflag1 , itemId1: $itemId1)
                }
               
               if showAlert {
                   Text("접수완료 또는 유효하지 않은 샘플!")
                       .frame(width: .infinity, height: 20)
                       .padding()
                       .foregroundColor(.red)
                       .fontWeight(.black)
               }
             
                   List(scannedCodes, id: \.self) { code in
                       HStack {
                           Text(code)
                           Spacer()
                           Button(action: {
                               unRegistSample(code: code)
                           }){
                               Image(systemName: "x.square")
                                   .resizable()
                                   .frame(width: 20, height: 20)
                                   .foregroundColor(.red)
                                   .padding(.leading, 10)
                           }
                        //   Text("[삭제]")
                       }
                      
                       
                   }
                   .listRowBackground(Color.clear)
                   .background(Color.yellow.opacity(0.2))
               
               
            }
           
           .frame(maxWidth: .infinity)
               // .background(Color.gray.opacity(0.8))
                .padding()
    
                .onChange(of: itemId1) { newValue in
             
                        checkForDuplicate(newValue)
                }
                
          
            Button(action: {
                showBottomSheet = false
            }){
                Text("닫기")
                    .padding(14)
                    .padding(.leading)
                    .padding(.trailing)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            
        
            Spacer()
        }
      
        
        .frame(height: 600)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.yellow.opacity(1))
        .cornerRadius(16)
        .shadow(radius: 0)
        .padding(.horizontal)
        .padding(.top,80)
        
      
        
    }
    
    func checkForDuplicate(_ newCode: String?) {
        guard let newCode = newCode else { return }
        
       // print("newCode:\(newCode)")
       // print("itemId1prev:\(String(describing: itemId1prev))")
        
        if newCode.isEmpty {
            
        }else{
            if (newCode ==  itemId1prev) {
                showAlert = true
                //print("2")
            }else{
                if !scannedCodes.contains(newCode) {
                    AcceptSample(newCode: newCode)
                }else{
                    
                    
                    showAlert = true
                    //    print("\(showAlert)")
                    
                    
                }
            }
        }
    }
    
    
    func unRegistSample(code: String ){
        var  memempmgnum = UserDefaults.standard.string(forKey: "mempmgnum")!
       
        if code.isEmpty {
            
        }else{
            
            guard let url = URL(string: "http://112.175.40.40:3000/sampleunregist?samplecode=\(code)&memempmgnum=\(memempmgnum)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data , let responseStr =  String(data: data, encoding: .utf8){
                    print("\(responseStr)")
                    
                    if (responseStr=="ok") {
                        scannedCodes.removeAll{ $0 == code }
                        itemId1prev = ""
                        itemId1 = ""
                       
                    }else{
                      //  showAlert = true
                    }
                }
            }.resume()
        }
    }
    
    
    func  AcceptSample(newCode: String){
        
       var  memempmgnum = UserDefaults.standard.string(forKey: "mempmgnum")!
        print("empno:\(memempmgnum)")
        
        let itemIdOri: String = String(newCode.dropFirst(2))
        
        if memempmgnum.isEmpty {
            
        }else{
            guard let url = URL(string: "http://112.175.40.40:3000/sampleaccept?memempmgnum=\(memempmgnum)&barcode=\(itemIdOri)&apikey=WCE2HG6-CKQ4JPE-J39AY8B-VTJCQ10") else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data , let responseStr =  String(data: data, encoding: .utf8){
                    print("testtest\(responseStr)")
                    
                    if (responseStr=="ok") {
                        
                        itemId1prev = newCode
                        scannedCodes.append(newCode)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            scnflag1 = true
                        }
                        
                    }else{
                        showAlert = true
                    }
                }
            }.resume()
        }
    }
    
    
}



