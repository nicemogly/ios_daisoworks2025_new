//
//  testView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 10/7/24.
//
import SwiftUI


struct Places: Identifiable {
    var id = UUID()
    var name: String
    var place: String
    var desc: String
    var kind: String
}

var placesList: [Places] = [
    Places(name: "애월더선셋", place: "제주 제주시 애월읍", desc: "해지는 모습을 볼 수 있는 제주 애월카페. 맑은 날 가면 멋진 바다배경의 인생사진을 얻을 수 있다.", kind: "carbak"),
    Places(name: "주전패밀리캠핑장", place: "울산 동구 주전해안길", desc: "울산 주전해안에 위치한 해돋이 명소 캠핑장. 총 5개 구역으로 구분된다.", kind: "camping"),
    Places(name: "더무빙카라반", place: "부산 기장군 장안읍", desc: "자연 속에서 즐기는 감성 카라반 캠핑. 차별화된 독특한 글램핑 시설의 프리미엄 카라반 리조트로, 바다와 해수욕장이 인접해 있다.", kind: "backpack")
]

class PlaceStore: ObservableObject {
    @Published var selectedCategory: String = "all"
    
    func returnPlaces() -> [Places] {
        switch selectedCategory {
        case "all" :
            return placesList
        case "camping":
            return placesList.filter { $0.kind == "camping"}
        case "carbak" :
            return placesList.filter { $0.kind == "carbak"}
        case "glamping":
            return placesList.filter { $0.kind == "glamping"}
        case "backpack":
            return placesList.filter { $0.kind == "backpack"}
        default :
            return placesList
        }
    }
}




struct testView : View   {
    
  
    var body: some View {
    
        VStack {
           
        }
       
        
    }
    
   
}


