//
//  Equation.swift
//  Algebra
//
//  Created by Cihan Emre Kisakurek (Company) on 04.01.19.
//  Copyright © 2019 rocks.cihan. All rights reserved.
//

enum SolveError: Error {
    case notSolvable
    case hasMultipleLabels
    case needsSolveForLabel
}

protocol Solvable {

    func solve() throws -> Double
}


public struct VariableLabel {

    var name : String

    init(name: String) {
        self.name = name
    }
}


struct Variable: Solvable {

    public var label        : VariableLabel?
    public var multiplier   : Double
    public var constant     : Double

    init() {
        self.multiplier = 1.0
        self.constant = 0.0
    }

    init(label: VariableLabel) {
        self.init(label: label, multiplier: 1.0, constant: 0.0)
    }

    init(constant: Double) {
        self.init(label: nil, multiplier: 1.0, constant: constant)
    }

    init(multiplier: Double) {
        self.init(label: nil, multiplier: multiplier, constant: 0.0)
    }

    init(multiplier: Double, constant: Double) {
        self.init(label: nil, multiplier: multiplier, constant: constant)
    }

    init(label: VariableLabel?, multiplier: Double, constant: Double) {
        self.label = label
        self.multiplier = multiplier
        self.constant = constant
    }

    func solve() throws -> Double {
        let result = self.equal(variable: Variable(constant: 0.0))
        return try result.solve()
    }

    static func +(lhs: Variable, rhs: Variable) -> Equation {
        let equation = Equation()
        equation.terms.append(lhs)
        equation.terms.append(rhs)
        return equation
    }

    func equal(variable: Variable) -> Equation {
        let equation = Equation()
        equation.terms.append(self)
        equation.terms.append(variable)
        return equation
    }
}


public class Equation :  Solvable {

    var terms   : [Variable] = []
    var equals  : Variable?

    func hasVariableLabel() -> Bool {
        for t in terms {
            if t.label != nil {
                return true
            }
        }
        return false
    }

    func firstLabel() -> VariableLabel? {
        for t in terms {
            if t.label != nil {
                return t.label
            }
        }
        return nil
    }

    func hasMultipleLabels() -> Bool {
        var previousLabel:VariableLabel?
        for t in terms {
            if let previousLabel = previousLabel {
                if let label = t.label {
                    if label.name != previousLabel.name {
                        return true
                    }
                }
            }
            else if let label = t.label {
                previousLabel = label
            }
        }
        return false
    }

    func sumOfConstants() -> Double {
        var c = 0.0
        for t in terms {
            c += (t.constant * t.multiplier)
        }
        return c
    }

    func sumOfMultipliers(label: VariableLabel) -> Double {
        var m = 0.0
        for t in terms {
            if let termLabel = t.label, label.name == termLabel.name {
                m += t.multiplier
            }
        }
        return m
    }

    func sumOfLabel(label: VariableLabel) -> Double {
        var s = 0.0
        for t in terms {
            if let termLabel = t.label, termLabel.name == label.name {
                s += t.multiplier
            }
        }
        return s
    }

    func solve() throws -> Double {

        if self.hasVariableLabel() {
            if self.hasMultipleLabels() {
                throw SolveError.hasMultipleLabels
            }
            else {
                // we have one label
                let label = self.firstLabel()! // guaranteed label
                // check if there is equals
                if let equals = self.equals {
                    // check if label
                    if let equalsLabel = equals.label {
                        // label varsa first labellari karsilastir

                        if label.name == equalsLabel.name {
                            // ayniysa coz
                            return 0.0
                        }
                        else {
                            // ayni degilse 2 bilinmeyenli
                            return Double.greatestFiniteMagnitude
                        }
                    }
                    else {
                        let equalsValue = equals.constant * equals.multiplier
                        let termConstant = self.sumOfConstants()
                        let c = equalsValue - termConstant
                        let m = self.sumOfMultipliers(label: label)
                        if m <= 1.0 {
                            return c * m
                        }
                        else {
                            return c / m
                        }
                    }
                }
                else {
                    return -sumOfConstants()/sumOfMultipliers(label: label)
                }
            }
        }
        else { // Basic

            var sum = 0.0
            for t in terms {
                sum += (t.constant * t.multiplier)
            }
            return sum
        }
    }

    func equal(variable: Variable) -> Equation {
        if self.hasMultipleLabels() {
            let newEquation = LineEquation()
            newEquation.equals = variable
            newEquation.terms = self.terms
            return newEquation
        }
        else {
            let newEquation = Equation()
            newEquation.terms = self.terms
            newEquation.equals = variable
            return newEquation
        }

    }
}

public class LineEquation : Equation {

    override func solve() throws -> Double {
        throw SolveError.needsSolveForLabel
    }

    public func solveFor(label: VariableLabel, value: Double) throws -> Equation {

        let newEquation = Equation()
        for t in terms {
            if let termLabel = t.label, termLabel.name == label.name {
                let newVariable = Variable(constant: t.constant + (t.multiplier * value))
                newEquation.terms.append(newVariable)
            }
            else {
                newEquation.terms.append(t)
            }
        }
        return newEquation
    }
}


class Result : Solvable {

    public var constant:Double = 0.0
    public var multiplier:Double = 1.0

    public func solve() throws -> Double {
        return self.constant*self.multiplier
    }
}





