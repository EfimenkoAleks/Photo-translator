//
//  CameraViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import SwiftUI
import AVFoundation
import MLKitTranslate
import Photos

enum CameraEvent {
    case ligth, live, createPhoto, refresh, lastPhoto
}

class CameraViewModel: ObservableObject {
 
  // Reference to the CameraManager.
    @ObservedObject var cameraManager: CameraManager
    var imageStorage: ImageStorage
 
  // Published properties to trigger UI updates.
  @Published var isFlashOn = false
    @Published var capturedImage: UIImage?
  @Published var showAlertError = false
  @Published var showSettingAlert = false
  @Published var isPermissionGranted: Bool = false
    @Published private var flashMode: AVCaptureDevice.FlashMode = .off
 
  var alertError: Alert!

  // Reference to the AVCaptureSession.
  var session: AVCaptureSession = .init()

  // Cancellable storage for Combine subscribers.
  private var cancelables = Set<AnyCancellable>()
 
    init(cameraManager: CameraManager = CameraManager(), imageStorage: ImageStorage = ImageStorage.shared) {
    // Initialize the session with the cameraManager's session.
        self.cameraManager = cameraManager
        self.imageStorage = imageStorage
    session = cameraManager.session
  }

  deinit {
    // Deinitializer to stop capturing when the ViewModel is deallocated.
    cameraManager.stopCapturing()
  }
 
  // Setup Combine bindings for handling publisher's emit values
  func setupBindings() {
      cameraManager.$shouldShowAlertView.sink { [weak self] value in
      // Update alertError and showAlertError based on cameraManager's state.
      self?.alertError = self?.cameraManager.alertError
      self?.showAlertError = value
    }
    .store(in: &cancelables)
      
      cameraManager.$capturedImage.sink { [weak self] imageData in
          guard let data = imageData else { return }
         _ = self?.imageStorage.dp_saveNewPhoto(data: data)
          DispatchQueue.main.async {
       
              guard let image = UIImage(data: data) else { return }
                        self?.capturedImage = image
          }
         }.store(in: &cancelables)
  }
    
    func startSession() {
        setupBindings()
        checkForDevicePermission()
    }
    
    // Call when the capture button tap
    func captureImage() {
//       requestGalleryPermission()
   //    let permission = checkGalleryPermissionStatus()
   //    if permission.rawValue != 2 {
         cameraManager.captureImage()
  //     }
    }

    // Ask for the permission for photo library access
//    func requestGalleryPermission() {
//       PHPhotoLibrary.requestAuthorization { status in
//         switch status {
//         case .authorized:
//            break
//         case .denied:
//            self.showSettingAlert = true
//         default:
//            break
//         }
//       }
//    }
     
//    func checkGalleryPermissionStatus() -> PHAuthorizationStatus {
//       return PHPhotoLibrary.authorizationStatus()
//    }
 
  // Check for camera device permission.
  func checkForDevicePermission() {
    let videoStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    if videoStatus == .authorized {
       // If Permission granted, configure the camera.
       isPermissionGranted = true
       configureCamera()
    } else if videoStatus == .notDetermined {
       // In case the user has not been asked to grant access we request permission
       AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { _ in })
    } else if videoStatus == .denied {
       // If Permission denied, show a setting alert.
       isPermissionGranted = false
       showSettingAlert = true
    }
  }
    
    
    func switchFlash() {
       isFlashOn.toggle()
       cameraManager.toggleTorch(tourchIsOn: isFlashOn)
    }
 
  // Configure the camera through the CameraManager to show a live camera preview.
  func configureCamera() {
     cameraManager.configureCaptureSession()
  }
    
    func setFocus(point: CGPoint) {
       // Delegate focus configuration to the CameraManager.
       cameraManager.setFocusOnTap(devicePoint: point)
    }
    
    func zoom(with factor: CGFloat) {
        cameraManager.setZoomScale(factor: factor)
    }
    
    
}
    
//    func cameraEvents(event: CameraEvent) {
//        switch event {
//        case .createPhoto:
//            createPhoto()
//        case .ligth:
//            ligthOf()
//        case .live:
//            liveCamera()
//        case .refresh:
//            refresh()
//        case .lastPhoto:
//            eventHendler?((.lastPhoto))
//        }
//    }
//
//    func ligthOf() {
//    ligth = ligth == .off ? .on : .off
//    }
//
//    func liveCamera() {
//        print("camera")
//    }
//
//    func refresh() {
//        print("refresh")
//    }
//
//    func createPhoto() {
//        print("photo")
//    }
//}
