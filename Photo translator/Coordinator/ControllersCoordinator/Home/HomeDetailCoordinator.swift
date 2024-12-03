//
//  HomeDetailCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine


enum HomeDetailCoordinatorEvent {
    case next
    case back
}

protocol HomeDetailCoordinatorProtocol: Coordinator, HomeDetailModuleCoordinator {
    var handlerBback: (() -> Void)? { get set }
    func eventOccurred(with type: HomeDetailCoordinatorEvent)
    func start(photoNumber: Int)
}

class HomeDetailCoordinator: HomeDetailCoordinatorProtocol {
    
    var childCoordinators: [Coordinator] = []
    weak var transitionController: UINavigationController?
    var handlerBback: (() -> Void)?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
 
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
 
    func start(photoNumber: Int) {
        let module = HomeDetailAssembly().createModule(coordinator: self, photoNumber: photoNumber)
        transitionController?.setViewControllers([module.view], animated: false)
    }
}

extension HomeDetailCoordinator {
    func eventOccurred(with type: HomeDetailCoordinatorEvent) {
        switch type {

        case .next:
            break

        case .back:
            hasSeenOnboarding.send(.main)
        }
    }
}
