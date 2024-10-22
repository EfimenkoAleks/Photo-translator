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

enum CameraEvent {
    case ligth, live, createPhoto, refresh, lastPhoto
}

final class CameraViewModel: ObservableObject {
    
    @Published var currentFrame: CGImage?
    private var cameraManager: CameraManager
    
    @Published var photo: UIImage
    @Published var stream: UIImage
    
    private var urlPhoto: URL?
    private var currentLang: TranslateLanguage?
    private var originalLang: TranslateLanguage?
    var currentImage: UIImage?
    var storage: ImageStorage
    var eventHendler: Block<(SecondTabEvent)>?
    private var ligth: AVCaptureDevice.FlashMode = .off
    
    init(storage: ImageStorage = ImageStorage.shared) {
        
        self.storage = storage
            
        cameraManager = CameraManager()
        photo = UIImage(named: "girl")! //storage.photo
        stream = UIImage(named: "girl")!
       
        Task {
            await handleCameraPreviews()
        }
        }
    
    func dp_resetImage() {
  //      dp_restartCondition()
         cameraManager.startSession()
//        dp_addVideo(captureSession: cameraManager.captureSession)
    }
    
    func dp_stopSessino() {
        cameraManager.stopSesion()
    }
    
//    func dp_setStartLoadImage(newImage: UIImage) {
//        cameraManager.stopSesion()
//        self.currentImage = storage.dp_scaleAndOrient(image: newImage)
//        guard let currentImage = self.currentImage else { return }
//        self.dp_startRecognizedText(image: currentImage, isOriginalLang: true)
//
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.dp_setPreview()
//        }
//    }
    
//    func dp_tapCamera() {
//        dp_resetLanguage()
//        cameraManager.dp_createPhoto(withLight: ligth)
//        cameraManager.imageHanddler = { [weak self] newImage in
//            guard let self = self else { return }
//
//   //         self.dp_addLoader()
//            guard let data = newImage.jpegData(compressionQuality: 0.7) else { return }
//
//            self.urlPhoto = self.storage.dp_saveNewPhoto(data: data)
//
//            self.dp_setStartLoadImage(newImage: newImage)
//        }
//    }
//
//    func dp_setStartLoadImage(newImage: UIImage) {
//        self.dp_stopSessino()
//        self.currentImage = self.photoHelper.dp_scaleAndOrient(image: newImage)
//        guard let currentImage = self.currentImage else { return }
//        self.dp_startRecognizedText(image: currentImage, isOriginalLang: true)
//
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.dp_setPreview()
//        }
//    }
    
    func dp_resetLanguage() {
        currentLang = DP_TranslateManager.shared.currentLanguages ?? TranslateLanguage.english
        originalLang = nil
    }
    
    func handleCameraPreviews() async {
           for await image in cameraManager.previewStream {
               Task { @MainActor in
                   currentFrame = image
               }
           }
       }
    
    func cameraEvents(event: CameraEvent) {
        switch event {
        case .createPhoto:
            createPhoto()
        case .ligth:
            ligthOf()
        case .live:
            liveCamera()
        case .refresh:
            refresh()
        case .lastPhoto:
            eventHendler?((.lastPhoto))
        }
    }
    
    func ligthOf() {
    ligth = ligth == .off ? .on : .off
    }
    
    func liveCamera() {
        print("camera")
    }
    
    func refresh() {
        print("refresh")
    }
    
    func createPhoto() {
        print("photo")
    }
}
