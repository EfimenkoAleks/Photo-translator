//
//  ThirdTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct ThirdTabView: View {
    
    @ObservedObject var viewModel: TranslateViewModel
    @State private var content1 = ""
    @State private var content2 = ""
    var doneRequested: () -> Void
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [Color(uiColor: DP_Colors.gradientTop.color), Color(uiColor: DP_Colors.gradientBottom.color)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: -10) {
                RoundedTextView(content: $content1, placeholderText: $viewModel.placeholder, height: viewModel.whitScreen() / 2)
                
                HStack {
                    LanguagePickerWheel(lang: $viewModel.inputLang, languages: viewModel.getAllLang()) { str in
                        print(str)
                    }
                    
                    Button {
                        
                    } label: {
                        Label("", systemImage: "arrowshape.right.fill")
                            .foregroundStyle(.black)
                    }
                    
                    LanguagePickerWheel(lang: $viewModel.outputLang, languages: viewModel.getAllLang())
                }
                
                TranslateButtonsLoad(buttonNameLeft: $viewModel.buttonNameLeft, buttonNameRight: $viewModel.buttonNameRight)
                
                RoundedTextView(content: $content2, placeholderText: $viewModel.placeholder, height: viewModel.whitScreen() / 3)
                
                LoadText(loadingText: $viewModel.loadingText)
            }
        }
    }
}

//struct ThirdTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThirdTabView(viewModel: TranslateViewModel(), doneRequested: {})
//    }
//}
