//
//  FirstTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

struct FirstTabView: View {
    
    @State var pickerSelection = 0
    @ObservedObject var viewModel: HomeViewModel
    var doneRequested: (FirstTabEvent) -> Void
    var transitions: [DP_HomeMenuEvent] = [.language, .gallery, .translate]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(uiColor: DP_Colors.gradientTop.color), Color(uiColor: DP_Colors.gradientBottom.color)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            List {
                ForEach(pinned(pined: pickerSelection), id:\.self) { photo in
                    ListPhotoCell(image: viewModel.convertImage(url: photo.image), photo: photo)
                    
                        .listRowSeparator(.hidden)
                    //                        .onTapGesture {
                    //                            print("")
                    //                        }
                }
                .onDelete(perform: self.deleteItems)
                .padding(EdgeInsets.init(top: 0, leading: -20, bottom: 0, trailing: -20))
            }
            .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 10, trailing: 20))
            
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(transitions, id: \.self) { transition in
                            Button(transition.title, action: {
                                switch transition {
                                case .language:
                                    doneRequested(.language)
                                case .gallery:
                                    doneRequested(.gallery)
                                case .translate:
                                    doneRequested(.policy)
                                }
                            })
                        }
                    } label: {
                        Label("", image: "settings")
                        //  .foregroundColor(.white)
                    }
                    .foregroundColor(.white)
                    
                }
                
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    
                    Picker(selection: $pickerSelection, label: Text("")) {
                        Text(DP_HomeModelPickerEvent.recent.title).tag(0).foregroundColor(Color.white)
                        Text(DP_HomeModelPickerEvent.pinned.title).tag(1)
                    }
                    .frame(width: 150)
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.leading, (viewModel.whitScreen() / 2.0) - 90)
                    
                    .onAppear {
                        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                        UISegmentedControl.appearance().backgroundColor = .white
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
                    }
                }
                
            }
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .purple
            viewModel.fetchPhotos()
        }
        
        
    }
    
    func createPhoto(url: URL) -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            return Data()
        }
    }
    
    func pinned(pined: Int) -> [HomeModel] {
        var source: [HomeModel] = []
        source = pickerSelection == 0 ? viewModel.photos : viewModel.pinedPhotos
        return source
    }
    
    func deleteItems(at offsets: IndexSet) {
        //  contacts.remove(atOffsets: offsets)
    }
}

//struct FirstTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        FirstTabView(viewModel: HomeViewModel(), doneRequested: {_ in })
//    }
//}
