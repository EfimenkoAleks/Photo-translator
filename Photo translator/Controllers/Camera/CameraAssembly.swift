//
//  CameraAssembly.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import SwiftUI

final class CameraAssembly {

    public struct CameraModule {
        let view: UIViewController
        let viewModel: CameraModuleViewModel
    }
   
    // MARK: - Module setup -

    func createModule(coordinator: CameraModuleCoordinator) -> CameraModule {
        let vModel = CameraViewModel(coordinator: coordinator)
        let first = SecondTabView(viewModel: vModel)
        let vc = UIHostingController(rootView: first)
        
        return CameraModule(view: vc, viewModel: vModel)
    }
}

