//
//  Curve.swift
//  SpaceFillingCurves
//
//  Created by Cihan Emre Kisakurek (Company) on 04.01.19.
//  Copyright © 2019 rocks.cihan. All rights reserved.
//

public struct Hilbert {

    let n:Int

    public init(n:Int) {
        self.n = n
    }
    public func distanceFromCoordinates(x : Int, y: Int) -> Int {
        var _x = x
        var _y = y
        var rx = 0
        var ry = 0
        var d = 0
        var s = Int(floor(Double(self.n/2)))

        while (s > 0) {
            rx = (_x & s) > 0 ? 1 : 0
            ry = (_x & s) > 0 ? 1 : 0
            d += s * s * ((3 * rx) ^ ry)
            _ = rotate(x: &_x, y: &_y, rx: rx, ry: ry,s:s)

            s = Int(floor(Double(s/2)))
        }
        return d
    }

    public func coordinatesFromDistance(d : Int) -> (Int,Int) {

        var rx = 0
        var ry = 0
        var s = 1
        var t = d

        var _x = 0
        var _y = 0

        while (s < self.n) {
            rx = 1 & (t / 2)
            ry = 1 & (t ^ rx)

            // rotate
            _ = rotate(x: &_x, y: &_y, rx: rx, ry: ry,s:s)

            _x = _x + (s * rx)
            _y = _y + (s * ry)
            t = t/4
            s *= 2
            print("\(_x) \(_y) \(rx) \(ry) \(s) \(t) \(n)")
        }
        return (_x,_y)
    }

    func rotate(x: inout Int, y: inout Int, rx: Int, ry:Int, s:Int) -> (Int,Int) {
        if (ry == 0) {
            if (rx == 1) {
                x = s - 1 - x
                y = s - 1 - y
            }
            let temp = x
            x = y
            y = temp
        }
        return (x,y)
    }
}


public func sierpinskiCurve(x : Double, y: Double, max: Int) -> Int {

    if (x < Double(max + 1)) {}
    if (y < Double(max + 1)) {}


    var _x = x
    var _y = y
    let _max = Double(max)

    var result = 0
    var index = Int(_max)
    if _x > _y {
        result += 1
        _x = _max - _x
        _y = _max - _y
    }

    while index > 0 {

        result = result + result

        if _x + _y < _max {
            result += 1
            let oldX = _x
            _x = _max - y
            _y = oldX
        }

        _x = _x + _x
        _y = _y + _y
        result = result + result

        if _y > _max {
            result += 1
            let oldX = _x
            _x = _y - _max
            _y = _max - oldX
        }
        index = Int(index/2)
    }

    return result
}


