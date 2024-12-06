//
//  ListPhotocellViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 21.11.2024.
//

import UIKit
import SwiftUI

class ListPhotocellViewModel: ObservableObject {
 
    var imageService: DP_ImageService

    @Published var capturedImage: UIImage
  
    init(imageService: DP_ImageService = DIContainer.default.imageService) {
     
        self.imageService = imageService
        self.capturedImage = UIImage()
    }
   
    func convertImage(url: URL) {
        imageService.dp_convertImage(url: url) { image in
            DispatchQueue.main.sync { [weak self] in
                self?.capturedImage = image ?? UIImage()
            }
        }
    }
}
