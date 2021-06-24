//
//  IDData.swift
//  Chats
//
//  Created by App-Designer2 . on 26.01.20.
//  Copyright © 2020 App-Designer2 . All rights reserved.
//

import SwiftUI


struct Message : Codable, Identifiable {
    internal init(id: String, name: String, msg: String, time: String, image: String) {
        self.id = id
        self.name = name
        self.msg = msg
        self.time = time
        self.image = image
    }
    
    var id: String
    var name : String
    var msg : String
    var time: String
    var image : String
}
