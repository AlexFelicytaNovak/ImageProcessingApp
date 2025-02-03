//
//  Document.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 28/02/2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

enum ChannelsColors{
    case red
    case green
    case blue
    
    var channelIndex: Int {
        switch self {
        case .red: return 0
        case .green: return 1
        case .blue: return 2
            
        }
    }
}

struct Document: FileDocument{
    var originalImage: CGImage?
    var filteredImage: NSBitmapImageRep?
    var filteredImageBeforeGrayScale: NSBitmapImageRep?
    var newPoints: [Point] = [Point(x: 0, y: 0), Point(x: 255, y: 255)]
    
    var brightnessCorrectionConst: Int = 25
    var contrastEnhancementConst: Int = 5
    var gammaCorrectionConst: Double = 0.5
    
    init() {
        
    }
    
    static var readableContentTypes: [UTType] { [.png, .jpeg] }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let readImage = NSBitmapImageRep(data: data),
              readImage.bitsPerPixel == 32
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        originalImage = readImage.cgImage!
        filteredImage = readImage
    }
    
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var imageToWrite: Data!
        if  configuration.contentType == .png
        {
            
            guard let isImage = filteredImage?.representation(using: .png, properties: [:]) else {
                throw CocoaError(.fileWriteUnknown)
            }
            imageToWrite = isImage
            
        } else if configuration.contentType == .jpeg
        {
            guard let isImage = filteredImage?.representation(using: .jpeg, properties: [:]) else {
                throw CocoaError(.fileWriteUnknown)
            }
            imageToWrite = isImage
        }
        
        return .init(regularFileWithContents: imageToWrite)
    }
    
    mutating func convertToGrayScaleImage() {
        
        guard let image = filteredImage else {
            return
        }
        
        filteredImageBeforeGrayScale = image.copy() as? NSBitmapImageRep
        
        for x in 0 ..< Int(image.pixelsWide) {
            for y in 0 ..< Int(image.pixelsHigh) {
                var tmpPixelsRGBA: [Int] = [0, 0, 0, 0]
                var grayScale = 0
                image.getPixel(&tmpPixelsRGBA, atX: x, y: y)
                grayScale = (tmpPixelsRGBA[0] + tmpPixelsRGBA[1] + tmpPixelsRGBA[2])/3
                tmpPixelsRGBA[0] = grayScale
                tmpPixelsRGBA[1] = grayScale
                tmpPixelsRGBA[2] = grayScale
                image.setPixel(&tmpPixelsRGBA, atX: x , y: y )
            }
            
        }
        filteredImage = image
    }
    
    mutating func back() {
        guard let image = filteredImageBeforeGrayScale else {
            return
        }
        
        filteredImage = image
    }
    
    mutating func reset()
    {
        guard let image = originalImage else {
            return
        }
        
        filteredImage = NSBitmapImageRep(cgImage: image)
    }
}
