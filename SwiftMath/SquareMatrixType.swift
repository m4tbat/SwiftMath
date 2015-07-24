//
//  MatrixType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

protocol SquareMatrixType: MatrixType {
    
    typealias Real: RealType
    
    var determinant: Real { get }
    
    func transpose() -> Self
    
    func cofactor() -> Self
    
    func adjugate() -> Self
    
    func inverse() -> Self?
    
    func identity(rowCount: Int, columnCount: Int) -> Self
    
    var isInvertible: Bool { get }
    
    var isOrthogonal: Bool { get }
    
}