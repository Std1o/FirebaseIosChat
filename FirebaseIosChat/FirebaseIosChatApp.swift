import Firebase
import SwiftUI
import GoogleSignIn

@main
struct FirebaseIosChatApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate 
    
    var body: some Scene {
        WindowGroup {
            ContentView(info: self.delegate)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject  {
    
    @Published var email = ""
    @Published var name = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
         
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else{
            print(error.localizedDescription)
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (result, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            self.email = (result?.user.email)!
            self.name = (result?.user.displayName)!
            print((result?.user.email)!)
        }
    }
}
