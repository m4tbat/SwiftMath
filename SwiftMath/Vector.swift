//
//  Vector.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 23/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public struct Vector<Real: RealType>: VectorType {
    
    public let coordinates: [Real]
    
    public init(_ coordinates: [Real]) {
        self.coordinates = coordinates
    }
    
}
