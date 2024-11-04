//
//  CameraDelegate.swift
//  Photo translator
//
//  Created by Aleksandr on 30.10.2024.
//

import UIKit
import AVFoundation
import Photos

class CameraDelegate: NSObject, AVCapturePhotoCaptureDelegate {
 
   private let completion: (Data?) -> Void
 
   init(completion: @escaping (Data?) -> Void) {
      self.completion = completion
   }
 
   func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      if let error {
         print("CameraManager: Error while capturing photo: \(error)")
         completion(nil)
         return
      }
  
      if let imageData = photo.fileDataRepresentation(){
 //        saveImageToGallery(capturedImage)
         completion(imageData)
      } else {
         print("CameraManager: Image not fetched.")
      }
   }
 
//   func saveImageToGallery(_ image: UIImage) {
//      PHPhotoLibrary.shared().performChanges {
//         PHAssetChangeRequest.creationRequestForAsset(from: image)
//      } completionHandler: { success, error in
//         if success {
//           print("Image saved to gallery.")
//         } else if let error {
//           print("Error saving image to gallery: \(error)")
//         }
//      }
//   }
}
