//
//  MainCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import SwiftUI
import Combine

class MainCoordinator: Coordinarot {
    
    var rootViewController: UITabBarController
    var childCoordinators: [Coordinarot] = []
    var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    var tabBarItemTypes: [DP_TabBarItemType] {
        return [.photo, .camera, .text]
    }
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
        rootViewController = UITabBarController()
        rootViewController.tabBar.isTranslucent = true
        rootViewController.tabBar.backgroundColor = .lightGray
        
        let screen = UIScreen.main.bounds
        let view = DP_BaseGradientView(frame: CGRect(x: 0, y: 0, width: screen.width, height: 120))
        rootViewController.tabBar.insertSubview(view, at: 0)
        rootViewController.tabBar.tintColor = DP_Colors.white.color
        rootViewController.tabBar.unselectedItemTintColor = DP_Colors.black.color
      
        let image = UIImage.imageWithGradient(from: DP_Colors.blueColor.color,
                                              to: DP_Colors.gradientItemTabBottom.color,
                                              with: CGRect(x: 0, y: 0, width: 44, height: 44))
        rootViewController.tabBar.selectionIndicatorImage = image.withRoundedCorners(radius: 22)
    }
    
    func start() {
        let firstCoordinator = FirstTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
        firstCoordinator.start()
        self.childCoordinators.append(firstCoordinator)
        firstCoordinator.rootViewController = setupTabBarItem(type: .photo, vc: firstCoordinator.rootViewController)
        
        let secondCoordinator = SecondTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
        secondCoordinator.start()
        self.childCoordinators.append(secondCoordinator)
        secondCoordinator.rootViewController = setupTabBarItem(type: .camera, vc: secondCoordinator.rootViewController)
        
        let thirdCoordinator = ThirdTabCoordinator(hasSeenOnboarding: hasSeenOnboarding)
        thirdCoordinator.start()
        self.childCoordinators.append(thirdCoordinator)
        thirdCoordinator.rootViewController = setupTabBarItem(type: .text, vc: thirdCoordinator.rootViewController)
        
        rootViewController.viewControllers = [firstCoordinator.rootViewController, secondCoordinator.rootViewController, thirdCoordinator.rootViewController]
        
      
    }
   
    func setupTabBarItem(type: DP_TabBarItemType, vc: UINavigationController) -> UINavigationController {
        vc.tabBarItem = type.item
        return vc
    }
}
