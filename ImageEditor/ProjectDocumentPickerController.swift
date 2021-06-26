//
//  ImagePickerController.swift
//  ImageEditor
//
//  Created by Namitha Pavithran on 25/06/2021.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

protocol ProjectImageDelegate {
    func didSelect(image: UIImage?)
}

class ProjectDocumentPickerController: NSObject {
    
    var presentationController: UIViewController?
    let supportedTypes: [UTType] = [UTType.image]
    var delegate: ProjectImageDelegate?
    
    init(presentationController: UIViewController,delegate: ProjectImageDelegate) {
        self.presentationController = presentationController
        self.delegate = delegate
    }
        func openPicker () {
        let supportedTypes: [UTType] = [UTType.image]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
       
        documentPicker.delegate = self
        
        // Present the document picker.
        self.presentationController?.present(documentPicker, animated: true, completion: nil)
       
    }
    
    func export(_ image: UIImage) {
        
        if let fileURL = FileManager.getFileUrlOf(image) {
      /*  guard let imageData = image.pngData() else {
               return
           }
           
           let fileManager = FileManager.default

           do {
               let fileURL = fileManager.temporaryDirectory.appendingPathComponent("temp.png") // 3
               // image data is temporarily saved to fileURL
               try imageData.write(to: fileURL)
            guard fileURL.startAccessingSecurityScopedResource() else { return }
                   defer {
                       DispatchQueue.main.async {
                        fileURL.stopAccessingSecurityScopedResource()
                       }
                    }*/
                           
               if #available(iOS 14, *) {
                   let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
                documentPicker.delegate = self
                documentPicker.title = "export"
                self.presentationController?.present(documentPicker, animated: true, completion: nil)
                
               } else {
                   let documentPicker = UIDocumentPickerViewController(url: fileURL, in: .exportToService)
                
                documentPicker.delegate = self
                self.presentationController?.present(documentPicker, animated: true, completion: nil)
               }
        } else {
            print("could not get file url")
        }
          /* } catch {
               print("Error creating file")
           }*/
    }
    
}
extension ProjectDocumentPickerController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else { return }
               defer {
                   DispatchQueue.main.async {
                       url.stopAccessingSecurityScopedResource()
                   }
                    }

               //Need to make a new image with the jpeg data to be able to close the security resources!
               guard let image = UIImage(contentsOfFile: url.path), let imageCopy = UIImage(data: image.jpegData(compressionQuality: 1.0)!) else { return }

        delegate?.didSelect(image: imageCopy)
        
        controller.dismiss(animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        if controller.title == "export" {
            FileManager.removeFileURL()
        /*let fileManager = FileManager.default
            
            let fileURL = fileManager.temporaryDirectory.appendingPathComponent("temp.png")
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error deleting file")
            }*/
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

