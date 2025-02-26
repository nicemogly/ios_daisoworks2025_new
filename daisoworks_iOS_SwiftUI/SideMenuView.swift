//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.03
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    Main Layout - Menu
//  Program Name       :    SideMenuView.swift
//  Description        :    1.Side Menu View구성
//
//=============================================================================================================================================================
 
import SwiftUI

//================= 자료구조: 열거형 Group Define Start=================================
enum SideMenuRowType: Int, CaseIterable{
    case home = 0
    case product
    case company
    case suju
    case dms
    case exhibition
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .product:
            return "상품조회"
        case .company:
            return "거래처조회"
        case .suju:
            return "수주조회"
        case .dms:
            return "디자인결재"
        case .exhibition:
            return "전시회상담관리"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home"
        case .product:
            return "product"
        case .company:
            return "company"
        case .suju:
            return "suju"
        case .dms:
            return "dms"
        case .exhibition:
            return "exhibition"
        }
    }
}
//================= 자료구조: 열거형 Group Define End=================================

// SideMenuView Start
struct SideMenuView: View {
    
    //================= View : @Binding Group Define Start===============================
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    //================= View : @Bindg Group Define End===============================
    
    //Side View Layout
    var body: some View {
        HStack {
            
            ZStack{
                Rectangle()
                    .fill(.white)
                    .frame(width: 270)
                    .shadow(color: .purple.opacity(0.1), radius: 5, x: 0, y: 3)
                   
                
                VStack(alignment: .leading, spacing: 0) {
                    ProfileImageView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                  
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, imageName: row.iconName, title: row.title) {
                          
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: 270)
                .background(
                    Color.white
                )
            } .padding(.top , 30)
            
            
            Spacer()
        }
        .background(.clear)
    }
    
    func ProfileImageView() -> some View{
        VStack(alignment: .center){
            HStack{
                Spacer()
                Image("profile-image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.purple.opacity(0.5), lineWidth: 10)
                    )
                    .cornerRadius(50)
                Spacer()
            }
           
            let UserDept  = UserDefaults.standard.string(forKey: "memdeptgbn")
            let UserName = UserDefaults.standard.string(forKey: "memdeptnme")
            let Userid = UserDefaults.standard.string(forKey: "Userid")
            
            //부서확인
            Text("\(UserName!) ( \(UserDept!) )")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Text("\(Userid!)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.5))
        }
    }
    
    func RowView(isSelected: Bool, imageName: String, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
            
        } label: {
            VStack(alignment: .leading){
                HStack(spacing: 20){
                    Rectangle()
                        .fill(isSelected ? .purple : .white)
                        .frame(width: 5)
                    
                    ZStack{
                        Image(imageName)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isSelected ? .black : .gray)
                            .frame(width: 26, height: 26)
                    }
                    .frame(width: 30, height: 30)
                    if(title=="전시회상담관리"){
                      
                            NavigationLink(destination: ExhibitionListView(presentSideMenu: $presentSideMenu) ){
                                Text(title)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(isSelected ? .black : .gray)
                            }
                            
                        
                    } else {
                        Text(title)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(isSelected ? .black : .gray)
                    }
                        
                    Spacer()
                }
            }
        }
        .frame(height: 50)
        .background(
            LinearGradient(colors: [isSelected ? .purple.opacity(0.5) : .white, .white], startPoint: .leading, endPoint: .trailing)
        )
    }
}
