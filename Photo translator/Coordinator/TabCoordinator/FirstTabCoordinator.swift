//
//  FirstTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

enum FirstTabEvent {
    case language, gallery, policy, home, removeChild
}

protocol FirstTabCoordinatorInterface: Coordinarot, AnyObject {
    func eventOccurred(with type: FirstTabEvent)
}

final class FirstTabCoordinator: FirstTabCoordinatorInterface {
    
    weak var transitionController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
    
    func start() {
        let module = HomeAssembly().createModule(coordinator: self)
        transitionController?.setViewControllers([module.view], animated: false)
    }
}

extension FirstTabCoordinator: FirstTabModuleCoordinator {
    
    func eventOccurred(with type: FirstTabEvent) {
        switch type {
        case .language:
            print("language")
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
            
        case .gallery:
            print("gallery")
   //         transitionController?.navigationController?.pushViewController(vc, animated: true)
            break
        case .policy:
            print("policy")
   //         transitionController?.navigationController?.pushViewController(vc, animated: true)
            break
            
        case .home:
            hasSeenOnboarding.send(.home)
            
        case .removeChild:
//                        guard let controller = controller else { return }
//                        controller.removeChild()
            break
        }
    }
}

//  UIApplication.getTopViewController()?.present(module.view, animated: true, completion: nil)
