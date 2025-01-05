//
//  TabbarView.swift
//  Photo translator
//
//  Created by Aleksandr on 04.01.2025.
//

import SwiftUI

struct TabbarView: View {
     
    @State var selected: Int = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HiddenView(selected: $selected)
            ZStack {
                VStack {
                    HStack {
                        SelectedButtonView(newSelected: 0, oldSelected: selected, imageName: "homeItem") { sel in
                            self.selected = sel
                        }
                        .offset(y: 5)
                           .padding(.leading, 10)
                        
                        Spacer(minLength: UIScreen.main.bounds.width / 2)
                        
                        SelectedButtonView(newSelected: 2, oldSelected: selected, imageName: "typeItem") { sel in
                            self.selected = sel
                        }
                        .offset(y: 5)
                             .padding(.trailing, 10)
                    }
                    .frame(height: 80)
                    .padding()
                    .padding(.horizontal, 22)
                    .background(CurvedShape())
                }
                SelectedButtonView(newSelected: 1, oldSelected: selected, imageName: "imageItem") { sel in
                    self.selected = sel
                }
                .offset(y: -25)
                .shadow(radius: 5)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}

struct CurvedShape: View {
    
    var body: some View {
        
        Path { path in
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0.0))
            path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 80.0))
            path.addArc(center: CGPoint(x: UIScreen.main.bounds.width / 2, y: 80.0), radius: 34.0, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
            path.addLine(to: CGPoint(x: 0.0, y: 80.0))
        }
        .fill(LinearGradient(colors: [Color(uiColor: DP_Colors.gradientBottom.color), Color(uiColor: DP_Colors.gradientTop.color)], startPoint: .top, endPoint: .bottom))
        .rotationEffect(Angle(degrees: 180))
    }
}

struct SelectedButtonView: View {
    
    var newSelected: Int
    var oldSelected: Int
    var imageName: String
    var selected: ((Int) -> Void)
    
    var body: some View {
        Button {
            selected(newSelected)
        } label: {
            Image(imageName)
                .frame(width: 55, height: 55)
        }
        .foregroundColor(oldSelected == newSelected ? Color(uiColor: DP_Colors.white.color) : Color(uiColor: DP_Colors.black.color))
        
        .background(oldSelected == newSelected ? LinearGradient(colors: [Color(uiColor: DP_Colors.gradientItemTabBottom.color), Color(uiColor: DP_Colors.blueColor.color)], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [], startPoint: .top, endPoint: .bottom))
        .background(newSelected == 1 ? Color.yellow : Color.clear)
        
        .clipShape(Circle())
    }
}

struct HiddenView: View {
    
    @Binding var selected: Int
    
    var body: some View {
        TabView(selection: $selected) {
            SomePage(text: "First Page", color: Color.purple)
                .tag(0)
            SomePage(text: "Second Page", color: Color.yellow)
                .tag(1)
            SomePage(text: "Third Page", color: Color.cyan)
                .tag(2)
        }
    }
}

struct SomePage: View {
    
    var text: String
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(text)
            }
            .frame(width: geometry.size.width, height: geometry.size.height - 50)
            .background(color)
        }
    }
}
