/*
    var b = Benchmarker()
    
    b.start()
    // do something
    b.stop()

    println("took \(b.milliseconds) ms")
*/

import Darwin

public struct Benchmarker {
    static var t = mach_timebase_info(numer: 0, denom: 0)
    var startTime = UInt64(0)
    var duration = UInt64(0)

    public var milliseconds: Double {
        return Double(duration) / 1_000_000
    }

    public init() {
        if Benchmarker.t.denom == 0 {
            mach_timebase_info(&Benchmarker.t)
        }
    }

    public mutating func start() {
        startTime = mach_absolute_time()
    }

    public mutating func stop() {
        let delta = mach_absolute_time() - startTime
        duration = (delta * UInt64(Benchmarker.t.numer)) / UInt64(Benchmarker.t.denom)
    }
    
    public mutating func measure(code: () -> ()) -> Double {
        start()
        code()
        stop()
        return milliseconds
    }
}