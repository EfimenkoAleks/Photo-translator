//
//  SecondTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

enum SecondTabEvent {
    case lastPhoto, home
}

final class SecondTabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var transitionController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
 
    func start() {
        let module = CameraAssembly().createModule(coordinator: self)
        transitionController?.setViewControllers([module.view], animated: false)
    }
}

extension SecondTabCoordinator: CameraModuleCoordinator {
    
    func eventOccurred(with type: SecondTabEvent) {
        switch type {
        case .lastPhoto:
            print("last photo")
//                        guard let controller = controller else { return }
//                        let child = SM_PayViewController()
//                        child.modalPresentationStyle = .fullScreen
//                        child.isModalInPresentation = true
//                        child.preferredContentSize = controller.view.frame.size
//                        controller.present(child, animated: true)
//                        child.eventHandlerBack = { [weak self] _ in
//                            self?.sm_eventOccurred(with: .removeChild)
//                        }
            break
            
        case .home:
           break
        }
    }
}
