//
//  DataFire.swift
//  Chats
//
//  Created by App-Designer2 . on 25.01.20.
//  Copyright © 2020 App-Designer2 . All rights reserved.
//

import Firebase
import Combine


class DataFire : ObservableObject {
    @Published var chat = [iDData]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("chat").addSnapshotListener { (snap, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            for i in snap!.documentChanges {
                if i.type == .added {
                    
                    guard let name = i.document.get("name") as? String else { return }
                    guard let msg = i.document.get("msg") as? String else { return }
                    guard let time = i.document.get("time") as? String else { return }
                    guard let image = i.document.get("image") as? String else { return }
                    let id = i.document.documentID
                    
                    self.chat.append(iDData(id: id,name: name, msg: msg, time: time, image: image))
                    print(msg)
                }
            }
        }
    }
    func addInfo(msg: String, user: String, image: String) {
        let db = Firestore.firestore()
        
        db.collection("chat").addDocument(data: ["msg": msg, "name": user, "image": image, "time": getTime()]) { (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("Success")
        }
    }
    
    func getTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let time = formatter.string(from: date)
        return time
    }
}
