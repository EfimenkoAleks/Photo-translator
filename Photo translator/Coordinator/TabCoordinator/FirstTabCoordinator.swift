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

final class FirstTabCoordinator: Coordinarot {
    
    var rootViewController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
    
    func start() {
        let vModel = HomeViewModel()
        let first = FirstTabView(viewModel: vModel) { [weak self] transition in
            self?.eventOccurred(with: transition)
        }
        let vc = UIHostingController(rootView: first)
        rootViewController?.setViewControllers([vc], animated: false)
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
            break
        case .policy:
            print("policy")
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
