//
//  AplicationCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import SwiftUI
import Combine

enum NavDetailCoordinator {
    case home(Int), camera, translate, main
}

final class AplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var transitionController: UINavigationController?
    
    var window: UIWindow
    var selectedTab: DP_TabBarSelectedItem = .photo
    var navigateOnboarding = CurrentValueSubject<NavDetailCoordinator, Never>(.main)
    var subscriptions = Set<AnyCancellable>()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigateOnboarding.sink { [weak self]  navigate in
            guard let self = self else { return }
            switch navigate {
            case .main:
                // Start main coordinator
                let mainCoordinator = MainCoordinator(hasSeenOnboarding: self.navigateOnboarding, selectedTab: self.selectedTab)
                mainCoordinator.start()
                self.childCoordinators = [mainCoordinator]
                self.window.rootViewController = mainCoordinator.rootViewController
                mainCoordinator.typeHandler = { [weak self] type in
                    guard let self = self else { return }
                    self.selectedTab = type
                }
                
            default:
                // Start onboarding coordinator
                let onboardingCoordinator = OnboardingCoordinator(hasSeenOnboarding: self.navigateOnboarding)
                onboardingCoordinator.start()
                self.childCoordinators = [onboardingCoordinator]
                self.window.rootViewController = onboardingCoordinator.transitionController
            }
        }
        .store(in: &subscriptions)
    }
}
