//
//  FunctionalFilters.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI

enum FunctionFilters {
    case inversion
    case brightnessCorrection
    case contrastEnhancement
    case gammaCorrection
    case newFunctionalFilter
}

extension Document {
    //FUNCTIONAL FILTERS
    mutating func applyFunctionFilters(functionFilterType: FunctionFilters) {
        
        guard let image = filteredImage else {
            return
        }
        
        for x in 0 ..< Int(image.pixelsWide) {
            for y in 0 ..< Int(image.pixelsHigh) {
                var pixelsRGBA: [Int] = [0, 0, 0, 0]
                image.getPixel(&pixelsRGBA, atX: x, y: y)
                
                switch functionFilterType {
                case .inversion:
                    inverse(pixelsRGBA: &pixelsRGBA)
                case .brightnessCorrection:
                    brightnessCorrection(pixelsRGBA: &pixelsRGBA)
                case .contrastEnhancement:
                    contrastEnhancement(pixelsRGBA: &pixelsRGBA)
                case .gammaCorrection:
                    gammaCorrection(pixelsRGBA: &pixelsRGBA)
                case .newFunctionalFilter:
                    newFilter(pixelsRGBA: &pixelsRGBA)
                }
                
                image.setPixel(&pixelsRGBA, atX: x, y: y)
                
            }
        }
        filteredImage = image
    }
    
    
    
    func inverse(pixelsRGBA: inout [Int]) {
        pixelsRGBA[0] =  255 - pixelsRGBA[0]
        pixelsRGBA[1] =  255 - pixelsRGBA[1]
        pixelsRGBA[2] =  255 - pixelsRGBA[2]
    }
    
    
    func brightnessCorrection(pixelsRGBA: inout [Int])
    {
        for channelIndex in 0...pixelsRGBA.endIndex - 2
        {
            
            pixelsRGBA[channelIndex] = (pixelsRGBA[channelIndex] + brightnessCorrectionConst).clamped(to: 0...255)
            
        }
        
    }
    
    func contrastEnhancement(pixelsRGBA: inout [Int])
    {
        for channelIndex in 0...pixelsRGBA.endIndex - 2
        {
            //formula from lecture 1
            pixelsRGBA[channelIndex] = ((pixelsRGBA[channelIndex] - 128) * contrastEnhancementConst + 128).clamped(to: 0...255)
        }
        
    }
    
    func gammaCorrection(pixelsRGBA: inout [Int])
    {
        for channelIndex in 0...pixelsRGBA.endIndex - 2
        {

            pixelsRGBA[channelIndex] = (Int(round(pow(Double(pixelsRGBA[channelIndex])/255, gammaCorrectionConst) * 255 ))).clamped(to: 0...255)
        }
        
    }
    
    //applying custom filter to image
    func newFilter(pixelsRGBA: inout [Int])
    {
        for channelIndex in 0...pixelsRGBA.endIndex - 2
        {
            if let newColorValue = newPoints.first(where: {
                $0.x == pixelsRGBA[channelIndex] })
            {
                pixelsRGBA[channelIndex] = newColorValue.y
            } else {
                let newXIndexUpper = newPoints.firstIndex(where: {
                    $0.x > pixelsRGBA[channelIndex] })!
                
                let newXIndexLower =  newXIndexUpper - 1
                
                pixelsRGBA[channelIndex] = (newPoints[newXIndexUpper].y - newPoints[newXIndexLower].y )/(newPoints[newXIndexUpper].x - newPoints[newXIndexLower].x ) * (pixelsRGBA[channelIndex] - newPoints[newXIndexLower].x) + newPoints[newXIndexLower].y
            }
        }
        
    }
}
