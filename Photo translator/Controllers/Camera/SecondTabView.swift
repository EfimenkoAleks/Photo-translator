//
//  SecondTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct SecondTabView: View {
    
    @ObservedObject var viewModel: CameraViewModel
    var doneRequested: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Second detail")
            
            Spacer()
            
            Button {
                doneRequested()
            } label: {
                Label {
                    Text("Press button")
                } icon: {
                    
                }

            }

            Spacer()
        }
    }
}

struct SecondTabView_Previews: PreviewProvider {
    static var previews: some View {
        SecondTabView(viewModel: CameraViewModel(), doneRequested: {})
    }
}
