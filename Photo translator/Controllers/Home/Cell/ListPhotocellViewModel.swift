//
//  ListPhotocellViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 21.11.2024.
//

import UIKit
import SwiftUI

class ListPhotocellViewModel: ObservableObject {
 
    var imageStorage: ImageStorage

    @Published var capturedImage: UIImage
  
    init(imageStorage: ImageStorage = ImageStorage.shared) {
     
        self.imageStorage = imageStorage
        self.capturedImage = UIImage()
    }
   
    func convertImage(url: URL) {
        imageStorage.convertImage(url: url) { image in
            DispatchQueue.main.sync { [weak self] in
                self?.capturedImage = image ?? UIImage()
            }
        }
    }
}
