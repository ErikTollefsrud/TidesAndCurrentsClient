//
//  Double.swift
//
//  Created by Klajd Deda on 1/30/21.
//  Copyright © 2021 id-design. All rights reserved.
//

import Foundation

public extension Double {
    var with3Digits: String {
        String(format: "%0.3f", self)
    }
}

