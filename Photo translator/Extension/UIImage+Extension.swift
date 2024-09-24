//
//  UIImage+Extension.swift
//  Photo translator
//
//  Created by Aleksandr on 20.09.2024.
//

import UIKit

extension UIImage {

    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}

extension UIImage {
    // image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    /**
     Create gradient image from beginColor on top and end color at bottom
     
     - parameter beginColor: beginColor
     - parameter endColor:   endColor
     - parameter frame:      frame to be filled
     
     - returns: filled image
     */
    static func imageWithGradient(from beginColor: UIColor, to endColor: UIColor, with frame: CGRect) -> UIImage {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.colors = [beginColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 0.7)
        UIGraphicsBeginImageContext(CGSize(width: frame.width, height: frame.height))
        guard let graphicsGetCurrentContext = UIGraphicsGetCurrentContext() else { return UIImage()}
        layer.render(in: graphicsGetCurrentContext)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage()}
        UIGraphicsEndImageContext()
        return image
    }
    
    static func convertToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)

            // The code below may solve your problem
        view.layer.render(in: UIGraphicsGetCurrentContext()!)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

