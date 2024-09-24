//
//  AplicationCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import SwiftUI
import Combine

enum NavDetailCoordinator {
    case home, camera, translate, main
}

class AplicationCoordinator: Coordinarot {
    
    var window: UIWindow
    var childCoordinator: [Coordinarot] = []
//    var hasDeenOnboarding = CurrentValueSubject<Bool, Never>(false)
    var navigateOnboarding = CurrentValueSubject<NavDetailCoordinator, Never>(.main)
    var subscriptions = Set<AnyCancellable>()
 //   private let coordinator: NavCoordinator<MapRouter> = .init(startingRoute: .map)
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigateOnboarding.sink { [weak self]  navigate in
            if let navigateOnboarding = self?.navigateOnboarding {
                switch navigate {
                case .main:
                    let mainCoordinator = MainCoordinator(hasSeenOnboarding: navigateOnboarding)
                    mainCoordinator.start()
                    self?.childCoordinator = [mainCoordinator]
                    self?.window.rootViewController = mainCoordinator.rootViewController
                    mainCoordinator.rootViewController
                    
                default:
                    let onboardingCoordinator = OnboardingCoordinator(hasSeenOnboarding: navigateOnboarding)
                    onboardingCoordinator.start()
                    self?.childCoordinator = [onboardingCoordinator]
                    self?.window.rootViewController = onboardingCoordinator.rootViewController
                }
            }
        }
        .store(in: &subscriptions)
        
//        navigateOnboarding.sink { [weak self]  navigate in
//            if navigate != .main, let hasDeenOnboarding = self?.hasDeenOnboarding {
//
//                let onboardingCoordinator = OnboardingCoordinator(hasSeenOnboarding: hasDeenOnboarding)
//                onboardingCoordinator.start()
//                self?.childCoordinator = [onboardingCoordinator]
//                self?.window.rootViewController = onboardingCoordinator.rootViewController
//
//
//
//     //           self?.createCoordinator(flow: .homeDetail)
//
//            } else if let navigateOnboarding = self?.navigateOnboarding {
//                let mainCoordinator = MainCoordinator(hasSeenOnboarding: navigateOnboarding)
//                mainCoordinator.start()
//                self?.childCoordinator = [mainCoordinator]
//                self?.window.rootViewController = mainCoordinator.rootViewController
//            }
//        }
//        .store(in: &subscriptions)
        
//        hasDeenOnboarding.sink { [weak self] hasSeen in
//            if hasSeen, let hasDeenOnboarding = self?.hasDeenOnboarding {
//
//                let onboardingCoordinator = OnboardingCoordinator(hasSeenOnboarding: hasDeenOnboarding)
//                onboardingCoordinator.start()
//                self?.childCoordinator = [onboardingCoordinator]
//                self?.window.rootViewController = onboardingCoordinator.rootViewController
//
//
//
//     //           self?.createCoordinator(flow: .homeDetail)
//
//            } else if let navigateOnboarding = self?.navigateOnboarding {
//                let mainCoordinator = MainCoordinator(hasSeenOnboarding: navigateOnboarding)
//                mainCoordinator.start()
//                self?.childCoordinator = [mainCoordinator]
//                self?.window.rootViewController = mainCoordinator.rootViewController
//            }
//        }
//        .store(in: &subscriptions)
    }
    
//    func createCoordinator(flow: NavDetailCoordinator) {
//        switch flow {
//        case .homeDetail:
//            let coordinator: NavCoordinator<HomeDetailCoordinator> = .init(startingRoute: .home)
//            window.rootViewController = coordinator.navigationController
//            coordinator.start()
//            childCoordinator = [coordinator]
//        }
//    }
}

