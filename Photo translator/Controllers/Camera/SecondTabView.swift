//
//  SecondTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct SecondTabView: View {
    
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        ZStack {
            Image(uiImage: viewModel.stream)
                .resizable()
                .scaledToFit()
                
            CameraControlView(lastPhoto: $viewModel.photo, eventHendler: { event in
                viewModel.cameraEvents(event: event)
            })
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.cameraEvents(event: .ligth)
                    } label: {
                        Image(systemName: "bolt.fill")
                    }
                    
                    Button {
                        viewModel.cameraEvents(event: .live)
                    } label: {
                        Image(systemName: "livephoto")
                    }
                }
            }
        }
    }
}

struct SecondTabView_Previews: PreviewProvider {
    static var previews: some View {
        SecondTabView(viewModel: CameraViewModel())
    }
}
