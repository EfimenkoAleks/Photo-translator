//
//  CameraViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import SwiftUI

enum CameraEvent {
    case ligth, live, createPhoto, refresh, lastPhoto
}

final class CameraViewModel: ObservableObject {
    
    @Published var photo: UIImage
    @Published var stream: UIImage
    var storage: ImageStorage
    var eventHendler: Block<(SecondTabEvent)>?
    
    init(storage: ImageStorage = ImageStorage.shared) {
        
        self.storage = storage
            
        photo = UIImage(named: "girl")! //storage.photo
        stream = UIImage(named: "girl")!
       
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
        print("ligth")
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
