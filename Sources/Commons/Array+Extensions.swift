//
//  Array+Extensions.swift
//
//  Created by Klajd Deda on 2/8/21.
//  Copyright © 2021 id-design. All rights reserved.
//

import Foundation


public extension Array {
    /**
     Apply a setter to each item in the array
     let shapes = [Shape]()
     let redShapes = shapes.reduce { $0.color = Color.red }
     */
    func reduce(with: (inout Element) -> ()) -> [Element] {
        return reduce(into: []) { (result, item) in
            var item = item
            with(&item)
            result.append(item)
        }
    }
}
