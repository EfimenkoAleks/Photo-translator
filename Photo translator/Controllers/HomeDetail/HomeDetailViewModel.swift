//
//  HomeDetailViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import UIKit

final class HomeDetailViewModel: ObservableObject, HomeDetailModuleViewModel {
    
    @Published var translateImage: UIImage?
    private var imageStorage: ImageStorage
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: HomeDetailModuleCoordinator
    
    init(imageStorage: ImageStorage = ImageStorage.shared, photoNumber: Int, coordinator: HomeDetailModuleCoordinator) {
        
        self.imageStorage = imageStorage
        self.coordinator = coordinator
        
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
    
    func transitionTo(_ event: HomeDetailCoordinatorEvent) {
        coordinator.eventOccurred(with: event)
    }
    
    private func convertImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        imageStorage.convertImage(url: url) { image in
            completion(image)
        }
    }
}

