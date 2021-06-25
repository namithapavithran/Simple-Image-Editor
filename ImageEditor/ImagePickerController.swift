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

class ImagePickerController: NSObject {
    
    var presentationController: UIViewController?
    let supportedTypes: [UTType] = [UTType.image]
    var delegate: ProjectImageDelegate?
    
    init(presentationController: UIViewController) {
        self.presentationController = presentationController
    }
        func implementPicker () {
        let supportedTypes: [UTType] = [UTType.image]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
       
        documentPicker.delegate = self

        // Present the document picker.
        self.presentationController?.present(documentPicker, animated: true, completion: nil)
       
    }
    
}
extension ImagePickerController: UIDocumentPickerDelegate {
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
        controller.dismiss(animated: true, completion: nil)
    }
}
