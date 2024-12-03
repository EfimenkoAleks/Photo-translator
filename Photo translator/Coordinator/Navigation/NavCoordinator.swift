//
//  NavCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

//import SwiftUI
//
//open class NavCoordinator<Router: NavigationRouter>: ObservableObject, Coordinator {
//
//    public var transitionController: UINavigationController?
//    public let startingRoute: Router?
//    private var animated: Bool = true
//
//    public init(navigationController: UINavigationController = .init(), startingRoute: Router? = nil) {
//        self.transitionController = navigationController
//        self.startingRoute = startingRoute
//    }
//
//    public func start() {
//        guard let route = startingRoute else { return }
//        show(route)
//    }
//
//    func show(_ route: Router) {
//        let view = route.view()
//        let viewWithCoordinator = view.environmentObject(self)
//        let viewController = UIHostingController(rootView: viewWithCoordinator)
//        switch route.transition {
//        case .push:
//            transitionController?.pushViewController(viewController, animated: animated)
//        case .presentModally:
//            viewController.modalPresentationStyle = .formSheet
//            transitionController?.present(viewController, animated: animated)
//        case .presentFullscreen:
//            viewController.modalPresentationStyle = .fullScreen
//            transitionController?.present(viewController, animated: animated)
//        }
//    }
//
//    func pop() {
//        transitionController?.popViewController(animated: animated)
//    }
//
//    func popToRoot() {
//        transitionController?.popToRootViewController(animated: animated)
//    }
//
//    func dismiss() {
//        transitionController?.dismiss(animated: true) { [weak self] in
//            /// because there is a leak in UIHostingControllers that prevents from deallocation
//     //       self?.navigationController.viewControllers = []
//        }
//    }
//}
