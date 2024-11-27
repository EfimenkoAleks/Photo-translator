//
//  HomeViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import SwiftUI
import UIKit
import Vision
import MLKitTranslate

final class HomeViewModel: FirstTabModuleViewModel, ObservableObject {
    
    @Published var photos: [HomeModel]
    @Published var pinedPhotos: [HomeModel]
  //  @Published var name: String?
    private var imageStorage: ImageStorage
    private var cancellables = Set<AnyCancellable>()
//    var doneRequested: ((FirstTabEvent) -> Void)?
     private var coordinator: FirstTabCoordinator
 //   private var photoManager: DP_PhotoManager
    
    init(coordinator: FirstTabCoordinator, storage: ImageStorage = ImageStorage.shared) {
        
        self.coordinator = coordinator
        self.imageStorage = storage
            
        photos = imageStorage.photos
        pinedPhotos = imageStorage.pinedPhotos
            
        bindImage()
        fetchPinedPhotos()
        }
    
    func transsitionTo(_ transition: FirstTabEvent)  {
        coordinator.eventOccurred(with: transition)
    }
    
    func bindImage() {
        imageStorage.$photos.sink { [weak self] in
            self?.photos = $0
        }
        .store(in: &cancellables)
    }
    
    func fetchPhotos() {
        imageStorage.dp_getPhotos()
    }
    
    func fetchPinedPhotos() {
        imageStorage.$pinedPhotos.sink { [weak self] in
            self?.pinedPhotos = $0
        }
        .store(in: &cancellables)
    }
    
    func removePhoto(index: Int, pined: Int) {
        let arr = pined == 0 ? photos : pinedPhotos
        let url = arr[index].image
        imageStorage.dp_deletePhoto(url: url)
    }
    
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
