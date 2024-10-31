//
//  CameraManager.swift
//  Photo translator
//
//  Created by Aleksandr on 10.10.2024.
//

import UIKit
import AVFoundation
import SwiftUI
// this class conforms to ObservableObject to make it easier to use with future Combine code
class CameraManager: ObservableObject {

 // Represents the camera's status
 enum Status {
    case configured
    case unconfigured
    case unauthorized
    case failed
 }
 
 // Observes changes in the camera's status
 @Published var status = Status.unconfigured
    
    @Published var capturedImage: UIImage? = nil

    private var cameraDelegate: CameraDelegate?
    var alertError: Alert?
    @Published var shouldShowAlertView: Bool = false
    var flashMode: AVCaptureDevice.FlashMode = .off
    var position: AVCaptureDevice.Position = .back // to store current position
 
 // AVCaptureSession manages the camera settings and data flow between capture inputs and outputs.
 // It can connect one or more inputs to one or more outputs
 let session = AVCaptureSession()

 // AVCapturePhotoOutput for capturing photos
 let photoOutput = AVCapturePhotoOutput()

 // AVCaptureDeviceInput for handling video input from the camera
 // Basically provides a bridge from the device to the AVCaptureSession
 var videoDeviceInput: AVCaptureDeviceInput?

 // Serial queue to ensure thread safety when working with the camera
 private let sessionQueue = DispatchQueue(label: "com.demo.sessionQueue")
 
 // Method to configure the camera capture session
 func configureCaptureSession() {
    sessionQueue.async { [weak self] in
      guard let self, self.status == .unconfigured else { return }
   
      // Begin session configuration
      self.session.beginConfiguration()

      // Set session preset for high-quality photo capture
      self.session.sessionPreset = .photo
   
      // Add video input from the device's camera
      self.setupVideoInput()
   
      // Add the photo output configuration
      self.setupPhotoOutput()
   
      // Commit session configuration
      self.session.commitConfiguration()

      // Start capturing if everything is configured correctly
      self.startCapturing()
   }
 }
 
 // Method to set up video input from the camera
 private func setupVideoInput() {
   do {
      // Get the default wide-angle camera for video capture
      // AVCaptureDevice is a representation of the hardware device to use
      let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)

      guard let camera else {
         print("CameraManager: Video device is unavailable.")
         status = .unconfigured
         session.commitConfiguration()
         return
      }
   
      // Create an AVCaptureDeviceInput from the camera
      let videoInput = try AVCaptureDeviceInput(device: camera)
   
      // Add video input to the session if possible
      if session.canAddInput(videoInput) {
         session.addInput(videoInput)
         videoDeviceInput = videoInput
         status = .configured
      } else {
         print("CameraManager: Couldn't add video device input to the session.")
         status = .unconfigured
         session.commitConfiguration()
         return
      }
   } catch {
      print("CameraManager: Couldn't create video device input: \(error)")
      status = .failed
      session.commitConfiguration()
      return
   }
 }
 
 // Method to configure the photo output settings
 private func setupPhotoOutput() {
   if session.canAddOutput(photoOutput) {
      // Add the photo output to the session
      session.addOutput(photoOutput)

      // Configure photo output settings
      photoOutput.isHighResolutionCaptureEnabled = true
      photoOutput.maxPhotoQualityPrioritization = .quality // work for ios 15.6 and the older versions
      //photoOutput.maxPhotoDimensions = .init(width: 4032, height: 3024) // for ios 16.0*

      // Update the status to indicate successful configuration
      status = .configured
   } else {
      print("CameraManager: Could not add photo output to the session")
      // Set an error status and return
      status = .failed
      session.commitConfiguration()
      return
   }
 }
 
 // Method to start capturing
 private func startCapturing() {
   if status == .configured {
      // Start running the capture session
      self.session.startRunning()
   } else if status == .unconfigured || status == .unauthorized {
      DispatchQueue.main.async {
        // Handle errors related to unconfigured or unauthorized states
          self.alertError = Alert(title: Text("Camera Error"), primaryButton: .default(Text("ok")), secondaryButton: .cancel(Text("Cancel")))
          
          
//          Alert(title: "Camera Error", message: "Camera configuration failed. Either your device camera is not available or its missing permissions", primaryButtonTitle: "ok", secondaryButtonTitle: nil, primaryAction: nil, secondaryAction: nil)
        self.shouldShowAlertView = true
      }
   }
 }
    
    func captureImage() {
       sessionQueue.async { [weak self] in
          guard let self else { return }
      
          // Configure photo capture settings
          var photoSettings = AVCapturePhotoSettings()
      
          // Capture HEIC photos when supported
           if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
             photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
          }
      
          // Sets the flash mode for the capture
          if self.videoDeviceInput!.device.isFlashAvailable {
             photoSettings.flashMode = self.flashMode
          }
      
          photoSettings.isHighResolutionPhotoEnabled = true
      
          // Specify photo quality and preview format
          if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
             photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
          }

          photoSettings.photoQualityPrioritization = .quality
      
           if let videoConnection = self.photoOutput.connection(with: .video), videoConnection.isVideoOrientationSupported {
             videoConnection.videoOrientation = .portrait
          }
      
           self.cameraDelegate = CameraDelegate { [weak self] image in
             self?.capturedImage = image
          }
      
           if let cameraDelegate = self.cameraDelegate {
             // Capture the photo with delegate
             self.photoOutput.capturePhoto(with: photoSettings, delegate: cameraDelegate)
          }
       }
    }

 // Method to stop capturing
 func stopCapturing() {
   // Ensure thread safety using `sessionQueue`.
   sessionQueue.async { [weak self] in
      guard let self else { return }

      // Check if the capture session is currently running.
      if self.session.isRunning {
         // stops the capture session and any associated device inputs.
         self.session.stopRunning()
      }
   }
 }
    
    func toggleTorch(tourchIsOn: Bool) {
       // Access the default video capture device.
       guard let device = AVCaptureDevice.default(for: .video) else { return }
          // Check if the device has a torch (flashlight).
          if device.hasTorch {
            do {
                // Lock the device configuration for changes.
                try device.lockForConfiguration()

                // Set the flash mode based on the torchIsOn parameter.
                flashMode = tourchIsOn ? .on : .off

                // If torchIsOn is true, turn the torch on at full intensity.
                if tourchIsOn {
                   try device.setTorchModeOn(level: 1.0)
                } else {
                   // If torchIsOn is false, turn the torch off.
                   device.torchMode = .off
                }
                // Unlock the device configuration.
                device.unlockForConfiguration()
            } catch {
            // Handle any errors during configuration changes.
            print("Failed to set torch mode: \(error).")
          }
       } else {
          print("Torch not available for this device.")
       }
    }
    
    func setFocusOnTap(devicePoint: CGPoint) {
       guard let cameraDevice = self.videoDeviceInput?.device else { return }
       do {
          try cameraDevice.lockForConfiguration()

          // Check if auto-focus is supported and set the focus mode accordingly.
          if cameraDevice.isFocusModeSupported(.autoFocus) {
             cameraDevice.focusMode = .autoFocus
             cameraDevice.focusPointOfInterest = devicePoint
          }

          // Set the exposure point and mode for auto-exposure.
          cameraDevice.exposurePointOfInterest = devicePoint
          cameraDevice.exposureMode = .autoExpose

          // Enable monitoring for changes in the subject area.
          cameraDevice.isSubjectAreaChangeMonitoringEnabled = true

          cameraDevice.unlockForConfiguration()
       } catch {
          print("Failed to configure focus: \(error)")
       }
    }
    
    func setZoomScale(factor: CGFloat){
      // Ensure we have a valid video device input.
      guard let device = self.videoDeviceInput?.device else { return }
      do {
        try device.lockForConfiguration()

        // Ensure we stay within a valid zoom range
        device.videoZoomFactor = max(device.minAvailableVideoZoomFactor, max(factor, device.minAvailableVideoZoomFactor))

        device.unlockForConfiguration()
      } catch {
        print(error.localizedDescription)
      }
    }
}
