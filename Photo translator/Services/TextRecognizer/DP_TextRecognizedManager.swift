//
//  DP_TextRecognizedManager.swift
//  Photo translator
//
//  Created by Aleksandr on 19.09.2024.
//

import Foundation
import UIKit
import Vision

final class DP_TextRecognizedManager: NSObject {
    
    static let shared: DP_TextRecognizedManager = DP_TextRecognizedManager()
    
  //  private let photoHelper: DP_PhotoHelper = DP_PhotoHelper()
    
    func dp_textRecognized(in image: UIImage, completion: @escaping (DP_ResponseTranslateModel) -> Void) {
        guard let cgImage = image.cgImage else { return }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let bounds = CGRect(origin: .zero, size: size)
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        
        let request = VNRecognizeTextRequest { [self] request, error in
            guard
                let results = request.results as? [VNRecognizedTextObservation],
                error == nil
            else { return }
        
            let rects = results.map {
                dp_convert(boundingBox: $0.boundingBox, to: CGRect(origin: .zero, size: size))
            }
            
            let modelText = results.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            let strings = results.compactMap({$0.topCandidates(1).first?.string})
           
            let model = DP_ResponseTranslateModel(rects: rects, imageBounds: bounds, texts: strings)
            completion(model)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Set some properties of the text recognition request.
        //            request.recognitionLanguages = ["en"]
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            request.minimumTextHeight = 0.011
            
            do {
                try imageRequestHandler.perform([request])
            } catch {
                print("Failed to perform image request: \(error)")
                return
            }
        }
    }
    
    func dp_convert(boundingBox: CGRect, to bounds: CGRect) -> CGRect {
        let imageWidth = bounds.width
        let imageHeight = bounds.height

        // Begin with input rect.
        var rect = boundingBox

        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += bounds.minX
        rect.origin.y = (1 - rect.maxY) * imageHeight + bounds.minY

        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight

        return rect
    }
}

struct DP_ResponseTranslateModel {
    var rects: [CGRect]
    var imageBounds: CGRect
    var texts: [String]
}
