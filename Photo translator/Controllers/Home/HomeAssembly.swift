//
//  HomeAssembly.swift
//  Photo translator
//
//  Created by Aleksandr on 02.12.2024.
//

import SwiftUI

final class HomeAssembly {

    public struct HomeModule {
        let view: UIViewController
        let viewModel: FirstTabModuleViewModel
    }
   
    // MARK: - Module setup -

    func createModule(coordinator: FirstTabCoordinatorInterface) -> HomeModule {
        let vModel = HomeViewModel(coordinator: coordinator)
        let first = FirstTabView(viewModel: vModel)
        let vc = UIHostingController(rootView: first)
        
        return HomeModule(view: vc, viewModel: vModel)
    }
}
