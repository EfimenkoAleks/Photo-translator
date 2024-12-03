//
//  HomeDetailAssembly.swift
//  Photo translator
//
//  Created by Aleksandr on 03.12.2024.
//

import SwiftUI

final class HomeDetailAssembly {

    public struct HomeDetailModule {
        let view: UIViewController
        let viewModel: HomeDetailModuleViewModel
    }
   
    // MARK: - Module setup -

    func createModule(coordinator: HomeDetailModuleCoordinator, photoNumber: Int) -> HomeDetailModule {
        let vModel = HomeDetailViewModel(photoNumber: photoNumber, coordinator: coordinator)
        let first = HomeDetailView(viewModel: vModel)
        let vc = UIHostingController(rootView: first)
        
        return HomeDetailModule(view: vc, viewModel: vModel)
    }
}
