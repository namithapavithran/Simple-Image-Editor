//
//  ImagePicker.swift
//  ImageEditor
//
//  Created by Namitha Pavithran on 27/06/2021.
//

import UIKit

public protocol ImagePickerDelegate: class {
   func didPick(image: UIImage?)
}

class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.sourceType = .photoLibrary
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    func present() {
        self.presentationController?.present(pickerController, animated: true, completion: nil)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate  {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
           return
        }
        delegate?.didPick(image: image)
    }
   
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
