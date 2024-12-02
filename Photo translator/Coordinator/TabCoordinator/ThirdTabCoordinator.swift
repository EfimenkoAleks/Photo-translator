//
//  ThirdTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

enum ThirdTabEvent {
    case lastPhoto, home, removeChild
}

final class ThirdTabCoordinator: Coordinarot {
    
    weak var transitionController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
    
    func start() {
        let vModel = TranslateViewModel(coordinator: self)
        let vc = UIHostingController(rootView: ThirdTabView(viewModel: vModel))
        transitionController?.setViewControllers([vc], animated: false)
    }
}

extension ThirdTabCoordinator: TranslateModuleCoordinator {
    func eventOccurred(with type: ThirdTabEvent) {
    }
}
