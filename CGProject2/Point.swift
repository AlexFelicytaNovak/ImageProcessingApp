//
//  Point.swift
//  CGProject1
//
//  Created by Aleksandra Novák on 16/03/2023.
//

import Foundation


struct Point: Comparable{
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.x < rhs.x
    }
    
    
    var x: Int
    var y: Int
    var isCurrentlyDragged: Bool
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.isCurrentlyDragged = false
    }
}
