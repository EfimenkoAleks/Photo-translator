//
//  ListPhotoCell.swift
//  Photo translator
//
//  Created by Aleksandr on 23.09.2024.
//

import SwiftUI

struct ListPhotoCell: View {
    
    var image: UIImage
    var photo: HomeModel
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
            
            HStack {
                Image("girl")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .cornerRadius(4)
                    .padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(photo.title)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    
                    Text(photo.time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Image("detail")
                
            }
            .padding(.leading,30)
            .padding(.trailing, 20)
        }
        
    }
}
