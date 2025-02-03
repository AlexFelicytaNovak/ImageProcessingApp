//
//  OrderedDithering.swift
//  CGProject2
//
//  Created by Aleksandra Novák on 27/03/2023.
//

import SwiftUI

enum DitherMatrices {
    case D2
    case D4
    case D3
    case D6
    
    var matrix: [[Float]] {
        switch self {
        case .D2:
            return [[1, 3],
                    [4, 2]]
            
        case .D4:
            return [[3, 7, 4],
                    [6, 1, 9],
                    [2, 8, 5]]
            
        case .D3:
            return [[1, 9, 3, 11],
                    [13, 5, 15, 7],
                    [4, 12, 2, 10],
                    [16, 8, 14, 16]]
            
        case .D6:
            return [[9, 25, 13, 11, 27, 15],
                    [21, 1, 33, 23, 3, 35],
                    [5, 29, 17, 7, 31, 19],
                    [12, 28, 16, 10, 26, 14],
                    [24, 4, 36, 22, 2, 34],
                    [8, 32, 20, 6, 30, 18]]
        }
        
    }
}

extension Document {
    // ORDERED DITHERING
    func calculateBayerMatrix(matrix: [[Float]]) -> [[Float]]{
        
        var newMatrix = matrix
        for x in 0..<matrix.count{
            for y in 0..<matrix[x].count{
                newMatrix[x][y] = matrix[x][y]/Float((matrix.count * matrix.count + 1))
            }
        }
        return newMatrix
    }
    
    mutating func orderedDithering(ditherMatrices: DitherMatrices, shades: Float){
        
        guard let imageCopy = filteredImage?.copy() as? NSBitmapImageRep else {
            return
        }
        
        guard let image = filteredImage else {
            return
        }
        
        var grayLevels = [CGFloat](repeating: 0, count: Int(shades))
        for i in 0..<Int(shades){
            grayLevels[i] = CGFloat(Double(i)*(1.0/Double(Int(shades)-1)))
        }
        
        let bayerMatrix = calculateBayerMatrix(matrix: ditherMatrices.matrix)
        
        for x in 0 ..< Int(image.pixelsWide) {
            for y in 0 ..< Int(image.pixelsHigh) {
                let intensity = image.colorAt(x: x, y: y)
                var newIntensity: [Int] = [0, 0, 0, 0]
                let intensityRed = intensity!.redComponent
                let intensityGreen = intensity!.greenComponent
                let intensityBlue = intensity!.blueComponent
                
                var colR = floor((CGFloat(shades) - 1) * intensityRed)
                var colG = floor((CGFloat(shades) - 1) * intensityGreen)
                var colB = floor((CGFloat(shades) - 1) * intensityBlue)
                
                let reR = (CGFloat(shades) - 1)*intensityRed - colR
                let reG = (CGFloat(shades) - 1)*intensityGreen - colG
                let reB = (CGFloat(shades) - 1)*intensityBlue - colB
                
                if ( reR >= CGFloat(bayerMatrix[x%ditherMatrices.matrix.count][y%ditherMatrices.matrix.count]))
                {
                    colR += 1
                }
                if ( reG >= CGFloat(bayerMatrix[x%ditherMatrices.matrix.count][y%ditherMatrices.matrix.count]))
                {
                    colG += 1
                }
                if ( reB >= CGFloat(bayerMatrix[x%ditherMatrices.matrix.count][y%ditherMatrices.matrix.count]))
                {
                    colB += 1
                }
                
                newIntensity[0] = Int(255*grayLevels[Int(colR)])
                newIntensity[1] = Int(255*grayLevels[Int(colG)])
                newIntensity[2] = Int(255*grayLevels[Int(colB)])
                newIntensity[3] = Int(255*intensity!.alphaComponent)
                
                imageCopy.setPixel(&newIntensity, atX: x , y: y)
                
            }
        }
        filteredImage = imageCopy
    }
}
