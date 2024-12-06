//
//  TextRecognized.swift
//  Photo translator
//
//  Created by Aleksandr on 06.12.2024.
//

import UIKit

protocol DP_TextRecognized: AnyObject {
    func dp_textRecognized(in image: UIImage, completion: @escaping (DP_ResponseTranslateModel) -> Void)
    func dp_convert(boundingBox: CGRect, to bounds: CGRect) -> CGRect
}
