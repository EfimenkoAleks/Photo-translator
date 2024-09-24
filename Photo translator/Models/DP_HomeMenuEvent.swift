//
//  DP_HomeMenuEvent.swift
//  Photo translator
//
//  Created by Aleksandr on 23.09.2024.
//

import Foundation

typealias DP_HomeMenuEventExtension = DP_HomeMenuEvent

enum DP_HomeMenuEvent: CaseIterable {
    case language
    case gallery
    case translate
}

extension DP_HomeMenuEventExtension {
  
    var title: String {
        switch self {
        case .language: return "Select language"
        case .gallery: return "From gallery"
        case .translate: return "Privacy policy"
        }
    }
}
