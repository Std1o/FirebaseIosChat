import Firebase

import SwiftUI

@main
struct FirebaseIosChatApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
