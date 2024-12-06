//
//  DP_PhotoManager.swift
//  Photo translator
//
//  Created by Aleksandr on 19.09.2024.
//

import UIKit
import AVFoundation

protocol DP_PhotoManager: AnyObject {
    var captureSession: AVCaptureSession? {get set}
    var backFacingCamera: AVCaptureDevice? {get set}
    var frontFacingCamera: AVCaptureDevice? {get set}
    var currentDevice: AVCaptureDevice! {get set}
    var stillImageOutput: AVCapturePhotoOutput! {get set}
    var imageHanddler: Block<(UIImage)>? {get set}
    
    func startSession()
    func dp_createPhoto(withLight: AVCaptureDevice.FlashMode)
    func stopSesion()
}
