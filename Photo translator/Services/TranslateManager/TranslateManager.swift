//
//  TranslateManager.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import Foundation
import MLKitTranslate

protocol DP_TranslateManager: AnyObject {
    var languages: [TranslateLanguage] {get set}
    var currentLanguages: TranslateLanguage? {get set}
    var originalLanguages: TranslateLanguage? {get set}
    var translator: Translator! {get set}
    var allLanguages: [TranslateLanguage] { get set }
    
    func setOptionTranslate(inputLang: TranslateLanguage, outputLang: TranslateLanguage)
    func dp_identityLanguage(text: String, completion: @escaping (String?) -> Void)
    func getText(_ text: String, originalLanguage: TranslateLanguage, completion: @escaping (TranslateLangEvents) -> Void)
    func dp_getNameLang(lang: TranslateLanguage?) -> String?
    func dp_translateTag(lang: TranslateLanguage?, completion: @escaping (String) -> Void)
    func model(forLanguage: TranslateLanguage) -> TranslateRemoteModel
    func isLanguageDownloaded(_ language: TranslateLanguage) -> Bool
    func translate(inputText: String, completion: @escaping (String) -> Void)
    func dp_downloadModel(language: TranslateLanguage, completion: @escaping () -> Void)
    func dp_deletedModel(language: TranslateLanguage)
}
