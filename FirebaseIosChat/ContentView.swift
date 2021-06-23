//
//  ContentView.swift
//  Chats
//
//  Created by App-Designer2 . on 25.01.20.
//  Copyright © 2020 App-Designer2 . All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct ContentView: View {
    
    @ObservedObject var info:  AppDelegate
    var body: some View {
        if !info.name.isEmpty {
            Messagepage(info: info)
        } else {
            Button(action: {
                GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                
                GIDSignIn.sharedInstance()?.signIn()
            }, label: {
                Text("Sign In")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 45)
                    .background(Color.red)
                    .clipShape(Capsule())
            }).onAppear() {
                let firebaseAuth = Auth.auth()
                let user = firebaseAuth.currentUser
                if user != nil {
                    info.name = (user?.displayName)!
                }
            }
        }
    }
}
