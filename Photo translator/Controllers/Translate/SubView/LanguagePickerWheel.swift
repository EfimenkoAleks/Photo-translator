//
//  LanguagePickerWheel.swift
//  Photo translator
//
//  Created by Aleksandr on 27.09.2024.
//

import SwiftUI
import MLKitTranslate

struct LanguagePickerWheel: View {
    
    private struct settings {
        static var onChange: String = "onChange"
    }
    
    @Binding var lang: TranslateLanguage
    var languages: [Language]
    var handler: Block<String>?
    
    var body: some View {
        VStack {
            ZStack {
                Picker("", selection: $lang) {
                    ForEach(languages, id: \.name) {
                        Text($0.name)
                            .font(.caption2)
                            .foregroundColor(.black)
                    }
                }.onChange(of: lang) { _ in
                    handler?(settings.onChange)
                }
                .labelsHidden()
                .pickerStyle(.wheel)
                // .frame(height: 120)
            }
        }
        .padding()
    }
}
