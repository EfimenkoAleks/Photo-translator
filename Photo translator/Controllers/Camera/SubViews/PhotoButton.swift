//
//  PhotoButton.swift
//  Photo translator
//
//  Created by Aleksandr on 01.10.2024.
//

import SwiftUI

struct PhotoButton: View {
    
    private struct settings {
        static var camera: String = "camera"
    }
    
    var eventHendler: Block<(CameraEvent)>?
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 40)
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.blue, lineWidth: 2)
                )
            
            Button {
                eventHendler?((.createPhoto))
            } label: {
                Image(systemName: settings.camera)
            }
            .frame(width: 60, height: 60)
            .foregroundStyle(.blue)
            .background(LinearGradient(colors: [.blue, .white], startPoint: .bottom, endPoint: .top))
            .cornerRadius(60)
        }
    }
}
