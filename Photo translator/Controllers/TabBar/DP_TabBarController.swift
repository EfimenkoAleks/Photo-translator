//
//  DP_TabBarController.swift
//  Photo translator
//
//  Created by Aleksandr on 24.09.2024.
//

import UIKit
import Combine
import SwiftUI

typealias DP_TabBarControllerExtension = DP_TabBarController

class DP_TabBarController: UIViewController {
    
    var selectedTab: DP_TabBarSelectedItem
    var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    var tabBarItemTypes: [DP_TabBarItemType] {
        return []
    }
    var typeHandler: Block<(DP_TabBarSelectedItem)>?
    
    var availableTabBarItemTypes: [DP_TabBarItemType] {
        return [.photo, .camera, .text]
    }
    private var embedTabBar: DP_CustomTabBar = DP_CustomTabBar()
    private var embedViewControllers: [DP_TabBarItemType: UINavigationController] = [:]
    private var curentSelectedItemType: DP_TabBarItemType?
    private var curentTabBarItem: UITabBarItem?
    
    // MARK: Life cycle
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>, selectedTab:  DP_TabBarSelectedItem) {
        self.hasSeenOnboarding = hasSeenOnboarding
        self.selectedTab = selectedTab
   //     self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dp_initialSetup()
    }
    
    // MARK: Publik func
    
    func setSelectedTab() {
      //  guard let selectedTab = selectedTab else { return }
        embedTabBar.selectedItem = embedTabBar.items?[selectedTab.selected]
        dp_updateSelectedViewController()
    }
}

// MARK: Private

private extension DP_TabBarControllerExtension {
    
    func dp_initialSetup() {
        
        embedTabBar.delegate = self
        availableTabBarItemTypes.forEach({embedViewControllers[$0] = dp_childViewControllers(itemForVC: $0)})
        embedTabBar.tabAppearance = { [weak self] _ in
            self?.dp_updateSelectedViewController()
        }
        embedTabBar.items = availableTabBarItemTypes.map { $0.item }
        embedTabBar.isTranslucent = false
        embedTabBar.layer.cornerRadius = 20
        embedTabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        embedTabBar.layer.masksToBounds = true
        
        view.backgroundColor = .white
        view.addSubview(embedTabBar)
        embedTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            embedTabBar.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            embedTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            embedTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            embedTabBar.heightAnchor.constraint(equalToConstant: 90)
        ])
    //    guard let selectedTab = selectedTab else { return }
        embedTabBar.selectedItem = embedTabBar.items?[selectedTab.selected]
        dp_updateSelectedViewController()
        embedTabBar.didTapButton = { [unowned self] _ in
 //           self.dp_selectDevice()
        }
    }
   
//    private func dp_selectDevice() {
//
//        var firstCoordinator: DP_CameraCoordinatorProtocol = DP_CameraCoordinator()
//        let navController = UINavigationController()
//        firstCoordinator.navigationTabController = navController
//        firstCoordinator.navigationController = self.coordinator?.navigationController
//        firstCoordinator.dp_start()
//
//    //    DP_StartCoordinator.shared.dp_startFlov(controller: DP_CameraViewController())
//
//        dp_updateSelectedViewController()
//    }
    
    // MARK: Child viewControllers
    
    func dp_childViewControllers(itemForVC: DP_TabBarItemType) -> UINavigationController {
        
        switch itemForVC {
        case .photo:
            let firstCoordinator = FirstTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
            let navController = UINavigationController()
            navController.tabBarItem = itemForVC.item
            firstCoordinator.rootViewController = navController
            firstCoordinator.start()
            return navController
        case .camera:
            let secondCoordinator = SecondTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
            let navController = UINavigationController()
            navController.tabBarItem = itemForVC.item
            secondCoordinator.rootViewController = navController
            secondCoordinator.start()
            return navController
        case .text:
            let thirdCoordinator = ThirdTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
            let navController = UINavigationController()
            navController.tabBarItem = itemForVC.item
            thirdCoordinator.rootViewController = navController
            thirdCoordinator.start()
            return navController
        }
    }
    
    func dp_updateSelectedViewController() {
        guard let item = embedTabBar.selectedItem,
              let itemType = DP_TabBarItemType(rawValue: item.tag) else { return }
        
        if let item: DP_TabBarItemType = curentSelectedItemType,
           let vc: UIViewController = embedViewControllers[item] {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        if itemType == curentSelectedItemType,
           let selectedVC: UINavigationController = embedViewControllers[itemType],
           selectedVC.viewControllers.count > 1 {
            selectedVC.popViewController(animated: true)
        }
        curentSelectedItemType = itemType
        curentTabBarItem = embedTabBar.selectedItem
        if let selectedVC: UIViewController = embedViewControllers[itemType] {
            selectedVC.additionalSafeAreaInsets.bottom = embedTabBar.bounds.height
            addChild(selectedVC)
            selectedVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            selectedVC.view.frame = view.bounds
            view.addSubview(selectedVC.view)
            selectedVC.didMove(toParent: self)
        }
        view.bringSubviewToFront(embedTabBar)
    }
}

// MARK: UITabBarDelegate

extension DP_TabBarControllerExtension: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
//        if item.title != DP_TabBarItemType.camera.item.title {
            dp_updateSelectedViewController()
//        }
        
        switch item.tag {
                     case 0:
            typeHandler?(.photo)
                     case 1:
            typeHandler?(.camera)
                     case 2:
            typeHandler?(.text)
        default:
            break
        }
    }
}

