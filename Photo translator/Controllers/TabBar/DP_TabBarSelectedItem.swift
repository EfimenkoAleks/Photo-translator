//
//  DP_TabBarSelectedItem.swift
//  Photo translator
//
//  Created by Aleksandr on 24.09.2024.
//

import Foundation

typealias DP_TabBarSelectedItemExtension = DP_TabBarSelectedItem

enum DP_TabBarSelectedItem {
    case photo, camera, text
}

extension DP_TabBarSelectedItemExtension {

    var selected: Int {
        switch self {
        case .photo: return 0
        case .camera: return 1
        case .text: return 2
        }
    }
}
