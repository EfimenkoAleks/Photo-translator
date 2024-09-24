//
//  HomeViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import SwiftUI
import UIKit
import AVFoundation
import Vision
import MLKitTranslate


final class HomeViewModel: ObservableObject {
    
    @Published var photos: [HomeModel]
    @Published var pinedPhotos: [HomeModel]
  //  @Published var name: String?
    var storage: ImageStorage
    private var cancellables = Set<AnyCancellable>()
 //   private var photoManager: DP_PhotoManager
    private var ligth: AVCaptureDevice.FlashMode = .off
    
    init(storage: ImageStorage = ImageStorage.shared) {
        
        self.storage = storage
            
        photos = storage.photos
        pinedPhotos = storage.pinedPhotos
            
        fetchPhotos()
        fetchPinedPhotos()
        }
    
    func fetchPhotos() {
        storage.$photos.sink { [weak self] in
            self?.photos = $0
        }
        .store(in: &cancellables)
    }
    
    func fetchPinedPhotos() {
        storage.$pinedPhotos.sink { [weak self] in
            self?.pinedPhotos = $0
        }
        .store(in: &cancellables)
    }
    
    func convertImage(data: URL) -> UIImage {
        let photo: UIImage = UIImage(contentsOfFile: data.absoluteString) ?? UIImage()
        return photo
    }
    
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
