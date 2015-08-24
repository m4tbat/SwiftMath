//
//  MatrixType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

public protocol MatrixType: ArrayLiteralConvertible {
    
    typealias MatrixElement: RealType
    
    typealias Order = (rows: Int, columns: Int)
    
    init(_ rows: [[MatrixElement]])
    
    init(_ rows: [MatrixElement]...)
    
//    var rows: ArraySlice<Element> { get }
//    
//    var columns: ArraySlice<Element> { get }
    
    var order: Order { get }
    
//    var rank: Int { get }
    
}

extension MatrixType {
    
    public init(_ rows: [MatrixElement]...) {
        self.init(rows)
    }
    
    public init(arrayLiteral elements: [MatrixElement]...) {
        self.init(elements)
    }
    
}