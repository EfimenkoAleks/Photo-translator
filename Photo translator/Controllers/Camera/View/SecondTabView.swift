//
//  SecondTabView.swift
//  Photo translator
//
//  Created by Aleksandr on 12.09.2024.
//

import SwiftUI
import AVFoundation

struct SecondTabView: View {
    
    private struct settings {
        static var bolt: String = "bolt.fill"
        static var boltSlash: String = "bolt.slash.fill"
    }
    
    @ObservedObject var viewModel: CameraViewModel
    @State private var isFocused = false
    @State private var focusLocation: CGPoint = .zero
    @State private var isScaled = false // To scale the view
    @State private var currentZoomFactor: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                //  Color.black.edgesIgnoringSafeArea(.all)
//                LinearGradient(colors: [Color(uiColor: DP_Colors.gradientTop.color), Color(uiColor: DP_Colors.gradientBottom.color)], startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.bottom)
                
                LinearGradient(colors: [Color(uiColor: DP_Colors.gradientTop.color), Color(uiColor: DP_Colors.gradientBottom.color)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
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
                    HorizontalButtonsView(image: $viewModel.capturedImage) { viewModel.captureImage()}
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.switchFlash()
                } label: {
                    Image(systemName: viewModel.isFlashOn ? settings.bolt : settings.boltSlash)
                        .foregroundColor(viewModel.isFlashOn ? Color.yellow : Color(uiColor: DP_Colors.blue.color))
                }
                .accentColor(viewModel.isFlashOn ? .yellow : .gray)
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
            viewModel.startSession()
        }
        //                    .onDisappear {
        //                        viewModel.stopSession()
        //                    }
        //           }
        //          }
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
    
    private struct settings {
        static var camera: String = "camera.fill"
    }
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .foregroundColor(.white)
                .frame(width: 70, height: 70, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.blue.opacity(0.8), lineWidth: 2)
                        .frame(width: 59, height: 59, alignment: .center)
                        .overlay(
                            Image(systemName: settings.camera)
                                .frame(width: 44, height: 44)
                                .foregroundColor(.blue))
                )
        }
    }
}

struct CameraSwitchButton: View {
    
    private struct settings {
        static var arrowTriangle: String = "arrow.triangle.2.circlepath"
    }
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .foregroundColor(Color.white)
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(
                    Image(systemName: settings.arrowTriangle)
                        .foregroundColor(Color.blue))
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

struct HorizontalButtonsView: View {
    
    @Binding var image: UIImage?
    var action: () -> Void
    
    var body: some View {
        HStack {
            PhotoThumbnail(image: $image) //$viewModel.capturedImage
            Spacer()
            CaptureButton() { action() } // viewModel.captureImage()
            Spacer()
            CameraSwitchButton { // Call the camera switch method }
            }
        }
        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
