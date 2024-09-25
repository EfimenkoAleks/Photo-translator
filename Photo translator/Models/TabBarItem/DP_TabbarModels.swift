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
    case camera
    case text
}

extension DP_TabbarModelsExtension {
    var image: String {
        switch self {
        case .photo: return "homeItem"
        case .camera: return "imageItem"
        case .text: return "typeItem"
        }
    }

    var title: String {
        switch self {
        case .photo: return ""
        case .camera: return ""
        case .text: return ""
        }
    }
}
