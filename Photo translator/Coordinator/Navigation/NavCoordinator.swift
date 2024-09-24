//
//  NavCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import SwiftUI

open class NavCoordinator<Router: NavigationRouter>: ObservableObject, Coordinarot {

    public let navigationController: UINavigationController
    public let startingRoute: Router?
    private var animated: Bool = true

    public init(navigationController: UINavigationController = .init(), startingRoute: Router? = nil) {
        self.navigationController = navigationController
        self.startingRoute = startingRoute
    }

    public func start() {
        guard let route = startingRoute else { return }
        show(route)
    }

    func show(_ route: Router) {
        let view = route.view()
        let viewWithCoordinator = view.environmentObject(self)
        let viewController = UIHostingController(rootView: viewWithCoordinator)
        switch route.transition {
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        case .presentModally:
            viewController.modalPresentationStyle = .formSheet
            navigationController.present(viewController, animated: animated)
        case .presentFullscreen:
            viewController.modalPresentationStyle = .fullScreen
            navigationController.present(viewController, animated: animated)
        }
    }

    func pop() {
        navigationController.popViewController(animated: animated)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: animated)
    }

    func dismiss() {
        navigationController.dismiss(animated: true) { [weak self] in
            /// because there is a leak in UIHostingControllers that prevents from deallocation
     //       self?.navigationController.viewControllers = []
        }
    }
}
