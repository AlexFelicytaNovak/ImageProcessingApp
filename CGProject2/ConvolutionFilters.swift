//
//  ConvolutionFilters.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI

enum ConvolutionFilters{
    case blur
    case gaussianBlur
    case sharpen
    case edgeDetection
    case emboss
    
    // values of kernels taken from Lecture 1
    var kernel: [[Int]] {
        switch self {
        case .blur:
              return [[1, 1, 1],
                     [1, 1, 1],
                     [1, 1, 1]]
            
        case .gaussianBlur:
            return [[0, 1, 0],
                    [1, 4, 1],
                    [0, 1, 0]]
         
        // "Mean-removal"
        case .sharpen:
            return [[-1, -1, -1],
                    [-1, 9, -1],
                    [-1, -1, -1]]
  
            
        //Horizontal
        case .edgeDetection:
            return [[0, -1, 0],
                    [0, 1, 0],
                    [0, 0, 0]]
            
        //South‐east Emboss
        case .emboss:
            return [[-1, -1, 0],
                    [-1, 1, 1],
                    [0, 1, 1]]
        }
    }
    
}

extension Document {
    //CONVOLUTION FILTERS
    mutating func applyConvolutionFilters(convolutionFilterType: ConvolutionFilters) {

        guard let imageCopy = filteredImage?.copy() as? NSBitmapImageRep else {
             return
         }
        
        guard let image = filteredImage else {
             return
         }
        
        let kernel = convolutionFilterType.kernel
        let xAnchorKernel = (kernel.count - 1)/2
        let yAnchorKernel = (kernel.count - 1)/2
        // divisor
        var D = kernel.joined().reduce(0, +)
        //offset for edge detection
        var offset = 0
        if D == 0
        {
            D = 1
            offset = 127
        }
        //From lecture 1
        for xAnchorImage in 0 ..< Int(image.pixelsWide) {
             for yAnchorImage in 0 ..< Int(image.pixelsHigh) {
                 var pixelsRGBA: [Int] = [0, 0, 0, 0]
                 image.getPixel(&pixelsRGBA, atX: xAnchorImage, y: yAnchorImage)
                 pixelsRGBA[0] = 0
                 pixelsRGBA[1] = 0
                 pixelsRGBA[2] = 0
                 
                 for xKernel in 0 ..< kernel.count{
                     for yKernel in 0 ..< kernel.count{
                         var tmpPixelsRGBA: [Int] = [0, 0, 0, 0]
                         var pixelX = xAnchorImage - xAnchorKernel + xKernel
                         var pixelY = yAnchorImage - yAnchorKernel + yKernel
                         
                         if pixelX < 0
                         {
                             pixelX = 0
                         }
                         if pixelY < 0
                         {
                             pixelY = 0
                         }
                         if pixelX > Int(image.pixelsWide)
                         {
                             pixelX = Int(image.pixelsWide)
                         }
                         if pixelY > Int(image.pixelsHigh)
                         {
                             pixelY = Int(image.pixelsHigh)
                         }
                         
                         image.getPixel(&tmpPixelsRGBA, atX: pixelX, y: pixelY)
                         
                         for channelIndex in 0...tmpPixelsRGBA.endIndex - 2
                         {
                             pixelsRGBA[channelIndex] += kernel[xKernel][yKernel] * tmpPixelsRGBA[channelIndex]
                         }
                     }
                 }
                 for channelIndex in 0...pixelsRGBA.endIndex - 2
                 {
                     pixelsRGBA[channelIndex] = (pixelsRGBA[channelIndex]/D  + offset).clamped(to: 0...255)
                 }
                 
                 
                 imageCopy.setPixel(&pixelsRGBA, atX: xAnchorImage , y: yAnchorImage )
                 
             }
         }
        filteredImage = imageCopy
    }
}
