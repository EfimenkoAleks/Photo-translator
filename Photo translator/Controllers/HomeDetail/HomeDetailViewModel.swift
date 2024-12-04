//
//  HomeDetailViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import UIKit

final class HomeDetailViewModel: ObservableObject, HomeDetailModuleViewModel {
    
    private struct settings {
        static var pinedIcon: String = "pin.fill"
        static var notPinedIcon: String = "pin"
    }
    
    @Published var translateImage: UIImage?
    @Published var pinedImage: String
    private var imageStorage: ImageStorage
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: HomeDetailModuleCoordinator
    private var numberPhoto: Int
    private var fileManager: DP_FileManager
    private var preferens: DP_PreferencesProtocol
    
    init(imageStorage: ImageStorage = ImageStorage.shared, photoNumber: Int, coordinator: HomeDetailModuleCoordinator, fileManager: DP_FileManager = DP_FileManager.shared, preferences: DP_PreferencesProtocol = DP_Preferences()) {
        
        self.preferens = preferences
        self.fileManager = fileManager
        self.numberPhoto = photoNumber
        self.imageStorage = imageStorage
        self.coordinator = coordinator
        self.pinedImage = settings.notPinedIcon
        self.pinedImage = self.pinStatus()
        
        translateImage = UIImage()
        fetchPhotos(number: photoNumber)
    }
    
    func fetchPhotos(number: Int) {
        imageStorage.dp_getPhotos()
        imageStorage.$photos.sink { [weak self] newValue in
            
            guard let self = self,
                  self.imageStorage.photos.count > 0 else { return }
            let photos = self.imageStorage.photos.map({$0.image})
            let numbers = photos.map({$0.lastPathComponent})
            let firstIndex = numbers.firstIndex(where: {$0 == String(number)})
            
            guard let index = firstIndex else { return }
            self.convertImage(url: photos[index]) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.translateImage = image
                }
            }
        }
        .store(in: &cancellables)
    }
    
    func sendPhoto() {
        transitionTo(.share(translateImage))
    }
    
    func transitionTo(_ event: HomeDetailCoordinatorEvent) {
        coordinator.eventOccurred(with: event)
    }
    
    private func convertImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        imageStorage.convertImage(url: url) { image in
            completion(image)
        }
    }
    
    func pinStatus() -> String {
        var pinStr = settings.notPinedIcon
        guard let path = fileManager.dp_getFileUrlFromPath(String(numberPhoto)) else { return pinStr }
        if dp_ifContainsPinedPhoto(url: path) {
            pinStr = settings.pinedIcon
        }
        return pinStr
    }
    
    func dp_didTapPin() {
        guard let path = fileManager.dp_getFileUrlFromPath(String(numberPhoto)) else { return }
        if dp_ifContainsPinedPhoto(url: path) {
            dp_deletePinedPhoto(url: path)
            pinedImage = settings.notPinedIcon
        } else {
            dp_savePinedPhoto(url: path)
            pinedImage = settings.pinedIcon
        }
    }
    
    func dp_ifContainsPinedPhoto(url: URL) -> Bool {
        guard let number = Int(url.lastPathComponent) else { return false }
       let intArr = preferens.dp_getPinedPhotoNumber()
        if intArr.contains(number) {
            return true
        } else {
            return false
        }
    }
    
    func dp_savePinedPhoto(url: URL) {
        guard let number = Int(url.lastPathComponent) else { return }
        preferens.dp_saveNumberPinedPhoto(number: number)
    }
    
    func dp_deletePinedPhoto(url: URL) {
        guard let number = Int(url.lastPathComponent) else { return }
        
        let intArr = preferens.dp_getPinedPhotoNumber()
        let intArrDelete = intArr.filter({$0 != number})
        preferens.dp_deletePinedPhoto(arrInt: intArrDelete)
    }
}

