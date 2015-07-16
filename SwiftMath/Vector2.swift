//
//  Vector2.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 16/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

/// Vector in the two-dimensional Euclidean space – R×R
public struct Vector2<Real: RealType> {

    private let vector3: Vector3<Real>
    
    public init(x: Real, y: Real) {
        vector3 = Vector3(x: x, y: y, z: Real(0))
    }
    
}