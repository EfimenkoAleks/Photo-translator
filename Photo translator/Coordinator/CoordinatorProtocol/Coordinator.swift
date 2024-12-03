//
//  Coordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var transitionController: UINavigationController? {get set}
 //   func start()
}
