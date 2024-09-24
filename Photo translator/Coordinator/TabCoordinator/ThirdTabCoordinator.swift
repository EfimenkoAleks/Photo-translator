//
//  ThirdTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

class ThirdTabCoordinator: Coordinarot {
    
    var rootViewController: UINavigationController
    var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
        rootViewController = UINavigationController()
    }
    
    func start() {
        let vModel = TranslateViewModel()
        let vc = UIHostingController(rootView: ThirdTabView(viewModel: vModel, doneRequested: {}))
        rootViewController.setViewControllers([vc], animated: false)
    }
}
