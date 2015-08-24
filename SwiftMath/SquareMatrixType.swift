//
//  MatrixType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

protocol SquareMatrixType: MatrixType {
    
    static func identity(rowCount: Int) -> Self
    
    var determinant: Element { get }
    
    func transpose() -> Self
    
    func cofactor() -> Self
    
    func adjugate() -> Self
    
    func inverse() -> Self?
    
    var isInvertible: Bool { get }
    
    var isOrthogonal: Bool { get }
    
}