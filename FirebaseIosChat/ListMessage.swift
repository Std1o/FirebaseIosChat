//
//  ListMessage.swift
//  Chats
//
//  Created by App-Designer2 . on 26.01.20.
//  Copyright © 2020 App-Designer2 . All rights reserved.
//

import SwiftUI


struct ListMessage : View {
    
    var msg = ""
    
    var Message = false
    var user = ""
    var imageFormats = ["JPG", "PNG", "JPEG", "HEIC"]
    var image : String
    var body: some View {
        
        HStack {
            if Message {
                Spacer()
                
                VStack {
                    if !msg.isEmpty {
                        Text(msg).padding(10).background(Color.secondary)
                            .cornerRadius(15).foregroundColor(.white)
                    }
                    if !image.isEmpty {
                        ImageView(withURL: image).cornerRadius(15)
                    }
                }
            } else {
                VStack {
                    if !msg.isEmpty {
                        Text(msg).padding(10).background(Color.blue)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                    }
                    if !image.isEmpty {
                        ImageView(withURL: image).cornerRadius(15)
                    }
                    
                }
                Spacer()
            }
        }
    }
}


struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    
    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
    
    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width:200, height:200)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}
