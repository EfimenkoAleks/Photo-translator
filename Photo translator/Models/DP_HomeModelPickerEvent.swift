//
//  DP_HomeModelPickerEvent.swift
//  Photo translator
//
//  Created by Aleksandr on 23.09.2024.
//

import Foundation

typealias DP_HomeModelPickerEventExtension = DP_HomeModelPickerEvent

enum DP_HomeModelPickerEvent: CaseIterable {
    case recent
    case pinned
}

extension DP_HomeModelPickerEventExtension {
  
    var title: String {
        switch self {
        case .recent: return "Recent"
        case .pinned: return "Pinned"
        }
    }
}
