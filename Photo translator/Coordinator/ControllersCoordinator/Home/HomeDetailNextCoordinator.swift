//
//  HomeDetailNextCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 16.09.2024.
//

import SwiftUI

//class HomeDetailNextCoordinator: Coordinarot {
//
//    var rootViewController: UINavigationController
// //   var hasSeenOnboarding: CurrentValueSubject<Bool, Never>
//
//    init(root: UINavigationController) {
//        self.rootViewController = root
//    }
//
//    func start() {
//        let controller = CityView(name: "Elpassoooo") { [weak self] in
//            self?.backButtonAction()
//        }
//        let vc = UIHostingController(rootView: controller)
//        pushNextVc(vc)
//    }
//
//    func pushNextVc(_ vc: UIViewController) {
//        rootViewController.pushViewController(vc, animated: true)
//    }
//
//    func backButtonAction() {
//        rootViewController.popViewController(animated: true)
//    }
//}

enum HomeDetailNextCoordinatorEvent {
    case back
}

protocol HomeDetailNextCoordinatorProtocol: Coordinarot {
    var handlerBback: (() -> Void)? { get set }
    var rootViewController: UINavigationController?  { get set }
    func start()
    func eventOccurred(with type: HomeDetailNextCoordinatorEvent)
}

class HomeDetailNextCoordinator: HomeDetailNextCoordinatorProtocol {
    var cildren: [Coordinarot] = []
    
    var rootViewController: UINavigationController?
    var handlerBback: (() -> Void)?
    private var controller: UIViewController?
    
    func start() {
        let controller = CityView(name: "Elpassoooo") { [weak self] event in
            switch event {
            case .back:
                self?.handlerBback?()
         //       self?.eventOccurred(with: .back)
            }
         //   self?.handlerBback?()
        }
        let vc = UIHostingController(rootView: controller)
        pushNextVc(vc)
    }
    
    func pushNextVc(_ vc: UIViewController) {
        controller = vc
        rootViewController?.pushViewController(vc, animated: true)
    }
}

extension HomeDetailNextCoordinator {
    func eventOccurred(with type: HomeDetailNextCoordinatorEvent) {
        switch type {
            
        case .back:
            guard let controller = controller else { return }
            rootViewController?.popToViewController(controller, animated: true)
            self.controller = nil
            cildren.removeLast()
        }
    }
}
