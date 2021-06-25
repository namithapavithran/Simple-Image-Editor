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
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Properties
    
    var imagePicker: ImagePickerController?
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePickerController(presentationController: self)
        imagePicker?.delegate = self
       
    }
// MARK: - IBActions

    @IBAction func openButtonClicked(_ sender: Any) {
        imagePicker?.implementPicker()
    }
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    @IBAction func cropButtonClicked(_ sender: Any) {
    }
    @IBAction func flipVerticalButtonClicked(_ sender: Any) {
    }
    @IBAction func flipHorizontalButtonClicked(_ sender: Any) {
    }
    @IBAction func infoButtonClicked(_ sender: Any) {
    }
}


extension ViewController: ProjectImageDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            imageView.image = image
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
