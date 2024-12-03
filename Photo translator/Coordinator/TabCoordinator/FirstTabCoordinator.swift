//
//  FirstTabCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine

enum FirstTabEvent {
    case language, gallery, policy, detail(Int)
}

protocol FirstTabCoordinatorInterface: Coordinator, AnyObject {
    func eventOccurred(with type: FirstTabEvent)
}

final class FirstTabCoordinator: FirstTabCoordinatorInterface {
    
    var childCoordinators: [Coordinator] = []
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
        
        case .detail(let number):
            var homeDetailCoordinator: HomeDetailCoordinatorProtocol = HomeDetailCoordinator(hasSeenOnboarding: hasSeenOnboarding)
            homeDetailCoordinator.transitionController = transitionController
            homeDetailCoordinator.start(photoNumber: number)
//            homeDetailCoordinator.handlerBback = { [unowned self] in
//                self.eventOccurred(with: .back)
//            }
           
//        case .back:
//            hasSeenOnboarding.send(.home)
        }
    }
}

//  UIApplication.getTopViewController()?.present(module.view, animated: true, completion: nil)
