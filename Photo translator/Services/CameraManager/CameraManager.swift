//
//  CameraManager.swift
//  Photo translator
//
//  Created by Aleksandr on 10.10.2024.
//

import UIKit
import AVFoundation

class CameraManager: NSObject {
    // 1.
    private var captureSession: AVCaptureSession?
        // 2.
        private var deviceInput: AVCaptureDeviceInput?
        // 3.
        private var videoOutput: AVCaptureVideoDataOutput?
        // 4.
        private let systemPreferredCamera = AVCaptureDevice.default(for: .video)
        // 5.
        private var sessionQueue = DispatchQueue(label: "video.preview.session")
    
    var stillImageOutput: AVCapturePhotoOutput!

    private var isAuthorized: Bool {
            get async {
                let status = AVCaptureDevice.authorizationStatus(for: .video)

                // Determine if the user previously authorized camera access.
                var isAuthorized = status == .authorized

                // If the system hasn't determined the user's authorization status,
                // explicitly prompt them for approval.
                if status == .notDetermined {
                    isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
                }

                return isAuthorized
            }
        }

    private var addToPreviewStream: ((CGImage) -> Void)?

        lazy var previewStream: AsyncStream<CGImage> = {
            AsyncStream { continuation in
                addToPreviewStream = { cgImage in
                    continuation.yield(cgImage)
                }
            }
        }()

    // 1.
       override init() {
           super.init()

//           Task {
//             //  await configureSession()
//               await startSession()
//           }
       }
    
    func startSession() {
                   Task {
                       await configureSession()
                       await startRunning()
                   }
    }

       // 2.
       private func configureSession() async {
           // 1.
            guard await isAuthorized,
                  let systemPreferredCamera,
                  let deviceInput = try? AVCaptureDeviceInput(device: systemPreferredCamera)
            else { return }

           captureSession = AVCaptureSession()
           guard let captureSession = captureSession else { return }

            // 2.
            captureSession.beginConfiguration()

            // 3.
            defer {
                self.captureSession?.commitConfiguration()
            }

            // 4.
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)

            // 5.
            guard captureSession.canAddInput(deviceInput) else {
                print("Unable to add device input to capture session.")
                return
            }

            // 6.
            guard captureSession.canAddOutput(videoOutput) else {
                print("Unable to add video output to capture session.")
                return
            }

            // 7.
            captureSession.addInput(deviceInput)
            captureSession.addOutput(videoOutput)
       }

       // 3.
    func startRunning() async {
           /// Checking authorization
           guard await isAuthorized else { return }
           /// Start the capture session flow of data
    
        captureSession?.startRunning()
       }

    func stopSesion() {
        captureSession?.stopRunning()
        captureSession = nil
    }

//    func dp_createPhoto(withLight: AVCaptureDevice.FlashMode) {
//        // Set photo settings
//        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        photoSettings.isHighResolutionPhotoEnabled = true
//        photoSettings.flashMode = withLight
//
//        stillImageOutput.isHighResolutionCaptureEnabled = true
//        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
//    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let currentFrame = sampleBuffer.cgImage else { return }
        addToPreviewStream?(currentFrame)
    }

}

//class CameraManager: NSObject {
//
//    var captureSession: AVCaptureSession?
//    var backFacingCamera: AVCaptureDevice?
//    var frontFacingCamera: AVCaptureDevice?
//    var currentDevice: AVCaptureDevice!
//    private let sessionQueue = DispatchQueue(label: "session.queue")
//
//    var stillImageOutput: AVCapturePhotoOutput!
//    var imageHanddler: Block<(UIImage)>?
//
//        private var addToPreviewStream: ((CGImage) -> Void)?
//
//            lazy var previewStream: AsyncStream<CGImage> = {
//                AsyncStream { continuation in
//                    addToPreviewStream = { cgImage in
//                        continuation.yield(cgImage)
//                    }
//                }
//            }()
//
//    func startSession() {
//        captureSession = AVCaptureSession()
//        guard let captureSession = captureSession else { return }
//        // Preset the session for taking photo in full resolution
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//
//        // Get the front and back-facing camera for taking photos
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
//
//        for device in deviceDiscoverySession.devices {
//            if device.position == .back {
//                backFacingCamera = device
//            } else if device.position == .front {
//                frontFacingCamera = device
//            }
//        }
//
//        currentDevice = backFacingCamera
//
//        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: currentDevice) else {
//            return
//        }
//
//        // Configure the session with the output for capturing still images
//        stillImageOutput = AVCapturePhotoOutput()
//
//        // Configure the session with the input and the output devices
//        captureSession.addInput(captureDeviceInput)
//        captureSession.addOutput(stillImageOutput)
//
//        sessionQueue.async {
//            captureSession.startRunning()
//        }
//
//    }
//
//    func dp_createPhoto(withLight: AVCaptureDevice.FlashMode) {
//        // Set photo settings
//        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
//        photoSettings.isHighResolutionPhotoEnabled = true
//        photoSettings.flashMode = withLight
//
//        stillImageOutput.isHighResolutionCaptureEnabled = true
//        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
//    }
//
//    func stopSesion() {
//        captureSession?.stopRunning()
//        captureSession = nil
//    }
//}
//
//extension CameraManager: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard error == nil else {
//            return
//        }
//
//        // Get the image from the photo buffer
//        guard let imageData = photo.fileDataRepresentation(),
//
//        let image = UIImage(data: imageData) else { return }
//
//        imageHanddler?(image)
//    }
//}
//
