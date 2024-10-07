import SwiftUI
import LocalAuthentication

struct LoginView1: View {
   // var size: CGSize
    @State private var isFaceIdDone: Bool = false
    @State var isActiv = false

    var body: some View {
        
        NavigationStack {
            VStack(
                alignment: .center,
                spacing: 10
                
            ){
                NavigationLink(destination: MainTabbedView().navigationBarBackButtonHidden(true), isActive: $isActiv) {
                    EmptyView()
                }
                
           
                
                Text(isFaceIdDone ? "생체인증 완료" : "생체인증")
                    .onAppear{
                        print("here")
                        Task.detached{ @MainActor in
                            print("will start on appear main")
                            faceIdAuthentication()
                            
                        }
                    }
                
                Button{
                    isFaceIdDone = false
                    faceIdAuthentication()
                    
                } label: {
                    Text("Reset")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 80)
                        .padding(.vertical, 15)
                        .background{
                            Capsule()
                                .fill(.black)
                        }
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(maxHeight: .infinity, alignment: .center)
        }
    }
    
    
    func boo() {
        self.isActiv.toggle()
    
    }
    
    func faceIdAuthentication(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Daisoworks를 사용하려면 암호를 입력하세요"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason){ success, authenticationError in
                if success{
                    print("successed")
                    isFaceIdDone = true
                    isActiv = true
                }else{
                    print("failed")
            
                }
            }
        }else{
            // Device does not support Face ID or Touch ID
            print("생체인증을 지원하지 않는 디바이스입니다.")
        }
    }
    
 
}
