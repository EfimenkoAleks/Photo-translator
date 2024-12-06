//
//  ThirdTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

enum ThirdTabEvent {
    case share(String?)
}

final class ThirdTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
   
    weak var transitionController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
    
    func start() {
        let model = TranslateAssembly().createModule(coordinator: self)
        transitionController?.setViewControllers([model.view], animated: false)
    }
}

extension ThirdTabCoordinator: TranslateModuleCoordinator {
    func eventOccurred(with type: ThirdTabEvent) {
        switch type {
        case .share(let text):
            guard let text = text else { return }
            
                let textShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = transitionController?.topViewController?.view
            transitionController?.present(activityViewController, animated: true, completion: nil)
        }
    }
}
