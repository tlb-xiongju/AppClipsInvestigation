//
//  Then.swift
//  Punchor
//
//  Created by 熊 炬 on 2020/11/17.
//

import Foundation

protocol Then {}

extension Then where Self: Any {
    @inlinable
    func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
}

extension NSObject: Then {}
