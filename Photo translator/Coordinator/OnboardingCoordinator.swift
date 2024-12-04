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
        case .home(let number):
            var homeDetailCoordinator: HomeDetailCoordinatorProtocol = HomeDetailCoordinator(hasSeenOnboarding: hasSeenOnboarding)
            homeDetailCoordinator.transitionController = transitionController
            homeDetailCoordinator.start(photoNumber: number)
            childCoordinators.append(homeDetailCoordinator)
            homeDetailCoordinator.childCoordinators = childCoordinators
        case .camera:
           break
        case .translate:
           break
        default:
            break
        }
    }
}
