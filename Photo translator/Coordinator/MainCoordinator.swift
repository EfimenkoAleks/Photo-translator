//
//  MainCoordinator.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import SwiftUI
import Combine

final class MainCoordinator: Coordinarot {
    
    var window: UIWindow?
    var typeHandler: Block<(DP_TabBarSelectedItem)>?
    private var selectedTab: DP_TabBarSelectedItem
    private var hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<NavDetailCoordinator, Never>, selectedTab: DP_TabBarSelectedItem) {
        self.hasSeenOnboarding = hasSeenOnboarding
        self.selectedTab = selectedTab
    }
    
    func start() {
        let vc = DP_TabBarController(hasSeenOnboarding: hasSeenOnboarding, selectedTab: selectedTab)
        vc.setSelectedTab()
        window?.rootViewController = vc
        vc.typeHandler = { [weak self] type in
            self?.typeHandler?(type)
        }
    }
}
