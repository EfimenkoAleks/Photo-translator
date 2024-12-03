//
//  HomeDetailInterfaces.swift
//  Photo translator
//
//  Created by Aleksandr on 03.12.2024.
//

import SwiftUI

protocol HomeDetailModuleCoordinator: AnyObject {
    func eventOccurred(with type: HomeDetailCoordinatorEvent)
}

protocol HomeDetailModuleViewModel: AnyObject {
    var translateImage: UIImage? {get set}
    func transitionTo(_ event: HomeDetailCoordinatorEvent)
}
