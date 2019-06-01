import Foundation
precedencegroup LeftApplyPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

precedencegroup FunctionCompositionPrecedence {
    associativity: right
    higherThan: LeftApplyPrecedence
}

precedencegroup LensSetPrecedence {
    associativity: left
    higherThan: FunctionCompositionPrecedence
}

infix operator |> : LeftApplyPrecedence
infix operator .~ : LensSetPrecedence

// swiftlint:disable variable_name

public func |><A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

// swiftlint:disable variable_name
public func .~ <A, B> (lens: WritableKeyPath<A, B>, b: B) -> (A) -> A {

    return { a in
        var copy = a
        copy[keyPath:lens] = b
        return copy
    }

}
