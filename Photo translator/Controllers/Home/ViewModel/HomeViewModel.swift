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
    private var imageService: DP_ImageService
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: FirstTabCoordinatorInterface
    
    init(coordinator: FirstTabCoordinatorInterface, imageService: DP_ImageService = DIContainer.default.imageService) {
        
        photos = []
        pinedPhotos = []
        self.coordinator = coordinator
        self.imageService = imageService
            
        bindImage()
    }
    
    func transsitionTo(_ transition: FirstTabEvent)  {
        coordinator.eventOccurred(with: transition)
    }
    
    private func bindImage() {
        imageService.photosPublisher.sink { [weak self] in
            self?.photos = $0
        }
        .store(in: &cancellables)
        
        imageService.pinedPhotosPublisher.sink { [weak self] in
            self?.pinedPhotos = $0
        }
        .store(in: &cancellables)
    }
    
    func fetchPhotos() {
        imageService.dp_getPhotos()
        imageService.dp_getPinedPhotos()
    }
    
    func removePhoto(index: Int, pined: Int) {
        let arr = pined == 0 ? photos : pinedPhotos
        let url = arr[index].image
        imageService.dp_deletePhoto(url: url)
    }
    
    func showPhoto(number: Int?) {
        guard let numberPhoto = number else { return }
        coordinator.eventOccurred(with: .detail(numberPhoto))
    }
    
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
