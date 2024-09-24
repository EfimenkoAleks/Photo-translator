//
//  HomeDetailCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import Combine


enum HomeDetailCoordinatorEvent {
    case next
    case back
}

protocol HomeDetailCoordinatorProtocol: Coordinarot {
    var handlerBback: (() -> Void)? { get set }
    func start()
    func eventOccurred(with type: HomeDetailCoordinatorEvent)
}

class HomeDetailCoordinator: HomeDetailCoordinatorProtocol {
    
    var rootViewController: UINavigationController?
    var childCoordinators: [Coordinarot] = []
    var handlerBback: (() -> Void)?
    private var controller: UIViewController?
    
        init() {}
 
    func start() {
        let vModel = HomeDetailViewModel()
        let first = HomeView(viewModel: vModel) { [weak self] event in
            switch event {
            case .back:
                self?.handlerBback?()
            case .next:
                self?.eventOccurred(with: .next)
            }
        }
        let vc = UIHostingController(rootView: first)
        pushNextVc(vc)
    }
    
    func pushNextVc(_ vc: UIViewController) {
        controller = vc
        rootViewController?.pushViewController(vc, animated: true)
    }
}

extension HomeDetailCoordinator {
    func eventOccurred(with type: HomeDetailCoordinatorEvent) {
        switch type {
//        case .price:
//            guard let controller = controller else { return }
//            let child = SM_PayViewController()
//            child.modalPresentationStyle = .fullScreen
//            child.isModalInPresentation = true
//            child.preferredContentSize = controller.view.frame.size
//            controller.present(child, animated: true)
//            child.eventHandlerBack = { [weak self] _ in
//                self?.sm_eventOccurred(with: .removeChild)
//            }
        case .next:
            
            var detailCoordinator: HomeDetailNextCoordinatorProtocol = HomeDetailNextCoordinator()
            detailCoordinator.rootViewController = rootViewController
            childCoordinators.append(detailCoordinator)
            detailCoordinator.start()
            detailCoordinator.handlerBback = { [unowned self] in
                self.eventOccurred(with: .back)
            }
            
//        case .removeChild:
//            guard let controller = controller else { return }
//            controller.removeChild()
            
        case .back:
            guard let controller = controller else { return }
            rootViewController?.popToViewController(controller, animated: true)
            childCoordinators.removeLast()
            self.controller = nil
            childCoordinators = []
        }
    }
}
