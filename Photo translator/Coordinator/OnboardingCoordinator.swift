//
//  OnboardingCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

final class OnboardingCoordinator: Coordinator {
    var transitionController: UINavigationController?
   
    var childCoordinators: [Coordinator] = []
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
        transitionController = UINavigationController()
    }
    
    func start() {
        switch hasSeenOnboarding.value {
        case .home:
            var firstCoordinator: HomeDetailCoordinatorProtocol = HomeDetailCoordinator(hasSeenOnboarding: hasSeenOnboarding)
            firstCoordinator.transitionController = transitionController
            firstCoordinator.start(photoNumber: 1)
            self.childCoordinators.append(firstCoordinator)
            firstCoordinator.childCoordinators = childCoordinators
//            firstCoordinator.handlerBback = { [weak self] in
//                self?.childCoordinators = []
//                self?.transitionController = nil
//                self?.hasSeenOnboarding.send(.main)
//            }
        case .camera:
           break
        case .translate:
           break
        default:
            break
        }
    }
}
