//
//  DP_TabbarModels.swift
//  Photo translator
//
//  Created by Aleksandr on 20.09.2024.
//

import Foundation

typealias DP_TabbarModelsExtension = DP_TabbarModels

enum DP_TabbarModels: CaseIterable {
    case photo
    case text
    case camera
}

extension DP_TabbarModelsExtension {
    var image: String {
        switch self {
        case .photo: return "homeItem"
        case .text: return "typeItem"
        case .camera: return "imageItem"
        }
    }

    var title: String {
        switch self {
        case .photo: return ""
        case .text: return ""
        case .camera: return ""
        }
    }
}
