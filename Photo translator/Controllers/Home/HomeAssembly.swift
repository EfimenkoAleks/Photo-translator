//
//  HomeAssembly.swift
//  Photo translator
//
//  Created by Aleksandr on 26.11.2024.
//

import SwiftUI
import Combine

final class HomeAssembly {
    
    public struct HomeModule {
        let view: UIViewController
        let viewModel: FirstTabModuleViewModel
        let coordinator: FirstTabModuleCoordinator
    }
    
    // MARK: - Module setup -

    func createModule(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>, navController: UINavigationController) -> HomeModule {
        
        let coordinator = FirstTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
        coordinator.transitionController = navController
        let vModel = HomeViewModel(coordinator: coordinator)
        let first = FirstTabView(viewModel: vModel)
        let vc = UIHostingController(rootView: first)
        coordinator.transitionController = vc
        
        return HomeModule(view: vc, viewModel: vModel, coordinator: coordinator)
    }
}
