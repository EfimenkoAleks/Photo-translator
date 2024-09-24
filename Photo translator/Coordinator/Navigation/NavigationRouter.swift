//
//  NavigationRouter.swift
//  Photo translator
//
//  Created by Aleksandr on 11.09.2024.
//

import SwiftUI

public protocol NavigationRouter {

    associatedtype V: View

    var transition: NavigationTranisitionStylel { get }

    /// Creates and returns a view of assosiated type
    ///
    @ViewBuilder
    func view() -> V
}
