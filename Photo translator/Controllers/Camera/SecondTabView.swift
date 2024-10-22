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
            
            CameraView(image: $viewModel.currentFrame, placeholder: $viewModel.stream)
                
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
        .onAppear {
            viewModel.dp_resetImage()
        }
        .onDisappear {
            viewModel.dp_stopSessino()
        }
    }
}

struct SecondTabView_Previews: PreviewProvider {
    static var previews: some View {
        SecondTabView(viewModel: CameraViewModel())
    }
}

struct CameraView: View {
    
    @Binding var image: CGImage?
    @Binding var placeholder: UIImage
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(decorative: image, scale: 1, orientation: .right)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height)
                
            } else {
                Image(uiImage: placeholder)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
