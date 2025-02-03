//
//  MedianCut.swift
//  CGProject2
//
//  Created by Aleksandra Novák on 01/02/2025.
//

import SwiftUI

extension Document {
    func pixels(image: NSBitmapImageRep) -> [Pixel]{
        var pixelsArray:[Pixel] = []
        for x in 0 ..< Int(image.pixelsWide) {
            for y in 0 ..< Int(image.pixelsHigh) {
                var tmpPixelsRGBA: [Int] = [0, 0, 0, 0]
                image.getPixel(&tmpPixelsRGBA, atX: x, y: y)
                pixelsArray.append(Pixel(x: x, y: y, red: tmpPixelsRGBA[0], green: tmpPixelsRGBA[1], blue: tmpPixelsRGBA[2], alpha: tmpPixelsRGBA[3]))
                
            }
            
        }
        return pixelsArray
    }
    
    func divisionByChannel(cube: [Pixel]) -> ChannelsColors
    {
        var color: ChannelsColors
        let redValue = cube.map(\.red)
        let greenValue = cube.map(\.green)
        let blueValue =  cube.map(\.blue)
        
        let redRange = redValue.max()! - redValue.min()!
        let greenRange = greenValue.max()! - greenValue.min()!
        let blueRange = blueValue.max()! - blueValue.min()!
        
        if redRange == greenRange && greenRange == blueRange && redRange == blueRange {
            color = [ChannelsColors.red,ChannelsColors.green,ChannelsColors.blue].randomElement()!
        } else if redRange == greenRange {
            color = [ChannelsColors.red, ChannelsColors.green].randomElement()!
        } else if redRange == blueRange {
            color = [ChannelsColors.red, ChannelsColors.blue].randomElement()!
        } else if blueRange == greenRange {
            color = [ChannelsColors.blue,ChannelsColors.green].randomElement()!
        } else {
            let maxRange = [redRange,greenRange,blueRange].max()
            if maxRange == redRange {
                color = ChannelsColors.red
            } else if maxRange == greenRange {
                color = ChannelsColors.green
            } else {
                color = ChannelsColors.blue
            }
        }
        
        
        return color
    }
    
    func colorAverage(cube: [Pixel])  ->  [Int] {
        
        var red = 0
        var green = 0
        var blue = 0
        var alpha = 0
        let cubeCount = cube.count
        for pixel in cube {
            red += pixel.red
            green += pixel.green
            blue += pixel.blue
            alpha += pixel.alpha
        }
        
        return [red/cubeCount, green/cubeCount, blue/cubeCount, alpha/cubeCount]
    }
    
    mutating func medianCutAlgorithm(colors: Float){
        guard let image = filteredImage else {
            return
        }
        let pixelsArray = pixels(image: image)
        var cubes = [pixelsArray]
        
        while cubes.count < Int(colors) {
            let channelForDivision = divisionByChannel(cube: cubes.first!)
            let sortedCube = cubes.first!.sorted{$0.channelName(channel: channelForDivision) > $1.channelName(channel: channelForDivision)}
            let newCube1 = Array(sortedCube[0 ..< (sortedCube.count - 1)/2])
            let newCube2 = Array(sortedCube[(sortedCube.count - 1)/2 ..< sortedCube.count])
            cubes.remove(at: 0)
            cubes.append(newCube1)
            cubes.append(newCube2)
        }
        
        var colorPalette: [[Int]] = []
        
        for cube in cubes{
            let color = colorAverage(cube: cube)
            colorPalette.append(color)
        }
        
        for cubeIndex in 0..<cubes.count{
            for elementIndex in 0..<cubes[cubeIndex].count{
                cubes[cubeIndex][elementIndex].red = colorPalette[cubeIndex][0]
                cubes[cubeIndex][elementIndex].green = colorPalette[cubeIndex][1]
                cubes[cubeIndex][elementIndex].blue = colorPalette[cubeIndex][2]
                cubes[cubeIndex][elementIndex].alpha = colorPalette[cubeIndex][3]
            }
        }
        
        var hashMap = [Coordinates: Pixel]()
        for cube in cubes {
            for pixel in cube {
                hashMap[Coordinates(x: pixel.x, y: pixel.y)] = pixel
            }
        }
        
        for x in 0 ..< Int(image.pixelsWide) {
            for y in 0 ..< Int(image.pixelsHigh) {
                if let pixel = hashMap[Coordinates(x: x, y: y)] {
                    var tmpRGB = [pixel.red, pixel.green, pixel.blue, pixel.alpha]
                    image.setPixel(&tmpRGB, atX: x , y: y)
                }
            }
        }
        self.filteredImage = image
    }
}
