//
//  ViewController.swift
//  ImageEditor
//
//  Created by Namitha Pavithran on 24/06/2021.
//

import UIKit
import UniformTypeIdentifiers


class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //MARK: - Properties
    
    var documentPicker: ProjectDocumentPickerController?
    var imagePicker: ImagePicker!
    var verFlipped = false
    var present = false
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentPicker = ProjectDocumentPickerController(presentationController: self, delegate: self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
       
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            // we got back an error!
            showAlert(message: error.localizedDescription, title: "Save error")
            
        } else {
            showAlert(message: "Your altered image has been saved to your photos.", title: "Saved!")
        }
    
}
    func showAlert(message: String,title: String) {
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showOpenOptions() {
        
    }
// MARK: - IBActions

    @IBAction func openButtonClicked(_ sender: Any) {
        //imagePicker?.openPicker()
        let alertController = UIAlertController(title: "nil", message: "select an option to open your photo", preferredStyle: .actionSheet)

        let action = UIAlertAction(title: "Open from Files", style: .default) { (action) in
            self.documentPicker?.openPicker()
        }
        let action1 = UIAlertAction(title: "Open from Photos album", style: .default) { (action) in
            self.imagePicker.present()
        }
        alertController.addAction(action)
        alertController.addAction(action1)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: "Select an option to save your photo", preferredStyle: .actionSheet)

        let action = UIAlertAction(title: "Files", style: .default) { (action) in
            if let image = self.imageView.image {
                self.documentPicker?.export(image)
            }
        }
        let action1 = UIAlertAction(title: "Save in Photos album", style: .default) { (action) in
            if let image = self.imageView.image {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
             }
        }
        alertController.addAction(action)
        alertController.addAction(action1)
        present(alertController, animated: true, completion: nil)
      
    }
 
    @IBAction func cropButtonClicked(_ sender: Any) {
        // The shortest side
        if let image = imageView.image {
        let sideLength = min(
            image.size.width,
            image.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = image.size
            let xOffset = (sourceSize.width  - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = image.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!
            let croppedImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
            imageView.image = croppedImage
        }
    }
    
    @IBAction func flipVerticalButtonClicked(_ sender: Any) {
        if let image = imageView.image {
            if verFlipped {
                let flippedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
             imageView.image = flippedImage
                
            }
            else {
            let flippedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .downMirrored)
         imageView.image = flippedImage
                
            }
            verFlipped = !verFlipped
        }
    }
    @IBAction func flipHorizontalButtonClicked(_ sender: Any) {
        if let image = imageView.image {
       
            let flippedImage = image.withHorizontallyFlippedOrientation()
            imageView.image = flippedImage
        }
        
    }
    fileprivate func convertToString(_ dic: CFDictionary) -> String? {
        let info = NSDictionary(dictionary: dic)//["Exif"] as? [String]
        let exifInfo = info["{Exif}"] as? NSDictionary
        
        var strExif = ""
        if let exifinfo = exifInfo {
            exifinfo.forEach { (key,value) in
                strExif += "\(key) : \(value) \n"
                print(strExif)
            }
            
            return strExif
        }
        return nil
    }
    
   
    
    func presentingOverlay(_ present: Bool) {
        overlayView.isHidden = !present
        if present {
            view.backgroundColor = .gray
            view.bringSubviewToFront(overlayView)
            overlayView.alpha = 1
        }
        else {
            
            view.backgroundColor = .white
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        presentingOverlay(false)
    }
   
    @IBAction func infoButtonClicked(_ sender: Any) {
        
        let dict = imageView.image?.getExifData()
        if let dic = dict {
            let info = convertToString(dic) ?? "nil"
           
            let textView = overlayView.subviews[0].subviews[0] as? UITextView
            textView?.text = info
      
            presentingOverlay(true)
    }
    }
}
     

extension ViewController: ProjectImageDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            imageView.image = image
            messageLabel.isHidden = true
        }
    }
   
}

extension ViewController: ImagePickerDelegate {
    func didPick (image: UIImage?) {
        if let image = image {
            imageView.image = image
            messageLabel.isHidden = true
        }
    }
}

//code to open file
/*
 let dialog = NSOpenPanel();

 dialog.title                   = "Choose an image | Our Code World";
 dialog.showsResizeIndicator    = true;
 dialog.showsHiddenFiles        = false;
 dialog.allowsMultipleSelection = false;
 dialog.canChooseDirectories = false;
 dialog.allowedFileTypes        = ["png", "jpg", "jpeg", "gif"];

 if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
     let result = dialog.url // Pathname of the file

     if (result != nil) {
         let path: String = result!.path
         
         // path contains the file path e.g
         // /Users/ourcodeworld/Desktop/tiger.jpeg
     }
     
 } else {
     // User clicked on "Cancel"
     return
 }
 */

// code for uiimagepickercontroller to open a photo

/*
 public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
 
 class ViewController: UIViewController {

     @IBOutlet var imageView: UIImageView!

     var imagePicker: ImagePicker!

     override func viewDidLoad() {
         super.viewDidLoad()

         self.imagePicker = ImagePicker(presentationController: self, delegate: self)
     }

     @IBAction func showImagePicker(_ sender: UIButton) {
         self.imagePicker.present(from: sender)
     }
 }

 extension ViewController: ImagePickerDelegate {

     func didSelect(image: UIImage?) {
         self.imageView.image = image
     }
 }
 
 */


// code for saving image to phto album

/*UIImageWriteToSavedPhotosAlbum(yourImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

@objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
    if let error = error {
        // we got back an error!
        let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    } else {
        let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}*/

//code to show asset information EXIF

/*
 let library = ALAssetsLibrary() /
let url: NSURL = (info as NSDictionary!).objectForKey(UIImagePickerControllerReferenceURL) as! NSURL
      
let resultBlockHandler = { (asset: ALAsset!) -> Void in
       if asset == nil { // photo stream, hides metadata
                         // need specific processing here
     } else {                    // photo roll asset != nil
          if asset.valueForProperty(ALAssetPropertyLocation) != nil {
              let location: CLLocation = asset.valueForProperty(ALAssetPropertyLocation) as! CLLocation
               let theDate = asset.valueForProperty(ALAssetPropertyDate) as! NSDate
            }
         }         // end of resultBlockHandler
      library.assetForURL(url, resultBlock: resultBlockHandler, failureBlock: nil )
   }
*/

/*
 let fileURL = theURLToTheImageFile
 if let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil) {
     let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil)
     if let dict = imageProperties as? [String: Any] {
         print(dict)
     }
 }
 */
/*
 func imagePickerController(_
       picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

       let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       image = Image(uiImage: uiImage)

       if let asset: PHAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
           print("Asset: \(asset)")
           print("Creation Data \(String(describing: asset.creationDate))")
           print("Location: \(String(describing: asset.location))")
       } else {
           print("Asset: nil")
       }
       isShown = false
   }
 */
/*
 func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
   guard !results.isEmpty else {
     return
   }
   let imageResult = results[0]

   if let assetId = imageResult.assetIdentifier {
     let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)

     print(assetResults.firstObject?.creationDate ?? "No date")
     print(assetResults.firstObject?.location?.coordinate ?? "No location")
   }
 }
 */

//to flip image horizontally

//var image = UIImage(cgImage: img.cgImage!, scale: 1.0, orientation: .downMirrored)
//YourUIImage.transform = CGAffineTransformMakeScale(-1, 1)

//to flip image vertically

/*
 yourImageView.image =[UIImage imageNamed:@"whatever.png"];
yourImageView.transform = CGAffineTransform(scaleX: -1, y: 1); //Flipped
*/
//func withHorizontallyFlippedOrientation() -> UIImage
//func imageFlippedForRightToLeftLayoutDirection() -> UIImage
