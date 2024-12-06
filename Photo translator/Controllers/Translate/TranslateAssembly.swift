//
//  TranslateAssembly.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import SwiftUI

final class TranslateAssembly {

    public struct TranslateModule {
        let view: UIViewController
        let viewModel: TranslateModuleViewModel
    }
   
    // MARK: - Module setup -

    func createModule(coordinator: TranslateModuleCoordinator) -> TranslateModule {
        let vModel = TranslateViewModel(coordinator: coordinator)
        let view = ThirdTabView(viewModel: vModel)
        let vc = UIHostingController(rootView: view)
        
        return TranslateModule(view: vc, viewModel: vModel)
    }
}
