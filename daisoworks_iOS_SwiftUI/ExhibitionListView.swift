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
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

struct ExhibitionListView: View {
    @Binding var presentSideMenu: Bool
    @State private var navigateTo: String?
   

    var body: some View {
        
        VStack {
            
            NavigationView {
                VStack {
                   
                    WebView(urlString: "https://ex.hanwellchina.net/appTest.aspx", navigateTo: $navigateTo)
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




