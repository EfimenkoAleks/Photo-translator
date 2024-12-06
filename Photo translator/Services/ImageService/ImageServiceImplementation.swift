//
//  ImageServiceImplementation.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import SwiftUI
import Photos

final class ImageServiceImplementation: ObservableObject {
   
    @Published private(set) var photos: [HomeModel] = []
    @Published private(set) var pinedPhotos: [HomeModel] = []
    var photosPublished: Published<[HomeModel]> { _photos }
    var photosPublisher: Published<[HomeModel]>.Publisher { $photos }
    var pinedPhotosPublished: Published<[HomeModel]> { _pinedPhotos }
    var pinedPhotosPublisher: Published<[HomeModel]>.Publisher { $pinedPhotos }
    
    private let storage: DP_FileManager
    private var preferens: DP_PreferencesProtocol
    private var screenNumber = 0
    private let convertQueue = DispatchQueue(label: "convertQueue", qos: .background, attributes: .concurrent)
    
    init(preferens: DP_PreferencesProtocol = DP_Preferences(), storage: DP_FileManager) {
        self.preferens = preferens
        self.storage = storage
    }
}

extension ImageServiceImplementation : DP_ImageService {

    func dp_deletePhoto(url: URL) {
        guard let number = Int(url.lastPathComponent) else { return }
        
        let intArr = preferens.dp_getPhotoNumber()
        let intArrDelete = intArr.filter({$0 != number})
        preferens.dp_deletePhoto(arrInt: intArrDelete)
        storage.dp_removeFile(path: url.lastPathComponent)
    }
    
    func dp_getPhotos() {
        let arrInt = dp_getNumber()
        
       let paths = arrInt.compactMap({storage.dp_getFileUrlFromPath("\($0)")})
        var models: [HomeModel] = paths.map { url -> HomeModel in
          var dateCreated = ""
            if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any],
                let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                dateCreated = Date.sm_convertDateToString(date: creationDate, formatter: "dd.MM.yy HH:mm")
                }
            return HomeModel(id: UUID(), title: "", time: dateCreated, image: url)
        }
        
        models = models.sorted(by: {Int($0.image.lastPathComponent) ?? 0 > Int($1.image.lastPathComponent) ?? 1})
        photos = models
    }
    
    func dp_getPinedPhotos() {
        let arrInt = preferens.dp_getPinedPhotoNumber()
        
       let paths = arrInt.compactMap({storage.dp_getFileUrlFromPath("\($0)")})
        var models: [HomeModel] = paths.map { url -> HomeModel in
          var dateCreated = ""
            if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any],
                let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                dateCreated = Date.sm_convertDateToString(date: creationDate, formatter: "dd.MM.yy HH:mm")
                }
            return HomeModel(id: UUID(), title: "", time: dateCreated, image: url)
        }
        
        models = models.sorted(by: {Int($0.image.lastPathComponent) ?? 0 > Int($1.image.lastPathComponent) ?? 1})
        pinedPhotos = models
    }
    
    
    private func dp_getNumber() -> [Int] {
        preferens.dp_getPhotoNumber()
    }
 
    func dp_convertImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        convertQueue.async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else  {
                completion(UIImage())
                return
            }
            completion(image)
        }
    }
    
    func dp_getCountPhotos() -> [Int] {
        preferens.dp_getPhotoNumber()
    }
    
    func dp_getImageFromUrl(path: URL) -> UIImage? {
        do {
            let data = try Data(contentsOf: path)
             return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    func dp_getPhotos(completion: @escaping ([HomeModel]) -> Void) {
        let arrInt = preferens.dp_getPhotoNumber()
        
       let paths = arrInt.compactMap({storage.dp_getFileUrlFromPath("\($0)")})
        var models: [HomeModel] = paths.map { url -> HomeModel in
          var dateCreated = ""
            if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any],
                let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                dateCreated = Date.sm_convertDateToString(date: creationDate, formatter: "dd.MM.yy HH:mm:ss")
                }
            return HomeModel(id: UUID(), title: "", time: dateCreated, image: url)
        }
        
        models = models.sorted(by: {$0.time > $1.time})
     completion(models)
    }
    
    func dp_saveNewPhoto(data: Data) -> URL? {
        var rezUrl: URL?
        let lastNumber = dp_getNumber()
        screenNumber = lastNumber.last ?? 0
        screenNumber += 1
        
        let photo = storage.dp_saveData(data, path: "\(screenNumber)")
        preferens.dp_saveNumberPhoto(number: screenNumber)
        switch photo {
        case .loaded(let url):
            rezUrl = url
        default:
            break
        }
        return rezUrl
    }
    
    private func dp_fetchAssets(completionHandler: @escaping (PHFetchResult<PHAsset>?) -> Void) {
        var allPhotos: PHFetchResult<PHAsset>?
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                completionHandler(allPhotos)
            default:
                allPhotos = nil
                completionHandler(allPhotos)
            }
        }
    }
    
    func dp_getLastPhoto(completion: @escaping (UIImage?) -> Void) {
        var photos: [PHAsset] = []
        dp_fetchAssets { results in
            guard let results = results else { return }
            for i in 0..<results.count {
                let asset = results.object(at: i)
            //    let photo = SM_Photo(asset: asset, isSelected: false)
                photos.append(asset)
            }
            photos = photos.sorted(by: {$0.creationDate ?? Date() < $1.creationDate ?? Date()})
    //        completion(photos.last)
            let asset = photos.last
            completion(asset?.image)
        }
    }
    
    func dp_scaleAndOrient(image: UIImage) -> UIImage {

        // Set a default value for limiting image size.
        let maxResolution: CGFloat = 640

        guard let cgImage = image.cgImage else {
            print("UIImage has no CGImage backing it!")
            return image
        }

        // Compute parameters for transform.
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        var transform = CGAffineTransform.identity

        var bounds = CGRect(x: 0, y: 0, width: width, height: height)

        if width > maxResolution ||
            height > maxResolution {
            let ratio = width / height
            if width > height {
                bounds.size.width = maxResolution
                bounds.size.height = round(maxResolution / ratio)
            } else {
                bounds.size.width = round(maxResolution * ratio)
                bounds.size.height = maxResolution
            }
        }

        let scaleRatio = bounds.size.width / width
        let orientation = image.imageOrientation
        switch orientation {
        case .up:
            transform = .identity
        case .down:
            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
        case .left:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
        case .right:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
        case .upMirrored:
            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
        case .leftMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
        case .rightMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
        default:
            transform = .identity
        }

        return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
            let context = rendererContext.cgContext

            if orientation == .right || orientation == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            context.concatenate(transform)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
    }
}
