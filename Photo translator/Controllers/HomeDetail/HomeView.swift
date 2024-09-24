//
//  HomeView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeDetailViewModel
    var transitionEvent: ((HomeDetailCoordinatorEvent) -> Void)?
    
    var btnBack : some View { Button(action: {
        transitionEvent?(.back)
    }) {
        HStack {
            Image(systemName: "arrow.backward")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
            Text("Go back")
        }
    }
    }
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            Text("My detail home")
            Button("Go to the city") {
                transitionEvent?(.next)
            }
            Button {
                transitionEvent?(.back)
            } label: {
                Label {
                    Text("Back")
                } icon: {
                    
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

struct CityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let name: String
    var transitionEvent: ((HomeDetailNextCoordinatorEvent) -> Void)?
    
    var btnBack : some View { Button(action: {
        //     self.presentationMode.wrappedValue.dismiss()
        transitionEvent?(.back)
    }) {
        HStack {
            Image(systemName: "arrow.left") // set image here
                .aspectRatio(contentMode: .fit)
            Text("Go back")
        }
    }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text(name)
            
            Button {
                transitionEvent?(.back)
            } label: {
                Label {
                    Text("Back")
                } icon: {
                    
                }
                
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

//struct CityView2: View {
//
//    @ObservedObject var viewModel: City2ViewModel
//    @EnvironmentObject var coordinator: NavCoordinator<MapRouter>
//
//   @State var name: String
//
//    var body: some View {
//        VStack(spacing: 30) {
//
//            Text(name)
//
//            Button("City4") {
//                coordinator.show(.city4(named: "City 4"))
//            }
//
//            Button("Back") {
//                coordinator.pop()
//            }
//
//            Button("Back root") {
//                coordinator.popToRoot()
//            }
//
//        }
//        .navigationBarHidden(true)
//        .onAppear {
//            guard let model = viewModel.notes.first else {
//                name = "No name"
//                return
//            }
//            name = model.name
//        }
//    }
//}

//struct CityView3: View {
//
//    @EnvironmentObject var coordinator: NavCoordinator<MapRouter>
//
//    let name: String
//
//    var body: some View {
//        VStack(spacing: 30) {
//            Spacer()
//            Text(name)
//
//            Button("Dismiss") {
//                coordinator.dismiss()
//            }
//            Spacer()
//        }.navigationBarHidden(true)
//    }
//}
//
//struct CityView4: View {
//
//    @ObservedObject var viewModel: City4ViewModel
//    @EnvironmentObject var coordinator: NavCoordinator<MapRouter>
//
//    let name: String
//
//    var body: some View {
//
//        VStack(spacing: 30) {
//            Spacer()
//            Form {
//                Section {
//                    TextField("Title", text: $viewModel.title)
//                    TextField("Content", text: $viewModel.content)
//                }
//
//                Section {
//                    HStack {
//                        Spacer()
//                        Button("Save") {
//                            if viewModel.note != nil {
//                                viewModel.note?.name = viewModel.title
//                                viewModel.note?.content = viewModel.content
//                            } else {
//                                let newNote = City4Model(
//                                    id: 1, name: viewModel.title.isEmpty ? "Untitled" : viewModel.title,
//                                    content: viewModel.content
//                                )
//                                viewModel.note = newNote
//                            }
//                            viewModel.addOrUpdateNote()
//                            coordinator.pop()
//                        }
//                        Spacer()
//                    }
//                }
//            }
//
//            .onAppear {
//                if let note = viewModel.note {
//                    viewModel.title = note.name
//                    viewModel.content = note.content
//                }
//            }
//            .navigationBarTitle(viewModel.note == nil ? "Add Note" : "Edit Note")
//
//            Button("Back") {
//                coordinator.pop()
//            }
//            Spacer()
//        }
//    }
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeDetailViewModel(), transitionEvent: {_ in })
    }
}
