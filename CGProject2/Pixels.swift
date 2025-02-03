//
//  Pixels.swift
//  CGProject2
//
//  Created by Aleksandra Novák on 30/03/2023.
//

import Foundation

struct Coordinates: Hashable {
    let x: Int
    let y: Int
}

struct Pixel {
    var x: Int
    var y: Int
    
    var red: Int
    var green: Int
    var blue: Int
    var alpha: Int
    
    init(x: Int, y: Int, red: Int, green: Int, blue: Int, alpha: Int) {
        self.x = x
        self.y = y
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    func channelName(channel: ChannelsColors) -> Int{
        
        switch(channel){
        case .red:
            return self.red
        case .green:
            return self.green
        case .blue:
            return self.blue
        }
    
    }
}
