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

final class FirstTabCoordinator: FirstTabModuleCoordinator {
    
    weak var transitionController: UIViewController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
}

extension FirstTabCoordinator {
    
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
