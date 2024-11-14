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


final class HomeViewModel: ObservableObject {
    
    @Published var photos: [HomeModel]
    @Published var pinedPhotos: [HomeModel]
  //  @Published var name: String?
    private var imageStorage: ImageStorage
    private var cancellables = Set<AnyCancellable>()
 //   private var photoManager: DP_PhotoManager
    
    init(storage: ImageStorage = ImageStorage.shared) {
        
        self.imageStorage = storage
            
        photos = imageStorage.photos
        pinedPhotos = imageStorage.pinedPhotos
            
        bindImage()
        fetchPinedPhotos()
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
    
    func convertImage(url: URL) -> UIImage {
        imageStorage.convertImage(url: url)
    }
    
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
