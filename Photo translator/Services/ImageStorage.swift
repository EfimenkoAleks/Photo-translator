//
//  ImageStorage.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import SwiftUI

class ImageStorage: ObservableObject {
    
   static let shared: ImageStorage = ImageStorage()
    
    @Published private(set) var photos: [HomeModel] = []
    @Published private(set) var pinedPhotos: [HomeModel] = []
    
    private let storage: DP_FileManager
    private var preferens: DP_PreferencesProtocol
    private var screenNumber = 0
    
    private init(preferens: DP_PreferencesProtocol = DP_Preferences(), storage: DP_FileManager = DP_FileManager.shared) {
        self.preferens = preferens
        self.storage = storage
        photos = getMockData() //dp_getPhotos()
        pinedPhotos = getMockPinedData()
    }
 
    func dp_deletePhoto(url: URL) {
        guard let number = Int(url.lastPathComponent) else { return }
        
        let intArr = preferens.dp_getPhotoNumber()
        let intArrDelete = intArr.filter({$0 != number})
        preferens.dp_deletePhoto(arrInt: intArrDelete)
        DP_FileManager.shared.dp_removeFile(path: url.lastPathComponent)
    }
    
    func dp_saveNewPhoto(data: Data) -> URL? {
        var rezUrl: URL?
        let lastNumber = dp_getNumber()
        screenNumber = lastNumber.last ?? 0
        screenNumber += 1
        
        let photo = DP_FileManager.shared.dp_saveData(data, path: "\(screenNumber)")
        preferens.dp_saveNumberPhoto(number: screenNumber)
        switch photo {
        case .loaded(let url):
            rezUrl = url
        default:
            break
        }
        return rezUrl
    }
    
    func dp_getPhotos() -> [HomeModel] {
        let arrInt = dp_getNumber()
        
       let paths = arrInt.compactMap({DP_FileManager.shared.dp_getFileUrlFromPath("\($0)")})
        var models: [HomeModel] = paths.map { url -> HomeModel in
          var dateCreated = ""
            if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any],
                let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                dateCreated = Date.sm_convertDateToString(date: creationDate, formatter: "dd.MM.yy HH:mm")
                }
            return HomeModel(id: UUID(), title: "", time: dateCreated, image: url)
        }
        
        models = models.sorted(by: {$0.time > $1.time})
        return models
    }
    
    private func dp_getNumber() -> [Int] {
        preferens.dp_getPhotoNumber()
    }
    
    private func getMockData() -> [HomeModel] {
        let mok = [
            HomeModel(id: UUID(), title: "wish-i-knew", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew2", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew3", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew4", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew5", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew6", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew7", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew8", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew9", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew10", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!)
        ]
        return mok
    }
    
    private func getMockPinedData() -> [HomeModel] {
        let mok = [
            HomeModel(id: UUID(), title: "wish-i-knew", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
            HomeModel(id: UUID(), title: "wish-i-knew2", time: "February 17, 2019", image: URL(string: "https://youtu.be/EgpKu1tAVMY")!),
        ]
        return mok
    }
}
