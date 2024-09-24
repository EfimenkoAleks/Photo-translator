//
//  SecondTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

class SecondTabCoordinator: Coordinarot {
    
    var rootViewController: UINavigationController
    var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
        rootViewController = UINavigationController()
    }
 
    func start() {
        let vModel = CameraViewModel()
        let first = SecondTabView(viewModel: vModel, doneRequested: { [weak self] in
            self?.hasSeenOnboarding.send(.camera)
        })
        let vc = UIHostingController(rootView: first)
        rootViewController.setViewControllers([vc], animated: false)
    }
}

