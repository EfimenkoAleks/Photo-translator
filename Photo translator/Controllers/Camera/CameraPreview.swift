//
//  CameraPreview.swift
//  Photo translator
//
//  Created by Aleksandr on 23.10.2024.
//

import SwiftUI
import AVFoundation // To access the camera related swift classes and methods

struct CameraPreview: UIViewRepresentable { // for attaching AVCaptureVideoPreviewLayer to SwiftUI View
 
  let session: AVCaptureSession
    var onTap: (CGPoint) -> Void // handle the user's tap actions
 
  // creates and configures a UIKit-based video preview view
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspect
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        // Add a tap gesture recognizer to the view
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func makeCoordinator() -> Coordinatorr {
        Coordinatorr(self)
    }
 
  // updates the video preview view
  public func updateUIView(_ uiView: VideoPreviewView, context: Context) { }
 
  // UIKit-based view for displaying the camera preview
  class VideoPreviewView: UIView {

     // specifies the layer class used
     override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
     }
  
     // retrieves the AVCaptureVideoPreviewLayer for configuration
     var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
     }
  }
}


class Coordinatorr: NSObject {
  
  var parent: CameraPreview
  
  init(_ parent: CameraPreview) {
     self.parent = parent
  }
  
  @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
     let location = sender.location(in: sender.view)
     parent.onTap(location)
  }
}
