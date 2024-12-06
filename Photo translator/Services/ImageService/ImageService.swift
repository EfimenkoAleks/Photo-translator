//
//  ImageService.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import SwiftUI

protocol DP_ImageService: AnyObject {
    var photos: [HomeModel] {get}
    // (Published property wrapper)
    var photosPublished: Published<[HomeModel]> { get }
        // Publisher
    var photosPublisher: Published<[HomeModel]>.Publisher { get }
    
    var pinedPhotos: [HomeModel] {get}
    var pinedPhotosPublished: Published<[HomeModel]> { get }
    var pinedPhotosPublisher: Published<[HomeModel]>.Publisher { get }
    
    func dp_deletePhoto(url: URL)
    func dp_getPhotos()
    func dp_getPinedPhotos()
    func dp_getCountPhotos() -> [Int]
    func dp_getImageFromUrl(path: URL) -> UIImage?
    func dp_getPhotos(completion: @escaping ([HomeModel]) -> Void)
    func dp_saveNewPhoto(data: Data) -> URL?
    func dp_getLastPhoto(completion: @escaping (UIImage?) -> Void)
    func dp_convertImage(url: URL, completion: @escaping (UIImage?) -> Void)
    func dp_scaleAndOrient(image: UIImage) -> UIImage
}
