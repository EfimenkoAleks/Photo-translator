//
//  HomeDetailView.swift
//  Photo translator
//
//  Created by Aleksandr on 03.12.2024.
//

import SwiftUI

struct HomeDetailView: View {
    
    @ObservedObject var viewModel: HomeDetailViewModel
 
    var btnBack : some View { Button(action: {
        viewModel.transitionTo(.back)
    }) {
        HStack {
            Image("arrowBack")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
            Text("")
        }
    }
    }
    
    var body: some View {
        
        ZStack() {
            
            Image(uiImage: viewModel.translateImage ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
          //      .edgesIgnoringSafeArea(.top)
           
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

