//
//  TranslateInterfaces.swift
//  Photo translator
//
//  Created by Aleksandr on 28.11.2024.
//

import Foundation
import MLKitTranslate

protocol TranslateModuleCoordinator: AnyObject {
    func eventOccurred(with type: ThirdTabEvent)
}

protocol TranslateModuleViewModel: AnyObject {
    var loadingText: String {get set}
    var placeholder: String {get set}
    var inputLang: TranslateLanguage {get set}
    var outputLang: TranslateLanguage {get set}
    var allLanguage: [TranslateLanguage] {get set}
    var buttonNameLeft: String {get set}
    var buttonNameRight: String {get set}
    func whitScreen() -> CGFloat
    func getAllLang() -> [Language]
    func sendTranslate()
}
