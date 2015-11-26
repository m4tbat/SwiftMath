// Hyperbolic.swift
//
// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Accelerate

public struct Matrix<Real: RealType>: MatrixType {

    public var grid: [Real] = []
    public let order: (rows: Int, columns: Int)

    public var prova: Real {
        return Real(1)
    }
    
    public init(rows: Int, columns: Int, repeatedValue: Real) {
        order = (rows, columns)
        grid = [Real](count: rows * columns, repeatedValue: repeatedValue)
    }
    
    public init(_ rows: [[Real]]) {
        let m: Int = rows.count
        let n: Int = rows[0].count
        order = (m, n)
        grid.reserveCapacity(m*n)
        for row in rows {
            grid += row
//            grid.replaceRange((i*n)..<(i*n+m), with: row)
        }
    }

    public subscript(row: Int, column: Int) -> Real {
        get {
            assert(indexIsValidForRow(row, column: column))
            return grid[(row * order.columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column))
            grid[(row * order.columns) + column] = newValue
        }
    }

    private func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < order.rows && column >= 0 && column < order.columns
    }
}

// MARK: - CustomStringConvertible

extension Matrix: CustomStringConvertible {
    public var description: String {
        var description = ""

        for i in 0..<order.rows {
            let contents = (0..<order.columns).map({"\(self[i, $0])"}).joinWithSeparator("\t")

            switch (i, order.rows) {
            case (0, 1):
                description += "(\t\(contents)\t)"
            case (0, _):
                description += "⎛\t\(contents)\t⎞"
            case (order.rows - 1, _):
                description += "⎝\t\(contents)\t⎠"
            default:
                description += "⎜\t\(contents)\t⎥"
            }

            description += "\n"
        }

        return description
    }
}

// MARK: - SequenceType

extension Matrix: SequenceType {
    
    public func generate() -> AnyGenerator<ArraySlice<Real>> {
        let endIndex = order.rows * order.columns
        var nextRowStartIndex = 0

        return anyGenerator {
            if nextRowStartIndex == endIndex {
                return nil
            }

            let currentRowStartIndex = nextRowStartIndex
            nextRowStartIndex += self.order.columns

            return self.grid[currentRowStartIndex..<nextRowStartIndex]
        }
    }
    
}

// MARK: -

public func rank(x: Matrix<Float>) -> Int {
    var results = x
    
    var nr = __CLPK_integer(x.order.rows)
    var nc = __CLPK_integer(x.order.columns)
    var lwork = __CLPK_integer(10*max(nr, nc))
    var work = [__CLPK_real](count: Int(lwork), repeatedValue: 0.0)
    var error: __CLPK_integer = 0
    let lds = max(nr, nc)
    var s = [__CLPK_real](count: Int(lds), repeatedValue: 0.0)
    var u = [__CLPK_real](count: Int(nr * nr), repeatedValue: 0.0)
    var vt = [__CLPK_real](count: Int(nc), repeatedValue: 0.0)
    
    var jobu: Int8 = 78 // 'N'
    var jobvt: Int8 = 78 // 'N'
    
    sgesvd_(&jobu, &jobvt, &nr, &nc, &(results.grid), &nc, &s, &u, &nr, &vt, &nc, &work, &lwork, &error)
    
    print(s)
    
    let epsilon: Float = 1e-4
    return s.lazy.filter { $0 > epsilon }.count
}

public func add(x: Matrix<Float>, y: Matrix<Float>) -> Matrix<Float> {
    precondition(x.order.rows == y.order.rows && x.order.columns == y.order.columns, "Matrix dimensions not compatible with addition")

    var results = y
    cblas_saxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(results.grid), 1)

    return results
}

public func add(x: Matrix<Double>, y: Matrix<Double>) -> Matrix<Double> {
    precondition(x.order.rows == y.order.rows && x.order.columns == y.order.columns, "Matrix dimensions not compatible with addition")

    var results = y
    cblas_daxpy(Int32(x.grid.count), 1.0, x.grid, 1, &(results.grid), 1)

    return results
}

public func mul(alpha: Float, x: Matrix<Float>) -> Matrix<Float> {
    var results = x
    cblas_sscal(Int32(x.grid.count), alpha, &(results.grid), 1)

    return results
}

public func mul(alpha: Double, x: Matrix<Double>) -> Matrix<Double> {
    var results = x
    cblas_dscal(Int32(x.grid.count), alpha, &(results.grid), 1)

    return results
}

public func mul(x: Matrix<Float>, y: Matrix<Float>) -> Matrix<Float> {
    precondition(x.order.columns == y.order.rows, "Matrix dimensions not compatible with multiplication")

    var results = Matrix<Float>(rows: x.order.rows, columns: y.order.columns, repeatedValue: 0.0)
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(x.order.rows), Int32(y.order.columns), Int32(x.order.columns), 1.0, x.grid, Int32(x.order.columns), y.grid, Int32(y.order.columns), 0.0, &(results.grid), Int32(results.order.columns))

    return results
}

public func mul(x: Matrix<Double>, y: Matrix<Double>) -> Matrix<Double> {
    precondition(x.order.columns == y.order.rows, "Matrix dimensions not compatible with multiplication")

    var results = Matrix<Double>(rows: x.order.rows, columns: y.order.columns, repeatedValue: 0.0)
    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(x.order.rows), Int32(y.order.columns), Int32(x.order.columns), 1.0, x.grid, Int32(x.order.columns), y.grid, Int32(y.order.columns), 0.0, &(results.grid), Int32(results.order.columns))

    return results
}

public func inv(x: Matrix<Float>) -> Matrix<Float> {
    precondition(x.order.rows == x.order.columns, "Matrix must be square")

    var results = x

    var ipiv = [__CLPK_integer](count: x.order.rows * x.order.rows, repeatedValue: 0)
    var lwork = __CLPK_integer(x.order.columns * x.order.columns)
    var work = [CFloat](count: Int(lwork), repeatedValue: 0.0)
    var error: __CLPK_integer = 0
    var nc = __CLPK_integer(x.order.columns)

    sgetrf_(&nc, &nc, &(results.grid), &nc, &ipiv, &error)
    sgetri_(&nc, &(results.grid), &nc, &ipiv, &work, &lwork, &error)

    assert(error == 0, "Matrix not invertible")

    return results
}

public func inv(x: Matrix<Double>) -> Matrix<Double> {
    precondition(x.order.rows == x.order.columns, "Matrix must be square")

    var results = x

    var ipiv = [__CLPK_integer](count: x.order.rows * x.order.rows, repeatedValue: 0)
    var lwork = __CLPK_integer(x.order.columns * x.order.columns)
    var work = [CDouble](count: Int(lwork), repeatedValue: 0.0)
    var error: __CLPK_integer = 0
    var nc = __CLPK_integer(x.order.columns)

    dgetrf_(&nc, &nc, &(results.grid), &nc, &ipiv, &error)
    dgetri_(&nc, &(results.grid), &nc, &ipiv, &work, &lwork, &error)

    assert(error == 0, "Matrix not invertible")

    return results
}

public func transpose(x: Matrix<Float>) -> Matrix<Float> {
    var results = Matrix<Float>(rows: x.order.columns, columns: x.order.rows, repeatedValue: 0.0)
    vDSP_mtrans(x.grid, 1, &(results.grid), 1, vDSP_Length(results.order.rows), vDSP_Length(results.order.columns))

    return results
}

public func transpose(x: Matrix<Double>) -> Matrix<Double> {
    var results = Matrix<Double>(rows: x.order.columns, columns: x.order.rows, repeatedValue: 0.0)
    vDSP_mtransD(x.grid, 1, &(results.grid), 1, vDSP_Length(results.order.rows), vDSP_Length(results.order.columns))

    return results
}

// MARK: - Operators

public func + (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    return add(lhs, y: rhs)
}

public func + (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    return add(lhs, y: rhs)
}

public func * (lhs: Float, rhs: Matrix<Float>) -> Matrix<Float> {
    return mul(lhs, x: rhs)
}

public func * (lhs: Double, rhs: Matrix<Double>) -> Matrix<Double> {
    return mul(lhs, x: rhs)
}

public func * (lhs: Matrix<Float>, rhs: Matrix<Float>) -> Matrix<Float> {
    return mul(lhs, y: rhs)
}

public func * (lhs: Matrix<Double>, rhs: Matrix<Double>) -> Matrix<Double> {
    return mul(lhs, y: rhs)
}

postfix operator ′ {}
public postfix func ′ (value: Matrix<Float>) -> Matrix<Float> {
    return transpose(value)
}

public postfix func ′ (value: Matrix<Double>) -> Matrix<Double> {
    return transpose(value)
}
