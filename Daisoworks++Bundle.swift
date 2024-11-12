//
//  Daisoworks++Bundle.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 11/29/24.
//
import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "DaisoworksInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_Key"] as? String else { fatalError("DaisoworksInfo.plist에 API_Key 키가 없습니다.") }
        return key
    }
}
