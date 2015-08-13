//
//  MatrixType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public protocol MatrixType: ArrayLiteralConvertible {
    
    typealias Vector: VectorType
    
    init(_ rows: [Vector])
    
    init(_ rows: Vector...)
    
    var rows: [Vector] { get }
    
    var columns: [Vector] { get }
    
    var order: (rows: Int, columns: Int) { get }
    
    var rank: Int { get }
    
}

extension MatrixType {
    
    init(_ elements: Vector...) {
        self.init(elements)
    }
    
    init(arrayLiteral elements: Vector...) {
        self.init(elements)
    }
    
    var columns: [Vector] {
        var cols: [Vector] = []
        cols.reserveCapacity(order.columns)
        for i in (0..<order.columns) {
            var col: [Vector.Real] = []
            col.reserveCapacity(order.rows)
            for row in rows {
                col.append(row.coordinates[i])
            }
            cols.append(Vector(col))
        }
        return cols
    }
    
    var size: (rows: Int, columns: Int) {
        return (rows.count, rows[0].coordinates.count)
    }
    
}