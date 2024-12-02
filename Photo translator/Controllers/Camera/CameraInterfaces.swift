//
//  CameraInterfaces.swift
//  Photo translator
//
//  Created by Aleksandr on 28.11.2024.
//

import UIKit
import AVFoundation

protocol CameraModuleCoordinator: AnyObject {
    func eventOccurred(with type: SecondTabEvent)
}

protocol CameraModuleViewModel: AnyObject {
    var capturedImage: UIImage? {get set}
    var session: AVCaptureSession {get set}
    var showAlertError: Bool {get set}
    var showSettingAlert: Bool {get set}
    var isFlashOn: Bool {get set}
    func startSession()
    func setFocus(point: CGPoint)
    func zoom(with factor: CGFloat)
}
