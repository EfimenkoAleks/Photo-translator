//
//  RoundedTextView.swift
//  Photo translator
//
//  Created by Aleksandr on 27.09.2024.
//

import SwiftUI

struct RoundedTextView: View {
    
    @Binding var content: String
    @Binding var placeholderText: String
    var height: CGFloat
    
    var body: some View {
        VStack {
            
            ZStack {
                if content.isEmpty {
                    TextEditor(text: $placeholderText)
                        .frame(height: height, alignment: .center)
                        .lineSpacing(10)
                        .font(.body)
                        .opacity(0.25)
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .padding()
                }
                
                TextEditor(text: $content)
                    .frame(height: height, alignment: .center)
                    .lineSpacing(10)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .padding()
            }
        }.overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue, lineWidth: 0.5)
        )
        .padding()
    }
}
