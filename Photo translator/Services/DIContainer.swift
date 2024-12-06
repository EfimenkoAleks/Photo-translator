//
//  DIContainer.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//


import Foundation

struct DIContainer {

    static var `default` = Self()
    
    lazy var textRecognizer: DP_TextRecognized = TextRecognizedImplementation()
    lazy var tranalateManager: DP_TranslateManager = TranslateManagerImplementation()
    lazy var cameraManager: CameraManagerImplementation = CameraManagerImplementation()
    lazy var photoManager: DP_PhotoManager = PhotoManagerImplementation()
    lazy var storage: DP_FileManager = FileManagerImplementation()
    lazy var imageService: DP_ImageService = ImageServiceImplementation(storage: storage)
}
