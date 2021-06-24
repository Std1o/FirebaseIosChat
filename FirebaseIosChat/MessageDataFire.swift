//
//  DataFire.swift
//  Chats
//
//  Created by App-Designer2 . on 25.01.20.
//  Copyright © 2020 App-Designer2 . All rights reserved.
//

import FirebaseDatabase
import Combine
import CodableFirebase

class MessageDataFire : ObservableObject {
    @Published var chat = [Message]()
    var ref = Database.database().reference()
    
    init() {
        
        _ = ref.child("chat").observe(.childAdded) { (snapshot) in
                    guard let value = snapshot.value else { return }
                    do {
                        let item = try FirebaseDecoder().decode(Message.self, from: value)
                        self.chat.append(item)
                    } catch let error {
                        print(error)
                    }
                }
    }
    
    func addInfo(msg: String, user: String, image: String) {
        let time = getTime()
        let messageModel = Message(id: NSUUID().uuidString, name: user, msg: msg, time: time, image: image)
        ref.child("chat").child(time.replacingOccurrences(of: ".", with: "")).setValue(try! FirebaseEncoder().encode(messageModel))
        print("Success")
    }
    
    func getTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let time = formatter.string(from: date)
        return time
    }
}
