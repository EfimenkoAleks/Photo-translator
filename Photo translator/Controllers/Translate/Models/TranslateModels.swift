//
//  TranslateModels.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import Foundation

struct Language: Identifiable {
    var id: String {
        self.name
    }
    var name: String
}
