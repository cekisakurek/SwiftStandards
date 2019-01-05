//
//  Bubble.swift
//  sort
//
//  Created by Cihan Emre Kisakurek (Company) on 03.01.19.
//  Copyright © 2019 rocks.cihan. All rights reserved.
//

func bubbleSort<Generic:Comparable>(array : inout [Generic]) {

    // First loop
    for i in 0...array.count - 1 {
        // Second loop
        for j in 0..<(array.count - i - 1) {
            // Check which one is bigger and swap values accordingly
            if array[j] > array[j+1] {

                let temp = array[j]
                array[j] = array[j+1]
                array[j+1] = temp
            }
        }
    }
}
