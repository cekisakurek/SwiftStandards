//
//  main.swift
//  TestBed
//
//  Created by Cihan Emre Kisakurek (Company) on 04.01.19.
//  Copyright © 2019 rocks.cihan. All rights reserved.
//

import SpaceFillingCurves

let hilbert = Hilbert(n:10)

let d = hilbert.distanceFromCoordinates(x: 1, y: 1)

print(d)

let (x,y) = hilbert.coordinatesFromDistance(d: d)

print("\(x) :\(y)")
