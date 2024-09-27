//
//  TranslateButtonsLoad.swift
//  Photo translator
//
//  Created by Aleksandr on 27.09.2024.
//

import SwiftUI

struct TranslateButtonsLoad: View {
    
    @Binding var buttonNameLeft: String
    @Binding var buttonNameRight: String
    
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text(buttonNameLeft)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Text(buttonNameRight)
                    .font(.system(size: 12))
                    .foregroundColor(.black)
            }
            
        }
        .padding()
    }
}
