//
//  MorphologicalFilters.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI

enum MorphologicalFilters{
    case opening
    case closing
    case erosion
    case dilation
    
    var kernel: [[Int]] {
        switch self {
        case .dilation:
            return [[1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1]]
            
        case .erosion:
            return [[1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1]]
            
        case .opening:
            return [[1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1]]
            
        case .closing:
            return [[1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1]]
        }
    }
}

extension Document {
    // MORPHOLOGICAL FILTERS
    func convertToBinaryImage(image: NSBitmapImageRep) {
        for x in 0 ..< Int(image.pixelsWide) {
            for y in 0 ..< Int(image.pixelsHigh) {
                var tmpPixelsRGBA: [Int] = [0, 0, 0, 0]
                image.getPixel(&tmpPixelsRGBA, atX: x, y: y)
                if tmpPixelsRGBA[0] > 127 && tmpPixelsRGBA[1] > 127 && tmpPixelsRGBA[2] > 127 {
                    tmpPixelsRGBA[0] = 255
                    tmpPixelsRGBA[1] = 255
                    tmpPixelsRGBA[2] = 255
                } else {
                    tmpPixelsRGBA[0] = 0
                    tmpPixelsRGBA[1] = 0
                    tmpPixelsRGBA[2] = 0
                }
                image.setPixel(&tmpPixelsRGBA, atX: x , y: y )
            }
            
        }
    }
    
    mutating func applyMorphologicalFilters(morphologicalFiltersType: MorphologicalFilters){
        
        guard let image = filteredImage else {
            return
        }
        
        convertToBinaryImage(image: image)
        
        switch morphologicalFiltersType
        {
        case .dilation:
            applyDilationErosionFilter(morphologicalFiltersType: morphologicalFiltersType)
            
        case .erosion:
            applyDilationErosionFilter(morphologicalFiltersType: morphologicalFiltersType)
            
        case .opening:
            openingFilter(morphologicalFiltersType: morphologicalFiltersType)
            
        case .closing:
            closingFilter(morphologicalFiltersType: morphologicalFiltersType)
        
        }
        
        
    }
    
    mutating func openingFilter(morphologicalFiltersType: MorphologicalFilters)
    {
        applyDilationErosionFilter(morphologicalFiltersType: .erosion, passedKernel: morphologicalFiltersType.kernel)
        applyDilationErosionFilter(morphologicalFiltersType: .dilation, passedKernel: morphologicalFiltersType.kernel)
    }
    
    mutating func closingFilter(morphologicalFiltersType: MorphologicalFilters)
    {
        applyDilationErosionFilter(morphologicalFiltersType: .dilation, passedKernel: morphologicalFiltersType.kernel)
        applyDilationErosionFilter(morphologicalFiltersType: .erosion, passedKernel: morphologicalFiltersType.kernel)
    }
    
    
    mutating func applyDilationErosionFilter(morphologicalFiltersType: MorphologicalFilters, passedKernel: [[Int]]? = nil) {
        
        guard let imageCopy = filteredImage?.copy() as? NSBitmapImageRep else {
             return
         }

        guard let image = filteredImage else {
             return
         }
        
        //erosion
        var value = 255
        var value2 = 0
        
        if morphologicalFiltersType == .dilation  {
            value = 0
            value2 = 255
        }
        
        let kernel = passedKernel ?? morphologicalFiltersType.kernel
        let xAnchorKernel = (kernel.count - 1)/2
        let yAnchorKernel = (kernel.count - 1)/2
        
        
        for xAnchorImage in 0 ..< Int(image.pixelsWide) {
             for yAnchorImage in 0 ..< Int(image.pixelsHigh) {
                 var pixelsRGBA: [Int] = [0, 0, 0, 0]
                 image.getPixel(&pixelsRGBA, atX: xAnchorImage, y: yAnchorImage)
                 pixelsRGBA[0] = value
                 pixelsRGBA[1] = value
                 pixelsRGBA[2] = value
                 
                 for xKernel in 0 ..< kernel.count{
                     var isBlackPixel = false
                     var isWhitePixel = false
                     for yKernel in 0 ..< kernel.count{
                         var tmpPixelsRGBA: [Int] = [0, 0, 0, 0]
                         let pixelX = xAnchorImage - xAnchorKernel + xKernel
                         let pixelY = yAnchorImage - yAnchorKernel + yKernel
                         
                         if pixelX < 0 || pixelY < 0 || pixelX > Int(image.pixelsWide) || pixelY > Int(image.pixelsHigh)
                         {
                             continue
                         }
                         
                         image.getPixel(&tmpPixelsRGBA, atX: pixelX, y: pixelY)
                         

                         if tmpPixelsRGBA[0] == value2 && tmpPixelsRGBA[1] == value2 && tmpPixelsRGBA[2] == value2 {
                             pixelsRGBA[0] = value2
                             pixelsRGBA[1] = value2
                             pixelsRGBA[2] = value2
                             if value2 == 0
                             {
                                 isBlackPixel = true
                             } else {
                                 isWhitePixel = true
                             }
                             
                             break
                            }
                            
                     }
                     
                     if isBlackPixel == true {
                         break
                     }
                     if isWhitePixel == true {
                         break
                     }
                     
                 }
                
                 imageCopy.setPixel(&pixelsRGBA, atX: xAnchorImage , y: yAnchorImage)
                 
             }
         }
        filteredImage = imageCopy
    }
}
