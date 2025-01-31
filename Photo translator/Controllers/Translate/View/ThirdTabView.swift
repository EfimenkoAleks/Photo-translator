//
//  ThirdTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct ThirdTabView: View {
    
    private struct settings {
        static var arrowRight: String = "arrowshape.right.fill"
        static var squareArrowUp: String = "square.and.arrow.up"
        static var empy: String = ""
    }
    
    @ObservedObject var viewModel: TranslateViewModel
    @State private var content1 = settings.empy
    @State private var content2 = settings.empy
 //   var doneRequested: () -> Void
    
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
                        viewModel.sendTranslate()
                    } label: {
                        Label(settings.empy, systemImage: settings.arrowRight)
                            .foregroundStyle(.black)
                    }
                    
                    LanguagePickerWheel(lang: $viewModel.outputLang, languages: viewModel.getAllLang())
                }
                
                TranslateButtonsLoad(buttonNameLeft: $viewModel.buttonNameLeft, buttonNameRight: $viewModel.buttonNameRight)
                
                RoundedTextView(content: $content2, placeholderText: $viewModel.placeholder, height: viewModel.whitScreen() / 3)
                
                LoadText(loadingText: $viewModel.loadingText)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.sendTranslate()
                    } label: {
                        Image(systemName: settings.squareArrowUp)
                            .foregroundColor(Color(uiColor: DP_Colors.blue.color))
                    }
                }
            }
        }
    }
}

//struct ThirdTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThirdTabView(viewModel: TranslateViewModel(), doneRequested: {})
//    }
//}
