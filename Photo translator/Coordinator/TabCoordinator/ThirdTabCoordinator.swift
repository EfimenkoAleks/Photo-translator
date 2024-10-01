//
//  ThirdTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

final class ThirdTabCoordinator: Coordinarot {
    
    var rootViewController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
    
    func start() {
        let vModel = TranslateViewModel()
        let vc = UIHostingController(rootView: ThirdTabView(viewModel: vModel))
        rootViewController?.setViewControllers([vc], animated: false)
    }
}
