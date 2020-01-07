//
//  CIFilterType.swift
//  p13.instafilter
//
//  Created by Matt Brown on 1/6/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import Foundation
import CoreImage

enum CIFilterType: String, CaseIterable {
    case bumpDistortion = "Bump Distortion"
    case gaussianBlur = "Gaussian Blur"
    case pixelate = "Pixelate"
    case sepiaTone = "Sepia Tone"
    case twirlDistortion = "Twirl Distortion"
    case unsharpMask = "Unsharp Mask"
    case vignette = "Vignette"
    
    init?(named name: String) {
        for value in CIFilterType.allCases where value.filterName == name {
            self = value
            return
        }
        
        return nil
    }
    
    private var filterName: String {
        switch self {
        case .bumpDistortion:
            return "CIBumpDistortion"
        case .gaussianBlur:
            return "CIGaussianBlur"
        case .pixelate:
            return "CIPixellate"
        case .sepiaTone:
            return "CISepiaTone"
        case .twirlDistortion:
            return "CITwirlDistortion"
        case .unsharpMask:
            return "CIUnsharpMask"
        case .vignette:
            return "CIVignette"
        }
    }
    
    var filter: CIFilter? {
        return CIFilter(name: self.filterName)
    }
}
