//
//  MatrixType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

protocol MatrixType {
    
    typealias Vector: VectorType
    
    init(_ rows: [Vector])
    
    init(_ rows: Vector...)
    
    var rows: [Vector] { get }
    
    var columns: [Vector] { get }

}