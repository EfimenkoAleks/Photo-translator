//
//  SecondTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

enum SecondTabEvent {
    case lastPhoto, home, removeChild
}

final class SecondTabCoordinator: Coordinarot {
    
    var rootViewController: UINavigationController?
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
 
    func start() {
        let vModel = CameraViewModel()
        vModel.eventHendler = { [weak self] event in
            self?.eventOccurred(with: event)
        }
        let first = SecondTabView(viewModel: vModel) 
        let vc = UIHostingController(rootView: first)
        rootViewController?.setViewControllers([vc], animated: false)
    }
}

extension SecondTabCoordinator {
    
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
            hasSeenOnboarding.send(.home)
            
        case .removeChild:
//                        guard let controller = controller else { return }
//                        controller.removeChild()
            break
        }
    }
}
