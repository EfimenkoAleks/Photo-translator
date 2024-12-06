//
//  HomeDetailView.swift
//  Photo translator
//
//  Created by Aleksandr on 03.12.2024.
//

import SwiftUI

struct HomeDetailView: View {
    
    private struct settings {
        static var arrowBack: String = "arrowBack"
        static var squareArrowUp: String = "square.and.arrow.up"
    }
    
    @ObservedObject var viewModel: HomeDetailViewModel
 
    var btnBack : some View { Button(action: {
        viewModel.transitionTo(.back)
    }) {
        HStack {
            Image(settings.arrowBack)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundColor(Color(uiColor: DP_Colors.blue.color))
            Text("")
        }
    }
    }
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [Color(uiColor: DP_Colors.gradientTop.color), Color(uiColor: DP_Colors.gradientBottom.color)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            Image(uiImage: viewModel.translateImage ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
          //      .edgesIgnoringSafeArea(.top)
           
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.dp_didTapPin()
                } label: {
                    Image(systemName: viewModel.pinedImage)
                        .foregroundColor(Color(uiColor: DP_Colors.blue.color))
                }
                
                Button {
                    viewModel.sendPhoto()
                } label: {
                    Image(systemName: settings.squareArrowUp)
                        .foregroundColor(Color(uiColor: DP_Colors.blue.color))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: HomeDetailViewModel(), transitionEvent: {_ in })
//    }
//}

