//
//  ThirdTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct ThirdTabView: View {
    
    @ObservedObject var viewModel: TranslateViewModel
    @State private var enteredText = "Type something..."
    var doneRequested: () -> Void
    
    var body: some View {

        TextEditor(text: $enteredText)
          .padding()
          .font(.title)
          .foregroundColor(.gray)
      }
}

struct ThirdTabView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdTabView(viewModel: TranslateViewModel(), doneRequested: {})
    }
}
