//
//  ProjectFileManager.swift
//  ImageEditor
//
//  Created by Namitha Pavithran on 26/06/2021.
//

import Foundation
import UIKit

extension FileManager {
   static func getFileUrlOf(_ image: UIImage) -> URL? {
        guard let imageData = image.pngData() else {
            return nil
           }
           
           let fileManager = FileManager.default

           do {
               let fileURL = fileManager.temporaryDirectory.appendingPathComponent("temp.png") // 3
               // image data is temporarily saved to fileURL
               try imageData.write(to: fileURL)
            guard fileURL.startAccessingSecurityScopedResource() else { return nil}
            do {
                       DispatchQueue.main.async {
                        fileURL.stopAccessingSecurityScopedResource()
                       }
                    }
            return fileURL
            
           }  catch {
                print("Error creating file")
            }
    return nil
    }
    
   static func removeFileURL() {
        let fileManager = FileManager.default
            
            let fileURL = fileManager.temporaryDirectory.appendingPathComponent("temp.png")
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error deleting file")
            }
        }
    
}

//if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) 

extension UIImage {

    func getExifData() -> CFDictionary? {
        var exifData: CFDictionary? = nil
        if let data = self.jpegData(compressionQuality: 1.0) {
            data.withUnsafeBytes {
                let bytes = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.count),
                    let source = CGImageSourceCreateWithData(cfData, nil) {
                    exifData = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)
                }
            }
        }
        return exifData
    }
}
