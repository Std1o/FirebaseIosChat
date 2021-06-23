import SwiftUI
import FirebaseStorage
import Combine
import PhotosUI

var FILE_NAME = NSUUID().uuidString

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var shown: Bool
    @Binding var selectedImage: UIImage?
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
        var parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.shown.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ [self]status in
                    if status == .authorized{
                        someShit(info: info, image: image)
                    } else {
                        someShit(info: info, image: image)
                    }
                })
            } else {
                someShit(info: info, image: image)
            }
        }
        
        func someShit(info: [UIImagePickerController.InfoKey : Any], image: UIImage) -> Void {
            if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
                let asset = result.firstObject
                let name = asset?.value(forKey: "filename")
                if name != nil {
                    FILE_NAME = name as! String
                }
                print(FILE_NAME)
                
            }
            parent.selectedImage = image
            self.parent.shown.toggle()
        }
        
        func getFileType(path: String) -> String {
            return path[path.lastIndex(of: ".")!...].replacingOccurrences(of: ".", with: "")
        }
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
