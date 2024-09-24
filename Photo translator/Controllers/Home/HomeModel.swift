//
//  HomeModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Foundation

struct HomeModel: Hashable {
    var id: UUID
    var title: String
    var time: String
    var image: URL
}
