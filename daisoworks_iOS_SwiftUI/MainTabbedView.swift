//=============================================================================================================================================================
//  ProjectName        :    DaisoWorks 아성다이소 관계사 업무관리 시스템
//  Dev.Environment    :    Swift6(iOS) , Kotlin(AOS) , HERP(Oracle 11g,.NET) , DMS(Mysql,JAVA SpringBoot) , REST API(Node.js Express)
//  Created by         :    Yoon Jang Hoon
//  Created Date       :    2024.10.03
//--------------------------------------------------------------------------------------------------------------------------------------------------------------
//  Module Name        :    Main Layout
//  Program Name       :    MainTabbedView.swift
//  Description        :    1.Side Menu 구성
//                     :    2.Tab Menu  구성
//                     :    3.Option Menu 구성
//=============================================================================================================================================================

import SwiftUI
import UIKit
 
// ===========================Extension Start========================
extension Color {
    static let purple_700 = Color("MyColor")
    static let lightGray_100 = Color("Bottomcolor")
}

private extension MainTabbedView {
    var navigationBarTitle: String{
        switch selectedSideMenuTab {
        case 0:
            return "홈"
        case 1:
            return "상품조회"
        case 2:
            return "거래처조회"
        case 3:
            return "수주조회"
        case 4:
            return "디자인결재"
        default:
            return ""
        }
    }
}

extension View {
    func navigationBarModifier(backgroundColor: UIColor = .systemBackground, foregroundColor: UIColor = .label, tintColor: UIColor?, withSeparator: Bool) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, tintColor: tintColor, withSeparator: withSeparator))
    }
}
// ===========================Extension End========================
// MainTabbedView  Start
struct MainTabbedView: View {
  
    //================= View : @State Group Define Start===============================
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    @State var tag1:Int? = nil
    @State var varTitle:String = ""
    @State var externalItemno:String = ""
    @State var itemNo:String = ""
    @State var barcodeNo:String = ""
    @State var buyCd:String = ""
    @State var comCode1:String = ""
    @State var sujubCode:String = ""
    @State var sujuMgno:String = ""
    @State var passKey:String = ""
    @State var reloadView:Int = 0
    //================= View : @State Group Define End==================================
    
    // 초기화
    init(){
        UITabBar.appearance().backgroundColor = .bottomcolor
    }

    //================= View : Body View Start==========================================
    var body: some View {
     
        
        NavigationView {
            ZStack{
                //Option Menu Logout Click
                NavigationLink(destination: LoginView(), tag: 1 , selection: $tag1){
                    EmptyView()
                }
                //Option Menu Setting Click
                NavigationLink(destination: SettingView(), tag: 2 , selection: $tag1){
                    EmptyView()
                }
                
           
                //TabView
                TabView(selection: $selectedSideMenuTab) {
                  
                    
                    HomeView(presentSideMenu: $presentSideMenu , selectedSideMenuTab : $selectedSideMenuTab, itemNo: $itemNo,   comCode1: $comCode1 , sujubCode: $sujubCode , sujuMgno: $sujuMgno , passKey: $passKey)
                        .tabItem{
                            (Image(systemName: "house"))
                            (Text("홈"))
                        }
                        .tag(0)
                    
                    ProductView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu  , itemNo: $itemNo , barcodeNo:$barcodeNo , buyCd: $buyCd,  passKey: $passKey , comCode1: $comCode1  )
                  
                        .tabItem{
                            (Image(systemName: "shippingbox.circle.fill"))
                            (Text("상품조회"))
                         
                        }
                        .tag(1)
                    
                    CompanyView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu  , itemNo: $itemNo , barcodeNo:$barcodeNo , buyCd: $buyCd, comCode1: $comCode1 , passKey: $passKey  )
                        .tabItem{
                            (Image(systemName: "person.text.rectangle"))
                            (Text("거래처조회"))
                        }
                        .tag(2)
                    
                    SujuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu  , itemNo: $itemNo , barcodeNo:$barcodeNo , buyCd: $buyCd,  passKey: $passKey , comCode1: $comCode1 , sujubCode: $sujubCode , sujuMgno: $sujuMgno)
                        .tabItem{
                            (Image(systemName: "rosette"))
                            (Text("수주조회"))
                        }
                        .tag(3)
                    DmsView( presentSideMenu: $presentSideMenu)
                        .tabItem{
                            (Image(systemName: "pencil.and.list.clipboard"))
                            (Text("디자인결재"))
                           
                        }
                        .tag(4)
                        
                }
              
                SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
            }
            
            .navigationBarItems(leading:
                  Button(action:{
                     presentSideMenu.toggle()
                 }){
                Image(systemName: "line.3.horizontal")
                         .foregroundColor(.white)
            }
            , trailing:
                    Menu{
                          Button("Setup", action:{
                              self.tag1 = 2
                          })
                          Button("Logout" , action:{
                                UserDefaults.standard.set("F", forKey: "autologin_Flag")
                                UserDefaults.standard.set("", forKey: "Userid")
                                UserDefaults.standard.set("", forKey: "Passwd")
                                UserDefaults.standard.set("", forKey: "LoginCompanyCode")
                                UserDefaults.standard.set("", forKey: "memdeptgbn")
                                UserDefaults.standard.set("", forKey: "memdeptnme")
                                UserDefaults.standard.set("", forKey: "memdeptcde")
                              UserDefaults.standard.set("", forKey: "autoExhFlag")
                              
                              self.tag1 = 1
                     })
                      } label: {
                                        Image( systemName: "ellipsis").rotationEffect(.degrees(90))
                                }
                                    .font(.system(size: 15))
                                    .frame(width: 50, height: 30)
                                    .accentColor(.white)
            )
            .navigationBarTitle(Text(navigationBarTitle), displayMode: .inline)
            .navigationBarModifier(backgroundColor: .mycolor, foregroundColor: .white, tintColor: .white, withSeparator: false)
        }
        .navigationBarBackButtonHidden(true)
    
    }
}

struct NavigationBarModifier: ViewModifier {
    
    init(backgroundColor: UIColor = .systemBackground, foregroundColor: UIColor = .blue, tintColor: UIColor?, withSeparator: Bool = true){
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.backgroundColor = backgroundColor
        if withSeparator {
            navBarAppearance.shadowColor = .clear
        }
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        if let tintColor = tintColor {
            UINavigationBar.appearance().tintColor = tintColor
        }
    }
    
    func body(content: Content) -> some View {
        content
   
    }
}
