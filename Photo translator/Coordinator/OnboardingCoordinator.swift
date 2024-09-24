//
//  OnboardingCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

class OnboardingCoordinator: Coordinarot {
    
    var rootViewController: UINavigationController?
    var childCoordinators: [Coordinarot] = []
    var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
        rootViewController = UINavigationController()
    }
    
    func start() {
        switch hasSeenOnboarding.value {
        case .home:
            let firstCoordinator = HomeDetailCoordinator()
            firstCoordinator.rootViewController = rootViewController
            firstCoordinator.start()
            self.childCoordinators.append(firstCoordinator)
            firstCoordinator.childCoordinators = childCoordinators
            firstCoordinator.handlerBback = { [weak self] in
                self?.childCoordinators = []
                self?.rootViewController = nil
                self?.hasSeenOnboarding.send(.main)
            }
        case .camera:
            var detailCoordinator: HomeDetailNextCoordinatorProtocol = HomeDetailNextCoordinator()
            detailCoordinator.rootViewController = rootViewController
            childCoordinators.append(detailCoordinator)
            detailCoordinator.start()
            detailCoordinator.handlerBback = { [weak self] in
                self?.childCoordinators = []
                self?.rootViewController = nil
                self?.hasSeenOnboarding.send(.main)
            }
        case .translate:
            let firstCoordinator = HomeDetailCoordinator()
            firstCoordinator.rootViewController = rootViewController
            firstCoordinator.start()
            self.childCoordinators.append(firstCoordinator)
            firstCoordinator.childCoordinators = childCoordinators
            firstCoordinator.handlerBback = { [weak self] in
                self?.childCoordinators = []
                self?.rootViewController = nil
                self?.hasSeenOnboarding.send(.main)
            }
        default:
            break
        }
    }
}
