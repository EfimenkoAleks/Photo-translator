//
//  LoadText.swift
//  Photo translator
//
//  Created by Aleksandr on 27.09.2024.
//

import SwiftUI

struct LoadText: View {
    
    @Binding var loadingText: String
    
    var body: some View {
        HStack {
            Text(loadingText)
                .font(.system(size: 12))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding()
    }
}
