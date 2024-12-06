//
//  HomeViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import SwiftUI

final class HomeViewModel: FirstTabModuleViewModel, ObservableObject {
    
    @Published var photos: [HomeModel]
    @Published var pinedPhotos: [HomeModel]
    private var imageStorage: ImageStorage
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: FirstTabCoordinatorInterface
    
    init(coordinator: FirstTabCoordinatorInterface, storage: ImageStorage = ImageStorage.shared) {
        
        photos = []
        pinedPhotos = []
        self.coordinator = coordinator
        self.imageStorage = storage
            
        bindImage()
    }
    
    func transsitionTo(_ transition: FirstTabEvent)  {
        coordinator.eventOccurred(with: transition)
    }
    
    private func bindImage() {
        imageStorage.$photos.sink { [weak self] in
            self?.photos = $0
        }
        .store(in: &cancellables)
        
        imageStorage.$pinedPhotos.sink { [weak self] in
            self?.pinedPhotos = $0
        }
        .store(in: &cancellables)
    }
    
    func fetchPhotos() {
        imageStorage.dp_getPhotos()
        imageStorage.dp_getPinedPhotos()
    }
    
    func removePhoto(index: Int, pined: Int) {
        let arr = pined == 0 ? photos : pinedPhotos
        let url = arr[index].image
        imageStorage.dp_deletePhoto(url: url)
    }
    
    func showPhoto(number: Int?) {
        guard let numberPhoto = number else { return }
        coordinator.eventOccurred(with: .detail(numberPhoto))
    }
    
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
