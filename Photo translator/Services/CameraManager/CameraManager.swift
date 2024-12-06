//
//  CameraManager.swift
//  Photo translator
//
//  Created by Aleksandr on 10.10.2024.
//

import SwiftUI
import AVFoundation

protocol DP_CameraManager: AnyObject {
    var capturedImage: Data? {get set}
    var capturedImagePublished: Published<Data?> { get }
    var capturedImagePublisher: Published<Data?>.Publisher { get }
    
    var shouldShowAlertView: Bool {get set}
    var shouldShowAlertViewPublished: Published<Bool>  { get }
    var shouldShowAlertViewPublisher: Published<Bool>.Publisher  { get }
    
    var alertError: Alert? {get set}
    var flashMode: AVCaptureDevice.FlashMode {get set}
    
    func configureCaptureSession()
    func captureImage()
    func stopCapturing()
    func toggleTorch(tourchIsOn: Bool)
    func setFocusOnTap(devicePoint: CGPoint)
    func setZoomScale(factor: CGFloat)
}
