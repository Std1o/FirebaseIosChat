import SwiftUI
import Combine
import FirebaseStorage

struct Messagepage: View {
    @ObservedObject var message = MessageDataFire()
    var image : String?
    @State var shown = false
    @State var selectedImage: UIImage?
    @State var attachedFiles = [String]()
    let storage = Storage.storage().reference()
    @StateObject var homeData = HomeViewModel()
    @ObservedObject var info:  AppDelegate
    
    @State var write = ""
    var body: some View {
        VStack {
            
            ScrollView(showsIndicators: false) {
                ForEach(message.chat) { i in
                    if i.name == info.name {
                        ListMessage(msg: i.msg, Message: true, user: i.name, image: i.image).padding(EdgeInsets(top: 3, leading: 50, bottom: 0, trailing: 10)).onTapGesture {
                            homeData.selectedImageID = i.image
                            homeData.showImageViewer.toggle()
                        }
                    } else {
                        ListMessage(msg: i.msg, Message: false, user: i.name, image: i.image).padding(EdgeInsets(top: 3, leading: 10, bottom: 10, trailing: 50)).onTapGesture {
                            homeData.selectedImageID = i.image
                            homeData.showImageViewer.toggle()
                        }
                    }
                }
            }.navigationBarTitle("Chats", displayMode: .inline)
            
            HStack {
                Image(systemName: "paperclip").onTapGesture {
                    shown.toggle()
                }
                TextField("message...",text: self.$write).padding(10)
                
                Button(action: {
                    if self.write.count > 0 {
                        self.message.addInfo(msg: self.write, user: info.name, image: self.image ?? "")
                        self.write = ""
                    } else {
                        
                    }
                }) {
                    Image(systemName: "paperplane.fill").font(.system(size: 20))
                        .foregroundColor((self.write.count > 0) ? Color.blue : Color.gray)
                        .rotationEffect(.degrees(50))
                    
                }
            }.padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
            .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.3)).padding()
            
        }.overlay(
            ZStack{
                FullImageView()
                if selectedImage != nil{
                    GeometryReader { geometry in
                        ProgressDialog().frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
                }
            }
        )
        //setting envoronment Object...
        .environmentObject(homeData).onChange(of: selectedImage, perform: { value in
            if selectedImage != nil {
                uploadImageToFireBase(image: selectedImage!)
            }
        }).sheet(isPresented: $shown, content: {
            ImagePicker(shown: $shown, selectedImage: $selectedImage)
        })
    }
    
    func uploadImageToFireBase(image: UIImage) {
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path FILE_NAME
        storage.child(FILE_NAME).putData(image.jpegData(compressionQuality: 0.42)!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print((error?.localizedDescription)!)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            
            print("Upload size is \(size)")
            print("Upload success")
            self.downloadImageFromFirebase()
        }
    }
    
    func downloadImageFromFirebase() {
        // Create a reference to the file you want to download
        storage.child(FILE_NAME).downloadURL { [self] (url, error) in
            if error != nil {
                // Handle any errors
                print((error?.localizedDescription)!)
                return
            }
            self.message.addInfo(msg: self.write, user: info.name, image: url!.absoluteString)
            selectedImage = nil
        }
    }
}
