//
//  TestView.swift
//  daisoworks_iOS_SwiftUI
//
//  Created by AD2201016P02 on 2/13/25.
//
 
import SwiftUI
import WebKit




struct WebView: UIViewRepresentable {
    let urlString: String
    @Binding var navigateTo: String?
    
    let parameters: [String: String]

 
    
    class Coordinator: NSObject, WKNavigationDelegate , WKScriptMessageHandler {
      
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
            }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
            if message.name == "buttonClicked", let messageBody = message.body as? String {
                print("Button clicked in webView:\(messageBody)")
                parent.navigateTo = messageBody
            }
         }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
            webView.evaluateJavaScript("""
                                       document.getElementById('myButton').addEventListener('click', function(){
                                       window.webkit.messageHanlers.buttonClicked.postMessage('navigateToDetail');
                                       });
            """) { (result, error)  in
                if let error = error {
                    print("Error injecting JavaScript: \(error)")
                }else{
                    print("JavaScript injected successfully.")
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.configuration.userContentController.add(context.coordinator , name: "buttonClicked")
     
        
        guard var urlComponents = URLComponents(string: urlString) else {
            fatalError("Invalid URL string: \(urlString)")
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.0, value: $0.1) }
   //urlComponents.url
        guard let url = urlComponents.url else {
            fatalError("Invalid URL components: \(urlComponents)")
        }
        
      // print("\(url)")
        //let request = URLRequest(url: url)
        webView.load(URLRequest(url:url))
      // print(url)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
//        if let url = URL(string: urlString){
//            
//            print("aaa\(url)")
//            
//            
//            let request = URLRequest(url: url)
//            uiView.load(request)
//        }
    }
}

struct ExhibitionListView: View {
    @Binding var presentSideMenu: Bool
    @State private var navigateTo: String?
   

    var body: some View {
        var  LoginID = UserDefaults.standard.string(forKey: "Userid")!
        VStack {
            
            NavigationView {
                VStack {
                   
                    WebView(urlString: "https://ex.hanwellchina.net/NSCMMain.aspx", navigateTo: $navigateTo , parameters: ["LoginID":"\(LoginID)"])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                       
                    NavigationLink(destination: ExhibitionItemView(), tag: "navigateToDetail" , selection: $navigateTo) {
                        EmptyView()
                        
                    }
                   
                    
                }  
                //
               
                
            }
            .modifier(AppearanceModifier())
        }
        
    
      
        .onDisappear() {
           presentSideMenu = false
        }
        .navigationTitle("전시회 상담관리")
    }
}




