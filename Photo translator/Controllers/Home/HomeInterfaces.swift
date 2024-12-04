//
//  HomeInterfaces.swift
//  Photo translator
//
//  Created by Aleksandr on 26.11.2024.
//

import Foundation

protocol FirstTabModuleCoordinator: AnyObject {
    func eventOccurred(with type: FirstTabEvent)
}

protocol FirstTabModuleViewModel: AnyObject {
    var photos: [HomeModel] {get set}
    var pinedPhotos: [HomeModel] {get set}
    func transsitionTo(_ transition: FirstTabEvent)
    func fetchPhotos()
}
