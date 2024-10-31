//
//  SecondTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI

//struct SecondTabView: View {
//
//    @ObservedObject var viewModel: CameraViewModel
//    @State private var isFocused = false
//    @State private var focusLocation: CGPoint = .zero
//
//    var body: some View {
//        ZStack {
//
//            CameraPreview(session: viewModel.session) { tapPoint in
//                isFocused = true
//                focusLocation = tapPoint
//                viewModel.setFocus(point: tapPoint)
//
//                // provide haptic feedback to enhance the user experience
//                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//            }
//
//            CameraControlView(lastPhoto: $viewModel.photo, eventHendler: { event in
//                viewModel.cameraEvents(event: event)
//            })
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    Button {
//                        viewModel.switchFlash()
//                    } label: {
//                        Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
//                                        .font(.system(size: 20, weight: .medium, design: .default))
//                    }
//                    .accentColor(viewModel.isFlashOn ? .yellow : .white)
//
//                    Button {
//        //                viewModel.cameraEvents(event: .live)
//                    } label: {
//                        Image(systemName: "livephoto")
//                    }
//                }
//            }
//        }
//        .alert(isPresented: $viewModel.showAlertError) {
//            Alert(title: Text($viewModel.alertError.title), message: Text($viewModel.alertError.message), dismissButton: .default(Text($viewModel.alertError.primaryButtonTitle), action: {
//                $viewModel.alertError.primaryAction
//                }))
//             }
//             .alert(isPresented: $viewModel.showSettingAlert) {
//                Alert(title: Text("Warning"), message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."), dismissButton: .default(Text("Go to settings"), action: {
//                   self.openSettings()
//                }))
//             }
//        .onAppear {
//      //      viewModel.dp_resetImage()
//        }
//        .onDisappear {
//     //       viewModel.dp_stopSessino()
//        }
//    }
//
//    // use to open app's setting
//     func openSettings() {
//        let settingsUrl = URL(string: UIApplication.openSettingsURLString)
//        if let url = settingsUrl {
//           UIApplication.shared.open(url, options: [:])
//        }
//      }
//}
//
////struct SecondTabView_Previews: PreviewProvider {
////    static var previews: some View {
////        SecondTabView(viewModel: CameraViewModel())
////    }
////}
//
//struct CameraView: View {
//
//    @Binding var image: CGImage?
//    @Binding var placeholder: UIImage
//
//    var body: some View {
//        GeometryReader { geometry in
//            if let image = image {
//                Image(decorative: image, scale: 1, orientation: .right)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: geometry.size.width,
//                           height: geometry.size.height)
//
//            } else {
//                Image(uiImage: placeholder)
//                    .resizable()
//                    .scaledToFit()
//            }
//        }
//    }
//}

struct SecondTabView: View {
 
 @ObservedObject var viewModel = CameraViewModel()
    @State private var isFocused = false
    @State private var focusLocation: CGPoint = .zero
    @State private var isScaled = false // To scale the view
    @State private var currentZoomFactor: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Button(action: {
                        viewModel.switchFlash()
                    }, label: {
                        Image(systemName: viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                           .font(.system(size: 20, weight: .medium, design: .default))
                    })
                    .accentColor(viewModel.isFlashOn ? .yellow : .white)
                    
                    ZStack  {
                        CameraPreview(session: viewModel.session) { tapPoint in
                            isFocused = true
                            focusLocation = tapPoint
                            viewModel.setFocus(point: tapPoint)

                            // provide haptic feedback to enhance the user experience
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        .gesture(MagnificationGesture() // Apply a MagnificationGesture to the CameraPreview

                        .onChanged { value in
                            // Calculate the change in zoom factor
                            self.currentZoomFactor += value - 1.0

                            // Ensure the zoom factor stays within a specific range
                            self.currentZoomFactor = min(max(self.currentZoomFactor, 0.5), 10)

                            // Call a method to update the zoom level
                            self.viewModel.zoom(with: currentZoomFactor)
                        })
                        
                        if isFocused {
                            FocusView(position: $focusLocation)
                                .scaleEffect(isScaled ? 0.8 : 1)
                                .onAppear {
                                    // Add a springy animation effect for visual appeal.
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                                        self.isScaled = true
                                        // Return to the default state after 0.6 seconds for an elegant user experience.
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            self.isFocused = false
                                            self.isScaled = false
                                        }
                                    }
                                }
                        }
                    }
                  
                    HStack {
                        PhotoThumbnail(image: $viewModel.capturedImage)
                        Spacer()
                        CaptureButton { viewModel.captureImage() }
                            Spacer()
                            CameraSwitchButton { // Call the camera switch method }
                            }
                            .padding(20)
                        }
                    }
                    .alert(isPresented: $viewModel.showAlertError) {
                        Alert(title: Text("Alert title"), message: Text("Alert mesage"), dismissButton: .default(Text("Dismiss"), action: {
 //                           $viewModel.alertError
                        }))
                    }
                    .alert(isPresented: $viewModel.showSettingAlert) {
                        Alert(title: Text("Warning"), message: Text("Application doesn't have all permissions to use camera and microphone, please change privacy settings."), dismissButton: .default(Text("Go to settings"), action: {
                            self.openSettings()
                        }))
                    }
                    .onAppear {
                        viewModel.setupBindings()
                        viewModel.checkForDevicePermission()
                    }
                }
            }
        }
    
    // use to open app's setting
    func openSettings() {
       let settingsUrl = URL(string: UIApplication.openSettingsURLString)
       if let url = settingsUrl {
          UIApplication.shared.open(url, options: [:])
       }
     }
    }

struct PhotoThumbnail: View {

  @Binding var image: UIImage?
 
  var body: some View {
    Group {
       if let image = image {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
       } else {
          Rectangle()
            .frame(width: 50, height: 50, alignment: .center)
            .foregroundColor(.black)
       }
    }
  }
}

struct CaptureButton: View {

  var action: () -> Void
 
  var body: some View {
     Button(action: action) {
        Circle()
          .foregroundColor(.white)
          .frame(width: 70, height: 70, alignment: .center)
          .overlay(
             Circle()
               .stroke(Color.black.opacity(0.8), lineWidth: 2)
               .frame(width: 59, height: 59, alignment: .center)
          )
     }
  }
}

struct CameraSwitchButton: View {

  var action: () -> Void
 
  var body: some View {
      Button(action: action) {
         Circle()
           .foregroundColor(Color.gray.opacity(0.2))
           .frame(width: 45, height: 45, alignment: .center)
           .overlay(
               Image(systemName: "camera.rotate.fill")
                  .foregroundColor(.white))
      }
   }
}

struct FocusView: View {
 
 @Binding var position: CGPoint
 
 var body: some View {
    Circle()
       .frame(width: 70, height: 70)
       .foregroundColor(.clear)
       .border(Color.yellow, width: 1.5)
       .position(x: position.x, y: position.y) // To show view at the specific place
    }
}
