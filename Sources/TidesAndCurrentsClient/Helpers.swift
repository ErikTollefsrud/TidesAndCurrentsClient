//
//  File.swift
//  
//
//  Created by Erik Tollefsrud on 3/23/21.
//

import Foundation

/// Configure a value with a given closure
public func configure<A>(_ a: A, _ f: (inout A) -> Void) -> A {
    var a = a
    f(&a)
    return a
}
