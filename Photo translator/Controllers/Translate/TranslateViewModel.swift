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
    
    @Published var buttonNameLeft: String
    @Published var buttonNameRight: String
    @Published var loadingText: String
    @Published var placeholder: String
    var inputLang: TranslateLanguage = TranslateLanguage.english
    var outputLang: TranslateLanguage = DP_TranslateManager.shared.currentLanguages ?? TranslateLanguage.english
    var allLanguage: [TranslateLanguage] = DP_TranslateManager.shared.allLanguages
    private var coordinator: TranslateModuleCoordinator
    
    init(coordinator: TranslateModuleCoordinator) {
        
        self.coordinator = coordinator
   
        buttonNameLeft = "Download model"
        buttonNameRight = "Download model"
        loadingText = "Load..."
        placeholder = "Enter text"
    }
    
    func whitScreen() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getAllLang() -> [Language] {
        let newLangs = allLanguage.map { TranslateLanguage -> Language in
            return Language(name: Locale.current.localizedString(forLanguageCode: findLang(input: TranslateLanguage).rawValue) ?? "no lang" )
        }
        return newLangs
    }
    
    func findLang(input: TranslateLanguage) -> TranslateLanguage {
       let firstt = DP_TranslateManager.shared.allLanguages.first(where: {$0 == input})
        return firstt ?? TranslateLanguage.english
    }
    
    func sendTranslate() {
        
    }
    
}

struct Language: Identifiable {
    var id: String {
        self.name
    }
    var name: String
}
