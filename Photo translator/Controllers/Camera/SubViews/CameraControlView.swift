//
//  CameraControlView.swift
//  Photo translator
//
//  Created by Aleksandr on 01.10.2024.
//

import SwiftUI

struct CameraControlView: View {
    
    private struct settings {
        static var arrowCounter: String = "arrow.counterclockwise"
    }
    
    @Binding var lastPhoto: UIImage
    var eventHendler: Block<(CameraEvent)>?
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Image(uiImage: lastPhoto)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        eventHendler?((.lastPhoto))
                    }
                
                Spacer()
                
                PhotoButton { event in
                    eventHendler?((event))
                }
                
                Spacer()
                
                Button {
                    eventHendler?((.refresh))
                } label: {
                    Image(systemName: settings.arrowCounter)
                }
                .frame(width: 50, height: 50)
                
                .foregroundStyle(.blue)
                .background(LinearGradient(colors: [.blue, .white], startPoint: .bottom, endPoint: .top))
                .cornerRadius(25)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
