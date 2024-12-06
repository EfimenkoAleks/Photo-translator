//
//  TranslateViewModel.swift
//  Photo translator
//
//  Created by Aleksandr on 17.09.2024.
//

import Combine
import SwiftUI
import MLKitTranslate

final class TranslateViewModel: ObservableObject {
    
    private struct settings {
        static var downloadModel: String = "Download model"
        static var load: String = "Load..."
        static var enterText: String = "Enter text"
        static var empty: String = ""
        static var noLang: String = "no lang"
    }
    
    @Published var buttonNameLeft: String
    @Published var buttonNameRight: String
    @Published var loadingText: String
    @Published var placeholder: String
    var translateManager : DP_TranslateManager
    var inputLang: TranslateLanguage = TranslateLanguage.english
    var outputLang: TranslateLanguage
    var allLanguage: [TranslateLanguage]
    private var coordinator: TranslateModuleCoordinator
    
    init(coordinator: TranslateModuleCoordinator, translateManager: DP_TranslateManager = DIContainer.default.tranalateManager) {
        
        self.coordinator = coordinator
   
        self.translateManager = translateManager
        outputLang = self.translateManager.currentLanguages ?? TranslateLanguage.english
        allLanguage = self.translateManager.allLanguages
        buttonNameLeft = settings.downloadModel
        buttonNameRight = settings.downloadModel
        loadingText = settings.load
        placeholder = settings.enterText
    }
}

extension TranslateViewModel: TranslateModuleViewModel {
 
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getAllLang() -> [Language] {
        let newLangs = allLanguage.map { TranslateLanguage -> Language in
            return Language(name: Locale.current.localizedString(forLanguageCode: findLang(input: TranslateLanguage).rawValue) ?? settings.noLang )
        }
        return newLangs
    }
    
    func findLang(input: TranslateLanguage) -> TranslateLanguage {
       let firstt = allLanguage.first(where: {$0 == input})
        return firstt ?? TranslateLanguage.english
    }
    
    func sendTranslate() {
        if placeholder != settings.empty && placeholder != settings.enterText {
            coordinator.eventOccurred(with: .share(placeholder))
        }
    }
}
