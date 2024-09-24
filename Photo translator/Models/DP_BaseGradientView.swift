//
//  DP_BaseGradientView.swift
//  Photo translator
//
//  Created by Aleksandr on 20.09.2024.
//

import UIKit

 final class DP_BaseGradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createView()
    }
    
    private func createView() {

        setGradient(colorTop: DP_Colors.gradientTop.color, colorBottom: DP_Colors.gradientBottom.color, frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
                let popapView = UIView()
        popapView.backgroundColor = .white.withAlphaComponent(0.4)
                popapView.translatesAutoresizingMaskIntoConstraints = false

                addSubview(popapView)
                NSLayoutConstraint.activate([
                    popapView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    popapView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    popapView.heightAnchor.constraint(equalToConstant: frame.height),
                    popapView.widthAnchor.constraint(equalToConstant: frame.width)
                ])
    }
}

